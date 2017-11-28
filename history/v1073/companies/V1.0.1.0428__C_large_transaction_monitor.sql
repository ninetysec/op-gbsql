-- auto gen by cherry 2017-09-30 09:30:52
CREATE TABLE IF not EXISTS large_transaction_monitor(
	id serial4 not null PRIMARY key,
	site_id int4,
	transaction_no varchar(32),
	create_time timestamp(6),
	transaction_money numeric(20,2),
	player_id int4,
	user_name varchar(16),
	status varchar(32),
	fund_type varchar(32),
	transaction_type varchar(32)
);

COMMENT ON TABLE large_transaction_monitor is '大额交易监控：主要记录存款、转入';
COMMENT ON COLUMN large_transaction_monitor.id is '主键';
COMMENT ON COLUMN large_transaction_monitor.site_id is '站点id';
COMMENT ON COLUMN large_transaction_monitor.transaction_no is '交易号';
COMMENT ON COLUMN large_transaction_monitor.create_time is '创建时间';
COMMENT ON COLUMN large_transaction_monitor.transaction_money is '交易金额';
COMMENT ON COLUMN large_transaction_monitor.player_id is '玩家id';
COMMENT ON COLUMN large_transaction_monitor.user_name is '玩家账号';
COMMENT ON COLUMN large_transaction_monitor.status is '状态';
COMMENT ON COLUMN large_transaction_monitor.fund_type is '资金类型';
COMMENT ON COLUMN large_transaction_monitor.transaction_type is '交易类型';

select redo_sqls($$
    ALTER TABLE sys_site ADD COLUMN default_transfer_limit numeric(20,2);
		ALTER TABLE sys_site ADD COLUMN current_transfer_limit numeric(20,2);
		ALTER TABLE sys_site ADD COLUMN transfer_out_sum numeric(20,2);
		ALTER TABLE sys_site ADD COLUMN transfer_into_sum numeric(20,2);
		ALTER TABLE sys_site ADD COLUMN transfer_limit_time TIMESTAMP(6);
  $$);

COMMENT ON COLUMN sys_site.default_transfer_limit is '默认转账上限';
COMMENT ON COLUMN sys_site.current_transfer_limit is '当前转账上限';
COMMENT ON COLUMN sys_site.transfer_out_sum is '当前转出统计';
COMMENT ON COLUMN sys_site.transfer_into_sum is '当前转入统计';
COMMENT ON COLUMN sys_site.transfer_limit_time is '转账超出倒计时时间';
