-- auto gen by cherry 2016-03-17 16:09:26

DROP VIEW IF EXISTS v_help_document;
CREATE OR REPLACE VIEW "v_help_document" AS
 SELECT o.id,
    o.parent_id,
    o.help_type_id,
    o.child_count
   FROM ( SELECT t.id,
            t.parent_id,
            t.help_type_id,
            t.child_count,
            ( SELECT y.order_num
                   FROM help_type y
                  WHERE (y.id = t.parent_id)) AS pordernum,
            ( SELECT y.order_num
                   FROM help_type y
                  WHERE (y.id = t.help_type_id)) AS cordernum
           FROM ( SELECT (((hd.parent_id || ''::text) || hd.help_type_id))::integer AS id,
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
                  GROUP BY hd.help_type_id, hd.parent_id) t) o
  ORDER BY o.pordernum, o.cordernum;
COMMENT ON VIEW "v_help_document" IS '新手指引(帮助文档)视图--river';

