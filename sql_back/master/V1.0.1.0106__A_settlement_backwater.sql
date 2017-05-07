-- auto gen by cheery 2015-10-09 13:32:16
--返水添加出账单时间字段、返佣添加出账单时间字段
select redo_sqls($$
   ALTER TABLE "settlement_rebate" ADD COLUMN "create_time" timestamp(6);

   ALTER TABLE  settlement_backwater ADD COLUMN create_time timestamp(6);
$$);

COMMENT ON COLUMN "settlement_rebate"."create_time" IS '创建时间';
COMMENT ON COLUMN settlement_backwater.create_time IS '出账单时间';