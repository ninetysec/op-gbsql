-- auto gen by cheery 2015-12-01 06:57:35
--存款表新增收款账户类型字段
DROP VIEW IF EXISTS v_player_recharge;

select redo_sqls($$
    ALTER TABLE player_recharge ADD COLUMN master_bank_type VARCHAR(50);
$$);

COMMENT ON COLUMN player_recharge.master_bank_type IS '收款账号类型（第三方账户、银行账户）';

UPDATE player_recharge SET master_bank_type = (
  SELECT pay_account.account_type FROM pay_account WHERE pay_account.id = player_recharge.pay_account_id
);

CREATE OR REPLACE VIEW v_player_recharge as
  SELECT t1.*,t2.username,t3.username check_user_name,
         t2.default_currency main_currency,t2.nation,t4.recharge_count,
         t5.account master_bank_card,t5.pay_name master_name,t5.status master_bankcard_status,
         t5.bank_code master_bank,t2.default_timezone,t6.risk_marker
  FROM player_recharge t1
    LEFT JOIN sys_user t2 on t1.player_id = t2."id"
    LEFT JOIN sys_user t3 ON t1.check_user_id=t3."id"
    LEFT JOIN user_player t4 ON t4.id = t1.player_id
    LEFT JOIN pay_account t5 ON t1.pay_account_id = t5.id
    LEFT JOIN player_rank t6 ON t6.id = t4.rank_id;