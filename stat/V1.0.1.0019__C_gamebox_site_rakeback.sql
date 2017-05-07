-- auto gen by admin 2016-04-29 21:16:08
/**

 * 收集站点总代.代理.玩家等信息.

 * @author 	Lins

 * @date 	2015-12-14

 * @param 	main_url 	运营商库.dblink格式URL

 * @param 	master_url 	站点库.dblink格式URL

 * @param 	start_time 	开始时间

 * @param 	end_time 	结束时间

 */

drop function if exists gamebox_site_rakeback(TEXT, TEXT, TEXT, TEXT);

create or replace function gamebox_site_rakeback(

	main_url 	TEXT,

	master_url 	TEXT,

	start_time 	TEXT,

	end_time 	TEXT

) returns TEXT as $$

DECLARE

	rec 		record;

	cnum 		INT;

	maps 		hstore[];

	rake_map 	hstore;

	act_map		hstore;		-- 实际返水

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

	IF ltrim(rtrim(master_url))='' THEN

		RAISE EXCEPTION '-1, 站点库URL为空';

	END IF;



	perform dblink_close_all();

	perform dblink_connect('master', master_url);

	SELECT site_id FROM dblink('master', 'SELECT * FROM gamebox_current_site()') as s(site_id INT) INTO sid;

	SELECT gamebox_site_map(sid) INTO dict_map;



	date_time = end_time::TIMESTAMP;

	SELECT extract(year FROM date_time) INTO c_year;

	SELECT extract(month FROM date_time) INTO c_month;

	dict_map = (SELECT ('year=>'||c_year)::hstore)||dict_map;

	dict_map = (SELECT ('month=>'||c_month)::hstore)||dict_map;



	SELECT  * FROM dblink(

		'master',

		'SELECT * FROM gamebox_rakeback_map('''||start_time||'''::TIMESTAMP, '''||end_time||'''::TIMESTAMP, '''||main_url||''', '''||category||''')'

	) as p(h hstore[]) INTO maps;



	rake_map = maps[1];

	act_map = maps[2];



	IF rake_map is not null THEN

		keys = akeys(rake_map);



		FOR i IN 1..array_length(keys, 1) LOOP

			IF char_length(keys[i]) > 1 THEN

				sub_keys = regexp_split_to_array(keys[i], col_split);

				--统计玩家数.

				IF num_map is null THEN

					SELECT sub_keys[1]||'=>1' INTO num_map;

					player_num = 0;

				ELSEIF exist(num_map, sub_keys[1]) = FALSE THEN

					num_map = (SELECT (sub_keys[1]||'=>1')::hstore)||num_map;

					player_num = player_num + 1;

				END IF;

				--统计API.GAME_TYPE

				sub_key = sub_keys[2]||col_split||sub_keys[3];

				IF api_map is null THEN

					--param=sub_key||'='||rake_map->keys[i];

					SELECT sub_key||'=>'||(rake_map->keys[i]) INTO api_map;

				ELSEIF exist(api_map, sub_key) THEN

					val = (rake_map->keys[i])::FLOAT;

					val = val + ((api_map->sub_key)::FLOAT);

					api_map = api_map||(SELECT (sub_key||'=>'||val)::hstore);

				ELSE

					api_map = (SELECT (sub_key||'=>'||(rake_map->keys[i]))::hstore)||api_map;

				END IF;

			END IF;

		END LOOP;



		raise info '站点返水.GAME_TYPE';

		perform gamebox_site_rakeback_gametype(api_map, dict_map);



		raise info '站点返水.API';

		perform gamebox_site_rakeback_api(dict_map);



		raise info '站点返水.玩家';

		dict_map = (SELECT ('player_num=>'||player_num)::hstore)||dict_map;



		perform gamebox_site_rakeback_player(act_map, dict_map);



	END IF;

	perform dblink_disconnect('master');

	RETURN '0';

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_site_rakeback(main_url TEXT, master_url TEXT, start_time TEXT, end_time TEXT)

IS 'Lins-站点返水-入口';



/**

 * 站点返水.玩家

 * @author 	Lins

 * @date 	2015-12-14

 * @param 	站点信息map

 */

drop function if exists gamebox_site_rakeback_player(hstore);

drop function if exists gamebox_site_rakeback_player(hstore, hstore);

create or replace function gamebox_site_rakeback_player(

	act_map 	hstore,

	dict_map 	hstore

) returns void as $$

DECLARE

	val 		FLOAT;

	sid 		INT;

	center_id 	INT;

	master_id 	INT;

	c_year 		INT;

	c_month 	INT;

	player_num 	INT;

	total FLOAT:=0.00;

	actual FLOAT:=0.00;

BEGIN

	sid = (dict_map->'site_id')::INT;

	center_id = (dict_map->'center_id')::INT;

	master_id = (dict_map->'master_id')::INT;

	c_year = (dict_map->'year')::INT;

	c_month = (dict_map->'month')::INT;

	player_num = (dict_map->'player_num')::INT;

	total = (act_map->'rakeback_tot')::FLOAT;

	actual = (act_map->'rakeback_act')::FLOAT;



	DELETE FROM site_rakeback_player WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;



	SELECT sum(rakeback) INTO val FROM site_rakeback_gametype

	WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;



	INSERT INTO site_rakeback_player(

  		center_id, master_id, site_id, player_count,

  		rakeback_year, rakeback_month, static_time, rakeback_total, rakeback_actual

	) VALUES (

		center_id, master_id, sid, player_num,

		c_year, c_month, now(), total, actual

	);

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_site_rakeback_player(act_map hstore, dict_map hstore)

IS 'Lins-站点返水.玩家';