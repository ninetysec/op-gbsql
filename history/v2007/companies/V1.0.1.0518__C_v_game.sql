-- auto gen by george 2018-01-15 16:49:15

select redo_sqls($$
  ALTER TABLE game_i18n ADD COLUMN background_cover varchar(128) ;
  COMMENT ON COLUMN "game_i18n"."background_cover" IS '背景图片';
$$);

DROP VIEW IF EXISTS v_game;
CREATE OR REPLACE VIEW v_game AS SELECT a1.id,
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
    a1.can_try,
    a1.game_3d,
    a1.game_line,
    a1.game_rtp,
    a2.background_cover
   FROM (game a1
     LEFT JOIN game_i18n a2 ON ((a1.id = a2.game_id)))
  ORDER BY a1.id;

COMMENT ON VIEW "v_game" IS '游戏列表视图 add by river';
