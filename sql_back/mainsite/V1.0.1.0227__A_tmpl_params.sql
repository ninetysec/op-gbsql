-- auto gen by cherry 2016-01-12 15:14:45
 ALTER TABLE "notice_text" ALTER COLUMN "tmpl_params" TYPE text COLLATE "default";
 select redo_sqls($$
		ALTER TABLE "game_i18n" ADD COLUMN "backup_cover" varchar(128);
$$);

COMMENT ON COLUMN "game_i18n"."backup_cover" IS '备用图片';

DROP VIEW IF EXISTS v_site_api_type;
CREATE OR REPLACE VIEW "v_site_api_type" AS
SELECT t.id,
    t.site_id,
    ( SELECT count(1) AS apicount
           FROM site_api_type_relation a
          WHERE (a.api_type_id = t.id and a.site_id=t.site_id) ) AS api_count,
    0 AS player_count,
    t.order_num,
    t.status,
    t.api_type_id
   FROM site_api_type t
  ORDER BY t.status DESC, t.order_num;
COMMENT ON VIEW "v_site_api_type" IS '站点API类型视图--river';