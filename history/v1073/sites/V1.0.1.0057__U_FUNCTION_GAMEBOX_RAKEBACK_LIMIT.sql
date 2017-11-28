-- auto gen by tom 2016-03-14 14:05:53

drop function IF EXISTS gamebox_rakeback_limit(rakeback_id int4, gradshash "hstore", agenthash "hstore");
CREATE OR REPLACE FUNCTION "gamebox_rakeback_limit"(rakeback_id int4, gradshash "hstore", agenthash "hstore", efftrans float8)
  RETURNS "pg_catalog"."float8" AS $BODY$
DECLARE
	keys 		text[];
	subkeys 	text[];
	keyname 	text:='';
	val 		text:='';
	hash 		hstore;
	--最大返水上限
	max_back_water 	float:=0.00;
	key 		text:='';
	tmp_rb_id	int;
  tmp_rb_validValue int;
BEGIN
	keys = akeys(gradshash);
	FOR i IN 1..array_length(keys, 1)
	LOOP
		subkeys = regexp_split_to_array(keys[i], '_');
		keyname = keys[i];
		val = gradshash->keyname;
		IF subkeys IS NOT NULL THEN
			key = subkeys[0];
		END IF;
		SELECT * FROM strToHash(val) INTO hash;
		tmp_rb_id = hash->'id';
		max_back_water = 0.00;
    tmp_rb_validValue=hash->'valid_value';
		IF rakeback_id = tmp_rb_id AND  effTrans>= (tmp_rb_validValue::float) THEN
			max_back_water = (hash->'max_rakeback')::float;
			EXIT;
		END IF;
	END LOOP;
	RETURN max_back_water;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "gamebox_rakeback_limit"(rakeback_id int4, gradshash "hstore", agenthash "hstore", efftrans float8) OWNER TO "postgres";
