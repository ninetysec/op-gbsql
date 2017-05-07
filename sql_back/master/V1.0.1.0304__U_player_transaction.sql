-- auto gen by orange 2016-01-05 14:46:18
select redo_sqls($$
  ALTER TABLE "player_transaction" ADD COLUMN  "remainder_effective_transaction" numeric(20);
$$);

COMMENT ON COLUMN "player_transaction"."remainder_effective_transaction" IS '剩余有效交易量';