-- auto gen by linsen 2018-07-11 16:45:51
-- 添加自定义图片启用/禁用状态 by linsen
select redo_sqls($$
   ALTER TABLE site_api_type ADD COLUMN own_icon BOOLEAN;
$$);

COMMENT ON COLUMN site_api_type.own_icon is '图片是否个性化 t-是　空或f-否';


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
    t.mobile_order_num,
		t.own_icon
   FROM site_api_type t
  ORDER BY t.status DESC, t.order_num;

COMMENT ON VIEW "v_site_api_type" IS '站点API类型视图--river';