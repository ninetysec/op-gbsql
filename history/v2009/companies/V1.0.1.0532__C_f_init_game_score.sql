-- auto gen by george 2018-01-25 19:20:29
DROP FUNCTION IF EXISTS "f_init_game_score"();
CREATE OR REPLACE FUNCTION "f_init_game_score"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare
gameRecord RECORD;
BEGIN
FOR gameRecord in select * From game where game_score is null
loop
raise notice '更新记录:%', gameRecord.id;

update game set game_score=((random()*1)+4)::numeric(4,1)   where id = gameRecord.id;

END loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_init_game_score"() IS '初始化游戏评分';