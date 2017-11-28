-- auto gen by bruce 2016-11-15 14:57:14
CREATE TABLE IF NOT EXISTS "sys_user_data_right" (
  "id" serial NOT NULL,
  "user_id" INT4,
  "module_type" VARCHAR(32),
  "right_type" VARCHAR(32),
  entity_id INT4,
  create_user INT4,
  create_time TIMESTAMP,
  CONSTRAINT "pk_sys_user_data_right" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "sys_user_data_right" IS '数据权限 -- bruce';
COMMENT ON COLUMN "sys_user_data_right"."id" IS '主键';
COMMENT ON COLUMN "sys_user_data_right"."user_id" IS '用户id';
COMMENT ON COLUMN "sys_user_data_right"."module_type" IS '模块类型(公司入款审核,线上支付审核,玩家取款审核)';
COMMENT ON COLUMN "sys_user_data_right"."right_type" IS '权限类型(玩家层级)';
COMMENT ON COLUMN "sys_user_data_right"."entity_id" IS '实体id';
COMMENT ON COLUMN "sys_user_data_right"."create_user" IS '创建人id';
COMMENT ON COLUMN "sys_user_data_right"."create_time" IS '创建时间';