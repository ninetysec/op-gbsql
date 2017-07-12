-- auto gen by cherry 2017-07-12 11:51:59
DROP FUNCTION if EXISTS f_delete_site_api_game(siteid int4, apiid int4);
CREATE OR REPLACE FUNCTION f_delete_site_api_game(siteid int4, apiid int4)
    RETURNS void AS
  $BODY$
  	declare
	v_count int;
	BEGIN
	--下架站点api
	DELETE FROM site_api  s WHERE s.api_id=apiid AND s.site_id=siteid;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '下架site_api数量 %', v_count;

	DELETE FROM site_api_i18n s WHERE s.api_id=apiid AND s.site_id=siteid;
	raise notice '下架site_api_i18n数量 %', v_count;

	DELETE FROM site_api_type_relation s WHERE s.api_id=apiid AND s.site_id=siteid;
	raise notice '下架site_api_type_relation数量 %', v_count;

	DELETE FROM site_api_type_relation_i18n s WHERE s.api_id=apiid AND s.site_id=siteid;
	raise notice '下架site_api_type_relation_i18n数量 %', v_count;

	DELETE FROM site_game  s WHERE s.api_id=apiid AND s.site_id=siteid;
	raise notice '下架site_game数量 %', v_count;

	DELETE FROM site_game_i18n s WHERE s.game_id IN(SELECT id FROM game WHERE api_id=apiid) AND s.site_id=siteid;
	raise notice '下架site_game_i18n数量 %', v_count;

	END
  $BODY$
    LANGUAGE plpgsql VOLATILE
    COST 100;


COMMENT on FUNCTION f_delete_site_api_game(siteid int4, apiid int4) is '下架站点api';