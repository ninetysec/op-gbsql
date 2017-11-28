-- auto gen by admin 2016-06-17 20:06:16
drop function if exists gamebox_site_rakeback_gametype(hstore, hstore);

create or replace function gamebox_site_rakeback_gametype(

	api_map 	hstore,

	dict_map 	hstore

) returns void as $$

/*版本更新说明

--版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：站点返水-入口

--v1.01  2016/06/17  Leisure  返水统计改为每天执行一次，去除DELETE逻辑

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

	--DELETE FROM site_rakeback_gametype WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;



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



drop function if exists gamebox_site_rakeback_api(hstore);

create or replace function gamebox_site_rakeback_api(

	dict_map hstore

) returns void as $$

/*版本更新说明

--版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：站点返水-入口

--v1.01  2016/06/17  Leisure  SUM(rakeback_total)改为SUM(rakeback)

--v1.02  2016/06/17  Leisure  返水统计改为每天执行一次，去除DELETE逻辑

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



	--v1.01  2016/06/17  Leisure

	--DELETE FROM site_rakeback_api WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;



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



drop function if exists gamebox_site_rakeback_player(hstore);

drop function if exists gamebox_site_rakeback_player(hstore, hstore);

create or replace function gamebox_site_rakeback_player(

	act_map 	hstore,

	dict_map 	hstore

) returns void as $$

/*版本更新说明

--版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：站点返水-入口

--v1.01  2016/06/17  Leisure  返水统计改为每天执行一次，去除DELETE逻辑

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

	--DELETE FROM site_rakeback_player WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;



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