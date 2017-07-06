-- auto gen by cherry 2017-07-06 16:44:29
DROP FUNCTION IF EXISTS "f_init_site_game"(siteid int4);

CREATE OR REPLACE FUNCTION "f_init_site_game"(siteid int4)
  RETURNS "pg_catalog"."void" AS $BODY$

declare
v_count int;

BEGIN
	--拷贝总控的game到具体站点
	INSERT INTO site_game (site_id,game_id, api_id, game_type, order_num, url, status, api_type_id, support_terminal, code)
	SELECT siteid,id, api_id, game_type, order_num, url, status,api_type_id, support_terminal, code from game g WHERE NOT EXISTS (select * from site_game s WHERE g.id=s.game_id and s.site_id=siteid);
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '新增site_game数量 %', v_count;

	INSERT INTO site_game_i18n (site_id, game_id, name, local, cover, introduce_status, game_introduce)
	SELECT siteid, game_id, name, locale, cover, introduce_status, game_introduce from game_i18n g WHERE NOT EXISTS (select * from site_game_i18n s WHERE g.game_id=s.game_id and s.site_id=siteid and g.locale=s.local);
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '新增site_game_i18n数量 %', v_count;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
