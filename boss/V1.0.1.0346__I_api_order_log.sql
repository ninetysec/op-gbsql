-- auto gen by cherry 2017-06-13 15:48:34
CREATE TABLE IF not EXISTS "api_order_log" (
"id" serial4 NOT NULL,
"api_id" int4 NOT NULL,
"start_id" int8,
"update_time" timestamp(6),
"type" varchar(1) COLLATE "default",
"start_time" timestamp(6),
"is_need_account" bool DEFAULT false,
"end_id" int8 DEFAULT 0,
"end_time" timestamp(6),
"ext_json" varchar(1000) COLLATE "default",
"gametype" varchar(2) COLLATE "default",
CONSTRAINT "api_order_log_pkey" PRIMARY KEY ("id"),
CONSTRAINT "api_order_log_unique" UNIQUE ("api_id", "type", "gametype")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "api_order_log" IS 'API下单获取记录';

COMMENT ON COLUMN "api_order_log"."id" IS '主键';

COMMENT ON COLUMN "api_order_log"."api_id" IS 'API表Id';

COMMENT ON COLUMN "api_order_log"."start_id" IS '注单最大序列号';

COMMENT ON COLUMN "api_order_log"."update_time" IS '更新时间';

COMMENT ON COLUMN "api_order_log"."type" IS '获取类型：0-新增，1-修改';

COMMENT ON COLUMN "api_order_log"."start_time" IS '开始时间';

COMMENT ON COLUMN "api_order_log"."is_need_account" IS '下单是否需要账号，默认为false';

COMMENT ON COLUMN "api_order_log"."end_id" IS '结束ID';

COMMENT ON COLUMN "api_order_log"."end_time" IS '结束时间';

COMMENT ON COLUMN "api_order_log"."ext_json" IS '扩展具体应用';
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '23', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=23 and type='0');


INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '24', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=24 and type='0');