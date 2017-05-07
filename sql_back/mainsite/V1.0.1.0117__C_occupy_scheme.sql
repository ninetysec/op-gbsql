-- ----------------------------
-- Table structure for occupy_scheme
-- ----------------------------
DROP TABLE IF EXISTS "occupy_scheme";
CREATE TABLE "occupy_scheme" (
"id" serial4 NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL,
"remark" varchar(200) COLLATE "default",
"status" varchar(1) COLLATE "default" DEFAULT 1 NOT NULL,
"create_time" timestamp(6),
"create_user_id" int4
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "occupy_scheme" IS '包网占成梯度主案-Lins';
COMMENT ON COLUMN "occupy_scheme"."name" IS '名称';
COMMENT ON COLUMN "occupy_scheme"."status" IS '状态（0停用，1正常，2删除）字典类型program_settings';
COMMENT ON COLUMN "occupy_scheme"."remark" IS '备注';
COMMENT ON COLUMN "occupy_scheme"."create_time" IS '创建时间';
COMMENT ON COLUMN "occupy_scheme"."create_user_id" IS '创建人ID';


ALTER TABLE "occupy_scheme" ADD PRIMARY KEY ("id");
