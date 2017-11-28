-- auto gen by cherry 2017-03-17 09:14:43
CREATE TABLE if NOT EXISTS "site_station_bill" (

"id" SERIAL4 NOT NULL  PRIMARY KEY,

"bill_year" int4,

"bill_month" int4,

"api_type_id" int4,

"api_id" int4,

profit_loss NUMERIC(20,2)

);

COMMENT ON TABLE "site_station_bill" IS '站点结算账单-younger';

COMMENT ON COLUMN "site_station_bill"."bill_year" IS '统计年';

COMMENT ON COLUMN "site_station_bill"."bill_month" IS '统计月';

COMMENT ON COLUMN "site_station_bill"."api_type_id" IS 'API类型ID';

COMMENT ON COLUMN "site_station_bill"."api_id" IS 'API ID';

COMMENT ON COLUMN "site_station_bill"."profit_loss" IS '损益';