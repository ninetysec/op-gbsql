-- auto gen by admin 2016-04-10 20:35:20
DROP FUNCTION if EXISTS gamebox_rakeback_filter_player(gradshash "hstore", agenthash "hstore", rec json);

CREATE OR REPLACE FUNCTION "gamebox_rakeback_filter_player"(gradshash "hstore", agenthash "hstore", rec json)
  RETURNS "hstore" AS $BODY$
DECLARE
  playerIdGradId hstore;
	keys 		text[];
	subkeys 	text[];
	keyname 	text:='';
	--临时
	val 		text:='';
	--临时Hstore
	hash 		hstore;
	--梯度有效交易量
	valid_value float:=0.00;
	--上次梯度有效交易量
	pre_valid_value float:=0.00;
	--玩家有效交易量
	total_effective_trade_amount 	float:=0.00;
	--梯度ID.
	back_water_id 	int:=0;
	--代理ID
	agent_id 		text;

BEGIN
	keys = akeys(gradshash);
	FOR i IN 1..array_length(keys, 1)
	LOOP
		subkeys = regexp_split_to_array(keys[i], '_');
		keyname = keys[i];
		back_water_id = rec->>'rakeback_id';
		--玩家未设置返水梯度,取当前玩家的代理返水梯度.
		agent_id = rec->>'owner_id';
		-- raise info '代理ID:%,梯度:%',keyname, back_water_id;

		IF back_water_id IS NULL THEN
			back_water_id = agenthash->agent_id;
		END IF;

		IF back_water_id IS NULL THEN
			raise info '%:玩家未设置返水梯度,代理也未设置', rec->>'username';
			RETURN 0;
		END IF;

		-- raise info 'gameType=%', gameType;
		IF subkeys[1]::int = back_water_id THEN
					-- 开始作比较.
					val = gradshash->keyname;
					-- 玩家有效交易总量
					total_effective_trade_amount = (rec->>'total_effective_trade_amount')::float;
			     -- 判断是否已经比较够且有效交易量大于当前值.
					IF total_effective_trade_amount > pre_valid_value THEN
											SELECT * FROM strToHash(val) INTO hash;
											-- 梯度有效交易量
											valid_value = (hash->'valid_value')::float;
											-- 玩家存在符合的梯度
										 IF total_effective_trade_amount >= valid_value THEN
															select (rec->>'player_id'||'=>'||subkeys[2]) into playerIdGradId;
															return playerIdGradId;
										 END IF;
						END IF;
		END IF;
		END LOOP;
		return '-1=>-1';
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "gamebox_rakeback_filter_player"(gradshash "hstore", agenthash "hstore", rec json) IS 'tom-返水-筛选满足返水的玩家';

DROP FUNCTION if EXISTS gamebox_rakeback_qualified_player(gradshash "hstore", agenthash "hstore", back_time timestamp);
CREATE OR REPLACE FUNCTION "gamebox_rakeback_qualified_player"(gradshash "hstore", agenthash "hstore", back_time timestamp)
  RETURNS "hstore" AS $BODY$

DECLARE
	playerIdGradId 	hstore;
  tempHstore hstore;
  rec 		record;
BEGIN
	raise info '取得当前返水梯度设置信息.';
  	FOR rec IN
		select po.player_id,su.owner_id,po.total_effective_trade_amount,up.rakeback_id,su.username
			from
			(SELECT player_id,SUM(COALESCE(pgo.effective_trade_amount, 0.00))	as total_effective_trade_amount
										 FROM player_game_order pgo
										WHERE to_char(pgo.create_time, 'yyyy-MM-dd') = to_char(back_time, 'yyyy-MM-dd')  group by  player_id) po
       LEFT JOIN sys_user su ON po.player_id = su."id"
			 LEFT JOIN user_player up ON po.player_id = up."id"
				WHERE su.user_type = '24'

  LOOP
					select gamebox_rakeback_filter_player(gradshash,agenthash,row_to_json(rec)) into tempHstore;
          if (tempHstore?'-1')=false THEN
									IF playerIdGradId is null THEN
												playerIdGradId = tempHstore;
									ELSE
												playerIdGradId = playerIdGradId||tempHstore;
									END IF;
					end if;
	END LOOP;

	raise info '过滤出符合玩家设置的梯度方案中的某个梯度的玩家';
  return playerIdGradId;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "gamebox_rakeback_qualified_player"(gradshash "hstore", agenthash "hstore", back_time timestamp) IS 'Tom-返水-过滤出符合玩家设置的梯度方案中的某个梯度的玩家';


DROP FUNCTION if EXISTS gamebox_rakeback_api_base(back_time timestamp);

CREATE OR REPLACE FUNCTION "gamebox_rakeback_api_base"(back_time timestamp)
  RETURNS "pg_catalog"."void" AS $BODY$

DECLARE
	rakeback 	FLOAT:=0.00;
	rec 		record;
	gradshash 	hstore;
	agenthash 	hstore;
	is_attach	int:=0;
  playerIdGradId hstore;
	keys 		text[];
	playerId text;
  subvalues text[];
  gradAndTotal text;
  gradId text;

BEGIN
	SELECT COUNT(1) FROM activity_message
	 WHERE back_time BETWEEN start_time AND end_time
	   AND check_status = '1'
	   AND is_display = TRUE
	   AND is_deleted = FALSE
	   AND activity_type_code = 'back_water' into is_attach;

   IF is_attach > 0 THEN
				raise info '取得当前返水梯度设置信息.';
  	    SELECT gamebox_rakeback_api_grads() into gradshash;
  	    raise info '取得代理返水设置.';
  	    SELECT gamebox_agent_rakeback() 	into agenthash;

  	    raise info '统计前清空当前日期( % )已有数据', back_time;
  	    DELETE FROM rakeback_api_base WHERE to_char(rakeback_time, 'yyyy-MM-dd') = to_char(back_time, 'yyyy-MM-dd');

  	    raise info '统计日期( % )内是否有返水优惠活动', back_time;

				select gamebox_rakeback_qualified_player(gradshash,agenthash,back_time) into playerIdGradId;

				keys = akeys(playerIdGradId);
				FOR i IN 1..array_length(keys, 1)
        LOOP
            playerId = (keys[i])::text;
            gradId = playerIdGradId->playerId;
					 SELECT ua.parent_id,
							su.owner_id,
							su.username,
							po.player_id 	as userid,
							po.api_id,
							po.api_type_id,
							po.game_type,
              po.effective_trade_amount,
							po.profit_amount,
							gradId as gid
						 FROM (SELECT pgo.player_id,
									pgo.api_id,
									pgo.api_type_id,
									pgo.game_type,
									SUM(COALESCE(pgo.effective_trade_amount, 0.00))	as effective_trade_amount,
									SUM(COALESCE(pgo.profit_amount, 0.00))			as profit_amount
								 FROM player_game_order pgo
								WHERE pgo.player_id=playerId::int and to_char(pgo.payout_time, 'yyyy-MM-dd') = to_char(back_time, 'yyyy-MM-dd')
								GROUP BY pgo.player_id, pgo.api_id, pgo.api_type_id, pgo.game_type) po
						 LEFT JOIN sys_user su ON po.player_id = su."id"
						 LEFT JOIN user_player up ON po.player_id = up."id"
						 LEFT JOIN user_agent ua ON su.owner_id = ua."id"
						WHERE su.user_type = '24' into rec;

					SELECT gamebox_rakeback_calculator(gradshash, agenthash, row_to_json(rec)) into rakeback;
					raise info '玩家[%]返水 = %', rec.username, rakeback;

					-- 新增玩家返水:有返水才新增.
					IF rakeback > 0 THEN
						INSERT INTO rakeback_api_base(
							top_agent_id, agent_id, player_id, api_id, api_type_id, game_type,
							effective_transaction, profit_loss, rakeback, rakeback_time
						) VALUES (
							rec.parent_id, rec.owner_id, rec.userid, rec.api_id, rec.api_type_id, rec.game_type,
							rec.effective_trade_amount, rec.profit_amount, rakeback, back_time
						);
					END IF;
				END LOOP;

				raise info '收集每个API下每个玩家的返水.完成';
   END IF;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "gamebox_rakeback_api_base"(back_time timestamp) IS 'Lins-返水-各玩家API返水基础表.入口';


DROP FUNCTION if EXISTS gamebox_rakeback_calculator(gradshash "hstore", agenthash "hstore", rec json);

CREATE OR REPLACE FUNCTION "gamebox_rakeback_calculator"(gradshash "hstore", agenthash "hstore", rec json)
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
	max_back_water 	float:=0.00;
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
	--raise info '=======================keys:%',keys;
	--raise info '=======================rec:%',rec;
	--raise info '=======================gradshash:%',gradshash;
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
				max_back_water = (hash->'max_rakeback')::float;

				--IF effective_trade_amount >= valid_value THEN
					-- 存储此次梯度有效交易量,作下次比较.
					-- pre_valid_value = valid_value;
					-- 返水计算:有效交易量 x 占成
					back_water_value = effective_trade_amount * ratio / 100;
					--raise info '[effective_trade_amount:%,ratio:%,back_water_value:%,max_back_water:%]', effective_trade_amount,ratio,back_water_value,max_back_water;
					-- 返水大于返水上限，以上限值为准.
					IF max_back_water <> 0 and back_water_value > max_back_water THEN
						back_water_value = max_back_water;
					END IF;
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
COMMENT ON FUNCTION "gamebox_rakeback_calculator"(gradshash "hstore", agenthash "hstore", rec json) IS 'Lins-c-tom-modify-返水-返水计算';