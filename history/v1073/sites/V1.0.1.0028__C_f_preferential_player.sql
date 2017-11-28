-- auto gen by cherry 2016-03-03 09:55:04
--删除函数

DROP FUNCTION if EXISTS f_preferential_player(activitymessageid int4, playerid int4);

--优惠活动前置条件函数

CREATE OR REPLACE FUNCTION "f_message_precondition"(activitymessageid int4)

  RETURNS "pg_catalog"."text" AS $BODY$

declare

	startTime TIMESTAMP;--活动开始时间

	endTime TIMESTAMP;--活动结束时间

	checkstatus  VARCHAR;--活动审核状态

	activitytype VARCHAR;--活动类型

	activity_status_success VARCHAR := '1';--活动审核通过状态值

	code_pre_meet text:='00';--活动满足前置条件

	code_not_exist text :='01';--活动未审核

	code_not_check text :='02';--活动未审核

	code_not_start text :='03';--活动未开始

	code_end text :='04';--活动已结束

BEGIN



IF NOT EXISTS(SELECT * FROM activity_message WHERE id=activitymessageid) THEN

raise info '活动:%不存在.',activitymessageid;

RETURN code_not_exist;

END IF;



SELECT start_time,end_time,check_status,activity_type_code FROM activity_message WHERE id = activitymessageid INTO startTime,endTime,checkstatus,activitytype;

raise info '活动开始时间为:%,结束时间为:%,当前审核状态为:%,活动类型为：%',startTime,endTime,checkstatus,activitytype;



IF checkstatus != activity_status_success THEN

raise info '活动:%,当前审核状态为:%,未审核通过.',activitymessageid,checkstatus;

RETURN code_not_check;

END IF;



IF startTime > CURRENT_TIMESTAMP THEN

raise info '活动:%,开始时间为:%,未开始.',activitymessageid,startTime;

RETURN code_not_start;

END IF;



IF endTime < CURRENT_TIMESTAMP THEN

raise info '活动:%,结束时间为:%,已结束.',activitymessageid,endTime;

RETURN code_end;

END IF;



RETURN code_pre_meet;





END

$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



ALTER FUNCTION "f_message_precondition"(activitymessageid int4) OWNER TO "postgres";



COMMENT ON FUNCTION "f_message_precondition"(activitymessageid int4) IS '优惠活动前置条件';





--查询申领区间的开始时间函数

CREATE OR REPLACE FUNCTION "f_query_activityapply_starttime"(activitymessageid int4)

  RETURNS "pg_catalog"."timestamp" AS $BODY$ DECLARE



starttime TIMESTAMP;--申领区间-开始时间

claimperiod VARCHAR; --活动申领周期



BEGIN



SELECT start_time FROM activity_message WHERE id = activitymessageid INTO starttime;



SELECT

	CASE

	WHEN (claim_period = 'NaturalDay') THEN '1 day'

	WHEN (claim_period = 'NaturalWeek') THEN '1 week'

	WHEN (claim_period = 'NaturalMonth') THEN '1 month'

	WHEN (claim_period = 'ActivityCycle') THEN 'cycle'

	ELSE 'cycle'

	END AS claim_period FROM activity_rule WHERE activity_message_id=activitymessageid INTO claimperiod;

	raise info '活动申领计算周期:%',claimperiod;



	IF claimperiod <> 'cycle' THEN

		loop

			exit WHEN (starttime+ claimperiod::INTERVAL) > CURRENT_TIMESTAMP;

			starttime = starttime + claimperiod::INTERVAL;

		END loop;

	END IF;

	raise info '申领周期的开始时间为:%',starttime;

RETURN starttime;



END $BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



ALTER FUNCTION "f_query_activityapply_starttime"(activitymessageid int4) OWNER TO "postgres";



COMMENT ON FUNCTION "f_query_activityapply_starttime"(activitymessageid int4) IS '查询申领区间的开始时间';



--救济金优惠计算

CREATE OR REPLACE FUNCTION "f_preferential_relief"(activitymessageid int4, playerid int4, sitecode varchar)

  RETURNS "pg_catalog"."json" AS $BODY$

declare

activityType VARCHAR;--活动类型

activitystarttime TIMESTAMP;--活动开始时间

activityendtime TIMESTAMP;--活动结束时间

claimperiod VARCHAR; --活动申领周期

applyid INT;--申请id

username VARCHAR;--玩家名

registertime TIMESTAMP;--注册时间

rankid INT;

rankname VARCHAR;

riskmarker BOOLEAN;--层级危险标志

applytime TIMESTAMP:= CURRENT_TIMESTAMP;--申请时间

starttime TIMESTAMP;--申领区间-开始时间

apply_check_status_confirmed VARCHAR := '0';--申请审核状态-待确认

apply_check_status_pending VARCHAR := '1';--申请审核状态-待处理

apply_check_status_success VARCHAR := '2';--申请审核状态-成功

apply_check_status_failure VARCHAR := '3';--申请审核状态-失败

profitloss NUMERIC;--玩家盈亏金额

effectivetransaction NUMERIC;--玩家有效交易量

totalassets NUMERIC;--玩家总资产



type_regist_send VARCHAR := 'regist_send';--注册送的activity_type

type_relief_fund VARCHAR := 'relief_fund';--救济金的activity_type

rule_loss_ge varchar := 'loss_ge';--优惠规则：亏损

rule_effective_transaction_ge varchar := 'effective_transaction_ge';--优惠规则：有效交易量

rule_total_assets_le varchar := 'total_assets_le';--优惠规则：总资产(小于等于)



order_num int :=10;--计算的优惠档次初始值

order_num_temp int;--计算的优惠档次临时值



result_code_array text [];--结果返回数组,由4个成员组成:resltCode(结果代码),code代码(),value(优惠金额,非必须),value值(非必须)

result_code text;---code(操作代码)



code_all_meet text := '000';--满足所有优惠条件

code_not_meet text:='99';--未满足前置条件

code_effective_transaction text := '1';

code_loss text:= '1';

code_total_assets text:= '1';

code_not_effective_transaction text := '100';--有效交易量没满足条件

code_not_loss text := '010';--亏损额度没满足条件

code_not_total_assets text := '001';--总资产没满足条件

code_not_effective_transaction_loss text := '110';--有效交易量,亏损额度没满足条件

code_not_loss_total_assets text := '011';--亏损额度,总资产没满足条件

code_not_effective_transaction_loss_total_assets text := '111';--有效交易量,亏损额度,总资产没满足条件

code_failure text := '999';--失败



rec_way record;--优惠形式结果集

preferential_form_percentage varchar := 'percentage_handsel';--优惠形式:比例彩金

preferential_form_regular varchar := 'regular_handsel';--优惠形式:固定彩金

isaudit BOOLEAN;--活动是否需要审核

orderNo VARCHAR;--订单流水号

favorable_id_temp int;--优惠记录主键

transaction_id_temp int;--订单记录主键

isAuditFavorable BOOLEAN := TRUE;--是否优惠稽核

auditPoints NUMERIC ;--稽核点

activityname_json VARCHAR := '' ;--活动名称，所有语言版本的名称都需要存储



BEGIN



	SELECT start_time,end_time,activity_type_code FROM activity_message WHERE id = activitymessageid INTO activitystarttime,activityendtime,activitytype;

	raise info '活动开始时间为:%,结束时间为:%,活动类型为：%',activitystarttime,activityendtime,activitytype;

	result_code_array[1] = 'resltCode';

	result_code_array[2] = code_failure;

	IF activityType <> type_relief_fund THEN

    result_code_array[2] = code_not_meet;

		RETURN json_object(result_code_array);

	END IF;



	SELECT * FROM f_query_activityapply_starttime(activitymessageid) INTO starttime;

	raise info '申领周期的开始时间为:%',starttime;



	SELECT  f_calculator_effective_transaction(playerid,starttime,applytime) INTO effectivetransaction;

	raise notice '查询玩家的有效交易量,结果:%',effectivetransaction;

	IF EXISTS(SELECT * FROM	activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = rule_effective_transaction_ge AND preferential_value <= effectivetransaction) THEN

		code_effective_transaction = '0';

		SELECT order_column FROM	activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = rule_effective_transaction_ge AND preferential_value <= effectivetransaction ORDER BY order_column DESC LIMIT 1 INTO order_num_temp;

		raise info '玩家:%的有效交易量已满足条件,当前的有效交易量最高满足了%档.',playerid,order_num_temp;

		IF COALESCE (order_num_temp, 0) < order_num THEN

			order_num = order_num_temp;

		END IF;

	END IF;



	SELECT  f_calculator_profit_loss(playerid,starttime,applytime) INTO profitloss;

	raise notice '查询玩家亏损情况,结果:%',profitloss;

	IF profitloss < 0 AND EXISTS(SELECT * FROM	activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = rule_loss_ge AND preferential_value <= abs(profitloss)) THEN

		code_loss = '0';

		SELECT order_column FROM activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = rule_loss_ge AND preferential_value <= abs(profitloss) order by order_column desc LIMIT 1 into order_num_temp;

		raise info '玩家:%的亏损额度已满足条件,当前的亏损额度最高满足了%档.',playerid,order_num_temp;

		IF COALESCE (order_num_temp, 0) < order_num THEN

			order_num = order_num_temp;

		END IF;

	END IF;



	SELECT  f_calculator_total_assets(playerid) into totalassets;

	raise notice '查询玩家的总资产,结果:%',totalassets;

	IF EXISTS(SELECT * FROM	activity_preferential_relation WHERE activity_message_id = activitymessageid AND preferential_code = rule_total_assets_le AND preferential_value >= totalassets) THEN

		code_total_assets = '0';

		SELECT order_column FROM activity_preferential_relation WHERE activity_message_id = activitymessageid and preferential_code = rule_total_assets_le and preferential_value >= totalassets order by order_column asc LIMIT 1 into order_num_temp;

		raise info '玩家:%的总资产已满足条件,当前总资产最低满足了%档.',playerid,order_num_temp;

		IF COALESCE (order_num_temp, 0) > order_num then

			raise info '总资产满足的最低档次大于当前已符合的最低档次,因此玩家不能获得优惠';

			code_total_assets = '1';

		END IF;

	END IF;



	result_code = code_effective_transaction || code_loss || code_total_assets;

	result_code_array[2] = result_code;

  raise info '玩家:%是否满足救济金的优惠条件的code:%.',playerid,result_code;



	IF result_code=code_all_meet THEN

		RETURN f_preferential_calculator(activitymessageid, playerid, sitecode, order_num);

	END IF;

	RETURN json_object(result_code_array);



END



$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



ALTER FUNCTION "f_preferential_relief"(activitymessageid int4, playerid int4, sitecode varchar) OWNER TO "postgres";



COMMENT ON FUNCTION "f_preferential_relief"(activitymessageid int4, playerid int4, sitecode varchar) IS '救济金优惠计算';



--玩家优惠申请统一入口

CREATE OR REPLACE FUNCTION "f_preferential_player"(activitymessageid int4, playerid int4, sitecode varchar)

  RETURNS "pg_catalog"."json" AS $BODY$

declare



activityType VARCHAR;--活动类型

activitystarttime TIMESTAMP;--活动开始时间

activityendtime TIMESTAMP;--活动结束时间

result_code text;---resltCode(结果代码)

result_code_array text [];--结果返回数组,由4个成员组成:resltCode(结果代码),code代码(),value(优惠金额,非必须),value值(非必须)



type_regist_send VARCHAR := 'regist_send';--注册送的activity_type

type_relief_fund VARCHAR := 'relief_fund';--救济金的activity_type

code_pre_meet text:='00';--活动满足前置条件





BEGIN



SELECT * FROM f_message_precondition(activitymessageid)  INTO result_code;

raise info '活动前置条件满足状态码为：%',result_code;

result_code_array[1] = 'resltCode';

result_code_array[2] = result_code;



SELECT activity_type_code FROM activity_message WHERE id = activitymessageid INTO activitytype;

raise info '活动类型为：%',activitytype;



IF result_code = code_pre_meet AND activitytype = type_relief_fund THEN

	RETURN f_preferential_relief(activitymessageid, playerid , sitecode);

END IF;



RETURN  json_object(result_code_array);



END

$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;


COMMENT ON FUNCTION "f_preferential_player"(activitymessageid int4, playerid int4, sitecode varchar) IS '玩家优惠申请统一入口';

