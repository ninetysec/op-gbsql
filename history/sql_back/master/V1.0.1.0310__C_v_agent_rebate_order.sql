-- auto gen by cherry 2016-01-06 14:22:50
drop view IF EXISTS v_agent_rebate_order;

CREATE OR REPLACE VIEW "v_agent_rebate_order" AS
 SELECT o.id,
    o.agent_id,
    o.transaction_no,
    o.settlement_state,
    o.currency,
    o.rebate_amount,
    o.actual_amount,
    o.create_time,
    o.reason_title,
    o.reason_content,
    o.remark,
    o.user_id,
    o.username,
    o.rebate_bill_id,
    b.start_time,
    b.end_time,
    b.create_time AS bill_create_time,
    b.period
   FROM (agent_rebate_order o
     LEFT JOIN rebate_bill b ON (((o.rebate_bill_id = b.id) AND (o.rebate_bill_id = b.id))));

ALTER TABLE "v_agent_rebate_order" OWNER TO "postgres";

COMMENT ON VIEW "v_agent_rebate_order" IS '代理返佣订单视图';

DROP FUNCTION IF EXISTS  f_preferential_message(integer);

CREATE OR REPLACE FUNCTION "f_preferential_message"(activitymessageid int4,sitecode varchar)
  RETURNS "pg_catalog"."void" AS $BODY$declare

		rec_apply	RECORD;--优惠申请结果集
		rec_preferential_code record;--优惠代码结果集
		rec_way record;--优惠形式结果集
		order_num_temp int;--计算的优惠档次临时值
		order_num int = 10;--满足的优惠档次
		preferential_value_temp NUMERIC;--优惠规则梯次值
		isaudit BOOLEAN;--活动是否需要审核
		orderNo VARCHAR;
		favorable_id_temp VARCHAR;--优惠记录主键
		transaction_id_temp VARCHAR;--订单记录主键

		rule_loss_ge varchar := 'loss_ge';--优惠规则：亏损
		rule_profit_ge varchar := 'profit_ge';--优惠规则：盈利
		rule_effective_transaction_ge varchar := 'effective_transaction_ge';--优惠规则：有效交易量
		rule_total_transaction_ge varchar := 'total_transaction_ge';--优惠规则：总有效交易量
		rule_total_assets_le varchar := 'total_assets_le';--优惠规则：总资产(小于等于)

		preferential_form_percentage varchar := 'percentage_handsel';--优惠形式:比例彩金
		preferential_form_regular varchar := 'regular_handsel';--优惠形式:固定彩金

BEGIN
select r.is_audit from activity_rule r where r.activity_message_id = activitymessageid INTO isaudit;
--获取该活动的所有申请玩家
FOR rec_apply IN (select a.id,a.activity_message_id,m.activity_type_code,a.user_id,a.start_time,a.end_time,a.player_recharge_id from activity_player_apply a LEFT OUTER JOIN activity_message m on a.activity_message_id=m.id where activity_message_id = activitymessageid)
loop
--获取当前活动的优惠规则
FOR rec_preferential_code in select DISTINCT(preferential_code) from activity_preferential_relation where activity_message_id = activitymessageid
loop
  --亏损
	if rec_preferential_code.preferential_code = rule_loss_ge THEN
	select  f_calculator_profit_loss(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) into preferential_value_temp;
	end if;
  --盈利
  if rec_preferential_code.preferential_code = rule_profit_ge THEN
	select  f_calculator_profit_loss(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) into preferential_value_temp;
	end if;
  --有效交易量(大于等于)
	if rec_preferential_code.preferential_code = rule_effective_transaction_ge THEN
	select  f_calculator_effective_transaction(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) into preferential_value_temp;
	end if;
  --总有效交易量
	if rec_preferential_code.preferential_code = rule_total_transaction_ge THEN
	select  f_calculator_effective_transaction(rec_apply.user_id,rec_apply.start_time,rec_apply.end_time) into preferential_value_temp;
	end if;
  --总资产(小于等于)
	if rec_preferential_code.preferential_code = rule_total_assets_le THEN
	select  f_calculator_total_assets(rec_apply.user_id) into preferential_value_temp;
	end if;


if rec_preferential_code.preferential_code = rule_loss_ge  THEN
		if preferential_value_temp > 0 then
		order_num = 0;
end if;
end if;

if rec_preferential_code.preferential_code = rule_profit_ge  THEN
		if preferential_value_temp < 0 then
			order_num = 0;
end if;
end if;

if 	order_num !=0 then
	select order_column from activity_preferential_relation where activity_message_id = activitymessageid and preferential_code = rec_preferential_code.preferential_code and preferential_value <= preferential_value_temp order by order_column desc LIMIT 1 into order_num_temp;
	if COALESCE (order_num_temp, 0) < order_num then
	order_num = order_num_temp;
	end if;
	raise info 'order_num_temp:%',order_num_temp;
end if;
END loop;

if 	order_num !=0 then
FOR rec_way in select t.* from activity_way_relation t  where activity_message_id = activitymessageid and order_column = order_num
loop
--生成玩家优惠记录
if rec_way.preferential_form = preferential_form_regular then
insert into activity_player_preferential(activity_player_apply_id,activity_message_id,preferential_form,preferential_value,preferential_audit) values(
|| rec_apply.id || ','
|| rec_apply.activity_message_id || ','
|| rec_way.preferential_form || ','
|| rec_way.preferential_value || ','
|| rec_way.preferential_audit || );
end if;

if isaudit THEN
--更新玩家优惠申请信息的状态１待处理２成功３失败
UPDATE activity_player_apply set check_state = '1' where id = rec_apply.id;

ELSE
--不需要审核，更新玩家优惠申请信息为成功，自动生成优惠记录和交易订单
orderNo := (SELECT f_order_no(siteCode, '02'));
UPDATE activity_player_apply set check_state = '2' where id = rec_apply.id;

WITH favorable AS (
						-- 新增优惠记录数据
						INSERT INTO player_favorable
(favorable, favorable_remark, is_audit_favorable, audit_favorable_multiple, activity_message_id, transaction_no, favorable_source)
						VALUES
(rec_way.preferential_value,
							'系统自动计算玩家优惠', 't', rec_way.preferential_audit, activitymessageid, orderNo, 'activity_favorable')
						RETURNING id
					)
SELECT id from favorable into favorable_id_temp;

WITH playtransaction AS (
						INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data)
					VALUES (orderNo, now(), 'favorable', '系统自动计算玩家优惠', rec_way.preferential_value,
	rec_way.preferential_value + (SELECT wallet_balance FROM user_player WHERE id = rec_apply.use_id), 'success',rec_apply.use_id, favorable_id_temp, rewardPoint, false, false, 'favourable', activitytype, '{"favorableType":"'||activitytype||'"}')
						RETURNING id
					)
SELECT id from playtransaction into transaction_id_temp;

UPDATE player_favorable set player_transaction_id = transaction_id_temp where id = favorable_id_temp;

end if;
end loop;
end if;

END loop;
END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "f_preferential_message"(activitymessageid int4, sitecode varchar) OWNER TO "postgres";

COMMENT ON FUNCTION "f_preferential_message"(activitymessageid int4, sitecode varchar) IS '优惠活动计算入口';