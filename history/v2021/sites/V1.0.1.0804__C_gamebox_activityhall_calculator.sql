-- auto gen by linsen 2018-05-08 09:20:37
-- 立即计算优惠 by kobe
DROP FUNCTION IF EXISTS "gamebox_activityhall_calculator"(activitymessage json, playerinfo json, applyresult json);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_calculator"(activitymessage json, playerinfo json, applyresult json)
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
  preferentialdata 	VARCHAR:= '';	-- json存放活动详情
--v1.01  2018/04/23  kobe
	user_name VARCHAR ; ---玩家账号
	agentid int4 ; ---代理id
	agentname VARCHAR ; ---代理账号
	topagentid int4 ; ---总代id
	topagentname VARCHAR ; ---总代账号
BEGIN
--信息初始化
activitymessageid =  activitymessage ->> 'activitymessageid';
activitytype = activitymessage->>'activitytype';
playerid =  playerInfo ->> 'playerid';
applytime =  (playerInfo ->> 'applytime')::TIMESTAMP;
sitecode =  playerInfo ->> 'sitecode';
applyid = applyresult->>'applyId';
ordernum = applyresult->>'ordernum';
preferentialdata = applyresult->>'preferentialdata';
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

SELECT * from gamebox_activityhall_query_activityname(activitymessageid) INTO activityname_json;
SELECT is_audit FROM activity_rule  where activity_message_id = activitymessageid INTO isaudit;
--v1.01  2018/04/23  kobe
SELECT username FROM sys_user where id = playerid INTO user_name;
SELECT user_agent_id,agent_name,general_agent_id,general_agent_name FROM user_player  where id = playerid INTO agentid,agentname,topagentid,topagentname;
raise info '该活动的优惠是否需要审核状态为:%',isaudit;
FOR rec_way in SELECT * FROM activity_way_relation WHERE activity_message_id = activitymessageid AND order_column = ordernum
loop
	--生成玩家优惠记录
	IF rec_way.preferential_form = PREFERETIAL_FORM_REGULAR THEN
		insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit,preferential_data)
		values(applyid,activitymessageid,rec_way.preferential_form,rec_way.preferential_value,rec_way.preferential_audit,preferentialdata);
		result_code_array[3] = 'value';
		result_code_array[4] = rec_way.preferential_value;
	END IF;

	IF isaudit THEN
		--更新玩家优惠申请信息的状态 0待确认１待处理２成功３失败
		UPDATE activity_player_apply set check_state = APPLY_CHECK_STATUS_PENDING WHERE id = applyid;
	ELSE
		SELECT apply_transaction_no FROM activity_player_apply WHERE id = applyid INTO orderNo;
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
			INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data,origin,rank_id,completion_time,agent_id,agent_username,topagent_id,topagent_username,user_name) VALUES
			(orderNo, applytime, 'favorable', favorableremark, rec_way.preferential_value, rec_way.preferential_value + (SELECT wallet_balance FROM user_player WHERE id = playerid), 'success',playerid, favorable_id_temp, auditPoints, false, false, 'favourable', activitytype, activityname_json,'PC',(SELECT rank_id FROM user_player WHERE id = playerid),applytime,agentid,agentname,topagentid,topagentname,user_name)
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


COMMENT ON FUNCTION "gamebox_activityhall_calculator"(activitymessage json, playerinfo json, applyresult json) IS '立即计算优惠';