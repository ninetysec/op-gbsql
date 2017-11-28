-- auto gen by bruce 2016-10-28 21:36:26
DROP  TABLE IF EXISTS sys_search_template;
CREATE TABLE "sys_search_template" (
  "id" serial NOT NULL,
  "name" varchar(100) COLLATE "default",
  "content" varchar(1024) COLLATE "default",
  "code" varchar(20) COLLATE "default",
  "op_type" int4,
  "site_id" int4,
  "subsys_code" varchar(32) COLLATE "default",
  CONSTRAINT "sys_search_template_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "sys_search_template" IS '用户自定义查询条件模板--Bruce';

COMMENT ON COLUMN "sys_search_template"."id" IS '主键';

COMMENT ON COLUMN "sys_search_template"."name" IS '查询模板名称';

COMMENT ON COLUMN "sys_search_template"."content" IS 'Json形式保存的自定义内容';

COMMENT ON COLUMN "sys_search_template"."code" IS '标识是那个类型的查询模板';

COMMENT ON COLUMN "sys_search_template"."op_type" IS '操作类型：1，查询过滤；2，列表';

COMMENT ON COLUMN "sys_search_template"."site_id" IS '站点ID';

COMMENT ON COLUMN "sys_search_template"."subsys_code" IS '所属子系统编号';

CREATE INDEX "fk_sys_search_template_id" ON "sys_search_template" USING btree (site_id);