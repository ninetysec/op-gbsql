-- auto gen by cherry 2016-09-12 21:28:18
drop view if exists v_ctt_document;
CREATE OR REPLACE VIEW "v_ctt_document" AS
 SELECT t.id,

    t.parent_id,

    t.create_user_id,

    t.create_time,

    t.build_in,

    t.status,

    t.update_user_id,

    t.update_time,

    t.check_user_id,

    t.check_status,

    t.check_time,

    t.publish_time,

    ( SELECT count(1) AS languagecount

           FROM ctt_document_i18n a

          WHERE (a.document_id = t.id)) AS language_count,

    ( SELECT count(1) AS childcount

           FROM ctt_document b_1

          WHERE ((b_1.parent_id = t.id) AND (b_1.is_delete = false))) AS child_count,

    t.code,

    t.order_num,

    t.is_delete,t.is_read,t.is_remove

   FROM ctt_document t

  ORDER BY t.build_in DESC;

COMMENT ON VIEW "v_ctt_document" IS '文案信息视图 add by river';