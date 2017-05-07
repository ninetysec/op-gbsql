-- auto gen by lenovo 2016-06-28 12:21:29
DROP TABLE IF EXISTS "bankhome_db";
CREATE TABLE "bankhome_db" (
"id" int8 DEFAULT nextval('bankhome_db_id_seq'::regclass) NOT NULL,
"cardnum" int8 NOT NULL,
"province" varchar(64) COLLATE "default",
"city" varchar(64) COLLATE "default",
"bank" varchar(100) COLLATE "default",
"type" varchar(100) COLLATE "default",
"cardname" varchar(80) COLLATE "default",
"tel" varchar(20) COLLATE "default",
"code" varchar(6) COLLATE "default",
"create_time" timestamp(6),
"update_time" timestamp(6)
)
WITH (OIDS=FALSE)

;
COMMENT ON COLUMN "bankhome_db"."id" IS '主键';
COMMENT ON COLUMN "bankhome_db"."cardnum" IS '银行卡号';
COMMENT ON COLUMN "bankhome_db"."province" IS '省份';
COMMENT ON COLUMN "bankhome_db"."city" IS '城市';
COMMENT ON COLUMN "bankhome_db"."bank" IS '银行名称';
COMMENT ON COLUMN "bankhome_db"."type" IS '银行卡类型';
COMMENT ON COLUMN "bankhome_db"."cardname" IS '银行卡名称';
COMMENT ON COLUMN "bankhome_db"."tel" IS '客服电话';
COMMENT ON COLUMN "bankhome_db"."code" IS '银行表码';

-- ----------------------------
-- Alter Sequences Owned By
-- ----------------------------

-- ----------------------------
-- Indexes structure for table bankhome_db
-- ----------------------------
CREATE INDEX "cardnum_index" ON "bankhome_db" USING btree (cardnum);
ALTER TABLE "bankhome_db" CLUSTER ON "cardnum_index";
COMMENT ON INDEX "cardnum_index" IS '银行卡号索引';
CREATE INDEX "createtime" ON "bankhome_db" USING btree (create_time);

-- ----------------------------
-- Uniques structure for table bankhome_db
-- ----------------------------
ALTER TABLE "bankhome_db" ADD UNIQUE ("cardnum");

-- ----------------------------
-- Primary Key structure for table bankhome_db
-- ----------------------------
ALTER TABLE "bankhome_db" ADD PRIMARY KEY ("id");