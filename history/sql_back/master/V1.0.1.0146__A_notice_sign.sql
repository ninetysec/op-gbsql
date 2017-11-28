-- auto gen by cheery 2015-10-27 20:01:49
--修改系统消息标记表名
ALTER TABLE IF EXISTS notice_sign rename to station_letter_sign;

--存款表新增玩家填写收款账号、玩家填写收款姓名字段
DROP VIEW IF EXISTS v_player_recharge;

select redo_sqls($$
  ALTER TABLE player_recharge ADD COLUMN receive_account varchar(50);
  ALTER TABLE player_recharge ADD COLUMN receive_name varchar(128);
$$);


COMMENT ON COLUMN player_recharge.receive_account  is '玩家填写收款账号';
COMMENT ON COLUMN player_recharge.receive_name IS '玩家填写收款姓名';

CREATE OR REPLACE VIEW v_player_recharge AS
  SELECT t1.*,t2.username,t3.username check_user_name,
                          t2.default_currency main_currency,t2.nation,t4.recharge_count,
                          t5.account master_bank_card,t5.pay_name master_name,t5.status master_bankcard_status,
                          t5.bank_code master_bank ,t5.account_type master_bank_type,t2.default_timezone,t6.risk_marker
  FROM player_recharge t1
    LEFT JOIN sys_user t2 on t1.player_id = t2."id"
    LEFT JOIN sys_user t3 ON t1.check_user_id=t3."id"
    LEFT JOIN user_player t4 ON t4.id = t1.player_id
    LEFT JOIN pay_account t5 ON t1.pay_account_id = t5.id
    LEFT JOIN player_rank t6 ON t6.id = t4.rank_id;