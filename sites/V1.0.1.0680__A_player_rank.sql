-- auto gen by linsen 2018-01-31 16:34:42
select redo_sqls($$
		alter table "player_rank" ADD column "is_withdraw_fee_zero_reset" bool DEFAULT false;
$$);
COMMENT ON COLUMN "player_rank"."is_withdraw_fee_zero_reset" IS '是否启用每日00:00重置取款手续费相关设置';