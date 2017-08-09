-- auto gen by cherry 2017-08-09 21:23:57
DROP FUNCTION IF EXISTS "f_update_site_api_by_game"(gameid int8);
CREATE OR REPLACE FUNCTION "f_update_site_api_by_game"(gameid int8)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
rec_site	RECORD;
BEGIN

FOR rec_site IN (SELECT * FROM sys_site where status='1' and id >0)
loop
  raise notice '同步站点:%,game_id:%的游戏数据',rec_site.id,gameid;
  INSERT INTO site_game (site_id,game_id, api_id, game_type, order_num, url, status, api_type_id)
SELECT rec_site.id,id, api_id, game_type, order_num, url, status,api_type_id from game g WHERE g.id=gameid AND NOT EXISTS (select * from site_game s WHERE s.game_id= gameid and s.site_id=rec_site.id);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '同步site_game数量 %', v_count;

INSERT INTO site_game_i18n (site_id, game_id, name, local, cover, introduce_status, game_introduce)
SELECT rec_site.id, game_id, name, locale, cover, introduce_status, game_introduce from game_i18n g WHERE game_id =gameid
AND NOT EXISTS (select * from site_game_i18n s WHERE gameid=s.game_id and s.site_id=rec_site.id AND s."local" = g.locale);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '同步site_game_i18n数量 %', v_count;
END loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_update_site_api_by_game"(gameid int8) is '根据gameId同步游戏';
