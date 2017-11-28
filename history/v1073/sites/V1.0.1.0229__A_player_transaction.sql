-- auto gen by cherry 2016-08-22 15:04:57
select redo_sqls($$
	ALTER TABLE player_transaction ADD COLUMN origin VARCHAR(16)
$$);

COMMENT ON COLUMN player_transaction.origin is '交易订单来源：PC-电脑，MOBILE-手机';
