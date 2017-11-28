-- auto gen by lenovo 2016-05-09 14:32:12

CREATE TABLE "game_api_transaction" (
"id" varchar(32) COLLATE "default" NOT NULL,
"api_id" varchar(4) COLLATE "default",
"mq_key" varchar(32) COLLATE "default",
"type" varchar(10) COLLATE "default",
"amount" numeric(20,2),
"create_time" timestamp(6),
"request_user" varchar(20) COLLATE "default",
"request_site_id" int8,
"request_time" varchar(20) COLLATE "default"
)
WITH (OIDS=FALSE)

;
COMMENT ON COLUMN "game_api_transaction"."id" IS '主键';
COMMENT ON COLUMN "game_api_transaction"."api_id" IS 'api的转账的id（传给api的）';
COMMENT ON COLUMN "game_api_transaction"."mq_key" IS 'mq的key';
COMMENT ON COLUMN "game_api_transaction"."type" IS '转账类型';
COMMENT ON COLUMN "game_api_transaction"."amount" IS '转账金额';
COMMENT ON COLUMN "game_api_transaction"."create_time" IS '创建时间';
COMMENT ON COLUMN "game_api_transaction"."request_user" IS '创建用户';
COMMENT ON COLUMN "game_api_transaction"."request_site_id" IS '请求站点id';
COMMENT ON COLUMN "game_api_transaction"."request_time" IS '请求时间';

-- ----------------------------
-- Alter Sequences Owned By
-- ----------------------------

-- ----------------------------
-- Indexes structure for table game_api_transaction
-- ----------------------------
CREATE INDEX "fk_game_api_transaction_mq_key" ON "game_api_transaction" USING btree (mq_key);
CREATE INDEX "fk_game_api_transaction_request_user " ON "game_api_transaction" USING btree (request_user);

-- ----------------------------
-- Primary Key structure for table game_api_transaction
-- ----------------------------
ALTER TABLE "game_api_transaction" ADD PRIMARY KEY ("id");
