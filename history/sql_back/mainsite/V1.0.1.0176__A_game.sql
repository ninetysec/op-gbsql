-- auto gen by longer 2015-12-23 19:16:43

drop view if EXISTS v_site_game;
drop VIEW if EXISTS v_game;

select redo_sqls($$
  ALTER TABLE "game" ALTER COLUMN "maintain_start_time" TYPE timestamp;
  ALTER TABLE "game"ALTER COLUMN "maintain_end_time" TYPE timestamp;
$$);

CREATE OR REPLACE VIEW v_game AS SELECT gm.id,
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

   CREATE OR REPLACE VIEW v_site_game AS SELECT t.id,
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

