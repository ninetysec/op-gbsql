-- auto gen by cherry 2016-03-23 09:53:31
--添加更新字段
 select redo_sqls($$
       ALTER TABLE "currency_exchange_rate" ADD COLUMN "update_time" timestamp(6);
      ALTER TABLE "currency_exchange_rate" ADD COLUMN "update_user" int4;
      $$);

COMMENT ON COLUMN "currency_exchange_rate"."update_time" IS '更新时间';

COMMENT ON COLUMN "currency_exchange_rate"."update_user" IS '更新人id';

--修改视图过滤条件

DROP VIEW if EXISTS v_help_type_and_document;

CREATE OR REPLACE VIEW "v_help_type_and_document" AS

 SELECT h.id,

    h.parent_id,

    h.order_num,

    (( SELECT array_to_json(array_agg(row_to_json(a1.*))) AS array_to_json

           FROM ( SELECT help_type_i18n.name,

                    help_type_i18n.local AS language

                   FROM help_type_i18n

                  WHERE (help_type_i18n.help_type_id = h.id)) a1))::text AS help_type_name_json,

    (( SELECT array_to_json(array_agg(row_to_json(a2.*))) AS ss

           FROM ( SELECT help_document.id

                   FROM help_document

                  WHERE (help_document.help_type_id = h.id AND help_document.is_delete = false)) a2))::text AS document_id_json

   FROM help_type h

  WHERE (h.is_delete = false)

  ORDER BY h.id;

COMMENT on VIEW v_help_type_and_document is '帮助中心文档视图';
