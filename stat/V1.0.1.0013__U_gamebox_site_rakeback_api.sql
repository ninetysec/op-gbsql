-- auto gen by tom 2016-03-22 16:28:03
CREATE OR REPLACE FUNCTION "gamebox_site_rakeback_api"(dict_map "hstore")
  RETURNS "void" AS $BODY$
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
	DELETE FROM site_rakeback_api WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;
	INSERT INTO site_rakeback_api(
  		center_id, master_id, site_id,
  		rakeback_year, rakeback_month, static_time,
  		api_id, rakeback
	) SELECT
		c_id, m_id, sid,
		c_year, c_month, now(),
		api_id, SUM(rakeback)
	   FROM site_rakeback_gametype
  	  WHERE site_id = sid
  	  	AND rakeback_year = c_year
  	  	AND rakeback_month = c_month
	  GROUP BY api_id;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "gamebox_site_rakeback_api"(dict_map "hstore") IS 'Lins-站点返水.API';

CREATE OR REPLACE FUNCTION "gamebox_site_rakeback_player"(dict_map "hstore")
  RETURNS "void" AS $BODY$
DECLARE
	val 		FLOAT;
	sid 		INT;
	center_id 	INT;
	master_id 	INT;
	c_year 		INT;
	c_month 	INT;
	player_num 	INT;
BEGIN
	sid = (dict_map->'site_id')::INT;
	center_id = (dict_map->'center_id')::INT;
	master_id = (dict_map->'master_id')::INT;
	c_year = (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;
	player_num = (dict_map->'player_num')::INT;

	DELETE FROM site_rakeback_player WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;

	SELECT sum(rakeback) INTO val FROM site_rakeback_gametype
	WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;

	INSERT INTO site_rakeback_player(
  		center_id, master_id, site_id,
  		player_count, rakeback_year, rakeback_month,
  		static_time, rakeback_total
	) VALUES (
		center_id, master_id, sid,
		player_num, c_year, c_month,
		now(), val
	);
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "gamebox_site_rakeback_player"(dict_map "hstore") IS 'Lins-站点返水.玩家';


CREATE OR REPLACE FUNCTION "gamebox_site_rakeback_gametype"(api_map "hstore", dict_map "hstore")
  RETURNS "void" AS $BODY$
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

	DELETE FROM site_rakeback_gametype WHERE site_id = sid AND rakeback_year = c_year AND rakeback_month = c_month;

	keys = akeys(api_map);
	IF api_map is null OR array_length(keys,  1) is null THEN
		RETURN;
	END IF;

	raise info 'len = %', array_length(keys,  1);
	FOR i IN 1..array_length(keys,  1) LOOP
		val = (api_map->keys[i])::FLOAT;
		sub_keys = regexp_split_to_array(keys[i], col_split);
		INSERT INTO site_rakeback_gametype(
			center_id, master_id, site_id,
			api_id, game_type,
			rakeback_year, rakeback_month, static_time, rakeback
		) VALUES (
			center_id, master_id, sid,
			sub_keys[1]::INT, sub_keys[2],
			c_year, c_month, now(), val
		);
	END LOOP;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "gamebox_site_rakeback_gametype"(api_map "hstore", dict_map "hstore") IS 'Lins-站点返水.GAME_TYPE';

ALTER TABLE "site_rakeback_gametype"
DROP COLUMN IF EXISTS "rakeback_total";