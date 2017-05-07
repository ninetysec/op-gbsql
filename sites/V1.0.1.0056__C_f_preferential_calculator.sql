-- auto gen by cherry 2016-03-11 19:38:08


--优惠奖励计算函数

CREATE OR REPLACE FUNCTION "f_preferential_calculator"(activitymessageid int4, playerid int4, sitecode varchar, ordernum int4)

  RETURNS "pg_catalog"."json" AS $BODY$

declare

activityType VARCHAR;--活动类型



--活动申请信息

applyid INT;--申请id

username VARCHAR;--玩家名

registertime TIMESTAMP;--注册时间

rankid INT;

rankname VARCHAR;

riskmarker BOOLEAN;--层级危险标志

applytime TIMESTAMP:= CURRENT_TIMESTAMP;--申请时间

starttime TIMESTAMP;--申领区间-开始时间



result_code_array text [];--结果返回数组,由4个成员组成:resltCode(结果代码),code代码(),value(优惠金额,非必须),value值(非必须)

result_code text;---code(操作代码)

rec_way record;--优惠形式结果集

isaudit BOOLEAN;--活动是否需要审核

orderNo VARCHAR;--订单流水号

favorable_id_temp int;--优惠记录主键

transaction_id_temp int;--订单记录主键

isAuditFavorable BOOLEAN := TRUE;--是否优惠稽核

auditPoints NUMERIC ;--稽核点

activityname_json VARCHAR := '' ;--活动名称，所有语言版本的名称都需要存储

favorableremark VARCHAR;--备注信息



apply_check_status_confirmed VARCHAR := '0';--申请审核状态-待确认

apply_check_status_pending VARCHAR := '1';--申请审核状态-待处理

apply_check_status_success VARCHAR := '2';--申请审核状态-成功

apply_check_status_failure VARCHAR := '3';--申请审核状态-失败

type_regist_send VARCHAR := 'regist_send';--注册送的activity_type

type_relief_fund VARCHAR := 'relief_fund';--救济金的activity_type

rule_loss_ge varchar := 'loss_ge';--优惠规则：亏损

rule_effective_transaction_ge varchar := 'effective_transaction_ge';--优惠规则：有效交易量

rule_total_assets_le varchar := 'total_assets_le';--优惠规则：总资产(小于等于)

preferential_form_percentage varchar := 'percentage_handsel';--优惠形式:比例彩金

preferential_form_regular varchar := 'regular_handsel';--优惠形式:固定彩金

code_all_meet text := '000';--满足所有优惠条件

code_exist_apply text := '200';--同一申领周期已存在申请



BEGIN



SELECT activity_type_code FROM activity_message WHERE id = activitymessageid INTO activitytype;



SELECT * from f_query_activityname(activitymessageid) INTO activityname_json;

raise info '活动名称的JSON：%',activityname_json;



SELECT * FROM f_query_activityapply_starttime(activitymessageid) INTO starttime;

raise info '申领周期的开始时间为:%',starttime;



SELECT is_audit FROM activity_rule WHERE activity_message_id = activitymessageid INTO isaudit;

raise info '当前活动优惠是否需要提交审核为：%.',isaudit;



IF activitytype = type_regist_send THEN

	favorableremark = '注册赠送彩金';

ELSEIF activitytype = type_relief_fund THEN

	favorableremark = '赠送救济金';

END IF;



IF EXISTS(SELECT * FROM activity_player_apply WHERE activity_message_id = activitymessageid AND user_id = playerid AND apply_time >= starttime AND apply_time <= applytime) THEN

	result_code_array[1] = 'resltCode';

	result_code_array[2] = code_exist_apply;

	raise info '同一申领周期已存在申请.';

	RETURN json_object(result_code_array);

END IF;



result_code_array[1] = 'resltCode';

result_code_array[2] = code_all_meet;

SELECT sysuser.username,sysuser.create_time,player.rank_id,prank.rank_name,prank.risk_marker FROM sys_user sysuser,user_player player,player_rank prank

WHERE sysuser.id = player.id AND player.rank_id = prank.id AND sysuser.id=playerid INTO username,registertime,rankid,rankname,riskmarker;

WITH activityaplayapply AS (

	INSERT INTO activity_player_apply(activity_message_id,user_id,user_name,register_time,rank_id,rank_name,risk_marker,apply_time,check_state,start_time,end_time)

	VALUES (activitymessageid,playerid,username,registertime,rankid,rankname,riskmarker,applytime,apply_check_status_confirmed,starttime,applytime)

	RETURNING id

)

SELECT id FROM activityaplayapply INTO applyid;

raise info '开始计算玩家:%能获得的优惠',playerid;

FOR rec_way in SELECT * FROM activity_way_relation WHERE activity_message_id = activitymessageid AND order_column = ordernum

loop

	--生成玩家优惠记录

	IF rec_way.preferential_form = preferential_form_regular THEN

		insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit)

		values(applyid,activitymessageid,rec_way.preferential_form,rec_way.preferential_value,rec_way.preferential_audit);

		result_code_array[3] = 'value';

		result_code_array[4] = rec_way.preferential_value;

	END IF;



	IF isaudit THEN

		--更新玩家优惠申请信息的状态 0待确认１待处理２成功３失败

		UPDATE activity_player_apply set check_state = apply_check_status_pending WHERE id = applyid;

	ELSE

		orderNo := (SELECT f_order_no(siteCode, '02'));

		IF rec_way.preferential_audit = NULL THEN

			isAuditFavorable = FALSE;

		ELSE

			auditPoints = rec_way.preferential_value*rec_way.preferential_audit;

		END IF;



		--更新玩家优惠申请信息为成功

		UPDATE activity_player_apply set check_state = apply_check_status_success WHERE id = applyid;



		--自动生成优惠记录

		WITH favorable AS (

			INSERT INTO player_favorable

			(favorable, favorable_remark, is_audit_favorable, audit_favorable_multiple, activity_message_id, transaction_no, favorable_source,player_id,operator_id) VALUES

			(rec_way.preferential_value,favorableremark, isAuditFavorable, rec_way.preferential_audit, activitymessageid, orderNo, 'activity_favorable',playerid,0)

			RETURNING id

		)



		SELECT id FROM favorable INTO favorable_id_temp;

		--自动生成交易订单

		WITH playtransaction AS (

			INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data) VALUES

			(orderNo, applytime, 'favorable', favorableremark, rec_way.preferential_value, rec_way.preferential_value + (SELECT wallet_balance FROM user_player WHERE id = playerid), 'success',playerid, favorable_id_temp, auditPoints, false, false, 'favourable', activitytype, activityname_json)

			RETURNING id

		)



		SELECT id FROM playtransaction INTO transaction_id_temp;

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

COMMENT ON FUNCTION "f_preferential_calculator"(activitymessageid int4, playerid int4, sitecode varchar, ordernum int4) IS '优惠奖励计算';