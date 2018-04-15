-- auto gen by linsen 2018-04-15 21:40:56
-- 救济金规则判断 by kobe
DROP FUNCTION IF EXISTS gamebox_activityhall_rule_relief;
CREATE OR REPLACE FUNCTION "gamebox_activityhall_rule_relief"(activitymessage json, playerinfo json)
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
code_effective_transaction text := '0';
code_loss text:= '1';
code_total_assets text:= '1';

ACTIVITY_RELIEF_ORDER_PENDING text:='25'; --有未结算订单
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
--是否有未开奖注单
IF EXISTS(SELECT * FROM player_game_order WHERE player_id=playerid AND bet_time<=applyendtime AND order_state = 'pending_settle') THEN
RETURN json_build_object('resultcode',ACTIVITY_RELIEF_ORDER_PENDING);
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
--判断亏损额度是否达到条件
	SELECT  gamebox_activityhall_calculator_profit_loss(playerid,applystarttime,applytime,activitymessageid) INTO profitloss;
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
	SELECT  gamebox_activityhall_calculator_total_assets(playerid) into totalassets;
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
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gamebox_activityhall_rule_relief"(activitymessage json, playerinfo json) IS '救济金规则判断';