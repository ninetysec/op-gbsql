-- auto gen by linsen 2018-02-04 19:06:40
DROP FUNCTION IF EXISTS "f_init_game_score"();
CREATE OR REPLACE FUNCTION "f_init_game_score"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare
gameRecord RECORD;
BEGIN
FOR gameRecord in select * From game where game_score is null or game_score = 0
loop
raise notice '更新记录:%', gameRecord.id;

update game set game_score=((random()*1)+4)::numeric(4,1)   where id = gameRecord.id;

END loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_init_game_score"() IS '初始化游戏评分';



DROP FUNCTION IF EXISTS "f_init_game_collect"();
CREATE OR REPLACE FUNCTION "f_init_game_collect"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare
gameRecord RECORD;
BEGIN
FOR gameRecord in select * From game where game_collect_number is null or game_collect_number = 0
loop
raise notice '更新记录:%', gameRecord.id;

update game set game_collect_number=floor(random()*(500-300)+300) where id = gameRecord.id;

END loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_init_game_collect"() IS '初始化游戏收藏量';

DROP VIEW IF EXISTS v_game;

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
	a1.game_view
   FROM (game a1
     LEFT JOIN game_i18n a2 ON ((a1.id = a2.game_id)))
  ORDER BY a1.id;

COMMENT ON VIEW "v_game" IS '游戏列表视图 add by river';
