-- auto gen by cherry 2016-03-04 10:08:40
CREATE TABLE IF not EXISTS "exception_transfer" (

"id" SERIAL4 NOT NULL,

"company_id" int4,

"master_id" int4,

"site_id" int4,

"player_id" int4,

"player_name" varchar(32) COLLATE "default",

"order_no" varchar(32) COLLATE "default",

"order_type" varchar(32) COLLATE "default",

"order_status" varchar(32) COLLATE "default",

"api_id" int4,

"currency_code" varchar(32) COLLATE "default",

"money" numeric(20,2),

"transfer_time" timestamp(6),

"create_time" timestamp(6),

"handler_id" int4,

"handl_time" timestamp(6),

CONSTRAINT "exception_transfer_pkey" PRIMARY KEY ("id")

);


COMMENT ON TABLE "exception_transfer" IS '转账异常表';



COMMENT ON COLUMN "exception_transfer"."id" IS '主键';



COMMENT ON COLUMN  "exception_transfer"."company_id" IS '运营商账号ID';



COMMENT ON COLUMN  "exception_transfer"."master_id" IS '站长账号ID';



COMMENT ON COLUMN  "exception_transfer"."site_id" IS '站点ID';



COMMENT ON COLUMN  "exception_transfer"."player_id" IS '玩家ID';



COMMENT ON COLUMN "exception_transfer"."player_name" IS '玩家名';



COMMENT ON COLUMN "exception_transfer"."order_no" IS '订单号';



COMMENT ON COLUMN "exception_transfer"."order_type" IS '订单类型(转出，转入)';



COMMENT ON COLUMN "exception_transfer"."order_status" IS '订单状态(待处理,成功,失败)';



COMMENT ON COLUMN  "exception_transfer"."api_id" IS '转账api';



COMMENT ON COLUMN "exception_transfer"."currency_code" IS '币种';



COMMENT ON COLUMN  "exception_transfer"."money" IS '金额';



COMMENT ON COLUMN "exception_transfer"."transfer_time" IS '订单提交时间';



COMMENT ON COLUMN  "exception_transfer"."create_time" IS '数据生成时间';



COMMENT ON COLUMN "exception_transfer"."handler_id" IS '处理人id';



COMMENT ON COLUMN "exception_transfer"."handl_time" IS '处理时间';

