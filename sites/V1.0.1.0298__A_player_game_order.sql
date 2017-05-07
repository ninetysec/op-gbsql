-- auto gen by cherry 2016-10-24 10:37:43
select redo_sqls($$
	ALTER TABLE player_game_order ADD COLUMN update_time TIMESTAMP(6);
	alter table player_transaction add column favorable_remainder_effective_transaction NUMERIC(20,2);
$$);

COMMENT ON COLUMN player_game_order.update_time is '更新时间';

COMMENT ON COLUMN player_transaction.favorable_remainder_effective_transaction IS '优惠剩余有效交易量';

COMMENT ON COLUMN player_transaction.remainder_effective_transaction IS '存款剩余有效交易量';