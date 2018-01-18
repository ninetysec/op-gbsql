-- auto gen by george 2018-01-18 14:08:50

select redo_sqls($$
    ALTER TABLE site_api_type ADD COLUMN mobile_order_num INT;
$$);
COMMENT ON COLUMN site_api_type.mobile_order_num IS '手机端顺序';

UPDATE site_api_type SET mobile_order_num=order_num;


DROP VIEW IF EXISTS v_site_api_type;

CREATE OR REPLACE VIEW "v_site_api_type" AS
 SELECT t.id,
    t.site_id,
    ( SELECT count(1) AS apicount
           FROM site_api_type_relation a
          WHERE ((a.api_type_id = t.api_type_id) AND (a.site_id = t.site_id))) AS api_count,
    0 AS player_count,
    t.order_num,
    t.status,
    t.api_type_id,
	t.mobile_order_num
   FROM site_api_type t
  ORDER BY t.status DESC, t.order_num;

COMMENT ON VIEW "v_site_api_type" IS '站点API类型视图--river';