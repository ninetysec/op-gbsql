
-- ----------------------------
-- Table structure for favorable_scheme
-- ----------------------------
DROP TABLE IF EXISTS "favorable_scheme";
CREATE TABLE "favorable_scheme" (
"id" serial4 NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL,
"status" varchar(1) COLLATE "default" DEFAULT 1 NOT NULL,
"remark" varchar(200) COLLATE "default",
"create_time" timestamp(6),
"create_user_id" int4
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "favorable_scheme" IS '包网优惠梯度主案-Lins';
COMMENT ON COLUMN "favorable_scheme"."name" IS '名称';
COMMENT ON COLUMN "favorable_scheme"."status" IS '状态（0停用，1正常，2删除）字典类型program_settings';
COMMENT ON COLUMN "favorable_scheme"."remark" IS '备注';
COMMENT ON COLUMN "favorable_scheme"."create_time" IS '创建时间';
COMMENT ON COLUMN "favorable_scheme"."create_user_id" IS '创建人ID';


ALTER TABLE "favorable_scheme" ADD PRIMARY KEY ("id");
