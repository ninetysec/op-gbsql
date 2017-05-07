-- auto gen by bruce 2016-08-23 20:47:11
select redo_sqls($$
    ALTER TABLE api ADD COLUMN transferable BOOL;
  $$);
COMMENT ON COLUMN api.transferable IS '开启关闭转账';

DROP VIEW IF EXISTS v_api;
CREATE OR REPLACE VIEW "v_api" AS
  SELECT a1.id,
    a1.status,
    a1.order_num,
    a1.maintain_start_time,
    a1.maintain_end_time,
    a1.code,
    a1.domain,
    a1.transferable,
    ( SELECT string_agg((a.api_type_id)::text, ','::text) AS type1
      FROM api_type_relation a
      WHERE (a.api_id = a1.id)) AS first_category,
    ( SELECT string_agg((api_gametype_relation.game_type)::text, ','::text) AS type2
      FROM api_gametype_relation
      WHERE (api_gametype_relation.api_id = a1.id)) AS second_category,
    (( SELECT count(1) AS count
       FROM game gm
       WHERE (gm.api_id = a1.id)))::integer AS game_count,
    (( SELECT count(1) AS count
       FROM site_api sa
       WHERE (sa.api_id = a1.id)))::integer AS site_count,
    a2.id AS api_i18n_id,
    a2.name,
    a2.cover,
    a2.introduce_status,
    a2.introduce_content,
    a2.locale
  FROM (api a1
    LEFT JOIN api_i18n a2 ON ((a1.id = a2.api_id)))
  ORDER BY a1.id;

COMMENT ON VIEW "v_api" IS 'API视图 add by river';

UPDATE api SET transferable=true