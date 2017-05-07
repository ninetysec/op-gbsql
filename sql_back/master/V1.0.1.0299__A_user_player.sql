-- auto gen by cheery 2015-12-30 11:20:31
--玩家表添加是否已导出字段 by river
select redo_sqls($$
 ALTER TABLE "user_player" ADD COLUMN "exported" bool;
$$);
COMMENT ON COLUMN "user_player"."exported" IS '是否已导出';

--创建导入玩家记录表 by river
CREATE TABLE IF NOT EXISTS "user_player_import" (
"id" serial4 NOT NULL,
"file_name" varchar(255),
"import_player_count" int4,
"import_time" timestamp,
"import_user_id" int4,
PRIMARY KEY ("id")
);
COMMENT ON TABLE "user_player_import" IS '玩家导入记录表 by River';

COMMENT ON COLUMN "user_player_import"."id" IS '主键';
COMMENT ON COLUMN "user_player_import"."file_name" IS '文件名';
COMMENT ON COLUMN "user_player_import"."import_player_count" IS '导入玩家数';
COMMENT ON COLUMN "user_player_import"."import_time" IS '导入时间';
COMMENT ON COLUMN "user_player_import"."import_user_id" IS '导入用户';

--导入玩家表
CREATE TABLE IF NOT EXISTS "user_player_transfer" (
"id" serial4 NOT NULL,
"topagent" varchar(32),
"agent" varchar(32),
"player_account" varchar(32),
"account_balance" numeric(20,2),
"real_name" varchar(20),
"mobile_phone" varchar(20),
"email" varchar(50),
"bankcard_number" varchar(32),
"bank_deposit" varchar(200),
"is_active" varchar(1),
"insert_time" timestamp,
PRIMARY KEY ("id")
);
COMMENT ON TABLE "user_player_transfer" IS '导入玩家表 by River';
COMMENT ON COLUMN "user_player_transfer"."id" IS '主键';
COMMENT ON COLUMN "user_player_transfer"."topagent" IS '所属总代';
COMMENT ON COLUMN "user_player_transfer"."agent" IS '所属代理';
COMMENT ON COLUMN "user_player_transfer"."player_account" IS '玩家账号';
COMMENT ON COLUMN "user_player_transfer"."account_balance" IS '账号余额';
COMMENT ON COLUMN "user_player_transfer"."real_name" IS '真实姓名';
COMMENT ON COLUMN "user_player_transfer"."mobile_phone" IS '手机号码';
COMMENT ON COLUMN "user_player_transfer"."email" IS '邮箱地址';
COMMENT ON COLUMN "user_player_transfer"."bankcard_number" IS '收款银行卡号';
COMMENT ON COLUMN "user_player_transfer"."bank_deposit" IS '开户行';
COMMENT ON COLUMN "user_player_transfer"."is_active" IS '是否激活 0未激活1已激活';
COMMENT ON COLUMN "user_player_transfer"."insert_time" IS '插入时间';




