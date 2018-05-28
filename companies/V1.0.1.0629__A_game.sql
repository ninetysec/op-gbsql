-- auto gen by steffan 2018-05-28 09:18:19  add by zain
  select redo_sqls($$
   ALTER TABLE game ADD COLUMN sys_insert BOOLEAN DEFAULT false;
  $$);


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
    a1.can_try,
    a1.game_3d,
    a1.game_line,
    a1.game_rtp,
    a2.background_cover,
    a1.game_score,
    a1.game_score_number,
    a1.game_collect_number,
    a1.game_view,
    a1.jackpot,
		a1.sys_insert
   FROM (game a1
     LEFT JOIN game_i18n a2 ON ((a1.id = a2.game_id)))
  ORDER BY a1.id;


COMMENT ON VIEW "v_game" IS '游戏列表视图 add by river';