drop function if exists gamebox_operation_favorable_calculate(hstore, FLOAT);
create or replace function gamebox_operation_favorable_calculate(
    favorable_map 	hstore,
    amount 			FLOAT
)returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 运营商优惠计算
--v1.01  2016/05/26  Laser    修改梯度判断逻辑，梯度下限——上限取该梯度，
                              超过最大梯度取最大梯度
*/
DECLARE
	val 				TEXT;
	keys 				TEXT[];
	key_name 			TEXT;
	favourable_grads 	TEXT:='';	-- 优惠满足梯度
	favourable_way 		TEXT:='';	-- 优惠方式(1:固定, 2:比例)
	favourable_value 	TEXT:='';	-- 优惠值
	favourable_limit 	TEXT:='';	-- 优惠上限
	actual_value		TEXT:='';	-- 实付值
	map 				hstore;
BEGIN

	IF favorable_map is null OR amount <= 0 THEN
		SELECT put(map, 'grads', '0') INTO map;
		SELECT put(map, 'limit', '0') INTO map;
		SELECT put(map, 'value', '0') INTO map;
		SELECT put(map, 'way', '0') INTO map;
	ELSE
		keys = akeys(favorable_map);
		--v1.01  2016/05/26  Laser
		FOR i IN 1..array_length(keys, 1) -- REVERSE
		LOOP
			key_name = keys[i];
			--raise info 'keys[i]: %,  amount: %',keys[i], amount;
			IF (keys[i]::FLOAT) > amount THEN
				exit;
			END IF;
		END LOOP;
		--v1.01  2016/05/26  Laser
		val = favorable_map->key_name;

		--raise info 'amount: %,  favorable_map: %,  val: %',amount ,favorable_map, val;

		--val格式:梯度下限_梯度上限_优惠类型_优惠方式_优惠值_优惠上限
		keys = regexp_split_to_array(val, '_');
		--raise info 'vals:%', keys;
		IF array_length(keys,  1) = 6 THEN
			favourable_grads = COALESCE(keys[2], '0');	-- 梯度值
			favourable_way = COALESCE(keys[4], '1');	-- 优惠方式(1:固定, 2:比例)
			favourable_value = COALESCE(keys[5], '0');	-- 优惠值
			favourable_limit = COALESCE(keys[6], '0');	-- 上限

			IF favourable_way = '2' THEN--比例
				favourable_value = (amount * (favourable_value::FLOAT) / 100)::TEXT;
			END IF;

			actual_value = favourable_value;
			IF favourable_limit::FLOAT > 0 AND favourable_value::FLOAT > favourable_limit::FLOAT THEN--超过上限
			 	actual_value = favourable_limit;
			END IF;

			SELECT put(map, 'grads', favourable_grads) INTO map;
			SELECT put(map, 'limit', favourable_limit) INTO map;
			SELECT put(map, 'value', favourable_value) INTO map;
			SELECT put(map, 'way', favourable_way) INTO map;
			SELECT put(map, 'actual', actual_value) INTO map;
		END IF;
	END IF;
	IF map is null THEN
		SELECT put(map, 'grads', '0') INTO map;
		SELECT put(map, 'limit', '0') INTO map;
		SELECT put(map, 'value', '0') INTO map;
		SELECT put(map, 'way', '0') INTO map;
	END IF;
	RETURN map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_favorable_calculate(favorable_map hstore, amount FLOAT)
IS 'Lins-运营商优惠计算';
