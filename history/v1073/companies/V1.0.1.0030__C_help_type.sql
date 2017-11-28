-- auto gen by cherry 2016-02-25 15:02:16
CREATE TABLE IF NOT EXISTS "help_type" (
"id" serial4 NOT NULL,
"is_delete" bool,
"parent_id" int4,
"order_num" int4,
CONSTRAINT "help_type_pkey" PRIMARY KEY ("id")
);

COMMENT ON TABLE help_type IS '帮助中心分类--River';
COMMENT ON COLUMN "help_type"."id" IS '主键';
COMMENT ON COLUMN "help_type"."is_delete" IS '是否删除';
COMMENT ON COLUMN "help_type"."parent_id" IS '一级分类';
COMMENT ON COLUMN "help_type"."order_num" IS '序号';

CREATE TABLE IF NOT EXISTS "help_type_i18n" (
"id" serial4 NOT NULL,
"help_type_id" int4,
"name" varchar(32) COLLATE "default",
"local" varchar(5) COLLATE "default",
CONSTRAINT "help_type_i18n_pkey" PRIMARY KEY ("id")
);

COMMENT ON TABLE help_type IS '帮助中心分类国际化表--River';
COMMENT ON COLUMN "help_type_i18n"."id" IS '主键';
COMMENT ON COLUMN "help_type_i18n"."help_type_id" IS '帮助中心分类';
COMMENT ON COLUMN "help_type_i18n"."name" IS '名称';
COMMENT ON COLUMN "help_type_i18n"."local" IS '语言版本';

CREATE TABLE IF NOT EXISTS "help_document" (
"id" serial4 NOT NULL,
"help_type_id" int4,
"is_delete" bool,
"create_user_id" int4,
"create_time" timestamp,
"update_user_id" int4,
"update_time" timestamp,
"order_num" int4,
CONSTRAINT "help_document_pkey" PRIMARY KEY ("id")
);

COMMENT ON TABLE help_document IS '帮助中心表--River';
COMMENT ON COLUMN "help_document"."id" IS '主键';
COMMENT ON COLUMN "help_document"."help_type_id" IS '帮助分类';
COMMENT ON COLUMN "help_document"."is_delete" IS '是否删除';
COMMENT ON COLUMN "help_document"."create_user_id" IS '创建人';
COMMENT ON COLUMN "help_document"."create_time" IS '创建时间';
COMMENT ON COLUMN "help_document"."update_user_id" IS '修改人';
COMMENT ON COLUMN "help_document"."update_time" IS '修改时间';
COMMENT ON COLUMN "help_document"."order_num" IS '序号';

CREATE TABLE IF NOT EXISTS "help_document_i18n" (
"id" serial4 NOT NULL,
"help_document_id" int4,
"help_title" varchar(256) COLLATE "default",
"help_content" text COLLATE "default",
"local" varchar(5) COLLATE "default",
CONSTRAINT "help_document_i18n_pkey" PRIMARY KEY ("id")
);

COMMENT ON TABLE help_document_i18n IS '帮助中心国际化表--River';
COMMENT ON COLUMN "help_document_i18n"."id" IS '主键';
COMMENT ON COLUMN "help_document_i18n"."help_document_id" IS '帮助文档';
COMMENT ON COLUMN "help_document_i18n"."help_title" IS '标题';
COMMENT ON COLUMN "help_document_i18n"."help_content" IS '内容';
COMMENT ON COLUMN "help_document_i18n"."local" IS '版本';


CREATE OR REPLACE VIEW "v_help_document" AS
 SELECT (((hd.parent_id || ''::text) || hd.help_type_id))::integer AS id,
    hd.parent_id,
    hd.help_type_id,
    ( SELECT count(1) AS count
           FROM help_document a
          WHERE ((a.help_type_id = hd.help_type_id) AND (a.is_delete = false))) AS child_count
   FROM ( SELECT hc.id,
            hc.help_type_id,
            hc.is_delete,
            hc.create_user_id,
            hc.create_time,
            hc.update_user_id,
            hc.update_time,
            hc.order_num,
            ht.parent_id
           FROM (help_document hc
             LEFT JOIN help_type ht ON ((hc.help_type_id = ht.id)))
          WHERE (hc.is_delete = false)) hd
  GROUP BY hd.help_type_id, hd.parent_id
  ORDER BY hd.parent_id;
COMMENT ON VIEW v_help_document IS '新手指引(帮助文档)视图--river';
