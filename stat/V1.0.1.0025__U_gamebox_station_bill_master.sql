-- auto gen by bruce 2016-06-05 15:26:03

select redo_sqls($$
    ALTER TABLE  master_operate  ADD COLUMN static_date date;
    ALTER TABLE  site_operate  ADD COLUMN static_date date;
    ALTER TABLE  site_rakeback_api  ADD COLUMN static_date date;
    ALTER TABLE  site_rakeback_gametype  ADD COLUMN static_date date;
    ALTER TABLE  site_rakeback_player  ADD COLUMN static_date date;
    ALTER TABLE  site_rebate  ADD COLUMN static_date date;
    ALTER TABLE  site_rebate_api  ADD COLUMN static_date date;
    ALTER TABLE  site_rebate_gametype  ADD COLUMN static_date date;
    ALTER TABLE  master_operate  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  site_operate  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  site_rakeback_api  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  site_rakeback_gametype  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  site_rakeback_player  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  site_rebate  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  site_rebate_api  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  site_rebate_gametype  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  company_operate  ADD COLUMN static_date date;
$$);
COMMENT ON COLUMN  master_operate. static_date IS '统计日期';
COMMENT ON COLUMN  site_operate. static_date IS '统计日期';
COMMENT ON COLUMN  site_rakeback_api. static_date IS '统计日期';
COMMENT ON COLUMN  site_rakeback_gametype. static_date IS '统计日期';
COMMENT ON COLUMN  site_rakeback_player. static_date IS '统计日期';
COMMENT ON COLUMN  site_rebate. static_date IS '统计日期';
COMMENT ON COLUMN  site_rebate_api. static_date IS '统计日期';
COMMENT ON COLUMN  site_rebate_gametype. static_date IS '统计日期';
COMMENT ON COLUMN  master_operate. static_time IS '统计起始时间';
COMMENT ON COLUMN  site_operate. static_time IS '统计起始时间';
COMMENT ON COLUMN  site_rakeback_api. static_time IS '统计起始时间';
COMMENT ON COLUMN  site_rakeback_gametype. static_time IS '统计起始时间';
COMMENT ON COLUMN  site_rakeback_player. static_time IS '统计起始时间';
COMMENT ON COLUMN  site_rebate. static_time IS '统计起始时间';
COMMENT ON COLUMN  site_rebate_api. static_time IS '统计起始时间';
COMMENT ON COLUMN  site_rebate_gametype. static_time IS '统计起始时间';
COMMENT ON COLUMN  master_operate. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  site_operate. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  site_rakeback_api. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  site_rakeback_gametype. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  site_rakeback_player. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  site_rebate. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  site_rebate_api. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  site_rebate_gametype. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  company_operate. static_date IS '统计日期';

UPDATE  master_operate  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  site_operate  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  site_rakeback_api  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  site_rakeback_gametype  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  site_rakeback_player  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  site_rebate  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  site_rebate_api  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  site_rebate_gametype  SET static_date = static_time::date WHERE static_date IS null;

UPDATE  master_operate SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;
UPDATE  site_operate  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;
UPDATE  site_rakeback_api  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;
UPDATE  site_rakeback_gametype  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;
UPDATE  site_rakeback_player  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;
UPDATE  site_rebate  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;
UPDATE  site_rebate_api  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;
UPDATE  site_rebate_gametype  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;

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


drop function if exists gamebox_station_bill_other(hstore);
create or replace function gamebox_station_bill_other(
    map hstore
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：站点账务.其它费用
--v1.01  2016/05/28  Leisure  新增游戏盈亏总额字段total_profit_loss
*/
DECLARE
	bill_id 	INT;
	payable 	FLOAT;
	code 		TEXT;
	actual 		FLOAT;
	grads 		FLOAT;
	way 		TEXT;
	value 		FLOAT;
	limit_value FLOAT;
	name 		TEXT;
	fee 		FLOAT;
	apportion 	FLOAT;
  total_profit_loss 	FLOAT; --v1.01  2016/05/28  Leisure
BEGIN
	bill_id = (map->'bill_id')::INT;
	payable = (map->'payable')::FLOAT;
	code = (map->'code')::TEXT;
	actual = (map->'actual')::FLOAT;
	grads = (map->'grads')::FLOAT;
	way = (map->'way')::TEXT;
	value = (map->'value')::FLOAT;
	limit_value = (map->'limit')::FLOAT;
	name = (map->'name')::TEXT;
	fee = (map->'fee')::FLOAT;
	apportion = (map->'apportion')::FLOAT;
	total_profit_loss = (map->'occupy_tatol')::FLOAT; --v1.01  2016/05/28  Leisure

	payable = COALESCE(payable, 0);
	code = COALESCE(code, '');
	actual = COALESCE(actual, 0);
	grads = COALESCE(grads, 0);
	way = COALESCE(way, '');
	value = COALESCE(value, 0);
	limit_value = COALESCE(limit_value, 0);
	name = COALESCE(name, '');
	fee = COALESCE(fee, 0);
	apportion = COALESCE(apportion, 0);
	total_profit_loss = COALESCE(total_profit_loss, 0); --v1.01  2016/05/28  Leisure

	raise info '------ 减免维护费（actual）= %', actual;

	IF name = '~' THEN
		name = '';
	END IF;

	--TODO station_bill_other 新增 游戏盈亏总额字段total_profit_loss
	--TODO 该值为站长中心-结算账单-站长账单的游戏盈利小计
	--v1.01  2016/05/28  Leisure
	INSERT INTO station_bill_other(
		station_bill_id, amount_payable, project_code, amount_actual,
		favourable_grads, favourable_way, favourable_value, favourable_limit,
		operate_user_name, fee, apportion_proportion, total_profit_loss
	) VALUES(
		bill_id, payable, code, actual,
		grads, way, value, limit_value,
		name, fee, apportion, total_profit_loss
	);
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_other(map hstore)
IS 'Lins-站点账务.其它费用';


--drop function IF EXISTS gamebox_operations_statement(text, text, text, text, text, text);
drop function IF EXISTS gamebox_operations_statement(text, text, text, text, text, text, text);
create or replace function gamebox_operations_statement(
	mainhost 	text,
	static_date	text,
	masterhost 	text,
	startTime 	text,
	endTime 	text,
	sids 		text,
	splitchar 	text
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：经营报表-单站点报表-入口
--v1.01  2016/05/27  Leisure  增加参数static_date统计日期
*/
DECLARE
	masterhosts varchar[];
	startTimes 	varchar[];
	endTimes 	varchar[];
	siteids 	varchar[];
	rtn 		text:='';

BEGIN
	IF mainhost is null or rtrim(ltrim(mainhost)) = '' THEN
		raise info '运营商库信息没有设置';
		return '运营商库信息没有设置';
	END IF;

	IF masterhost is null or rtrim(ltrim(masterhost)) = '' THEN
		raise info '站点库信息没有设置';
		return '站点库信息没有设置';
	END IF;

	masterhosts:=regexp_split_to_array(masterhost, splitchar);
	startTimes:=regexp_split_to_array(startTime, splitchar);
	endTimes:=regexp_split_to_array(endTime, splitchar);
	siteids:=regexp_split_to_array(sids, splitchar);

	IF array_length(masterhosts, 1) > 0 THEN
		FOR i in 1..array_length(masterhosts, 1)
		LOOP
			raise notice '名称:%', masterhosts[i];
		END LOOP;
		SELECT gamebox_operations_statement(mainhost, static_date, masterhosts, startTimes, endTimes, siteids) into rtn;
	END IF;

	raise info '%', rtn;
return rtn;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, static_date	text, masterhost text, startTime text, endTime text, sids text, splitchar text)
IS 'Lins-经营报表-单站点报表-入口';


--drop function IF EXISTS gamebox_operations_statement(text, text[], text[], text[], text[]);
drop function IF EXISTS gamebox_operations_statement(text, text, text[], text[], text[], text[]);
create or replace function gamebox_operations_statement(
	mainhost 	text,
	static_date	text,
	masterhost 	text[],
	startTimes 	text[],
	endTimes 	text[],
	siteids 	text[]
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：经营报表-多站点入口
--v1.01  2016/05/27  Leisure  增加参数static_date统计日期
--v1.02  2016/05/31  Leisure  站点报表增加参数startTime TEXT, endTime TEXT
*/
DECLARE
	--curday date;
	rtn text:='';
	tmp text:='';

BEGIN
	--设置当前日期.
	--SELECT CURRENT_DATE into curday;
	--curday := static_date::DATE;
	IF mainhost is null or rtrim(ltrim(mainhost)) = '' THEN
		raise info '运营商库信息没有设置';
		return '运营商库信息没有设置';
	END IF;

	IF masterhost is null or array_length(masterhost,  1) < 0 THEN
		raise info '站点库信息没有设置';
		return '站点库信息没有设置';
	END IF;

	--关闭所有链接.
	perform dblink_close_all();
	--收集当前所有运营站点相关信息.
	perform gamebox_collect_site_infor(mainhost);

	--拆分所有站点数据库信息.
	rtn = rtn||'1.开始执行各个站点玩家经营报表';

	FOR i in 1..array_length(masterhost,  1)
	LOOP
		raise notice '%.当前站点库信息：%', i, masterhost[i];
		IF rtrim(ltrim(masterhost[i])) = '' THEN
			return '站点库信息不能为空';
		END IF;

		--连接站点库
		perform dblink_connect('master', masterhost[i]);
		--执行玩家经营报表
		raise info '%.开始收集站点%的玩家下单信息', i, masterhost[i];
		rtn = rtn||'|||1.'||i||'.开始收集.站点.'||i||'.玩家报表.';
		SELECT gamebox_master_operation_statement('master', siteids[i]::int, static_date, startTimes[i], endTimes[i], mainhost) into tmp;
		rtn = rtn||'||'||tmp;
		raise info '%.收集完毕', i;
		--收集站点经营报表
		rtn = rtn||'4.  开始执行站点经营报表';
		--SELECT gamebox_operation_site('master', curday) into tmp; --v1.02  2016/05/31  Leisure
		SELECT gamebox_operation_site('master', static_date, startTimes[i], endTimes[i]) into tmp;
		rtn = rtn||'||'||tmp;
		perform dblink_disconnect('master');
	END LOOP;

	rtn = rtn||'5.  开始执行站长经营报表';
	SELECT gamebox_operation_master(static_date) into tmp;
	rtn = rtn||'||'||tmp;
	rtn = rtn||'6.  开始执行运营商经营报表';
	SELECT gamebox_operation_company(static_date) into tmp;
	rtn = rtn||'||'||tmp;

return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, static_date	text, masterhost text[], startTimes text[], endTimes text[], siteids text[])
IS 'Lins-经营报表-多站点入口';


--drop function IF EXISTS gamebox_master_operation_statement(text, int, text, text, date, text);
drop function IF EXISTS gamebox_master_operation_statement(text, int, text, text, text, text);
CREATE OR REPLACE FUNCTION gamebox_master_operation_statement(
	conn 		TEXT,
	siteid 		INT,
	curday 		TEXT,
	startTime 	TEXT,
	endTime 		TEXT,
	url 		TEXT
) RETURNS TEXT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：经营报表-玩家.代理.总代报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
*/
DECLARE
	rtn TEXT:='';
BEGIN
	SELECT
		INTO rtn P .msg
	FROM
		dblink (conn,
			--v1.01  2016/05/31  Leisure
			'SELECT * from gamebox_operations_statement('''||url||''', '||siteid||', '''||curday::TEXT||''', '''||startTime||''', '''||endTime||''')'
		) AS P (msg TEXT);
	RETURN rtn ;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_master_operation_statement(conn TEXT, siteid INT, curday TEXT, startTime TEXT, endTime TEXT, url TEXT)
IS 'Lins-经营报表-玩家.代理.总代报表';


--drop function IF EXISTS gamebox_operation_site(text, date);
drop function IF EXISTS gamebox_operation_site(TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_operation_site(
	conn 	TEXT,
	curday 	TEXT,
	start_time 	TEXT,
	end_time 		TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：经营报表-站点报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取，
                              站点报表增加参数startTime TEXT, endTime TEXT
*/
DECLARE
	rtn 	text:='';
	v_count	int:=0;
	d_static_date DATE; --v1.01  2016/05/31
BEGIN
	--v1.01  2016/05/31  Leisure
	d_static_date := to_date(curday, 'YYYY-MM-DD');
	--清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';

	--delete from site_operate where to_char(static_time, 'YYYY-MM-DD') = to_char(curday, 'YYYY-MM-DD');
	DELETE FROM site_operate WHERE static_date = d_static_date;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %',  v_count;
	rtn = rtn||'||执行完毕, 删除记录数: '||v_count||' 条||';

	--开始执行站点经营报表信息收集
	rtn = rtn||'|开始执行'||curday||'站点经营报表||';
	INSERT INTO site_operate(
		site_id, site_name, center_id, center_name, master_id, master_name, player_num,
		api_id, api_type_id, game_type,
		--static_time, create_time, --v1.01  2016/05/31  Leisure
		static_date, static_time, static_time_end, create_time,
		transaction_order, transaction_volume, effective_transaction, profit_loss
	) SELECT
			s.siteid, s.sitename, s.operationid, s.operationname, s.masterid, s.mastername, a.players_num,
			a.api_id, a.api_type_id, a.game_type,
			--current_date, now(), --v1.01  2016/05/31  Leisure
			d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
			a.transaction_order, a.transaction_volume, a.effective_transaction_volume, a.transaction_profit_loss
		FROM
			dblink (conn,
							'SELECT * from gamebox_operations_site('''||curday||''')
							AS Q(siteid int, api_id int, game_type varchar, api_type_id int, players_num bigint,
									transaction_order NUMERIC, transaction_volume NUMERIC,
									effective_transaction_volume NUMERIC, transaction_profit_loss NUMERIC
									)'
							)
		AS a(
				siteid int,
				api_id int,
				game_type varchar,
				api_type_id int,
				players_num bigint ,
				transaction_order NUMERIC ,
				transaction_volume NUMERIC,
				effective_transaction_volume NUMERIC,
				transaction_profit_loss NUMERIC
				) left join sys_site_info s on a.siteid = s.siteid;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
		rtn = rtn||'|执行完毕, 新增记录数: '||v_count||' 条||';
	return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_site(	conn TEXT, curday TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-经营报表-站点报表';


drop function IF EXISTS gamebox_operation_master(TEXT);
create or replace function gamebox_operation_master(
	curday TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fly      创建此函数：经营报表-站长报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取；
                              经营报表增加字段static_date统计日期
*/
DECLARE
	rtn 	text:='';
	v_count	int:=0;
	d_static_date DATE; --v1.01  2016/05/31
BEGIN
	--v1.01  2016/05/31  Leisure
	d_static_date := to_date(curday, 'YYYY-MM-DD');

	--清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	--delete from master_operate where to_char(static_time, 'YYYY-MM-dd') = curday;
	DELETE FROM master_operate WHERE static_date = d_static_date;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
	rtn = rtn||'||执行完毕, 删除记录数: '||v_count||'条||';
	--开始执行总代经营报表信息收集
	rtn = rtn||'|开始执行'||curday||'站长经营报表||';

	INSERT INTO master_operate(
		center_id, center_name, master_id, master_name, api_id, api_type_id, game_type, player_num,
		transaction_order, transaction_volume, effective_transaction, profit_loss,
		--static_time, create_time, --v1.01  2016/05/31  Leisure
		static_date, static_time, static_time_end, create_time
		)
	SELECT center_id, center_name, master_id, master_name, api_id, api_type_id, game_type, player_num,
			transaction_order, transaction_volume, effective_transaction, profit_loss,
			--current_date, now() --v1.01  2016/05/31  Leisure
			d_static_date, static_time, static_time_end, now()
	FROM (
		SELECT center_id, center_name, master_id, master_name, api_id, api_type_id, game_type,
					 SUM(player_num) player_num, SUM(transaction_order) transaction_order, SUM(transaction_volume) transaction_volume,
					 SUM(effective_transaction) effective_transaction, SUM(profit_loss) profit_loss,
					 --v1.01  2016/05/31  Leisure 增加筛选条件
					 MIN(static_time) static_time, MAX(static_time_end) static_time_end
			FROM site_operate
		 WHERE static_date = d_static_date --v1.01  2016/05/31  Leisure 增加筛选条件
	   GROUP BY center_id, center_name, master_id, master_name, api_id, api_type_id, game_type
	) so;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %',  v_count;
	rtn = rtn||'|执行完毕, 新增记录数: '||v_count||' 条||';

	return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_master(curday TEXT)
IS 'Fly - 经营报表-站长报表';


drop function IF EXISTS gamebox_operation_company(TEXT);
create or replace function gamebox_operation_company(
	curday TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fly      创建此函数：经营报表-运营商报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
                              经营报表增加字段static_date统计日期
*/
DECLARE
	rtn 	text:='';
	v_count	int:=0;
	d_static_date DATE; --v1.01  2016/05/31
BEGIN
	--v1.01  2016/05/31  Leisure
	d_static_date := to_date(curday, 'YYYY-MM-DD');

	--清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';

	--delete from company_operate where to_char(create_time, 'YYYY-MM-dd') = curday;
	DELETE FROM company_operate WHERE static_date = d_static_date;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %',  v_count;
	rtn = rtn||'| |执行完毕, 删除记录数: '||v_count||' 条||';
	--开始执行总代经营报表信息收集
	rtn = rtn||'|开始执行'||curday||'运营商经营报表||';

	INSERT INTO company_operate(
		operator_id, operator_name, api_id, api_type_id, game_type, transaction_order, transaction_volume,
		effective_transaction_volume, transaction_profit_loss,
		--static_year, static_month, create_time --v1.01  2016/05/31  Leisure
		static_year, static_month, static_date, create_time
		)
	SELECT center_id, center_name, api_id, api_type_id, game_type, transaction_order, transaction_volume,
		effective_transaction, profit_loss,
		--v1.01  2016/05/31  Leisure
		--(SELECT EXTRACT(year from now())::int4), (SELECT EXTRACT(month from now())::int4), now()
		EXTRACT(year from d_static_date)::int4, EXTRACT(month from d_static_date)::int4, d_static_date, now()
		FROM (
					SELECT center_id, center_name, api_id, api_type_id::int4, game_type,
								SUM(transaction_order) transaction_order, SUM(transaction_volume) transaction_volume,
								SUM(effective_transaction) effective_transaction, SUM(profit_loss) profit_loss
						FROM master_operate
					 WHERE static_date = d_static_date --v1.01  2016/05/31  Leisure 增加筛选条件
					GROUP BY center_id, center_name, api_id, api_type_id, game_type
					) o;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %',  v_count;
	rtn = rtn||'||执行完毕, 新增记录数: '||v_count||'条||';

	return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_company(curday TEXT)
IS 'Fly - 经营报表-运营商报表';


drop function if exists gamebox_site_rakeback(TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_site_rakeback(
	main_url 	TEXT,
	master_url 	TEXT,
	start_time 	TEXT,
	end_time 	TEXT
) returns TEXT as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：站点返水-入口
--v1.01  2016/06/01  Leisure  修改gamebox_rakeback_map参数
*/
DECLARE
	rec 		record;
	cnum 		INT;
	maps 		hstore[];
	rake_map 	hstore;
	act_map		hstore;		-- 实际返水
	category 	TEXT:='API';
	keys 		TEXT[];
	sub_keys 	TEXT[];
	sub_key 	TEXT:='';
	col_split 	TEXT:='_';
	num_map 	hstore;
	api_map 	hstore;
	dict_map 	hstore;
	param 		TEXT:='';
	sid 		INT;--站点ID.
	val 		FLOAT;
	date_time 	TIMESTAMP;
	c_year 		INT;
	c_month 	INT;
	player_num 	INT;

BEGIN
	IF ltrim(rtrim(master_url))='' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	perform dblink_close_all();
	perform dblink_connect('master', master_url);
	SELECT site_id FROM dblink('master', 'SELECT * FROM gamebox_current_site()') as s(site_id INT) INTO sid;
	SELECT gamebox_site_map(sid) INTO dict_map;

	date_time = end_time::TIMESTAMP;
	SELECT extract(year FROM date_time) INTO c_year;
	SELECT extract(month FROM date_time) INTO c_month;
	dict_map = (SELECT ('year=>'||c_year)::hstore)||dict_map;
	dict_map = (SELECT ('month=>'||c_month)::hstore)||dict_map;

	SELECT  * FROM dblink(
		'master',
		--'SELECT * FROM gamebox_rakeback_map('''||start_time||'''::TIMESTAMP, '''||end_time||'''::TIMESTAMP, '''||main_url||''', '''||category||''')'
		'SELECT * FROM gamebox_rakeback_map('''||start_time||'''::TIMESTAMP, '''||end_time||'''::TIMESTAMP, '''||category||''')'
	) as p(h hstore[]) INTO maps;

	rake_map = maps[1];
	act_map = maps[2];

	IF rake_map is not null THEN
		keys = akeys(rake_map);

		FOR i IN 1..array_length(keys, 1) LOOP
			IF char_length(keys[i]) > 1 THEN
				sub_keys = regexp_split_to_array(keys[i], col_split);
				--统计玩家数.
				IF num_map is null THEN
					SELECT sub_keys[1]||'=>1' INTO num_map;
					player_num = 0;
				ELSEIF exist(num_map, sub_keys[1]) = FALSE THEN
					num_map = (SELECT (sub_keys[1]||'=>1')::hstore)||num_map;
					player_num = player_num + 1;
				END IF;
				--统计API.GAME_TYPE
				sub_key = sub_keys[2]||col_split||sub_keys[3];
				IF api_map is null THEN
					--param=sub_key||'='||rake_map->keys[i];
					SELECT sub_key||'=>'||(rake_map->keys[i]) INTO api_map;
				ELSEIF exist(api_map, sub_key) THEN
					val = (rake_map->keys[i])::FLOAT;
					val = val + ((api_map->sub_key)::FLOAT);
					api_map = api_map||(SELECT (sub_key||'=>'||val)::hstore);
				ELSE
					api_map = (SELECT (sub_key||'=>'||(rake_map->keys[i]))::hstore)||api_map;
				END IF;
			END IF;
		END LOOP;

		raise info '站点返水.GAME_TYPE';
		perform gamebox_site_rakeback_gametype(api_map, dict_map);

		raise info '站点返水.API';
		perform gamebox_site_rakeback_api(dict_map);

		raise info '站点返水.玩家';
		dict_map = (SELECT ('player_num=>'||player_num)::hstore)||dict_map;

		perform gamebox_site_rakeback_player(act_map, dict_map);

	END IF;
	perform dblink_disconnect('master');
	RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rakeback(main_url TEXT, master_url TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-站点返水-入口';