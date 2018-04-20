-- auto gen by linsen 2018-04-20 20:22:50
-- 增加唯一约束 by mical
SELECT redo_sqls($$
	ALTER TABLE game_order_transaction ADD CONSTRAINT game_order_transaction_constraint UNIQUE(api_id,bet_id,transaction_type,money);
$$);