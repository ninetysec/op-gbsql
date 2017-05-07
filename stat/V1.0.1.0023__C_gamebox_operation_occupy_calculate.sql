-- auto gen by admin 2016-05-27 14:37:36
drop function if exists gamebox_operation_occupy_calculate(FLOAT[], FLOAT[], FLOAT[], FLOAT, BOOLEAN);

create or replace function gamebox_operation_occupy_calculate(

  p_lower_values  FLOAT[],

	p_limit_values 	FLOAT[],

	p_retios 			FLOAT[],

	p_amount 			FLOAT,

	p_assume 			BOOLEAN

) returns FLOAT as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2016/05/20  Leisure  创建此函数：运营商占成计算

--v1.01  2016/05/23  Leisure  修正一处bug，盈亏为负，共担为负

--v1.02  2016/05/25  Leisure  盈亏为正，最大上限取上限数组最大值

*/

DECLARE



	f_occupy FLOAT := 0;

	f_occupy_tmp FLOAT := 0;

	f_lower_val FLOAT := 0; --落在当前梯度的金额:=

	f_limit_val	FLOAT := 0; --f_limit_val - f_lower_val

	n_length	INT := 0;



BEGIN



	n_length := array_length(p_retios, 1);



	raise info '各API盈亏 = %', p_amount;



	IF array_length(p_lower_values, 1) <> array_length(p_retios, 1) OR

		array_length(p_limit_values, 1) <> array_length(p_retios, 1) THEN

		raise info '占成梯度设置有误，请检查！';

		RETURN 0.00;

	END IF;



	IF p_amount < 0 THEN



		IF p_assume = false THEN

			raise info '盈亏不共担, 盈亏为负时, 占成计0';

			RETURN 0.00;	-- 盈亏不共担, 计税金额为负时, 占成计0.

		END IF;



		IF p_lower_values[1] >= 0 THEN

			raise info '未设置亏损占成方案, 盈亏为负时, 占成计0';

			RETURN 0.00;	-- 盈亏不共担, 计税金额为负时, 占成计0.

		END IF;



		--如果亏损超出最小梯度范围，超出部分按最小梯度计算

		IF p_amount < p_lower_values[1] THEN

			f_occupy := (p_amount - p_limit_values[1]) * p_retios[1] / 100;

		END IF;



		FOR i IN 1..n_length LOOP

			f_lower_val := p_lower_values[i];

			f_limit_val := p_limit_values[i];

			IF f_lower_val >= 0 THEN

				EXIT; --亏损时，>0的梯度信息无用

			END IF;



			IF p_amount >= f_limit_val THEN

				CONTINUE; --大于梯度上限，直接计算下一梯度

			END IF;



			--对于类似-100000~200000这种梯度设置的特殊处理

			IF f_limit_val > 0 THEN

				f_limit_val := 0;

			END IF;



			--f_lower_val 取梯度下限和亏损金额的大值

			IF f_lower_val < p_amount THEN

				f_lower_val := p_amount;

			END IF;



			f_occupy_tmp := (f_lower_val - f_limit_val) * p_retios[i] / 100; --v1.01

			f_occupy := f_occupy + f_occupy_tmp;



		END LOOP;

	ELSE

	--盈利时

		--如果盈利超出最大梯度范围，超出部分按最大梯度计算

		IF p_amount > p_limit_values[n_length] THEN --v1.02  2016/05/25  Leisure

			f_occupy := (p_amount - p_limit_values[n_length]) * p_retios[n_length] / 100;

			--raise info 'p_amount :%  p_limit_values :%  p_retios:%  f_occupy :%', p_amount, p_lower_values[n_length], p_retios[n_length], f_occupy;

		END IF;



		FOR i IN 1..n_length LOOP

			f_lower_val := p_lower_values[i];

			f_limit_val := p_limit_values[i];

			IF f_limit_val <= 0 THEN

				CONTINUE; --盈利时时，<0的梯度信息无用

			END IF;

			IF p_amount <= f_lower_val THEN

				CONTINUE; --小于梯度下限，直接计算下一梯度

			END IF;



			--对于类似-100000~200000这种梯度设置的特殊处理

			IF f_lower_val < 0 THEN

				f_lower_val := 0;

			END IF;



			--f_limit_val 取梯度上限和盈利金额的小值

			IF f_limit_val > p_amount THEN

				f_limit_val := p_amount;

			END IF;



			f_occupy_tmp := (f_limit_val - f_lower_val) * p_retios[i] / 100;

			f_occupy := f_occupy + f_occupy_tmp;



			--raise info 'f_lower_val :%  f_limit_val :%  f_occupy_tmp:%  f_occupy :%', f_lower_val, f_limit_val, f_occupy_tmp, f_occupy;



		END LOOP;



	END IF;



	RETURN f_occupy;



END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operation_occupy_calculate(p_lower_values  FLOAT[], p_limit_values FLOAT[], p_retios FLOAT[], p_amount FLOAT, p_assume BOOLEAN)

IS 'Leisure-运营商占成计算';



drop function if exists gamebox_site_map(INT);

create or replace function gamebox_site_map(

	sid INT

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：站点信息

--v1.01  2016/05/25  Leisure  !=null改为，is not null

*/

DECLARE

	rec 		record;

	dict_map 	hstore;

BEGIN

	FOR rec IN

		SELECT  * FROM sys_site_info WHERE siteid = sid

	LOOP

    raise info 'rec.sitename : %', rec.sitename;

		SELECT 'site_id=>'||rec.siteid INTO dict_map;

		IF rec.sitename is not null AND rec.sitename <> '' THEN --v1.01  2016/05/25  Leisure

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



drop function if exists gamebox_station_bill_master(hstore, hstore, TEXT, TEXT, TEXT, TEXT);

create or replace function gamebox_station_bill_master(

	sys_map 	hstore,		-- 优惠分摊比例

	dict_map 	hstore,		-- 运营商，站长，站点，年，月，账务类型

	url_name 	TEXT,

	main_url 	TEXT,

	start_time 	TEXT,

	end_time 	TEXT

) returns TEXT as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：站点账务-API

--v1.01  2016/05/20  Leisure  改用新的运营商占成函数

--v1.02  2016/05/25  Leisure	上期未结需要计算应付和实付

*/

DECLARE

	net_maps 	hstore[];

	api_id 		INT;

	api 		TEXT;

	game_type 	TEXT;

	profit_loss FLOAT;

	occupy_proportion FLOAT;

	amount_payable FLOAT;



	bill_id 	INT;

	bill_year 	INT;

	bill_month 	INT;



	id 			INT;

	name 		TEXT;

	val 		TEXT;		-- 单个API单个GameType占成方案

	vals 		TEXT[];

	sval 		TEXT[];

	keys 		TEXT[];

	key_name 	TEXT:='';



	map 		hstore;

	cost_map 	hstore;



	category 	TEXT:='';

	value 		FLOAT;

	h_keys 		TEXT[]:=array['-1'];	-- 记录已存在ID.

	amount 		FLOAT:=0.00;			-- 应付总额（各API盈亏(盈利)）

	expense 	FLOAT:=0.00;			-- 分摊费用.

  lower_values FLOAT[];				-- 梯度数组 --v1.01

	limit_values FLOAT[];				-- 梯度数组

	retios 		FLOAT[];				-- 占成数组



	is_max 		boolean:=false;

	sid 		INT; 					-- 站点ID.

	cur 		refcursor;  			-- 每个API的占成

	rec 		record;

	trade_amount FLOAT:=0.00;

	profilt_amount FLOAT:=0.00;

	occupy 		FLOAT:=0.00;			-- API占成

	assume 		BOOLEAN:=false;			-- 单个API是否盈亏共担

	fee 		FLOAT:=0.00;			-- 费用

	no_bill 	FLOAT:=0.00;			-- 上期未结金额

  maintenance_charges FLOAT:=0.00;	-- 维护费

	ensure_consume FLOAT:=0.00;			-- 保底消费

	reduction_maintenance_fee FLOAT:=0.00; 		-- 减免维护费

	redu_main_fee_limit FLOAT:=0.00;	-- 减免维护费上限（最高=维护费）

	actual_maintenance_charges FLOAT:=0.00;		-- 实际维护费

	return_profit FLOAT:=0.00;			-- 返盈利

	actual_return_profit FLOAT:=0.00;	-- 实际返盈利



	net_map 	hstore;		-- 包网方案map

	occupy_map 	hstore;		-- API占成梯度map

	assume_map 	hstore;		-- 盈亏共担map.

	charge_map 	hstore; 	-- 维护费用map.

	favorable_map hstore;	-- 优惠map

	code 		TEXT:='';	-- 其它项目代码（maintenance_charges：维护费，ensure_consume：保底费，return_profit：反盈利，reduction_maintenance_fee：减免维护费，pending：上期未结，rakeback_offers：返水优惠，offers_recommended：优惠急推荐，back_charges：返手续费，rebate：佣金）

	sys_config 	hstore;		-- 系统变量

	prev_map	hstore;		-- 上期信息（未结金额，经办人）

	operator	TEXT:='';	-- 上期未结算经办人



	sp 			TEXT:='@';

	rs 			TEXT:='\~';

	cs 			TEXT:='\^';

	rs_a 		TEXT:='';

	cs_a 		TEXT:='';

	sp_a 		TEXT:='';

BEGIN

	-- 取得系统变量

	SELECT sys_config() INTO sys_config;

	sp = sys_config->'sp_split';

	rs = sys_config->'row_split';

	cs = sys_config->'col_split';

	sp_a = sys_config->'sp_split_a';

	rs_a = sys_config->'row_split_a';

	cs_a = sys_config->'col_split_a';

	rs_a = '\^&\^';

	cs_a = '\^';



	-- 取得当前站点的包网方案

	sid = sys_map->'site_id';

	SELECT  * FROM dblink(main_url, 'SELECT gamebox_contract('||sid||', '||is_max||')') as a(hash hstore[]) INTO net_maps;



	net_map = net_maps[1];

	occupy_map = net_maps[2];

	assume_map = net_maps[3];

	charge_map = net_maps[4];

	favorable_map = net_maps[5];



	amount = 0.00;

	SELECT put(dict_map, 'op', 'I') into dict_map;

	-- 准备station_bill.

	SELECT gamebox_station_bill(dict_map) INTO bill_id;



	-- 每个API的占成

	SELECT gamebox_operation_occupy_api(url_name, start_time, end_time) INTO cur;

	FETCH cur into rec;

	-- raise info '每个API的占成(rec) = %', rec;



	WHILE FOUND

	LOOP

		api 			= rec.api_id::TEXT;

		game_type 		= rec.game_type;

		profilt_amount 	= rec.profit_amount;

		trade_amount 	= rec.trade_amount;

		assume 			= COALESCE((assume_map->api)::BOOLEAN, FALSE); -- 是否盈亏共担

		key_name 		= api||'_'||game_type;

		val 			= COALESCE((occupy_map->key_name)::TEXT, '');

		IF val != '' THEN

			--v1.01

			SELECT gamebox_operation_occupy_to_array(val, 1) INTO lower_values;	-- 梯度

			SELECT gamebox_operation_occupy_to_array(val, 2) INTO limit_values;	-- 梯度

			SELECT gamebox_operation_occupy_to_array(val, 3) INTO retios;

			--raise info 'lower_values = %', lower_values;

			--raise info 'limit_values = %', limit_values;

			--raise info 'retios = %', retios;

			SELECT gamebox_operation_occupy_calculate(lower_values, limit_values, retios, profilt_amount, assume) INTO occupy;

			--v1.01

			raise info 'api_id = %, game_type = %, 盈亏 = %, 占成 = %', api, game_type, profilt_amount, occupy;



			SELECT put(map, 'api_id', api) into map;			-- API_ID

			SELECT put(map, 'game_type', game_type) into map;	-- API二级分类

			SELECT put(map, 'amount_payable', occupy::TEXT) into map; 		--应付金额

			SELECT put(map, 'occupy_proportion', '0') into map;				--占成比例

			SELECT put(map, 'profit_loss', profilt_amount::TEXT) into map;	--盈亏总和

			SELECT put(map, 'bill_id', bill_id::TEXT) into map;

			-- 新增各API占成金额

			perform gamebox_station_profit_loss(map);



			-- 盈亏不共担时且占成金额为负时，计0

			IF assume = FALSE AND occupy < 0 THEN

				occupy = 0;

			END IF;

			-- 累计占成金额

			amount = amount + COALESCE(occupy, 0.00);

		END IF;

		FETCH cur INTO rec;

	END LOOP;



	CLOSE cur;



	-- 计算其它费用.

	-- raise info '------ 各API盈亏(amount) = %', amount;

	SELECT put(map, 'bill_id', bill_id::TEXT) into map;

	SELECT put(map, 'payable', '0') into map;

	SELECT put(map, 'actual', '0') into map;

	SELECT put(map, 'apportion', '0') into map;



	--------- 上期未结费用.START

	code = 'pending';

	bill_year = (dict_map->'year')::INT;

	bill_month = (dict_map->'month')::INT;

	SELECT gamebox_station_bill_prev(sid, bill_year, bill_month, '1') INTO prev_map;

	no_bill = COALESCE(prev_map->'no_bill_actual', '0.00');  --v1.02  2016/05/25  Leisure

	operator = prev_map->'operator';

	SELECT put(map, 'name', operator) into map;

	SELECT put(map, 'code', code) into map;

	SELECT put(map, 'payable', prev_map->'no_bill_payable'::TEXT) into map;  --v1.02  2016/05/25  Leisure

	SELECT put(map, 'actual', prev_map->'no_bill_actual'::TEXT) into map;  --v1.02  2016/05/25  Leisure

	SELECT put(map, 'fee', '0.00') into map;

	perform gamebox_station_bill_other(map);

	--------- 上期未结费用.END



	SELECT put(map, 'name', '~') into map;



	--------- 保底费用.START

	ensure_consume = COALESCE((net_map->'ensure_consume')::FLOAT, 0.00);

	code = 'ensure_consume';

	SELECT put(map, 'code', code) into map;

	SELECT put(map, 'payable', ensure_consume::TEXT) into map;

	IF amount > ensure_consume THEN -- 盈亏大于保底费，不收保底费

		ensure_consume = 0.00;

	END IF;

	SELECT put(map, 'actual', ensure_consume::TEXT) into map;

	SELECT put(map, 'fee', ensure_consume::TEXT) into map;

	perform gamebox_station_bill_other(map);

	--------- 保底费用.END



	--------- 减免维护费.START

	code = 'reduction_maintenance_fee';

	SELECT gamebox_operation_favorable_calculate(charge_map, amount) INTO cost_map;

	-- 维护费

	maintenance_charges = COALESCE((net_map->'maintenance_charges')::FLOAT, 0.00);

	IF amount > 0 THEN

		reduction_maintenance_fee = COALESCE((cost_map->'value')::FLOAT, 0.00);

	ELSE

		reduction_maintenance_fee = 0.00;

	END IF;



	-- 减免维护费上限 = 全部维护费

	redu_main_fee_limit = reduction_maintenance_fee;

	IF redu_main_fee_limit > maintenance_charges THEN

		redu_main_fee_limit = maintenance_charges;

	END IF;



	SELECT put(map, 'code', code) into map;

	SELECT put(map, 'payable', reduction_maintenance_fee::TEXT) into map;

	SELECT put(map, 'actual', redu_main_fee_limit::TEXT) into map;

	SELECT put(map, 'fee', '0.00') into map;

	SELECT put(map, 'value', reduction_maintenance_fee::TEXT) into map;

	SELECT put(map, 'grads', COALESCE(cost_map->'grads', '0')) into map;

	SELECT put(map, 'way', COALESCE(cost_map->'way', '0')) into map;

	SELECT put(map, 'limit', COALESCE(cost_map->'limit', '0')) into map;



	map = cost_map||map;

	perform gamebox_station_bill_other(map);

	--------- 减免维护费.END



	--------- 维护费.START

	code = 'maintenance_charges';

	actual_maintenance_charges = maintenance_charges - redu_main_fee_limit;

	SELECT put(map, 'payable', maintenance_charges::TEXT) into map;

	SELECT put(map, 'actual', actual_maintenance_charges::TEXT) into map;

	SELECT put(map, 'code', code) into map;

	SELECT put(map, 'fee', maintenance_charges::TEXT) into map;

	SELECT put(map, 'value', '0') into map;

	SELECT put(map, 'grads', '0') into map;

	SELECT put(map, 'way', '0') into map;

	SELECT put(map, 'limit', '0') into map;

	perform gamebox_station_bill_other(map);

	--------- 维护费.END



	--------- 返盈利.START

	code = 'return_profit';

	SELECT gamebox_operation_favorable_calculate(favorable_map, amount) INTO cost_map;

	IF amount > 0 THEN

		return_profit = COALESCE((cost_map->'value')::FLOAT, 0.00);

	ELSE

		return_profit = 0.00;

	END IF;

	actual_return_profit = COALESCE(cost_map->'actual', '0');

	SELECT put(map, 'code', code) into map;

	SELECT put(map, 'payable', return_profit::TEXT) into map;

	SELECT put(map, 'actual', actual_return_profit::TEXT) into map;

	SELECT put(map, 'fee', '0.00') into map;

	SELECT put(map, 'value', return_profit::TEXT) into map;

	SELECT put(map, 'grads', COALESCE(cost_map->'grads', '0')) into map;

	SELECT put(map, 'way', COALESCE(cost_map->'way', '0')) into map;

	SELECT put(map, 'limit', COALESCE(cost_map->'limit', '0')) into map;

	--------- 返盈利.END



	map = map||cost_map;

	perform gamebox_station_bill_other(map);



	IF amount < 0 THEN					-- 各API盈亏为负

		amount = amount + ensure_consume;

	ELSEIF amount < ensure_consume THEN	-- 各API盈亏小于保底消费

		amount = ensure_consume;

	END IF;



	-- 站长付给运营商账务 = 各API盈亏 + 上期未结 + 维护费 - 实付减免维护费 - 实付返盈利

	fee = amount + no_bill +  maintenance_charges - redu_main_fee_limit - actual_return_profit;

	-- raise info '-------- API占成 = %', amount;

	-- raise info '-------- 应付金额 = %', fee;

	--更新账务.

	SELECT put(dict_map, 'bill_id', bill_id::TEXT) INTO dict_map;

	SELECT put(dict_map, 'op', 'U') INTO dict_map;

	SELECT put(dict_map, 'amount', fee::TEXT) into dict_map;

	-- raise info '------ dict_map = %', dict_map;

	SELECT gamebox_station_bill(dict_map) INTO bill_id;



	RETURN '0';

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_station_bill_master(sys_map hstore, dict_map hstore, url_name TEXT, main_url TEXT, start_time TEXT, end_time TEXT)

IS 'Lins-站点账务-API';



DROP FUNCTION if exists gamebox_station_bill_prev(INT, INT, INT, TEXT);

create or replace function gamebox_station_bill_prev(

    site_id 	INT,

    bill_year 	INT,

    bill_month 	INT,

    bill_type 	TEXT

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Fei      创建此函数：站点账务-上期信息

--v1.01  2016/05/25  Leisure	上期未结需要计算应付和实付

*/

DECLARE

	map hstore:='';

	rec record;

BEGIN

	IF bill_month = 1 THEN

		bill_month = 12;

		bill_year = bill_year - 1;

	ELSE

		bill_month = bill_month - 1;

	END IF;



	FOR rec IN EXECUTE

		' SELECT amount_actual, amount_payable operate_user_name

			FROM station_bill

		   WHERE site_id = $1

		     AND bill_year = $2

		     AND bill_month = $3

		     AND bill_type = $4

		     AND amount_actual < 0

		   LIMIT 1' USING site_id, bill_year, bill_month, bill_type

	LOOP

		--v1.01  2016/05/25  Leisure begin

		SELECT put(map, 'no_bill_payable', COALESCE(rec.amount_payable, 0.00)::TEXT) INTO map;

		SELECT put(map, 'no_bill_actual', COALESCE(rec.amount_actual, 0.00)::TEXT) INTO map;

		--v1.01  2016/05/25  Leisure end

 		SELECT put(map, 'operator', COALESCE(rec.operate_user_name, '~')) INTO map;

	END LOOP;

	RETURN map;

END;



$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_station_bill_prev(site_id INT, bill_year INT, bill_month INT, bill_type TEXT)

IS 'Fly-站点账务-上期信息（未结金额，经办人）';



drop function if exists gamebox_operation_favorable_calculate(hstore, FLOAT);

create or replace function gamebox_operation_favorable_calculate(

    favorable_map 	hstore,

    amount 			FLOAT

)returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：运营商优惠计算

--v1.01  2016/05/26  Leisure  修改梯度判断逻辑，梯度下限——上限取该梯度，

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

		--v1.01  2016/05/26  Leisure

		FOR i IN 1..array_length(keys, 1) -- REVERSE

		LOOP

			key_name = keys[i];

			--raise info 'keys[i]: %,  amount: %',keys[i], amount;

			IF (keys[i]::FLOAT) > amount THEN

				exit;

			END IF;

		END LOOP;

		--v1.01  2016/05/26  Leisure

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

--v1.00  2015/01/01  Lins     创建此函数：站点返水-入口

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



drop function if exists gamebox_site_rebate(TEXT, TEXT, TEXT, TEXT);

create or replace function gamebox_site_rebate(

	main_url 	TEXT,

	master_url 	TEXT,

	start_time 	TEXT,

	end_time 	TEXT

) returns TEXT as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：站点返佣-入口

--v1.01  2016/05/26  Leisure  增加sid判空

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

	date_time = end_time::TIMESTAMP;



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



drop function if exists gamebox_site_rebate(TEXT, TEXT, TEXT, TEXT, TEXT);

create or replace function gamebox_site_rebate(

	main_url 	TEXT,

	master_urls TEXT,

	start_times TEXT,

	end_times 	TEXT,

	split 		TEXT

) returns TEXT as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：站点返佣-入口

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



		FOR i IN 1..array_length(dblink_urls, 1) LOOP

			--v1.01  2016/05/26  Leisure

			perform gamebox_site_rebate(main_url, dblink_urls[i], start_time[1], end_time[1]);

		END LOOP;

	ELSE

		raise info '1-参数格式或者数量不一致';

		RETURN '1-参数格式或者数量不一致';

	END IF;



	RETURN '0';

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_site_rebate(main_url TEXT, master_urls TEXT, split TEXT, start_time TEXT, end_time TEXT)

IS 'Lins-站点返佣-入口';