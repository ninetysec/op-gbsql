-- auto gen by linsen 2018-03-06 21:10:22

--添加出款失败原因和操作记录 by linsen
select redo_sqls($$
	ALTER TABLE player_withdraw ADD COLUMN withdraw_failure_reason text;
	ALTER TABLE player_withdraw ADD COLUMN withdraw_operation_history text;
$$);

COMMENT ON COLUMN player_withdraw.withdraw_failure_reason is '出款失败原因';
COMMENT ON COLUMN player_withdraw.withdraw_operation_history is '出款操作记录';