-- auto gen by cherry 2016-01-20 09:29:35
/* -------- API和游戏二级分类关系国际化视图 -------- */
DROP VIEW IF EXISTS v_api_gametype_i18n;

CREATE OR REPLACE VIEW v_api_gametype_i18n AS
	SELECT agr."id",
		   agr.api_id,
		   agr.game_type,
		   si."value" "name",
		   si.locale
	  FROM api_gametype_relation agr
		LEFT JOIN site_i18n si ON agr.game_type = si."key"
	 WHERE si."type" = 'game_type'
	 ORDER BY agr.api_id, agr.game_type;

ALTER TABLE v_api_gametype_i18n OWNER TO postgres;
COMMENT ON VIEW v_api_gametype_i18n IS 'API和游戏二级分类关系国际化视图 - Fly';