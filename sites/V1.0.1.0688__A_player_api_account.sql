-- auto gen by linsen 2018-02-27 17:41:20
--添加转账限额字段
select redo_sqls($$
    ALTER TABLE player_api_account ADD COLUMN transfer_limit numeric(20,2);
  $$);

COMMENT ON COLUMN player_api_account.transfer_limit IS '转账限额';