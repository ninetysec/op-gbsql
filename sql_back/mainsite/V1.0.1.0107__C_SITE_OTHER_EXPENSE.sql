-- auto gen by tom 2015-11-24 18:33:35
CREATE TABLE IF NOT EXISTS "site_other_expenses" (
"id" serial4 NOT NULL,
"site_id" int4 NOT NULL,
"name" varchar(50) COLLATE "default" NOT NULL,
"expense" float4 NOT NULL,
"remark" varchar(200) COLLATE "default",
"required" bool NOT NULL,
CONSTRAINT "site_other_expenses_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_other_expenses" OWNER TO "postgres";

COMMENT ON TABLE "site_other_expenses" IS '站点其他费用--tom';

COMMENT ON COLUMN "site_other_expenses"."id" IS '主键';

COMMENT ON COLUMN "site_other_expenses"."site_id" IS '站点id';

COMMENT ON COLUMN "site_other_expenses"."name" IS '费用编码或者名称,固定费用使用编码国际化,非固定费用无需国际化直接展示';

COMMENT ON COLUMN "site_other_expenses"."expense" IS '费用';

COMMENT ON COLUMN "site_other_expenses"."remark" IS '备注';

COMMENT ON COLUMN "site_other_expenses"."required" IS '是否固定费用';