/**
 * Lins-站点账务-API.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	dict_map 各项值map
**/
drop function if exists gamebox_station_bill_top(hstore, hstore, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_station_bill_top(
	sys_map 	hstore,		-- 优惠分摊比例
	dict_map 	hstore,		-- 运营商，站长，站点，年，月，账务类型
	url_name 	TEXT,
	main_url 	TEXT,
	start_time 	TEXT,
	end_time 	TEXT
) returns TEXT as $$
DECLARE
	maps 		hstore[];
	api_map 	hstore;
	expense_map hstore;		-- 分推比例
	cost_map 	hstore;

	api_id 		INT;
	game_type 	TEXT;
	profit_loss FLOAT;
	occupy_proportion FLOAT;
	amount_payable FLOAT;

	bill_id 	INT;

	id 			INT;
	name 		TEXT;
	val 		TEXT;
	vals 		TEXT[];
	sval 		TEXT[];
	keys 		TEXT[];

	map 		hstore;
	expense_category TEXT[]:=array['backwater', 'refund_fee', 'favorable', 'rebate'];
	category 	TEXT:='';
	value 		FLOAT;
	h_keys 		TEXT[]:=array['-1'];	-- 记录已存在ID.
	amount 		FLOAT:=0.00;			-- 应付总额
	expense 	FLOAT:=0.00;			-- 分摊费用.

	sys_config hstore;
	sp 		TEXT:='@';
	rs 		TEXT:='\~';
	cs 		TEXT:='\^';
	rs_a 	TEXT:='';
	cs_a 	TEXT:='';
	sp_a 	TEXT:='';
BEGIN
	--取得系统变量
	SELECT sys_config() INTO sys_config;
	sp = sys_config->'sp_split';
	rs = sys_config->'row_split';
	cs = sys_config->'col_split';
	sp_a = sys_config->'sp_split_a';
	rs_a = sys_config->'row_split_a';
	cs_a = sys_config->'col_split_a';
	rs_a = '\^&\^';
	cs_a = '\^';

	raise info '------ url_name = %', url_name;
	raise info '------ main_url = %', main_url;

	SELECT  * FROM dblink(
		url_name,
		'SELECT  * FROM gamebox_occupy_map('''||main_url||''', '''||start_time||''', '''||end_time||''')'
	) as p(h hstore[]) INTO maps;

	IF array_length(maps,  1) < 2 THEN
		RETURN '1.站点库返回总代信息有误';
	END IF;

	api_map = maps[1];
	raise info '------ api_map = %', api_map;
	expense_map = maps[2];
	raise info '------ expense_map = %', expense_map;

	-- 格式：id=>name@api^game^val^retio^loss^&^api^game^val^retio^loss
	keys = akeys(api_map);
	raise info '------ keys = %', keys;
	raise info '------------------------------------ OFF LINE 1 --------------------------------------';
	IF array_length(keys, 1) > 0 THEN
		FOR i IN 1..array_length(keys, 1) LOOP

			val = api_map->keys[i];
			raise info '------ val = %', val;
			vals = regexp_split_to_array(val, sp);
			raise info '------ vals 1 = %', vals;

			IF array_length(vals, 1) = 2 THEN

				name = vals[1];
				raise info '------ name = %', name;
				SELECT put(dict_map, 'topagent_id', keys[i]) into dict_map;
				SELECT put(dict_map, 'topagent_name', name) into dict_map;
				SELECT put(dict_map, 'op', 'I') into dict_map;

				--准备station_bill.
				amount = 0.00;

				raise info '------ dict_map 1 = %', dict_map;
				SELECT gamebox_station_bill(dict_map) INTO bill_id;

				--API盈亏
				--vals[2].值格式:api^game^val^retio^loss
				vals = regexp_split_to_array(vals[2], rs_a);
				raise info '------ vals 2 = %', vals;

				IF array_length(vals,  1) > 0 THEN
					FOR k IN 1..array_length(vals,  1) LOOP

						--vals[k].值格式:api^game^val^retio^loss
						sval = regexp_split_to_array(vals[k], cs_a);
						raise info '------ sval = %', sval;
						IF array_length(sval,  1) >= 4 THEN
							map = null;
							SELECT put(map, 'api_id', sval[1]) into map;			--API
							SELECT put(map, 'game_type', sval[2]) into map;			--API二级分类
							SELECT put(map, 'amount_payable', sval[3]) into map;	--应付金额
							SELECT put(map, 'occupy_proportion', sval[4]) into map;	--占成比例
							SELECT put(map, 'profit_loss', sval[5]) into map;		--盈亏总和
							SELECT put(map, 'bill_id', bill_id::TEXT) into map;
							amount = amount + COALESCE(sval[3]::FLOAT, 0.00);

							raise info '------ map = %', map;
							perform gamebox_station_profit_loss(map);
						END IF;

					END LOOP;
				END IF;

				raise info '------ amount = %', amount;

				-- 其它费用.
				expense = 0.00;
				raise info '------ keys[i] = %', keys[i];
				IF exist(expense_map, keys[i]) THEN
					h_keys = array_append(h_keys,  keys[i]);
					val = expense_map->keys[i];
					val = replace(val, rs, ',');
					val = replace(val, cs, '=>');
					SELECT val INTO cost_map;
					
					raise info '------ cost_map = %', cost_map;

					SELECT gamebox_station_bill_other(cost_map, sys_map, bill_id) INTO expense;
				END IF;

				raise info '------ expense = %', expense;

				-- 更新账务.
				amount = amount-expense;

				SELECT put(dict_map, 'bill_id', bill_id::TEXT) into dict_map;
				SELECT put(dict_map, 'op', 'U') into dict_map;
				SELECT put(dict_map, 'amount', amount::TEXT) into dict_map;

				raise info '------ dict_map 2 = %', dict_map;

				SELECT gamebox_station_bill(dict_map) INTO bill_id;

			END IF;
		END LOOP;
	END IF;

	raise info '------------------------------------ OFF LINE 2 --------------------------------------';
	-- 处理特殊其它费用
	keys = akeys(expense_map);
	raise info '------ 其它 keys = %', keys;

	IF array_length(keys,  1) > 0 THEN
		FOR i IN 1..array_length(keys,  1)
		LOOP
			IF h_keys @> array[keys[i]] = false THEN--判断是否已经记账

				val = expense_map->keys[i];
				val = replace(val, rs, ',');
				val = replace(val, cs, '=>');
				SELECT val INTO cost_map;

				-- 准备station_bill.
				name = cost_map->'user_name';

				raise info '------ 其它 name = %', name;

				SELECT put(dict_map, 'topagent_id', keys[i]) INTO dict_map;
				SELECT put(dict_map, 'topagent_name', name) INTO dict_map;
				SELECT put(dict_map, 'op', 'I') INTO dict_map;

				SELECT gamebox_station_bill(dict_map) INTO bill_id;
				
				-- 其它费用
				raise info '------ 其它 cost_map = %', cost_map;
				SELECT gamebox_station_bill_other(cost_map, sys_map, bill_id) INTO expense;

				raise info '------ 其它 expense = %', expense;

				-- 更新账务.
				SELECT put(dict_map, 'bill_id', bill_id::TEXT) INTO dict_map;
				SELECT put(dict_map, 'op', 'U') INTO dict_map;
				SELECT put(dict_map, 'amount', (-expense)::TEXT) into dict_map;

				raise info '------ 其它 dict_map = %', dict_map;

				SELECT gamebox_station_bill(dict_map) INTO bill_id;

			END IF;
		END LOOP;
	END IF;

	RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_top(sys_map hstore, dict_map hstore, url_name TEXT, main_url TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-站点账务-API';