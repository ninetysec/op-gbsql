-- auto gen by marz 2017-10-05 21:38:46
 select redo_sqls($$
ALTER TABLE site_lottery_odd ADD COLUMN rebate numeric(20,3);
ALTER TABLE site_lottery_odd ADD COLUMN rebate_limit numeric(20,3);
$$);

COMMENT ON COLUMN "site_lottery_odd"."rebate" IS '返点比例';
COMMENT ON COLUMN "site_lottery_odd"."rebate_limit" IS '返点比例上限';