-- auto gen by cherry 2017-08-21 15:02:41
select redo_sqls($$
alter table lottery_payout_record add column payout_hash  varchar(50);
 ALTER TABLE "lottery_payout_record" ADD CONSTRAINT "unique_payout_hash" UNIQUE ("payout_hash");
  $$);
 COMMENT ON COLUMN lottery_gather_conf.conf_type IS '开奖hash，避免同时开奖';
