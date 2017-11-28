-- auto gen by cherry 2016-01-27 11:15:17
-- auto gen by fly 2016-01-25 19:19:32

/**
 * 返水计算
 * @author 	Lins
 * @date 	2015.11.10
 * @return 	返回float类型，返水值.
 */
DROP FUNCTION IF EXISTS gamebox_rakeback_calculator(hstore, hstore, json);
CREATE OR REPLACE FUNCTION gamebox_rakeback_calculator(
	gradshash hstore,
	agenthash hstore,
	rec json
) returns FLOAT as $$
DECLARE
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
	--返水值.
	back_water_value float:=0.00;
	--占成
	ratio 			float:=0.00;
	--最大返水上限
	max_back_water 	float:=0.00;
	--玩家有效交易量
	effective_trade_amount 	float:=0.00;
	--梯度ID.
	back_water_id 	int:=0;
	--API
	api 			int:=0;
	--游戏类型
	gameType 		text;
	--代理ID
	agent_id 		text;

BEGIN
	keys = akeys(gradshash);
	FOR i IN 1..array_length(keys, 1)
	LOOP
		subkeys = regexp_split_to_array(keys[i], '_');
		keyname = keys[i];
		back_water_id = rec->>'rakeback_id';
		api = rec->>'api_id';
		gameType = rtrim(ltrim(rec->>'game_type'));
		--玩家未设置返水梯度,取当前玩家的代理返水梯度.
		agent_id = rec->>'owner_id';

		raise info '代理ID:%,梯度:%',keyname, back_water_id;

		IF back_water_id IS NULL THEN
			back_water_id = agenthash->agent_id;
		END IF;

		IF back_water_id IS NULL THEN
			raise info '%:玩家未设置返水梯度,代理也未设置', rec->>'username';
			RETURN 0;
		END IF;

		raise info 'gameType=%', gameType;

		IF subkeys[1]::int = back_water_id AND subkeys[3]::int = api AND rtrim(ltrim(subkeys[4])) = gameType THEN
			--开始作比较.
			val = gradshash->keyname;
			raise info 'val = %', val;

			--玩家有效交易量
			effective_trade_amount = (rec->>'effective_trade_amount')::float;
			--判断是否已经比较够且有效交易量大于当前值.
			raise info '% > %',effective_trade_amount, pre_valid_value;
			IF effective_trade_amount > pre_valid_value THEN
				SELECT * FROM strToHash(val) INTO hash;
				--占成数
				ratio = (hash->'ratio')::float;
				--梯度有效交易量
				valid_value = (hash->'valid_value')::float;
				--返水上限
				max_back_water = (hash->'max_rakeback')::float;

				raise info '梯度有效交易量:%', valid_value;
				raise info '返水上限:%', max_back_water;
				raise info '占成比例:%', ratio;
				raise info '玩家有效交易量:%', effective_trade_amount;

				IF effective_trade_amount >= valid_value THEN
					--存储此次梯度有效交易量,作下次比较.
					pre_valid_value = valid_value;
					--返水计算:有效交易量 x 占成
					back_water_value = effective_trade_amount * ratio / 100;
					--返水大于返水上限，以上限值为准.
					IF back_water_value > max_back_water THEN
						back_water_value = max_back_water;
					END IF;

					raise info '玩家信息.ID=%, API=%, gameType=%, 有效交易量=%, 梯度.有效交易量=%, 上限=%, 比例:%, 返水=%'
						,rec->>'userid', api, gameType, effective_trade_amount, valid_value, max_back_water, ratio, back_water_value;

				END IF;

				raise info '玩家返水值:%',back_water_value;

			END IF;
			ELSE
				raise info '没找到返水方案';
			END IF;
		END LOOP;
	RETURN back_water_value;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_calculator(gradshash hstore, agenthash hstore, rec json)
IS 'Lins-返水-返水计算';

/**
 * 玩家[API]返水.
 * @author 	Lins
 * @date 	2015.12.3
 * @param 	startTime 	返水周期开始时间(yyyy-mm-dd HH:mm:ss)
 * @param 	endTime 	返水周期结束时间(yyyy-mm-dd HH:mm:ss)
 */
drop function IF EXISTS gamebox_rebate_rakeback_map(TIMESTAMP, TIMESTAMP);
create or replace function gamebox_rebate_rakeback_map(
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP
) returns hstore as $$

DECLARE
	rec record;
	sql TEXT:= '';
	key TEXT:= '';
	val TEXT:= '';
	hash hstore;
BEGIN
	raise info '统计玩家API返水';
	hash = '-1=>-1';
	sql = 'SELECT rp.player_id,
			 	  SUM(ra.rakeback)	rakeback
			 FROM rakeback_bill rb
			 LEFT JOIN rakeback_player rp ON rb."id" = rp.rakeback_bill_id
			 LEFT JOIN rakeback_api ra ON rb."id" = ra.rakeback_bill_id
			WHERE rb.start_time >= $1
			  AND rb.end_time < $2
			  AND rp.player_id IS NOT NULL
			GROUP BY rp.player_id';
	FOR rec IN EXECUTE sql USING startTime, endTime
	LOOP
		key = rec.player_id;
		val = key||'=>'||rec.rakeback;
		hash = hash||(SELECT val::hstore);
	END LOOP;
	raise info '玩家API返水 = %', hash;
	raise info '统计玩家API返水.完成';

	RETURN hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_rakeback_map(startTime TIMESTAMP, endTime TIMESTAMP)
IS 'Lins-返佣返水-返佣调用';