-- auto gen by cheery 2015-12-28 10:01:36
DROP VIEW IF EXISTS v_site_game;
DROP VIEW IF EXISTS v_site_api_type_relation;
DROP VIEW IF EXISTS v_site_api;
DROP VIEW IF EXISTS v_game;
DROP VIEW IF EXISTS v_api;

ALTER TABLE "game" ALTER COLUMN "maintain_start_time" TYPE timestamp, ALTER COLUMN "maintain_end_time" TYPE timestamp;
--重新创建v_game视图
CREATE OR REPLACE VIEW "v_game" AS
 SELECT gm.id,
    gm.api_id,
    gm.game_type,
    gm.order_num,
    gm.url,
    gm.status,
    gm.code,
    gm.api_type_id,
    gm.maintain_start_time,
    gm.maintain_end_time,
        CASE
            WHEN ((gm.status)::text <> 'maintain'::text) THEN (gm.status)::text
            ELSE
            CASE
                WHEN ((now() < gm.maintain_end_time) AND (now() > gm.maintain_start_time)) THEN 'maintain'::text
                ELSE 'normal'::text
            END
        END AS real_status
   FROM game gm;
COMMENT ON VIEW "v_game" IS '游戏列表视图 add by river';

--创建游戏标签表
CREATE TABLE IF NOT EXISTS "site_game_tag" (
"id" serial4 NOT NULL,
"site_id" int4,
"game_id" int4,
"tag_id" varchar(64),
PRIMARY KEY ("id")
);
COMMENT ON TABLE "site_game_tag" IS '游戏标签表 by River';
COMMENT ON COLUMN "site_game_tag"."id" IS '主键';
COMMENT ON COLUMN "site_game_tag"."site_id" IS '站点ID';
COMMENT ON COLUMN "site_game_tag"."game_id" IS '游戏ID';
COMMENT ON COLUMN "site_game_tag"."tag_id" IS '标签ID，site_i18n中setting.game_tag的key值';

ALTER TABLE api DROP COLUMN IF EXISTS announment_id;
--重新创建v_api视图
CREATE OR REPLACE VIEW "v_api" AS
 SELECT api.id,
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
COMMENT ON VIEW "v_api" IS 'API视图 add by river';

--重新创建v_site_api视图

CREATE OR REPLACE VIEW "v_site_api" AS
 SELECT t.id,
    t.site_id,
    t.status,
    ( SELECT count(1) AS count
           FROM site_game a
          WHERE (a.api_id = t.id)) AS game_count,
    '0' AS player_count,
    t.api_id,
    t.api_status,
    t.api_real_status,
    t.maintain_start_time,
    t.maintain_end_time
   FROM ( SELECT s1.id,
            s1.site_id,
            s1.api_id,
            s1.status,
            s1.order_num,
            s1.code,
            s2.status AS api_status,
                CASE
                    WHEN ((s2.status)::text <> 'maintain'::text) THEN (s2.status)::text
                    ELSE
                    CASE
                        WHEN ((now() < s2.maintain_end_time) AND (now() > s2.maintain_start_time)) THEN 'maintain'::text
                        ELSE 'normal'::text
                    END
                END AS api_real_status,
            s2.maintain_start_time,
            s2.maintain_end_time
           FROM (site_api s1
             LEFT JOIN api s2 ON ((s1.api_id = s2.id)))) t;
COMMENT ON VIEW "v_site_api" IS '站点API视图--river';

--重新创建v_site_api_type_relation视图

CREATE OR REPLACE VIEW "v_site_api_type_relation" AS
 SELECT a1.id,
    a1.site_id,
    a1.api_id,
    a1.api_type_id,
    ( SELECT count(1) AS count
           FROM site_game a
          WHERE ((a.api_id = a1.api_id) AND (a.site_id = a1.site_id))) AS game_count,
    0 AS player_count,
    a1.status,
    a1.order_num,
    a1.api_real_status,
    a1.api_status,
    a1.maintain_start_time,
    a1.maintain_end_time
   FROM ( SELECT s3.id,
            s3.site_id,
            s3.api_id,
            s3.api_type_id,
            s3.order_num,
            s3.api_status,
            s3.maintain_end_time,
            s3.maintain_start_time,
            s3.api_real_status,
            s4.status
           FROM (( SELECT s1.id,
                    s1.site_id,
                    s1.api_id,
                    s1.api_type_id,
                    s1.order_num,
                    s2.status AS api_status,
                    s2.maintain_end_time,
                    s2.maintain_start_time,
                        CASE
                            WHEN ((s2.status)::text <> 'maintain'::text) THEN (s2.status)::text
                            ELSE
                            CASE
                                WHEN ((now() < s2.maintain_end_time) AND (now() > s2.maintain_start_time)) THEN 'maintain'::text
                                ELSE 'normal'::text
                            END
                        END AS api_real_status
                   FROM (site_api_type_relation s1
                     LEFT JOIN api s2 ON ((s1.api_id = s2.id)))) s3
             LEFT JOIN site_api s4 ON (((s3.api_id = s4.api_id) AND (s3.site_id = s4.site_id))))) a1;
COMMENT ON VIEW "v_site_api_type_relation" IS '站点API类型和API视图--river';

--重新创建v_site_game视图
CREATE OR REPLACE VIEW "v_site_game" AS
 SELECT gm.id,
    gm.site_id,
    gm.api_id,
    gm.game_type,
    gm.views,
    gm.api_type_id,
    gm.order_num,
    gm.url,
    gm.status,
    0 AS player_count,
    0 AS yesterday_count,
    gm.game_id,
    gm.game_status,
        CASE
            WHEN ((gm.status)::text <> 'maintain'::text) THEN (gm.status)::text
            ELSE
            CASE
                WHEN ((now() < gm.maintain_end_time) AND (now() > gm.maintain_start_time)) THEN 'maintain'::text
                ELSE 'normal'::text
            END
        END AS game_real_status,
    gm.maintain_start_time,
    gm.maintain_end_time
   FROM ( SELECT g1.id,
            g1.game_id,
            g1.site_id,
            g1.api_id,
            g1.game_type,
            g1.views,
            g1.order_num,
            g1.url,
            g1.status,
            g1.api_type_id,
            g2.status AS game_status,
            g2.maintain_end_time,
            g2.maintain_start_time
           FROM (site_game g1
             LEFT JOIN game g2 ON (((g1.game_id = g2.id) AND (g1.api_id = g2.api_id))))) gm;
COMMENT ON VIEW "v_site_game" IS '站点游戏视图-River';


--重新创site_content视图
DROP VIEW IF EXISTS v_site_content;
CREATE OR REPLACE VIEW "v_site_content" AS
 SELECT a.id,
    a.site_id,
    a.pending_check,
    a.audit_check,
    a.last_publish_time,
    b.name AS site_name,
    c.username AS master_name,
    b.logo_path,
    b.site_classify_key,
    b.main_language,
    c.user_type,
    c.id AS master_id
   FROM site_content a,
    sys_site b,
    sys_user c
  WHERE ((a.site_id = b.id) AND (b.sys_user_id = c.id));
COMMENT ON VIEW "v_site_content" IS '内容审核视图--river';