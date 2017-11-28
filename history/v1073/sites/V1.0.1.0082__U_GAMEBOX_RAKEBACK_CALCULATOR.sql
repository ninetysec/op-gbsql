-- auto gen by tom 2016-03-23 09:46:27
CREATE OR REPLACE FUNCTION "public"."gamebox_rakeback_calculator"(gradshash "public"."hstore", agenthash "public"."hstore", rec json)
  RETURNS "pg_catalog"."float8" AS $BODY$
DECLARE
	keys 		text[];
	subkeys 	text[];
	keyname 	text:='';
	--临时
	val 		text:='';
	--临时Hstore
	hash 		hstore;
	--梯度有效交易量
	-- valid_value float:=0.00;
	--上次梯度有效交易量
	--pre_valid_value float:=0.00;
	--返水值.
	back_water_value float:=0.00;
	--占成
	ratio 			float:=0.00;
	--最大返水上限
	--max_back_water 	float:=0.00;
	--玩家有效交易量
	effective_trade_amount 	float:=0.00;
	--梯度ID.
   gid int;
	--back_water_id 	int:=0;
	--API
	api 			int:=0;
	--游戏类型
	gameType 		text;
	--代理ID
	--agent_id 		text;

BEGIN
	keys = akeys(gradshash);
	FOR i IN 1..array_length(keys, 1)
	LOOP
		subkeys = regexp_split_to_array(keys[i], '_');
		keyname = keys[i];
		-- back_water_id = rec->>'rakeback_id';
		api = rec->>'api_id';
		gameType = rtrim(ltrim(rec->>'game_type'));
		--玩家未设置返水梯度,取当前玩家的代理返水梯度.
		-- agent_id = rec->>'owner_id';
    gid = rec->>'gid';
		-- raise info '代理ID:%,梯度:%',keyname, back_water_id;

		/*IF back_water_id IS NULL THEN
			back_water_id = agenthash->agent_id;
		END IF;*/

		/*IF back_water_id IS NULL THEN
			raise info '%:玩家未设置返水梯度,代理也未设置', rec->>'username';
			RETURN 0;
		END IF;*/

		-- raise info 'gameType=%', gameType;
		IF subkeys[2]::int = gid AND subkeys[3]::int = api AND rtrim(ltrim(subkeys[4])) = gameType THEN
			-- 开始作比较.
			val = gradshash->keyname;
			-- raise info 'val = %', val;

			-- 玩家有效交易量
			effective_trade_amount = (rec->>'effective_trade_amount')::float;
			-- 判断是否已经比较够且有效交易量大于当前值.
			--IF effective_trade_amount > pre_valid_value THEN
				SELECT * FROM strToHash(val) INTO hash;
				-- 占成数
				ratio = (hash->'ratio')::float;
				-- 梯度有效交易量
				-- valid_value = (hash->'valid_value')::float;
				-- 返水上限
				--max_back_water = (hash->'max_rakeback')::float;

				--IF effective_trade_amount >= valid_value THEN
					-- 存储此次梯度有效交易量,作下次比较.
					-- pre_valid_value = valid_value;
					-- 返水计算:有效交易量 x 占成
					back_water_value = effective_trade_amount * ratio / 100;
					-- 返水大于返水上限，以上限值为准.
					/*IF back_water_value > max_back_water THEN
						back_water_value = max_back_water;
					END IF;*/
				--END IF;
				-- raise info '玩家返水值:%', back_water_value;

			--END IF;
			-- ELSE
			-- 	raise info '没找到返水方案';
			END IF;
		END LOOP;
		-- raise info 'back_water_value = %', back_water_value;
	RETURN back_water_value;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "public"."gamebox_rakeback_calculator"(gradshash "public"."hstore", agenthash "public"."hstore", rec json) OWNER TO "postgres";

COMMENT ON FUNCTION "public"."gamebox_rakeback_calculator"(gradshash "public"."hstore", agenthash "public"."hstore", rec json) IS 'Lins-c-tom-modify-返水-返水计算';