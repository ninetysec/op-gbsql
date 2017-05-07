-- auto gen by cheery 2015-09-14 09:26:01
--删除玩家存款视图
DROP VIEW IF EXISTS v_player_recharge;
--修改玩家存款-手续费输入值类型
ALTER TABLE player_recharge  ALTER COLUMN cf_ratio_or_fixed_value TYPE NUMERIC(20,2);
--创建玩家存款视图
CREATE VIEW v_player_recharge as
SELECT t1.*,t2.username,t3.username check_user_name,
	t4.main_currency,t4.special_focus,t4.nation,t4.recharge_count,
	t5.account master_bank_card,t5.pay_name master_name,t5.status master_bankcard_status,
	t5.bank_code master_bank ,t5.account_type master_bank_type,t2.default_timezone
FROM player_recharge t1
LEFT JOIN sys_user t2 on t1.player_id = t2."id"
LEFT JOIN sys_user t3 ON t1.check_user_id=t3."id"
LEFT JOIN user_player t4 ON t4.id = t1.player_id
LEFT JOIN pay_account t5 ON t1.pay_account_id = t5.id
