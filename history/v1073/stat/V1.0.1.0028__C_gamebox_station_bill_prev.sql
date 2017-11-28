-- auto gen by admin 2016-06-14 14:58:53
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

--v1.02  2016/06/08  Leisure	修正一处bug，字段缺少逗号

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



	--V1.02  2016/06/08  Leisure

	FOR rec IN EXECUTE

		' SELECT amount_actual, amount_payable, operate_user_name

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



drop function if exists gamebox_site_rebate(hstore, hstore);

create or replace function gamebox_site_rebate(

	expense_map hstore,

	dict_map 	hstore

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：站点返佣

--v1.01  2016/06/09  Leisure  增加上期未结费用计算

*/

DECLARE

	center_id 	INT;

	master_id 	INT;

	siteId 		INT;

	rbt_year 	INT;

	rbt_month 	INT;



	player_num 	INT:=0;

	apportion 	FLOAT:=0.00;

	rakeback 	FLOAT:=0.00;

	recommend	FLOAT:=0.00;

	refund_fee 	FLOAT:=0.00;

	profit_loss FLOAT:=0.00;

	deposit 	FLOAT:=0.00;	-- 存款

	effe_trans 	FLOAT:=0.00;

	favorable 	FLOAT:=0.00;	-- 优惠

	withdraw 	FLOAT:=0.00;	-- 取款

	rebate_tot 	FLOAT:=0.00;

	rebate_act 	FLOAT:=0.00;

	expense_leaving		FLOAT := 0.00; --v1.01  2016/06/09  Leisure



BEGIN

	center_id 	= (dict_map->'center_id')::INT;

	master_id 	= (dict_map->'master_id')::INT;

	siteId 	= (dict_map->'site_id')::INT;

	rbt_year = (dict_map->'year')::INT;

	rbt_month = (dict_map->'month')::INT;



	player_num 	= (expense_map->'player_num')::INT;

	apportion	= (expense_map->'apportion')::FLOAT;

	rakeback	= (expense_map->'rakeback')::FLOAT;

	recommend	= (expense_map->'recommend')::FLOAT;

	refund_fee	= (expense_map->'refund_fee')::FLOAT;

	profit_loss = (expense_map->'profit_loss')::FLOAT;

	deposit 	= (expense_map->'deposit')::FLOAT;

	effe_trans 	= (expense_map->'effe_trans')::FLOAT;

	favorable 	= (expense_map->'favorable')::FLOAT;

	withdraw 	= (expense_map->'withdraw')::FLOAT;

	rebate_tot 	= (expense_map->'rebate_tot')::FLOAT;

	rebate_act 	= (expense_map->'rebate_act')::FLOAT;

	--v1.01  2016/06/09  Leisure

	expense_leaving 	= (expense_map->'expense_leaving')::FLOAT;



	DELETE FROM site_rebate re WHERE re.site_id = siteId AND re.rebate_year = rbt_year AND re.rebate_month = rbt_month;



	INSERT INTO site_rebate(

  		center_id, master_id, site_id,

  		effective_player, effective_transaction, profit_loss, deposit_amount,

  		withdrawal_amount, preferential_value, refund_fee, rebate_total, rebate_actual,

  		rebate_year, rebate_month, static_time, rakeback, apportion, history_apportion --v1.01  2016/06/09  Leisure

	) VALUES (

		center_id, master_id, siteId,

  		player_num, effe_trans, profit_loss, deposit,

  		withdraw, favorable + recommend, refund_fee, rebate_tot, rebate_act,

  		rbt_year, rbt_month, now(), rakeback, apportion, expense_leaving --v1.01  2016/06/09  Leisure

	);

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_site_rebate(expense_map hstore, dict_map hstore)

IS 'Lins-站点返佣';



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

--v1.03  2016/05/28  Leisure	bill_other增加api占成总金额

--v1.04  2016/06/09  Leisure  如果未设置返还盈利、减免维护费，则不生成station_profit_loss记录

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

	occupy_tatol  FLOAT:=0.00;  -- API占成总金额 --v1.03  2016/05/28  Leisure

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

			--amount = amount + COALESCE(occupy, 0.00);

			occupy_tatol = occupy_tatol + COALESCE(occupy, 0.00); --v1.03  2016/05/28  Leisure

		END IF;

		FETCH cur INTO rec;

	END LOOP;



	CLOSE cur;



	amount := amount + occupy_tatol; --v1.03  2016/05/28  Leisure



	-- 计算其它费用.

	-- raise info '------ 各API盈亏(amount) = %', amount;

	SELECT put(map, 'bill_id', bill_id::TEXT) into map;

	SELECT put(map, 'occupy_tatol', occupy_tatol::TEXT) into map; --v1.03  2016/05/28  Leisure

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

	IF charge_map is not null THEN --v1.04  2016/06/09

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

	END IF;

	--------- 维护费.END



	--------- 返盈利.START

	IF charge_map is not null THEN --v1.04  2016/06/09

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

	END IF;



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

--v1.02  2016/06/08  Leisure	修正一处bug，字段缺少逗号

--v1.03  2016/06/10  Leisure  修改查询条件，上期未结以应付金额判断

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



	--V1.02  2016/06/08  Leisure

	FOR rec IN EXECUTE

		' SELECT amount_actual, amount_payable, operate_user_name

			FROM station_bill

		   WHERE site_id = $1

		     AND bill_year = $2

		     AND bill_month = $3

		     AND bill_type = $4

		     --AND amount_actual < 0

		     AND amount_payable < 0

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

--v1.02  2016/06/13  Leisure  梯度map的key改为下限值；

                              合并判空逻辑

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

	/*

	IF favorable_map is null OR amount <= 0 THEN

		SELECT put(map, 'grads', '0') INTO map;

		SELECT put(map, 'limit', '0') INTO map;

		SELECT put(map, 'value', '0') INTO map;

		SELECT put(map, 'way', '0') INTO map;

	ELSE

	*/

	IF favorable_map IS NOT null AND amount > 0 THEN

		keys = akeys(favorable_map);

		--v1.01  2016/05/26  Leisure

		FOR i IN REVERSE array_length(keys, 1)..1

		--FOR i IN 1..array_length(keys, 1)

		LOOP

			--raise info 'keys[i]: %,  amount: %',keys[i], amount;

			IF amount > (keys[i]::FLOAT) THEN

				key_name = keys[i];

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

			--favourable_grads = COALESCE(keys[2], '0'); --v1.02  2016/06/13  Leisure

			favourable_grads = COALESCE(key_name, '0');	-- 梯度值

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

		SELECT put(map, 'actual', '0') INTO map;

	END IF;



	RETURN map;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operation_favorable_calculate(favorable_map hstore, amount FLOAT)

IS 'Lins-运营商优惠计算';



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

--v1.03  2016/05/28  Leisure	bill_other增加api占成总金额

--v1.04  2016/06/09  Leisure  如果未设置返还盈利、减免维护费，则不生成station_profit_loss记录

--v1.05  2016/06/13  Leisure  修改维护费，减免维护费计算逻辑

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

	occupy_tatol  FLOAT:=0.00;  -- API占成总金额 --v1.03  2016/05/28  Leisure

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

			--amount = amount + COALESCE(occupy, 0.00);

			occupy_tatol = occupy_tatol + COALESCE(occupy, 0.00); --v1.03  2016/05/28  Leisure

		END IF;

		FETCH cur INTO rec;

	END LOOP;



	CLOSE cur;



	amount := amount + occupy_tatol; --v1.03  2016/05/28  Leisure



	-- 计算其它费用.

	-- raise info '------ 各API盈亏(amount) = %', amount;

	SELECT put(map, 'bill_id', bill_id::TEXT) into map;

	SELECT put(map, 'occupy_tatol', occupy_tatol::TEXT) into map; --v1.03  2016/05/28  Leisure

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



	-- 维护费（包网方案）--v1.05  2016/06/13  Leisure

	maintenance_charges = COALESCE((net_map->'maintenance_charges')::FLOAT, 0.00);

	--------- 减免维护费.START

	IF charge_map is not null THEN --v1.04  2016/06/09

		code = 'reduction_maintenance_fee';

		SELECT gamebox_operation_favorable_calculate(charge_map, amount) INTO cost_map;



		IF amount > 0 THEN

			reduction_maintenance_fee = COALESCE((cost_map->'value')::FLOAT, 0.00);

		ELSE

			reduction_maintenance_fee = 0.00;

		END IF;



		--v1.05  2016/06/13  Leisure

		/*

		--减免维护费上限 = 全部维护费

		--redu_main_fee_limit = reduction_maintenance_fee;

		*/

		--减免维护费上限 = 实际维护费 和 维护费用 中的小值

		redu_main_fee_limit = COALESCE(cost_map->'actual', '0')::FLOAT;

		--减免维护费，不能超过维护费

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

	END IF;

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

	IF charge_map is not null THEN --v1.04  2016/06/09

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

	END IF;



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