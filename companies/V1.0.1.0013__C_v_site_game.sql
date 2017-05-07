-- auto gen by cherry 2016-02-18 09:56:37
drop view if EXISTS v_site_game;
CREATE OR REPLACE VIEW  "v_site_game" AS
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
    gm.can_try,
    (select count(1) from site_game_tag gt where gt.game_id=gm.game_id and gt.site_id=gm.site_id) as tag_count
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
COMMENT ON VIEW  "v_site_game" IS '站点游戏视图-River';

