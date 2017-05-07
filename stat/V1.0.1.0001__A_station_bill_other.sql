-- auto gen by cherry 2016-03-02 10:13:05
select redo_sqls($$
       ALTER TABLE "station_bill_other" ADD COLUMN "total_profit_loss" numeric(20,2);
     $$);

COMMENT ON COLUMN "station_bill_other"."total_profit_loss" IS '游戏盈亏总额';