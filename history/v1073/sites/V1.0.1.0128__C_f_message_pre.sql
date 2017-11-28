-- auto gen by admin 2016-04-27 21:03:22
CREATE OR REPLACE FUNCTION "f_message_pre"(activitymessage json)
  RETURNS "pg_catalog"."text" AS $BODY$
declare
	--活动信息
  activitymessageid INT;--活动id
	startTime TIMESTAMP;--活动开始时间
	endTime TIMESTAMP;--活动结束时间
	checkstatus  VARCHAR;--活动审核状态
	activitytype VARCHAR;--活动类型
	--状态常量
	ACTIVITY_STATUS_SUCCESS VARCHAR := '1';--活动审核通过状态值
	ACTIVITY_MEET_PRE text:='00';--活动满足前置条件
	ACTIVITY_NOT_EXIST text :='01';--活动不存在
	ACTIVITY_NOT_CHECK text :='02';--活动未审核
	ACTIVITY_NOT_START text :='03';--活动未开始
	ACTIVITY_END text :='04';--活动已结束
BEGIN
activitymessageid =  (activitymessage ->> 'activitymessageid')::INT;
startTime =  (activitymessage ->> 'activitystarttime')::TIMESTAMP;
endTime =  (activitymessage ->> 'activityendtime')::TIMESTAMP;
checkstatus =  activitymessage ->> 'checkstatus';
activitytype =  activitymessage ->> 'activitytype';
--前置条件判断
IF NOT EXISTS(SELECT * FROM activity_message WHERE id=activitymessageid) THEN
RETURN ACTIVITY_NOT_EXIST;
END IF;
IF checkstatus <> ACTIVITY_STATUS_SUCCESS THEN
RETURN ACTIVITY_NOT_CHECK;
END IF;
IF startTime > CURRENT_TIMESTAMP THEN
RETURN ACTIVITY_NOT_START;
END IF;
IF endTime < CURRENT_TIMESTAMP THEN
RETURN ACTIVITY_END;
END IF;
RETURN ACTIVITY_MEET_PRE;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;
COMMENT ON FUNCTION "f_message_pre"(activitymessage json) IS '优惠活动前置条件';


CREATE OR REPLACE FUNCTION "f_message_query_activityname"(activitymessageid int4)
  RETURNS "pg_catalog"."text" AS $BODY$
DECLARE
	rec_activity RECORD;--活动国际化结果集
	activityname_json VARCHAR := '' ;--活动名称，所有语言版本的名称都需要存储
BEGIN
FOR rec_activity IN SELECT * FROM activity_message_i18n WHERE activity_message_id=activitymessageid
LOOP
	activityname_json = activityname_json || '"' ||rec_activity.activity_version||'":"'||rec_activity.activity_name||'",';
END LOOP;

IF length(activityname_json) > 0 THEN
	activityname_json = substring(activityname_json,  1 , length(activityname_json)-1);
	activityname_json = '{' || activityname_json  || '}';
END IF;
RETURN activityname_json;
END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;
COMMENT ON FUNCTION "f_message_query_activityname"(activitymessageid int4) IS '查询活动名称，包含所有语言版本';


CREATE OR REPLACE FUNCTION "f_message_query_applytime"(activitymessageid int4)
  RETURNS "pg_catalog"."json" AS $BODY$
DECLARE
	starttime TIMESTAMP;--申请开始时间
	endtime TIMESTAMP;--申请结束时间
	claimperiod VARCHAR; --活动申领周期
BEGIN
SELECT start_time,end_time FROM activity_message WHERE id = activitymessageid INTO starttime,endtime;
SELECT
	CASE
	WHEN (claim_period = 'NaturalDay') THEN '1 day'
	WHEN (claim_period = 'NaturalWeek') THEN '1 week'
	WHEN (claim_period = 'NaturalMonth') THEN '1 month'
	WHEN (claim_period = 'ActivityCycle') THEN 'cycle'
	ELSE 'cycle'
	END AS claim_period FROM activity_rule WHERE activity_message_id=activitymessageid INTO claimperiod;
	raise info '活动申领周期:%',claimperiod;
	IF claimperiod <> 'cycle' THEN
		loop
			exit WHEN (starttime+ claimperiod::INTERVAL) > CURRENT_TIMESTAMP;
			starttime = starttime + claimperiod::INTERVAL;
		END loop;
		endtime = starttime + claimperiod::INTERVAL;
	END IF;
	raise info '申领周期的开始时间为:%,结束时间为:%',starttime,endtime;
RETURN json_build_object('applystarttime',starttime,'applyendtime',endtime);
END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;
COMMENT ON FUNCTION "f_message_query_applytime"(activitymessageid int4) IS '查询活动的当前申请时间区间';


CREATE OR REPLACE FUNCTION "f_message_rule_default"(activitymessage json,playerInfo json)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
	activitymessageid int4;--活动id
	applystarttime TIMESTAMP;--申领开始时间
	applyendtime TIMESTAMP;--申领结束时间
	playerid int4;--玩家id
	ACTIVITY_MEET text:='000';--满足注册送条件
	ACTIVITY_REPEAT_APPLY text:='99';--本申领周期已达申请上限
BEGIN
activitymessageid =  activitymessage ->> 'activitymessageid';
applystarttime = (activitymessage->>'applystarttime')::TIMESTAMP;
applyendtime  = (activitymessage->>'applyendtime')::TIMESTAMP;
playerid =  playerInfo ->> 'playerid';
--同一申请周期是否存在重复申请
IF EXISTS(SELECT * FROM activity_player_apply WHERE user_id = playerid AND activity_message_id = activitymessageid AND apply_time>=applystarttime AND apply_time<=applystarttime) THEN
	RETURN json_build_object( 'resultcode',ACTIVITY_REPEAT_APPLY);
	END IF;
	RETURN json_build_object( 'resultcode',ACTIVITY_MEET);
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;
COMMENT ON FUNCTION "f_message_rule_default"(activitymessage json,playerInfo json) IS '活动规则判断';


CREATE OR REPLACE FUNCTION "f_message_rule_regist"(activitymessage json,playerInfo json)
  RETURNS "pg_catalog"."json" AS $BODY$
declare

activitymessageid int4;--活动id
playerid int4;--玩家id
registTime TIMESTAMP;--玩家注册时间
effectiveTime VARCHAR;--有效时间
activityEffectiveTime TIMESTAMP;--活动有效时间=玩家注册时间+有效时间

ACTIVITY_MEET text:='000';--满足注册送条件
ACTIVITY_REGIST_EXPIRE text:='11';--有效期已过
ACTIVITY_REPEAT_APPLY text:='99';--本申领周期已达申请上限
BEGIN
activitymessageid =  activitymessage ->> 'activitymessageid';
playerid =  playerInfo ->> 'playerid';
registTime =  (playerInfo ->> 'registertime')::TIMESTAMP;
--判断是否存在重复的申请
	IF EXISTS(SELECT * FROM activity_player_apply WHERE user_id = playerid AND activity_message_id = activitymessageid) THEN
	RETURN json_build_object( 'resultcode',ACTIVITY_REPEAT_APPLY);
	END IF;
--判断是否过期
	SELECT CASE
		WHEN (effective_time = 'OneDay') THEN '1'
		WHEN (effective_time = 'TwoDays') THEN '2'
		WHEN (effective_time = 'ThreeDays') THEN '3'
		WHEN (effective_time = 'SevenDays') THEN '7'
		WHEN (effective_time = 'ThirtyDays') THEN '30'
		ELSE '0'
	END AS effective_time FROM activity_rule WHERE activity_message_id = activitymessageid INTO effectiveTime;
	raise info '玩家:%,的注册时间为：%,活动：%,的有效时间为：%.',playerid,registTime,activitymessageid,effectiveTime;

	SELECT registTime + (effectiveTime || ' day')::interval  INTO activityEffectiveTime;
	IF activityEffectiveTime < CURRENT_TIMESTAMP THEN
		RETURN json_build_object( 'resultcode',ACTIVITY_REGIST_EXPIRE);
	END IF;
	RETURN json_build_object( 'resultcode',ACTIVITY_MEET,'ordernum',1);
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_message_rule_regist"(activitymessage json,playerInfo json) IS '注册送规则判断';


CREATE OR REPLACE FUNCTION "f_message_rule_relief"(activitymessage json,playerInfo json)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
activitymessageid int4;--活动id
applystarttime TIMESTAMP;--申领开始时间
applyendtime TIMESTAMP;--申领结束时间
playerid int4;--玩家id
applytime TIMESTAMP;--申请时间

limitnumber int4;--限制名额
applynumber int4;--申请周期内已申请人数
profitloss NUMERIC;--玩家盈亏金额
effectivetransaction NUMERIC;--玩家有效交易量
totalassets NUMERIC;--玩家总资产
order_num int :=100;--计算的优惠档次初始值
order_num_temp int;--计算的优惠档次临时值
code_effective_transaction text := '1';
code_loss text:= '1';
code_total_assets text:= '1';

ACTIVITY_RELIEF_WITHDRAW_EXIST text:='21';--已提交取款订单
ACTIVITY_RELIEF_WITHDRAW_SUCCESS text:='22';--已成功取过款
ACTIVITY_REPEAT_APPLY text:='99';--本申领周期已达申请上限
ACTIVITY_RELIEF_QUOTA_FULL text:='24';--名额已满
RULE_LOSS_GE varchar := 'loss_ge';--优惠规则：亏损
RULE_EFFECTIVE_TRANSACTION_GE varchar := 'effective_transaction_ge';--优惠规则：有效交易量
RULE_TOTAL_ASSETS_LE varchar := 'total_assets_le';--优惠规则：总资产(小于等于)
BEGIN
activitymessageid =  activitymessage ->> 'activitymessageid';
applystarttime = (activitymessage->>'applystarttime')::TIMESTAMP;
applyendtime  = (activitymessage->>'applyendtime')::TIMESTAMP;
playerid =  playerInfo ->> 'playerid';
applytime =  (playerInfo ->> 'applytime')::TIMESTAMP;
--是否存在待处理的取款订单
IF EXISTS(SELECT * FROM player_withdraw WHERE player_id=playerid AND create_time >=applystarttime AND create_time<=applyendtime AND withdraw_status in('1','2')) THEN
RETURN json_build_object( 'resultcode',ACTIVITY_RELIEF_WITHDRAW_EXIST);
END IF;
--是否成功取过款
IF EXISTS(SELECT * FROM player_withdraw WHERE player_id=playerid AND create_time >=applystarttime AND create_time<=applyendtime AND withdraw_status = '4') THEN
RETURN json_build_object( 'resultcode',ACTIVITY_RELIEF_WITHDRAW_SUCCESS);
END IF;
--同一申请周期是否存在重复申请
IF EXISTS(SELECT * FROM activity_player_apply WHERE user_id = playerid AND activity_message_id = activitymessageid AND apply_time>=applystarttime AND apply_time<=applystarttime) THEN
	RETURN json_build_object( 'resultcode',ACTIVITY_REPEAT_APPLY);
	END IF;
--申请名额是否已满
SELECT limit_number FROM activity_rule  where activity_message_id = activitymessageid INTO limitnumber;
SELECT count(1) FROM activity_player_apply WHERE activity_message_id = activitymessageid AND apply_time>=applystarttime AND apply_time<=applystarttime INTO applynumber;
IF COALESCE(limitnumber,0) > 0 AND  COALESCE(limitnumber,0)<=COALESCE(applynumber,0) THEN
	RETURN json_build_object( 'resultcode',ACTIVITY_RELIEF_QUOTA_FULL);
END IF;
--判断有效交易量是否达到条件
SELECT  f_calculator_effective_transaction(playerid,applystarttime,applytime) INTO effectivetransaction;
raise notice '查询玩家的有效交易量,结果:%',effectivetransaction;
	IF EXISTS(SELECT * FROM	activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = RULE_EFFECTIVE_TRANSACTION_GE AND preferential_value <= effectivetransaction) THEN
		code_effective_transaction = '0';
		SELECT order_column FROM	activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = RULE_EFFECTIVE_TRANSACTION_GE AND preferential_value <= effectivetransaction ORDER BY order_column DESC LIMIT 1 INTO order_num_temp;
		raise info '玩家:%的有效交易量已满足条件,当前的有效交易量最高满足了%档.',playerid,order_num_temp;
		IF COALESCE (order_num_temp, 0) < order_num THEN
			order_num = order_num_temp;
		END IF;
	END IF;
--判断亏损额度是否达到条件
	SELECT  f_calculator_profit_loss(playerid,applystarttime,applytime) INTO profitloss;
	raise notice '查询玩家亏损额度,结果:%',profitloss;
	IF profitloss < 0 AND EXISTS(SELECT * FROM	activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = RULE_LOSS_GE AND preferential_value <= abs(profitloss)) THEN
		code_loss = '0';
		SELECT order_column FROM activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = RULE_LOSS_GE AND preferential_value <= abs(profitloss) order by order_column desc LIMIT 1 into order_num_temp;
		raise info '玩家:%的亏损额度已满足条件,当前的亏损额度最高满足了%档.',playerid,order_num_temp;
		IF COALESCE (order_num_temp, 0) < order_num THEN
			order_num = order_num_temp;
		END IF;
	END IF;
--判断总资产是否达到条件
	SELECT  f_calculator_total_assets(playerid) into totalassets;
	raise notice '查询玩家的总资产,结果:%',totalassets;
	IF EXISTS(SELECT * FROM	activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = RULE_TOTAL_ASSETS_LE AND preferential_value >= totalassets) THEN
		code_total_assets = '0';
		SELECT order_column FROM activity_preferential_relation WHERE activity_message_id = activitymessageid and preferential_code = RULE_TOTAL_ASSETS_LE and preferential_value >= totalassets order by order_column asc LIMIT 1 into order_num_temp;
		raise info '玩家:%的总资产已满足条件,当前总资产最低满足了%档.',playerid,order_num_temp;
		IF COALESCE (order_num_temp, 0) > order_num then
			raise info '总资产满足的最低档次大于当前已符合的最低档次,因此玩家不能获得优惠';
			code_total_assets = '1';
			order_num=0;
		END IF;
	END IF;
	RETURN json_build_object( 'resultcode',code_effective_transaction || code_loss || code_total_assets,'ordernum',order_num);

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;
COMMENT ON FUNCTION "f_message_rule_relief"(activitymessage json,playerInfo json) IS '救济金规则判断';


CREATE OR REPLACE FUNCTION "f_message_rule"(activitymessage json,playerInfo json)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
activitymessageid int4;--活动id
playerid int4;--玩家id
activitytype VARCHAR;--活动类型
playerRank int;--玩家层级
activityRank VARCHAR;--活动参与层级
isAllRank BOOLEAN;--是否全部层级
tempActivityRank VARCHAR;--临时活动参与层级字符串
tempPlayerRank VARCHAR;--临时玩家层级字符串

TYPE_REGIST_SEND VARCHAR := 'regist_send';--注册送的activity_type
TYPE_RELIEF_FUND VARCHAR := 'relief_fund';--救济金的activity_type
TYPE_PROFIT_LOSS VARCHAR := 'profit_loss';--盈亏送的activity_type
TYPE_EFFECTIVE_TRANSACTION VARCHAR := 'effective_transaction';--有效交易量的activity_type
ACTIVITY_NOT_CONTAIN_RANK text:='09';--当前层级无法参与优惠
ACTIVITY_MEET text := '000';--满足优惠规则条件

BEGIN

activitymessageid =  activitymessage ->> 'activitymessageid';
activitytype = activitymessage->>'activitytype';
playerid =  playerInfo ->> 'playerid';
playerRank =  playerInfo ->> 'rankid';
--判断玩家的层级是否能参与该活动
SELECT rank,is_all_rank FROM activity_rule WHERE activity_message_id=activitymessageid INTO activityRank,isAllRank;
IF  isAllRank=FALSE THEN
tempActivityRank = ',' || activityRank || ',';
tempPlayerRank =  ',' || playerRank || ',';
raise info '申请玩家层级:%,活动参与层级:%',tempPlayerRank,tempActivityRank;
IF position(tempPlayerRank in tempActivityRank) <=0 THEN
RETURN json_build_object( 'resultcode',ACTIVITY_NOT_CONTAIN_RANK);
END IF;
END IF;
--注册送活动规则判断
	IF activitytype = TYPE_REGIST_SEND THEN
		RETURN f_message_rule_regist(activitymessage,playerInfo);
	END IF;
--救济金活动规则判断
	IF activitytype = TYPE_RELIEF_FUND THEN
		RETURN f_message_rule_relief(activitymessage,playerInfo);
	END IF;
--盈亏送和有效交易量活动规则判断
	IF activitytype = TYPE_PROFIT_LOSS OR activitytype = TYPE_EFFECTIVE_TRANSACTION THEN
		RETURN f_message_rule_default(activitymessage,playerInfo);
	END IF;

	RETURN  json_build_object( 'resultcode',ACTIVITY_MEET);

END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;
COMMENT ON FUNCTION "f_message_rule"(activitymessage json,playerInfo json) IS '优惠活动规则判断';


CREATE OR REPLACE FUNCTION "f_message_apply"(activitymessage json,playerInfo json)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
--优惠活动信息
activitymessageid int4;--活动id
activitytype VARCHAR;--活动类型
activitystarttime TIMESTAMP;--活动开始时间
activityendtime TIMESTAMP;--活动结束时间
--活动申请信息
applyid INT;--申请id
applytime TIMESTAMP;--申请时间
applystarttime TIMESTAMP;--申领开始时间
applyendtime TIMESTAMP;--申领结束时间
--玩家信息
playerid int4;--玩家id
username VARCHAR;--玩家名
registertime TIMESTAMP;--注册时间
rankid INT;--层级id
rankname VARCHAR;--层级名称
riskmarker BOOLEAN;--层级危险标志
--临时结果
ordernum INT;--优惠档次
ruleresult json;--规则验证的返回结果json
result_code text;---code(操作代码)
applytimeinterval json;
--常量
TYPE_REGIST_SEND VARCHAR := 'regist_send';--注册送的activity_type
TYPE_RELIEF_FUND VARCHAR := 'relief_fund';--救济金的activity_type
APPLY_CHECK_STATUS_CONFIRMED VARCHAR := '0';--申请审核状态-待确认
ACTIVITY_MEET_PRE text:='00';--满足优惠活动前置条件
ACTIVITY_MEET text:='000';--满足优惠活动的规则
BEGIN
--信息初始化
activitymessageid =  activitymessage ->> 'activitymessageid';
activitytype = activitymessage->>'activitytype';
applystarttime = (activitymessage->>'applystarttime')::TIMESTAMP;
applyendtime  = (activitymessage->>'applyendtime')::TIMESTAMP;
playerid =  playerInfo ->> 'playerid';
username =  playerInfo ->> 'username';
registertime =  (playerInfo ->> 'registertime')::TIMESTAMP;
rankid =  playerInfo ->> 'rankid';
rankname =  playerInfo ->> 'rankname';
riskmarker =  playerInfo ->> 'riskmarker';
applytime =  (playerInfo ->> 'applytime')::TIMESTAMP;
--是否满足活动前置条件
SELECT * FROM f_message_pre(activitymessage)  INTO result_code;
IF result_code <> ACTIVITY_MEET_PRE THEN
	raise info '不满足该优惠活动的前置条件,状态码为:%',result_code;
	RETURN json_build_object( 'resultcode',result_code);
END IF;
--是否满足活动规则
SELECT * FROM f_message_rule(activitymessage,playerInfo) INTO ruleresult;
raise info '规则判断的结果为:%',ruleresult;
result_code = ruleresult->>'resultcode';
IF result_code <> ACTIVITY_MEET THEN
	RETURN json_build_object( 'resultcode',result_code);
END IF;
--满足活动规则，生成优惠活动申请信息
	IF activitytype = TYPE_REGIST_SEND OR activitytype =TYPE_RELIEF_FUND THEN
		applyEndTime = applytime;
		ordernum=ruleresult->>'ordernum';
	END IF;
WITH activityaplayapply AS (
	INSERT INTO activity_player_apply(activity_message_id,user_id,user_name,register_time,rank_id,rank_name,risk_marker,apply_time,check_state,start_time,end_time)
	VALUES (activitymessageid,playerid,username,registertime,rankid,rankname,riskmarker,applytime,APPLY_CHECK_STATUS_CONFIRMED,applystarttime,applyendtime)
	RETURNING id
)
SELECT id FROM activityaplayapply INTO applyid ;
RETURN json_build_object( 'resultcode',result_code,'applyId',applyid,'ordernum',ordernum);

END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_message_apply"(activitymessage json,playerInfo json) IS '优惠活动申请统一入口';


CREATE OR REPLACE FUNCTION "f_message_calculator"(activitymessage json,playerInfo json,applyresult json)
  RETURNS "pg_catalog"."json" AS $BODY$

declare
	--优惠活动信息
	activitymessageid int4;--活动id
	activityType VARCHAR;--活动类型
	--活动申请信息
	applyid INT;--申请id
	applytime TIMESTAMP;--申请时间
	ordernum INT;--优惠档次
	--玩家信息
	playerid int4;--玩家id
	sitecode varchar;--站点code

	rec_way record;--优惠形式结果集
	isaudit BOOLEAN;--活动是否需要审核
	orderNo VARCHAR;--订单流水号
	favorable_id_temp int;--优惠记录主键
	transaction_id_temp int;--订单记录主键
	isAuditFavorable BOOLEAN := TRUE;--是否优惠稽核
	auditPoints NUMERIC ;--稽核点
	activityname_json VARCHAR := '' ;--活动名称，所有语言版本的名称都需要存储
	favorableremark VARCHAR;--备注信息
	result_code_array text [];--结果返回数组,由4个成员组成:resultcode(结果代码),code代码(),value(优惠金额,非必须),value值(非必须)
	result_code text;---code(操作代码)
	ACTIVITY_MEET text := '000';--满足所有优惠条件
	TYPE_REGIST_SEND VARCHAR := 'regist_send';--注册送的activity_type
	TYPE_RELIEF_FUND VARCHAR := 'relief_fund';--救济金的activity_type
	APPLY_CHECK_STATUS_PENDING VARCHAR := '1';--申请审核状态-待处理
	APPLY_CHECK_STATUS_SUCCESS VARCHAR := '2';--申请审核状态-成功
	PREFERETIAL_FORM_PERCENTAGE varchar := 'percentage_handsel';--优惠形式:比例彩金
	PREFERETIAL_FORM_REGULAR varchar := 'regular_handsel';--优惠形式:固定彩金
BEGIN
--信息初始化
activitymessageid =  activitymessage ->> 'activitymessageid';
activitytype = activitymessage->>'activitytype';
playerid =  playerInfo ->> 'playerid';
applytime =  (playerInfo ->> 'applytime')::TIMESTAMP;
sitecode =  playerInfo ->> 'sitecode';
applyid = applyresult->>'applyId';
ordernum = applyresult->>'ordernum';
result_code_array[1] = 'resultcode';
result_code_array[2] = ACTIVITY_MEET;
--目前只有注册送和救济金需要立即计算活动优惠
IF activitytype <> TYPE_REGIST_SEND AND activitytype <> TYPE_RELIEF_FUND THEN
	raise info '活动类型：%，不需要立即计算活动优惠',activitytype;
	RETURN json_object(result_code_array);
END IF;

IF activitytype = TYPE_REGIST_SEND THEN
	favorableremark = '注册赠送彩金';
ELSEIF activitytype = TYPE_RELIEF_FUND THEN
	favorableremark = '赠送救济金';
END IF;

SELECT * from f_message_query_activityname(activitymessageid) INTO activityname_json;
SELECT is_audit FROM activity_rule  where activity_message_id = activitymessageid INTO isaudit;
raise info '该活动的优惠是否需要审核状态为:%',isaudit;
FOR rec_way in SELECT * FROM activity_way_relation WHERE activity_message_id = activitymessageid AND order_column = ordernum
loop
	--生成玩家优惠记录
	IF rec_way.preferential_form = PREFERETIAL_FORM_REGULAR THEN
		insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit)
		values(applyid,activitymessageid,rec_way.preferential_form,rec_way.preferential_value,rec_way.preferential_audit);
		result_code_array[3] = 'value';
		result_code_array[4] = rec_way.preferential_value;
	END IF;

	IF isaudit THEN
		--更新玩家优惠申请信息的状态 0待确认１待处理２成功３失败
		UPDATE activity_player_apply set check_state = APPLY_CHECK_STATUS_PENDING WHERE id = applyid;
	ELSE
		orderNo := (SELECT f_order_no(sitecode, '02'));
		IF rec_way.preferential_audit = NULL OR rec_way.preferential_audit = 0 THEN
			isAuditFavorable = FALSE;
		ELSE
			auditPoints = rec_way.preferential_value*rec_way.preferential_audit;
		END IF;
		--更新玩家优惠申请信息为成功
		UPDATE activity_player_apply set check_state = APPLY_CHECK_STATUS_SUCCESS WHERE id = applyid;
		--自动生成优惠记录
		WITH favorable AS (
			INSERT INTO player_favorable
			(favorable, favorable_remark, is_audit_favorable, audit_favorable_multiple, activity_message_id, transaction_no, favorable_source,player_id,operator_id) VALUES
			(rec_way.preferential_value,favorableremark, isAuditFavorable, rec_way.preferential_audit, activitymessageid, orderNo, 'activity_favorable',playerid,0)
			RETURNING id
		)
		SELECT id FROM favorable INTO favorable_id_temp;
		raise info '自动生成优惠记录:%',favorable_id_temp;
		--自动生成交易订单
		WITH playtransaction AS (
			INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data) VALUES
			(orderNo, applytime, 'favorable', favorableremark, rec_way.preferential_value, rec_way.preferential_value + (SELECT wallet_balance FROM user_player WHERE id = playerid), 'success',playerid, favorable_id_temp, auditPoints, false, false, 'favourable', activitytype, activityname_json)
			RETURNING id
		)
		SELECT id FROM playtransaction INTO transaction_id_temp;
		raise info '自动生成交易记录:%',transaction_id_temp;
		--更新玩家优惠记录
		UPDATE player_favorable set player_transaction_id = transaction_id_temp WHERE id = favorable_id_temp;
		-- 修改玩家余额
		UPDATE user_player SET wallet_balance = COALESCE(wallet_balance,0) + rec_way.preferential_value WHERE id = playerid;
	END IF;
END loop;

	RETURN json_object(result_code_array);

END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_message_calculator"(activitymessage json,playerInfo json,applyresult json) IS '立即计算优惠';
CREATE OR REPLACE FUNCTION "f_message_entrance"(activitymessageid int4, playerid int4, sitecode varchar)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
	--优惠活动信息
	activitytype VARCHAR;--活动类型
	activitystarttime TIMESTAMP;--活动开始时间
	activityendtime TIMESTAMP;--活动结束时间
	checkstatus  VARCHAR;--活动审核状态
	applystarttime TIMESTAMP;--申领开始时间
	applyendtime TIMESTAMP;--申领结束时间
	--玩家信息
	username VARCHAR;--玩家名
	registertime TIMESTAMP;--注册时间
	rankid INT;--层级id
	rankname VARCHAR;--层级名称
	riskmarker BOOLEAN;--层级危险标志
	--临时结果
	applytimeinterval json;
	result_code text;---code(操作代码)
	activitymessage json;--优惠活动信息
	playerInfo json;--申请玩家信息
	applyresult json;--活动申请信息
	resultjson json;--活动优惠信息
	ACTIVITY_MEET text := '000';--执行成功代码
BEGIN
--查询优惠活动信息，转化为json存储
SELECT start_time,end_time,activity_type_code,check_status FROM activity_message WHERE id = activitymessageid INTO activitystarttime,activityendtime,activitytype,checkstatus;
SELECT * FROM f_message_query_applytime(activitymessageid) INTO applytimeinterval;
applystarttime = (applytimeinterval->>'applystarttime')::TIMESTAMP;
applyendtime  = (applytimeinterval->>'applyendtime')::TIMESTAMP;
activitymessage = json_build_object('activitymessageid',activitymessageid,'activitystarttime',activitystarttime,'activityendtime',activityendtime,'activitytype',activitytype,'checkstatus',checkstatus,'applystarttime',applystarttime,'applyendtime',applyendtime);
raise info '优惠活动信息:%',activitymessage;
--查询玩家信息，转化为json存储
SELECT sysuser.username,sysuser.create_time,player.rank_id,prank.rank_name,prank.risk_marker FROM sys_user sysuser,user_player player,player_rank prank
WHERE sysuser.id = player.id AND player.rank_id = prank.id AND sysuser.id=playerid INTO username,registertime,rankid,rankname,riskmarker;
playerInfo = json_build_object('playerid',playerid,'username',username,'registertime',registertime,'rankid',rankid,'rankname',rankname,'riskmarker',riskmarker,'applytime',CURRENT_TIMESTAMP,'sitecode',sitecode);
raise info '申请玩家信息:%',playerInfo;
--生成优惠活动申请
SELECT * FROM f_message_apply(activitymessage ,playerInfo) INTO applyresult;
raise info '生成优惠活动申请的结果:%',applyresult;
result_code = applyresult->>'resultcode';
IF result_code<> ACTIVITY_MEET THEN
 RETURN applyresult;
END IF;
--计算活动优惠
SELECT * FROM f_message_calculator(activitymessage, playerinfo, applyresult) INTO resultjson;
raise info '计算活动优惠的结果:%',resultjson;
	RETURN resultjson;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;
COMMENT ON FUNCTION "f_message_entrance"(activitymessageid int4, playerid int4, sitecode varchar) IS '优惠活动统一入口';