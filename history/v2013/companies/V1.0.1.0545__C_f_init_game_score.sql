-- auto gen by linsen 2018-02-04 09:48:47
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