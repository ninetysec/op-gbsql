
-- ----------------------------
-- Table structure for net_contract_scheme
-- ----------------------------
DROP TABLE IF EXISTS "net_contract_scheme";
CREATE TABLE "net_contract_scheme" (
"id" serial4 NOT NULL,
"name" varchar(100) COLLATE "default" NOT NULL,
"remark" varchar(500) COLLATE "default",
"occupy_scheme_id" int4 NOT NULL,
"is_assume" varchar(1) COLLATE "default" DEFAULT 'N',
"assume_scheme_id" int4,
"favorable_scheme_id" int4,
"ensure_consume" numeric(20,2) DEFAULT 0,
"status" varchar(1) COLLATE "default",
"create_user_id" int4,
"create_time" timestamp(6)
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "net_contract_scheme" IS '包网方案-Lins';
COMMENT ON COLUMN "net_contract_scheme"."id" IS '主键,自增长';
COMMENT ON COLUMN "net_contract_scheme"."name" IS '方案名称';
COMMENT ON COLUMN "net_contract_scheme"."remark" IS '说明';
COMMENT ON COLUMN "net_contract_scheme"."occupy_scheme_id" IS '运营商占成方案ID. occupy_scheme_id.id';
COMMENT ON COLUMN "net_contract_scheme"."is_assume" IS '盈亏是否共担，Y/N 默认为N';
COMMENT ON COLUMN "net_contract_scheme"."assume_scheme_id" IS '默认为0,只在有特别API需开启共担与否时,才需设值, assume_scheme.id';
COMMENT ON COLUMN "net_contract_scheme"."favorable_scheme_id" IS '优惠ID 默认0不优惠, favorable_scheme.id';
COMMENT ON COLUMN "net_contract_scheme"."ensure_consume" IS '保底消费额';
COMMENT ON COLUMN "net_contract_scheme"."status" IS '状态（0停用，1正常，2删除）字典类型program_settings';
COMMENT ON COLUMN "net_contract_scheme"."create_user_id" IS '用户ID.sys_user.id';
COMMENT ON COLUMN "net_contract_scheme"."create_time" IS '创建时间';

ALTER TABLE "net_contract_scheme" ADD PRIMARY KEY ("id");
