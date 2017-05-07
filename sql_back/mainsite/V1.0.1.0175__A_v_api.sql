-- auto gen by longer 2015-12-23 19:07:48

DROP VIEW if EXISTS v_api;

ALTER TABLE "api_type_relation" DROP COLUMN IF EXISTS type;
select redo_sqls($$
  ALTER TABLE "api_type_relation"  ADD COLUMN api_type_id int4;
$$);

COMMENT ON COLUMN api_type_relation.api_type_id IS 'api分类';

CREATE OR REPLACE VIEW v_api AS SELECT api.id,
                                         api.status,
                                         api.order_num,
                                         api.maintain_start_time,
                                         api.maintain_end_time,
                                         api.code,
                                         api.domain,
                                         ( SELECT string_agg((a.api_type_id)::text, ','::text) AS type1
                                           FROM api_type_relation a
                                           WHERE (a.api_id = api.id)) AS first_category,
                                         ( SELECT string_agg((api_gametype_relation.game_type)::text, ','::text) AS type2
                                           FROM api_gametype_relation
                                           WHERE (api_gametype_relation.api_id = api.id)) AS second_category,
                                         (( SELECT count(1) AS count
                                            FROM game gm
                                            WHERE (gm.api_id = api.id)))::integer AS game_count,
                                         (( SELECT count(1) AS count
                                            FROM site_api sa
                                            WHERE (sa.api_id = api.id)))::integer AS site_count,
                                         CASE
                                         WHEN ((api.status)::text <> 'maintain'::text) THEN (api.status)::text
                                         ELSE
                                           CASE
                                           WHEN ((now() < api.maintain_end_time) AND (now() > api.maintain_start_time)) THEN 'maintain'::text
                                           ELSE 'normal'::text
                                           END
                                         END AS real_status
                                       FROM api api;


ALTER TABLE v_api OWNER TO postgres;
COMMENT ON VIEW v_api IS 'API视图 add by river';

DROP VIEW IF EXISTS v_site_game;
ALTER TABLE "site_game" DROP COLUMN IF EXISTS "game_type_parent";

CREATE OR REPLACE VIEW "v_site_game" AS
 SELECT t.id,
    t.site_id,
    t.api_id,
    t.game_type,
    t.views,
    t.api_type_id,
    t.order_num,
    t.url,
    t.status,
    0 AS player_count,
    0 AS yesterday_count,
    t.game_id,
    t2.status AS game_status,
    t2.real_status AS game_real_status,
    t2.maintain_start_time,
    t2.maintain_end_time
   FROM (site_game t
     LEFT JOIN v_game t2 ON ((t.game_id = t2.id)));

ALTER TABLE "v_site_game" OWNER TO "postgres";

COMMENT ON VIEW "v_site_game" IS '站点游戏视图-River';
