-- ----------------------------
-- Table structure for occupy_scheme_grads
-- ----------------------------
DROP TABLE IF EXISTS "occupy_scheme_grads";
CREATE TABLE "occupy_scheme_grads" (
"id" serial4 NOT NULL,
"occupy_scheme_id" int4,
"min_value" numeric(20,2) DEFAULT 0,
"max_value" numeric(20,2) DEFAULT 0
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "occupy_scheme_grads" IS '包网占成梯度-Lins';
COMMENT ON COLUMN "occupy_scheme_grads"."occupy_scheme_id" IS '优惠主案id.外键:occupy_scheme.id';
COMMENT ON COLUMN "occupy_scheme_grads"."min_value" IS '盈利最小值(包含最小值)';
COMMENT ON COLUMN "occupy_scheme_grads"."max_value" IS '盈利最大值';

ALTER TABLE "occupy_scheme_grads" ADD PRIMARY KEY ("id");
