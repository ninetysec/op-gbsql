-- auto gen by george 2017-10-25 21:45:53
SELECT redo_sqls($$
   ALTER TABLE "activity_rule" ADD COLUMN "condition_type" varchar(2);
   COMMENT ON COLUMN "activity_rule"."condition_type" IS '优惠条件类型';
$$);