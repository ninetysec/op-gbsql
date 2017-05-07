-- auto gen by cherry 2016-08-15 14:56:00
drop function if exists gamebox_site_rakeback(TEXT, TEXT, TEXT, TEXT);

create or replace function gamebox_site_rakeback(

	main_url 	TEXT,

	master_url 	TEXT,

	start_time 	TEXT,

	end_time 	TEXT

) returns TEXT as $$

/*版本更新说明

--版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数: 站点返水-入口

--v1.01  2016/06/01  Leisure  修改gamebox_rakeback_map参数

--v1.02  2016/08/10  Leisure  取中间时间，解决时区问题

*/

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



	--date_time = end_time::TIMESTAMP;

	--v1.02  2016/08/10  Leisure

	date_time = start_time::TIMESTAMP + (end_time::TIMESTAMP - start_time::TIMESTAMP)/2;

	SELECT extract(year FROM date_time) INTO c_year;

	SELECT extract(month FROM date_time) INTO c_month;

	dict_map = (SELECT ('year=>'||c_year)::hstore)||dict_map;

	dict_map = (SELECT ('month=>'||c_month)::hstore)||dict_map;



	SELECT  * FROM dblink(

		'master',

		--'SELECT * FROM gamebox_rakeback_map('''||start_time||'''::TIMESTAMP, '''||end_time||'''::TIMESTAMP, '''||main_url||''', '''||category||''')'

		'SELECT * FROM gamebox_rakeback_map('''||start_time||'''::TIMESTAMP, '''||end_time||'''::TIMESTAMP, '''||category||''')'

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





drop function if exists gamebox_site_rebate(TEXT, TEXT, TEXT, TEXT);

create or replace function gamebox_site_rebate(

	main_url 	TEXT,

	master_url 	TEXT,

	start_time 	TEXT,

	end_time 	TEXT

) returns TEXT as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数: 站点返佣-入口

--v1.01  2016/05/26  Leisure  增加sid判空

--v1.02  2016/08/10  Leisure  取中间时间，解决时区问题

*/

DECLARE

	expense_map hstore;

	maps 		hstore[];

	category 	TEXT:='API';

	api_map 	hstore;

	dict_map 	hstore;

	sid 		INT;	--站点ID.

	date_time 	TIMESTAMP;

	c_year 		INT;

	c_month 	INT;

BEGIN

	IF ltrim(rtrim(master_url)) = '' THEN

		RAISE EXCEPTION '-1, 站点库URL为空';

	END IF;



	perform dblink_close_all();

	perform dblink_connect('master', master_url);



	SELECT  * FROM dblink(

		'master',

		'SELECT  * FROM gamebox_rebate_map('''||main_url||''', '''||start_time||''', '''||end_time||''', '''||category||''')'

	) as p(h hstore[]) INTO maps;



	IF array_length(maps, 1) < 2 THEN

		RETURN '1.站点库返回信息有误';

	END IF;

	--raise info 'api_map: %', api_map;

	api_map = maps[1];

	expense_map = maps[2];

	sid = (expense_map->'site_id')::INT;

	--v1.01  2016/05/26  Leisure

	IF sid is null THEN

		raise info 'site_id为空，退出！';

		RETURN '1';

	END IF;



	perform gamebox_collect_site_infor(main_url);

	SELECT gamebox_site_map(sid) INTO dict_map;

	--raise info 'dict_map: %', dict_map;



	--date_time = end_time::TIMESTAMP;

	--v1.02  2016/08/10  Leisure

	date_time = start_time::TIMESTAMP + (end_time::TIMESTAMP - start_time::TIMESTAMP)/2;



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



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_site_rebate(main_url TEXT, master_url TEXT, start_time TEXT, end_time TEXT)

IS 'Lins-站点返佣-入口';