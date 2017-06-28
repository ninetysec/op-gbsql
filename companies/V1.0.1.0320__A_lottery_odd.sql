-- auto gen by cherry 2017-06-28 14:05:51
  select redo_sqls($$
   ALTER TABLE lottery_odd ADD COLUMN odd_limit numeric(20,3);
   ALTER TABLE site_lottery_odd ADD COLUMN odd_limit numeric(20,3);

  $$);

COMMENT ON COLUMN "lottery_odd"."odd_limit" IS '赔率上限';
COMMENT ON COLUMN "site_lottery_odd"."odd_limit" IS '赔率上限';
