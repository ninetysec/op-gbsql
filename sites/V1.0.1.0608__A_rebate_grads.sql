-- auto gen by george 2017-11-23 14:18:08
SELECT redo_sqls($$
ALTER TABLE "rebate_grads"
ADD COLUMN "rakeback_ratio" numeric(5,2),
ADD COLUMN "favorable_ratio" numeric(5,2),
ADD COLUMN "other_ratio" numeric(5,2);

COMMENT ON COLUMN "rebate_grads"."rakeback_ratio" IS '返水费用';
COMMENT ON COLUMN "rebate_grads"."favorable_ratio" IS '优惠费用';
COMMENT ON COLUMN "rebate_grads"."other_ratio" IS '其它费用';
$$);