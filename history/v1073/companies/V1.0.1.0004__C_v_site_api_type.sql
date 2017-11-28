-- auto gen by cherry 2016-02-05 10:50:04

DROP VIEW IF EXISTS v_site_api_type;
CREATE OR REPLACE VIEW v_site_api_type AS
 SELECT t.id,
    t.site_id,
    ( SELECT count(1) AS apicount
           FROM site_api_type_relation a
          WHERE ((a.api_type_id = t.api_type_id) AND (a.site_id = t.site_id))) AS api_count,
    0 AS player_count,
    t.order_num,
    t.status,
    t.api_type_id
   FROM site_api_type t
  ORDER BY t.status DESC, t.order_num;

COMMENT ON VIEW v_site_api_type IS '站点API类型视图--river';

DROP VIEW IF EXISTS v_site_game;
DROP VIEW IF EXISTS v_game;

 select redo_sqls($$
    ALTER TABLE "site_game_i18n" ADD COLUMN "backup_cover" varchar(128);
	ALTER TABLE "game"  ADD COLUMN "support_terminal" varchar(255);
		ALTER TABLE "game" ADD COLUMN "can_try" bool;
$$);

COMMENT ON COLUMN "site_game_i18n"."backup_cover" IS '备用图片';
ALTER TABLE "site_game_i18n" ALTER COLUMN "name" TYPE varchar(50) COLLATE "default";

ALTER TABLE "game" ALTER COLUMN "code" TYPE varchar(64) COLLATE "default";

COMMENT ON COLUMN "game"."support_terminal" IS '支持终端';
COMMENT ON COLUMN "game"."can_try" IS '试玩';

CREATE OR REPLACE VIEW "v_game" AS
 SELECT a1.id,
    a1.api_id,
    a1.game_type,
    a1.order_num,
    a1.url,
    a1.status,
    a1.code,
    a1.api_type_id,
    a1.maintain_start_time,
    a1.maintain_end_time,
    a2.id AS game_i18n_id,
    a2.name,
    a2.cover,
    a2.locale,
    a2.introduce_status,
    a2.game_introduce,
    a1.support_terminal,
    a1.can_try
   FROM (game a1
     LEFT JOIN game_i18n a2 ON ((a1.id = a2.game_id)))
  ORDER BY a1.id;
COMMENT ON VIEW "v_game" IS '游戏列表视图 add by river';

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
    gm.maintain_end_time,
    gm.support_terminal,
    gm.can_try
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
            g2.maintain_start_time,
            g2.support_terminal,
            g2.can_try
           FROM (site_game g1
             LEFT JOIN game g2 ON (((g1.game_id = g2.id) AND (g1.api_id = g2.api_id))))) gm;


COMMENT ON VIEW "v_site_game" IS '站点游戏视图-River';