-- auto gen by linsen 2018-02-27 09:14:43
select redo_sqls($$
	ALTER TABLE player_withdraw ADD COLUMN withdraw_check_user_id int4;
	ALTER TABLE player_withdraw ADD COLUMN withdraw_check_time timestamp(6);
$$);

COMMENT ON COLUMN player_withdraw.withdraw_check_user_id is '出款确认人id';
COMMENT ON COLUMN player_withdraw.withdraw_check_time is '出款确认时间';