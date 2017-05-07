-- auto gen by cheery 2015-10-09 09:23:02
select redo_sqls($$
  ALTER TABLE settlement_backwater_player ADD COLUMN operate_id int4;
  ALTER TABLE settlement_backwater_player ADD COLUMN operate_username varchar(100);
  ALTER TABLE settlement_backwater_player ADD COLUMN settlement_time timestamp(6);
$$);

COMMENT ON COLUMN settlement_backwater_player.operate_id IS '最后操作者id';
COMMENT ON COLUMN settlement_backwater_player.operate_username IS '最后操作用户名';
COMMENT ON COLUMN settlement_backwater_player.settlement_time IS '结算时间';
