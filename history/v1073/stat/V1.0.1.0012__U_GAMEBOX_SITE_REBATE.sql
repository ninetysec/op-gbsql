-- auto gen by tom 2016-03-21 16:38:04
CREATE OR REPLACE FUNCTION "gamebox_site_rebate"(main_url text, master_url text, start_time text, end_time text)
  RETURNS "pg_catalog"."text" AS $BODY$
DECLARE
	rec 		record;
	cnum 		INT;
	expense_map hstore;
	maps 		hstore[];
	category 	TEXT:='API';
	keys 		TEXT[];
	sub_keys 	TEXT[];
	sub_key 	TEXT:='';
	col_split 	TEXT:='_';
	num_map 	hstore;
	api_map 	hstore;
	dict_map 	hstore;
	param 		TEXT:='';
	sid 		INT;--站点ID.
	val 		FLOAT;
	date_time 	TIMESTAMP;
	c_year 		INT;
	c_month 	INT;
	player_num 	INT;
BEGIN
	IF ltrim(rtrim(master_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	perform dblink_close_all();
	perform dblink_connect('master',  master_url);

	SELECT  * FROM dblink(
		'master',
		'SELECT  * FROM gamebox_rebate_map('''||main_url||''', '''||start_time||''', '''||end_time||''', '''||category||''')'
	) as p(h hstore[]) INTO maps;

	IF array_length(maps, 1) < 2 THEN
		RETURN '1.站点库返回信息有误';
	END IF;

	api_map = maps[1];
	expense_map = maps[2];
	sid = (expense_map->'site_id')::INT;
  perform gamebox_collect_site_infor(main_url);
  	SELECT gamebox_site_map(sid) INTO dict_map;
	date_time = end_time::TIMESTAMP;

	SELECT extract(year FROM date_time) INTO c_year;
	SELECT extract(month FROM date_time) INTO c_month;

	dict_map = (SELECT ('year=>'||c_year)::hstore)||dict_map;

	dict_map = (SELECT ('month=>'||c_month)::hstore)||dict_map;

	raise info '站点返佣.GAME_TYPE';
	perform gamebox_site_rebate_gametype(api_map, dict_map);

	raise info '站点返佣.API';
	perform gamebox_site_rebate_api(dict_map);

	raise info '站点返佣';
	perform gamebox_site_rebate(expense_map, dict_map);

	perform dblink_disconnect('master');

	RETURN '0';
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "gamebox_site_rebate"(main_url text, master_url text, start_time text, end_time text) OWNER TO "postgres";

COMMENT ON FUNCTION "gamebox_site_rebate"(main_url text, master_url text, start_time text, end_time text) IS 'Lins-站点返佣-入口';