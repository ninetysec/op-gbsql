CREATE EXTENSION IF NOT EXISTS hstore;

/**
 * 收集站点总代.代理.玩家等信息.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	main_url 	运营商库.dblink格式URL
 * @param 	master_urls 站点库.dblink格式URL(多库, 以分隔符分开)
 * @param 	start_times 开始时间
 * @param 	end_times 	结束时间
 * @param 	split 		分隔符
**/
drop function if exists gamebox_site_rakeback(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_site_rakeback(
	main_url 	TEXT,
	master_urls TEXT,
	start_times TEXT,
	end_times 	TEXT,
	split 		TEXT
) returns TEXT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点返水-入口
--v1.01  2016/05/26  Leisure  站长下所有站点时区相同，时间只取第一个
*/
DECLARE
	dblink_urls TEXT[];
	start_time 	TEXT[];
	end_time 	TEXT[];

BEGIN
	IF ltrim(rtrim(main_url)) = '' THEN
		raise info '1-运营商URL为空';
		RETURN '1-运营商URL为空';
	ELSEIF ltrim(rtrim(master_urls)) = '' THEN
		raise info '1-站点库URL为空';
		RETURN '1-站点库URL为空';
	ELSEIF ltrim(rtrim(split)) = '' THEN
		raise info '1-分隔符为空';
		RETURN '1-分隔符为空';
	END IF;

	dblink_urls:=regexp_split_to_array(master_urls, split);
	start_time:=regexp_split_to_array(start_times, split);
	end_time:=regexp_split_to_array(end_times, split);

	IF array_length(dblink_urls, 1) > 0
		--v1.01  2016/05/26  Leisure
		--AND array_length(dblink_urls, 1) = array_length(start_time, 1)
		--AND array_length(dblink_urls, 1) = array_length(end_time, 1)
	THEN
		perform dblink_close_all();
		perform gamebox_collect_site_infor(main_url);
		FOR i IN 1..array_length(dblink_urls, 1)
		LOOP
			--v1.01  2016/05/26  Leisure
			perform gamebox_site_rakeback(main_url, dblink_urls[i], start_time[1], end_time[1]);
		END LOOP;
	ELSE
		raise info '1-参数格式或者数量不一致';
		RETURN '1-参数格式或者数量不一致';
	END IF;

	RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rakeback(main_url TEXT, master_urls TEXT, split TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-站点返水-入口';

/**
 * 收集站点总代.代理.玩家等信息.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	main_url 	运营商库.dblink格式URL
 * @param 	master_url 	站点库.dblink格式URL
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
**/
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

	date_time = end_time::TIMESTAMP;
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

/**
 * 站点返水.GAME TYPE统计.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	sid 站点ID
**/
drop function if exists gamebox_site_map(INT);
create or replace function gamebox_site_map(
	sid INT
) returns hstore as $$
DECLARE
	rec 		record;
	dict_map 	hstore;
BEGIN
	FOR rec IN
		SELECT  * FROM sys_site_info WHERE siteid = sid
	LOOP
		SELECT 'site_id=>'||rec.siteid INTO dict_map;
		IF rec.sitename != null AND rec.sitename != '' THEN
			dict_map = (SELECT ('site_name=>'||rec.sitename)::hstore)||dict_map;
		END IF;
		dict_map = (SELECT ('master_id=>'||rec.masterid)::hstore)||dict_map;
		dict_map = (SELECT ('master_name=>'||rec.mastername)::hstore)||dict_map;
		dict_map = (SELECT ('center_id=>'||rec.operationid)::hstore)||dict_map;
		dict_map = (SELECT ('center_name=>'||rec.operationname)::hstore)||dict_map;
	END LOOP;
	IF dict_map is null THEN
		SELECT '-1=>-1' INTO dict_map;
	END IF;

	RETURN dict_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_map(sid INT)
IS 'Lins-站点信息';

/**
 * 站点返水.GAME_TYPE统计.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	api_map 	API返水map
 * @param 	dict_map 	站点信息map
**/
drop function if exists gamebox_site_rakeback_gametype(hstore, hstore);
create or replace function gamebox_site_rakeback_gametype(
	api_map 	hstore,
	dict_map 	hstore
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点返水-入口
--v1.01  2016/06/01  Leisure  返水统计改为每期（原来为每月）执行一次，去除DELETE逻辑
--v1.02  2016/07/05  Leisure  撤销--v1.01的修改
*/
DECLARE
	keys 		TEXT[];
	sub_keys 	TEXT[];
	val 		FLOAT;
	col_split 	TEXT:='_';
	sid 		INT;
	center_id 	INT;
	master_id 	INT;
	c_year 		INT;
	c_month 	INT;

BEGIN
	sid = (dict_map->'site_id')::INT;
	center_id = (dict_map->'center_id')::INT;
	master_id = (dict_map->'master_id')::INT;
	c_year 	= (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;

	--v1.01  2016/06/01  Leisure
	--v1.02  2016/07/05  Leisure
	DELETE FROM site_rakeback_gametype WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;

	keys = akeys(api_map);
	IF api_map is null OR array_length(keys, 1) is null THEN
		RETURN;
	END IF;

	raise info 'len = %', array_length(keys, 1);
	FOR i IN 1..array_length(keys, 1) LOOP
		val = (api_map->keys[i])::FLOAT;
		sub_keys = regexp_split_to_array(keys[i], col_split);
		INSERT INTO site_rakeback_gametype(
			center_id, master_id, site_id,
			api_id, game_type, rakeback,
			rakeback_year, rakeback_month, static_time
		) VALUES (
			center_id, master_id, sid,
			sub_keys[1]::INT, sub_keys[2], val,
			c_year, c_month, now()
		);
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rakeback_gametype(api_map hstore, dict_map hstore)
IS 'Lins-站点返水.GAME_TYPE';

/**
 * 站点返水.API.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	站点信息map
**/
drop function if exists gamebox_site_rakeback_api(hstore);
create or replace function gamebox_site_rakeback_api(
	dict_map hstore
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点返水-入口
--v1.01  2016/06/17  Leisure  SUM(rakeback_total)改为SUM(rakeback)
--v1.02  2016/06/17  Leisure  返水统计改为每期（原来为每月）执行一次，去除DELETE逻辑
--v1.03  2016/07/05  Leisure  撤销--v1.02的修改
*/
DECLARE
	sid 	INT;
	c_id 	INT;
	m_id 	INT;
	c_year 	INT;
	c_month INT;
BEGIN
	sid = (dict_map->'site_id')::INT;
	c_id = (dict_map->'center_id')::INT;
	m_id = (dict_map->'master_id')::INT;
	c_year = (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;

	--v1.02  2016/06/17  Leisure
	--v1.03  2016/07/05  Leisure
	DELETE FROM site_rakeback_api WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;

	INSERT INTO site_rakeback_api(
  		center_id, master_id, site_id, rakeback_year,
  		rakeback_month, static_time, api_id, rakeback
	) SELECT
		c_id, m_id, sid, c_year,
		c_month, now(), api_id, SUM(rakeback)
	   FROM site_rakeback_gametype
  	  WHERE site_id = sid
  	  	AND rakeback_year = c_year
  	  	AND rakeback_month = c_month
	  GROUP BY api_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rakeback_api(dict_map hstore)
IS 'Lins-站点返水.API';

/**
 * 站点返水.玩家
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	站点信息map
**/
drop function if exists gamebox_site_rakeback_player(hstore);
drop function if exists gamebox_site_rakeback_player(hstore, hstore);
create or replace function gamebox_site_rakeback_player(
	act_map 	hstore,
	dict_map 	hstore
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点返水-入口
--v1.01  2016/06/17  Leisure  返水统计改为每期（原来为每月）执行一次，去除DELETE逻辑
--v1.02  2016/07/05  Leisure  撤销--v1.01的修改
*/
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

	--v1.01  2016/06/17  Leisure
	--v1.02  2016/07/05  Leisure
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

/*
--测试收集站点玩家数.
SELECT * FROM gamebox_site_rakeback (
	'host=192.168.0.88 dbname=gb-companies user=gb-companies password=postgres',
	'host=192.168.0.88 dbname=gb-sites user=gb-site-2 password=postgres',
	'2015-01-01',
	'2015-12-31',
	'\|'
);

SELECT * FROM gamebox_site_rakeback (
	'host=192.168.0.88 dbname=gb-companies user=gb-companies password=postgres',
	'host=192.168.0.88 dbname=gb-sites user=gb-site-2 password=postgres',
	'2015-01-01',
	'2015-12-31'
);

SELECT extract(month FROM now());
*/
