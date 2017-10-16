-- auto gen by marz 2017-10-05 21:37:43
 select redo_sqls($$
ALTER TABLE lottery_odd ADD COLUMN rebate numeric(20,3);
ALTER TABLE lottery_odd ADD COLUMN rebate_limit numeric(20,3);
ALTER TABLE lottery_odd ADD COLUMN base_num numeric(20,3);
$$);

COMMENT ON COLUMN "lottery_odd"."rebate" IS '返点比例';
COMMENT ON COLUMN "lottery_odd"."rebate_limit" IS '返点比例上限';
COMMENT ON COLUMN "lottery_odd"."base_num" IS '基数';