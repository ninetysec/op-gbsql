-- auto gen by cheery 2015-12-11 07:55:49
select redo_sqls($$
 ALTER TABLE site_rebate  ADD COLUMN apportion  NUMERIC(20,2) DEFAULT 0;
$$);

COMMENT ON COLUMN site_rebate.apportion IS '分摊费用';

ALTER TABLE site_rebate DROP COLUMN IF EXISTS deduct_expenses;