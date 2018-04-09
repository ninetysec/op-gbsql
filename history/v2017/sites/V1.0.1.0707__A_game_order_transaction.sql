-- auto gen by linsen 2018-03-15 11:06:26
-- 修改注单资金记录表添加注单id by mical
select redo_sqls($$
  ALTER TABLE game_order_transaction ADD COLUMN bet_id VARCHAR(50);
  ALTER TABLE game_order_transaction ALTER source_id TYPE VARCHAR(50);
  $$);

COMMENT ON COLUMN game_order_transaction.bet_id IS '注单id';