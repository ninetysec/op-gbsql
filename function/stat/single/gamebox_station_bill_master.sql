/**
 * Lins-站点账务-API.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	dict_map 各项值map
**/
 drop function if exists gamebox_station_bill_master(hstore, hstore, TEXT, TEXT, TEXT, TEXT);
 create or replace function gamebox_station_bill_master(
 	sys_map 	hstore,		-- 优惠分摊比例
 	dict_map 	hstore,		-- 运营商，站长，站点，年，月，账务类型
 	url_name 	TEXT,
 	main_url 	TEXT,
 	start_time 	TEXT,
 	end_time 	TEXT
 ) returns TEXT as $$
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
 			SELECT gamebox_operation_occupy_to_array(val, 2) INTO limit_values;	-- 梯度
 			SELECT gamebox_operation_occupy_to_array(val, 3) INTO retios;
 			SELECT gamebox_operation_occupy_calculate(limit_values, retios, profilt_amount, assume) INTO occupy;

 			-- raise info 'api_id = %, game_type = %, 盈亏 = %, 占成 = %', api, game_type, profilt_amount, occupy;

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
 	no_bill = COALESCE(prev_map->'no_bill', '0.00');
 	operator = prev_map->'operator';
 	SELECT put(map, 'name', operator) into map;
 	SELECT put(map, 'code', code) into map;
 	SELECT put(map, 'payable', no_bill::TEXT) into map;
 	SELECT put(map, 'actual', no_bill::TEXT) into map;
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

 	-- 站长付给运营商账务 = 各API盈亏 + 上期未结 + 维护费 - 返盈利 - 减免维护费
 	-- fee = amount + no_bill + maintenance_charges - return_profit - reduction_maintenance_fee;
 	fee = amount + no_bill + actual_maintenance_charges - actual_return_profit - redu_main_fee_limit;
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
