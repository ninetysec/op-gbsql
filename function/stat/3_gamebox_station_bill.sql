/**
 * 账务(站长、总代).
 * @author	Lins
 * @date 	2015-12-14
 * @param 	main_url 	运营商库.dblink格式URL
 * @param 	master_urls 站点库.dblink格式URL(多库, 以分隔符分开)
 * @param 	start_times 开始时间
 * @param 	end_times 	结束时间
 * @param 	split 		分隔符.
 * @param 	flag 		账务类别. 1:站长, 2:总代
**/
drop function if exists gamebox_station_bill(TEXT, TEXT, TEXT, TEXT, TEXT, INT);
create or replace function gamebox_station_bill(
    main_url    TEXT,
    master_urls TEXT,
    start_times TEXT,
    end_times 	TEXT,
    split 		TEXT,
    flag 		INT
) returns TEXT as $$
DECLARE
    dblink_urls TEXT[];
    start_time 	TEXT[];
    end_time 	TEXT[];

BEGIN
    IF ltrim(rtrim(main_url)) = '' THEN
        raise info '运营商URL为空';
        RETURN '运营商URL为空';
    ELSEIF ltrim(rtrim(master_urls)) = '' THEN
        raise info '站点库URL为空';
        RETURN '站点库URL为空';
    ELSEIF ltrim(rtrim(split)) = '' THEN
        raise info '分隔符为空';
        RETURN '分隔符为空';
    END IF;

    dblink_urls:=regexp_split_to_array(master_urls, split);
    start_time:=regexp_split_to_array(start_times, split);
    end_time:=regexp_split_to_array(end_times, split);

    IF array_length(dblink_urls, 1) > 0
        AND array_length(dblink_urls, 1) = array_length(start_time, 1)
        AND array_length(dblink_urls, 1) = array_length(end_time, 1)
    THEN
        perform dblink_close_all();
        perform gamebox_collect_site_infor(main_url);
        FOR i IN 1..array_length(dblink_urls, 1)
        LOOP
            perform gamebox_station_bill(main_url, dblink_urls[i], start_time[i], end_time[i], flag);
        END LOOP;
    ELSE
        raise info '参数格式或者数量不一致';
        RETURN '参数格式或者数量不一致';
    END IF;

    RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill(main_url TEXT, master_urls TEXT, split TEXT, start_time TEXT, end_time TEXT, flag INT)
IS 'Lins-账务(站长、总代)-入口';

/**
 * 账务(站长、总代).
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	main_url 	运营商库.dblink格式URL
 * @param 	master_url 	站点库.dblink格式URL
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	flag 		账务类别.1:站点, 2:总代
**/
drop function if exists gamebox_station_bill(TEXT, TEXT, TEXT, TEXT, INT);
create or replace function gamebox_station_bill(
	main_url 	TEXT,
	master_url 	TEXT,
	start_time 	TEXT,
	end_time 	TEXT,
	flag 	INT
) returns TEXT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 账务(站长、总代)-入口
--v1.01  2016/06/04  Leisure  取dict_map之前，先同步site_info表,
                              如果账务日期不为1号，则取1号日期
*/
DECLARE
	rec 		record;
	cnum 		INT;

	category 	TEXT:='API';
	keys 		TEXT[];
	sub_keys 	TEXT[];
	sub_key 	TEXT:='';
	col_split 	TEXT:='_';
	num_map 	hstore;

	maps 		hstore[];
	sys_map 	hstore;		-- 优惠分摊比例
	api_map 	hstore;
	expense_map hstore;
	dict_map 	hstore;		-- 运营商，站长，账务类型等信息
	param 		TEXT:='';
	sid 		INT;		-- 站点ID.
	val 		FLOAT;
	date_time 	TIMESTAMP;
	c_year 		INT;
	c_month 	INT;

	player_num 	INT;
	bill_id 	INT;
	rtn 		TEXT;
	bill_no 	TEXT;		-- 账务流水号
BEGIN
	IF ltrim(rtrim(master_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	perform dblink_close_all();
	perform dblink_connect('master',  master_url);

	SELECT  * FROM dblink(
		'master', 'SELECT  * FROM gamebox_sys_param(''apportionSetting'')'
	) as p(h hstore) INTO sys_map;

	raise info 'sys_map: %', sys_map;

	sid = (sys_map->'site_id')::INT;

	--v1.01  2016/06/04  Leisure
	perform gamebox_collect_site_infor(main_url);
	SELECT gamebox_site_map(sid) INTO dict_map;

	--v1.01  2016/06/04  Leisure
	date_time = start_time::TIMESTAMP;
	IF extract(day FROM date_time) <> '1' THEN
		date_time = date_time + '1 day';
	END IF;

	SELECT extract(year FROM date_time) INTO c_year;
	SELECT extract(month FROM date_time) INTO c_month;

	dict_map = (SELECT ('year=>'||c_year)::hstore)||dict_map;
	dict_map = (SELECT ('month=>'||c_month)::hstore)||dict_map;

	SELECT put(dict_map, 'bill_type', flag::TEXT) into dict_map; 	-- 账务类型

	raise info 'dict_map: %', dict_map;

	-- raise info '运营商，站长，账务类型等信息(dict_map) = %', dict_map;

	SELECT put(sys_map, 'backwater_percent', sys_map->'topagent.rakeback.percent') 		into sys_map;
	SELECT put(sys_map, 'refund_fee_percent', sys_map->'topagent.poundage.percent') 	into sys_map;
	SELECT put(sys_map, 'favourable_percent', sys_map->'topagent.preferential.percent') 	into sys_map;
	SELECT put(sys_map, 'rebate_percent', sys_map->'topagent.rebate.percent') 			into sys_map;

	-- raise info '优惠分摊比例(sys_map) = %', sys_map;

	-- 删除重复运行记录.
	DELETE FROM station_bill_other WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT);
	DELETE FROM station_profit_loss WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT);
	DELETE FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT;

	IF flag = 1 THEN 		-- 计算站长账务
		-- 站长账单流水号
		SELECT gamebox_generate_order_no('B', sid::TEXT, '03', 'master') INTO bill_no;
		SELECT put(dict_map, 'bill_no', bill_no) into dict_map;
		SELECT gamebox_station_bill_master(sys_map, dict_map, 'master', main_url, start_time, end_time) INTO rtn;
	ELSEIF flag = 2 THEN	-- 计算总代账务
		-- 总代账单流水号
		SELECT gamebox_generate_order_no('B', sid::TEXT, '04', 'master') INTO bill_no;
		SELECT put(dict_map, 'bill_no', bill_no) into dict_map;
		SELECT gamebox_station_bill_top(sys_map, dict_map, 'master', main_url, start_time, end_time) INTO rtn;
	END IF;

	--关闭连接
	perform dblink_disconnect('master');

	RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill(main_url TEXT, master_url TEXT, start_time TEXT, end_time TEXT, flag INT)
IS 'Lins-账务(站长、总代)-入口';

/**
 * Lins-站点账务.其它费用.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	map 	其它费用map
**/
drop function if exists gamebox_station_bill_other(hstore);
create or replace function gamebox_station_bill_other(
    map hstore
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点账务.其它费用
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

	raise info '------station_bill_other（actual）= %', actual;

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

/**
 * Lins-总代账务.其它费用.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	map 	其它费用map
**/
drop function if exists gamebox_station_bill_other(hstore, hstore, INT);
create or replace function gamebox_station_bill_other(
    cost_map 	hstore,
    sys_map 	hstore,
    bill_id 	INT
) returns FLOAT as $$
DECLARE
	map 		hstore;
	expense_category 	TEXT[]:=array['backwater', 'refund_fee', 'favourable', 'rebate'];
	category 	TEXT:='';
	expense_code 		TEXT[]:=array['rakeback_offers', 'back_charges', 'offers_recommended', 'rebate'];
	code 		TEXT:='';
	value 		FLOAT;
	amount 		FLOAT:=0.00;--费用总和.
BEGIN
	FOR j IN 1..array_length(expense_category, 1) LOOP
		category = expense_category[j];
		code = expense_code[j];
		value = (cost_map->category)::FLOAT;
		IF value is null THEN
			CONTINUE;
		END IF;

		map = null;
		amount = amount + COALESCE((cost_map->(category||'_apportion'))::FLOAT, 0.00);

		SELECT put(map, 'bill_id', bill_id::TEXT) into map;
		SELECT put(map, 'payable', cost_map->(category||'_apportion')) into map;
		SELECT put(map, 'actual', cost_map->(category||'_apportion')) into map;
		SELECT put(map, 'apportion', sys_map->(category||'_percent')) into map;
		SELECT put(map, 'code', code) into map;

		perform gamebox_station_bill_other(map);

	END LOOP;
	RETURN amount;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_other(cost_map hstore, sys_map hstore, bill_id INT)
IS 'Lins-站点账务.其它费用';

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

	-- raise info '------ url_name = %', url_name;
	-- raise info '------ main_url = %', main_url;

	SELECT  * FROM dblink(
		url_name,
		'SELECT  * FROM gamebox_occupy_map('''||main_url||''', '''||start_time||''', '''||end_time||''')'
	) as p(h hstore[]) INTO maps;

	IF array_length(maps,  1) < 2 THEN
		RETURN '1.站点库返回总代信息有误';
	END IF;

	api_map = maps[1];
	-- raise info '------ api_map = %', api_map;
	expense_map = maps[2];
	raise info '------ expense_map = %', expense_map;

	-- 格式：id=>name@api^game^val^retio^loss^&^api^game^val^retio^loss
	keys = akeys(api_map);
	-- raise info '------ keys = %', keys;
	-- raise info '------------------------- OFF LINE 1 -------------------------';
	IF array_length(keys, 1) > 0 THEN
		FOR i IN 1..array_length(keys, 1) LOOP

			val = api_map->keys[i];
			-- raise info '------ val = %', val;
			vals = regexp_split_to_array(val, sp);
			-- raise info '------ vals 1 = %', vals;

			IF array_length(vals, 1) = 2 THEN

				name = vals[1];
				-- raise info '------ name = %', name;
				SELECT put(dict_map, 'topagent_id', keys[i]) into dict_map;
				SELECT put(dict_map, 'topagent_name', name) into dict_map;
				SELECT put(dict_map, 'op', 'I') into dict_map;

				--准备station_bill.
				amount = 0.00;

				-- raise info '------ dict_map 1 = %', dict_map;
				SELECT gamebox_station_bill(dict_map) INTO bill_id;

				--API盈亏
				--vals[2].值格式:api^game^val^retio^loss
				vals = regexp_split_to_array(vals[2], rs_a);
				-- raise info '------ vals 2 = %', vals;

				IF array_length(vals, 1) > 0 THEN
					FOR k IN 1..array_length(vals, 1) LOOP

						--vals[k].值格式:api^game^val^retio^loss
						sval = regexp_split_to_array(vals[k], cs_a);
						-- raise info '------ sval = %', sval;
						IF array_length(sval, 1) >= 4 THEN
							map = null;
							SELECT put(map, 'api_id', sval[1]) into map;			--API
							SELECT put(map, 'game_type', sval[2]) into map;			--API二级分类
							SELECT put(map, 'amount_payable', sval[3]) into map;	--应付金额
							SELECT put(map, 'occupy_proportion', sval[4]) into map;	--占成比例
							SELECT put(map, 'profit_loss', sval[5]) into map;		--盈亏总和
							SELECT put(map, 'bill_id', bill_id::TEXT) into map;
							amount = amount + COALESCE(sval[3]::FLOAT, 0.00);

							-- raise info '------ map = %', map;
							perform gamebox_station_profit_loss(map);
						END IF;

					END LOOP;
				END IF;

				-- raise info '------ amount = %', amount;

				-- 其它费用.
				expense = 0.00;
				-- raise info '------ keys[i] = %', keys[i];
				IF exist(expense_map, keys[i]) THEN
					h_keys = array_append(h_keys, keys[i]);
					val = expense_map->keys[i];
					val = replace(val, rs, ',');
					val = replace(val, cs, '=>');
					SELECT val INTO cost_map;

					-- raise info '------ cost_map = %', cost_map;

					SELECT gamebox_station_bill_other(cost_map, sys_map, bill_id) INTO expense;
				END IF;

				-- raise info '------ expense = %', expense;

				-- 更新账务.
				amount = amount-expense;

				SELECT put(dict_map, 'bill_id', bill_id::TEXT) into dict_map;
				SELECT put(dict_map, 'op', 'U') into dict_map;
				SELECT put(dict_map, 'amount', amount::TEXT) into dict_map;

				-- raise info '------ dict_map 2 = %', dict_map;

				SELECT gamebox_station_bill(dict_map) INTO bill_id;

			END IF;
		END LOOP;
	END IF;

	-- raise info '------------------------- OFF LINE 2 -------------------------';
	-- 处理特殊其它费用
	keys = akeys(expense_map);
	-- raise info '------ 其它 keys = %', keys;

	IF array_length(keys, 1) > 0 THEN
		FOR i IN 1..array_length(keys, 1)
		LOOP
			IF h_keys @> array[keys[i]] = false THEN--判断是否已经记账

				val = expense_map->keys[i];
				val = replace(val, rs, ',');
				val = replace(val, cs, '=>');
				SELECT val INTO cost_map;

				-- 准备station_bill.
				name = cost_map->'user_name';

				-- raise info '------ 其它 name = %', name;

				SELECT put(dict_map, 'topagent_id', keys[i]) INTO dict_map;
				SELECT put(dict_map, 'topagent_name', name) INTO dict_map;
				SELECT put(dict_map, 'op', 'I') INTO dict_map;

				SELECT gamebox_station_bill(dict_map) INTO bill_id;

				-- 其它费用
				-- raise info '------ 其它 cost_map = %', cost_map;
				SELECT gamebox_station_bill_other(cost_map, sys_map, bill_id) INTO expense;

				-- raise info '------ 其它 expense = %', expense;

				-- 更新账务.
				SELECT put(dict_map, 'bill_id', bill_id::TEXT) INTO dict_map;
				SELECT put(dict_map, 'op', 'U') INTO dict_map;
				SELECT put(dict_map, 'amount', (-expense)::TEXT) into dict_map;

				-- raise info '------ 其它 dict_map = %', dict_map;

				SELECT gamebox_station_bill(dict_map) INTO bill_id;

			END IF;
		END LOOP;
	END IF;

	RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_top(sys_map hstore, dict_map hstore, url_name TEXT, main_url TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-站点账务-API';

/**
 * Lins-站点账务-API.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	map 各项值map
**/
drop function if exists gamebox_station_profit_loss(hstore);
create or replace function gamebox_station_profit_loss(
    map hstore
) returns void as $$
DECLARE
	api_id 		INT;
	game_type 	TEXT;
	profit_loss FLOAT;
	occupy_proportion FLOAT;
	amount_payable FLOAT;
	bill_id 	INT;
	api_type_id INT;
BEGIN
	api_id = (map->'api_id')::INT;
	game_type = (map->'game_type')::TEXT;
	profit_loss = (map->'profit_loss')::FLOAT;
	occupy_proportion = (map->'occupy_proportion')::FLOAT;
	amount_payable = (map->'amount_payable')::FLOAT;
	bill_id = (map->'bill_id')::INT;
	api_type_id = CASE game_type WHEN 'LiveDealer' THEN 1 WHEN 'Casino' THEN 2 WHEN 'Sportsbook' THEN 3 WHEN'Lottery' THEN 4 END;

	INSERT INTO station_profit_loss(
		station_bill_id, api_id, profit_loss,
		amount_payable, game_type, occupy_proportion, api_type_id
	) VALUES (
		bill_id, api_id, profit_loss,
		amount_payable, game_type, occupy_proportion, api_type_id
	);
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_profit_loss(
  map hstore
) IS 'Lins-站点账务-API';

/**
 * 返佣插入与更新数据.
 * @author 	Lins
 * @date 	2015.12.2
**/
DROP FUNCTION IF EXISTS gamebox_station_bill(hstore);
create or replace function gamebox_station_bill(
  	dict_map hstore
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 总代占成-当前周期的返佣
--v1.01  2016/05/16  Leisure  bill_id改为returning获取，防止并发
*/
DECLARE
	rec 		record;
	bill_id 	INT;
	s_id 		INT;
	s_name 		TEXT;
	c_id 		INT;
	c_name 		TEXT;
	m_id 		INT;
	m_name 		TEXT;
	c_year 		INT;
	c_month 	INT;
	bill_type 	TEXT;
	bill_no 	TEXT;
	topagent_id INT:=0;
	topagent_name TEXT:='';
	amount 		FLOAT:=0.00;--应付金额
	op 			TEXT;
BEGIN
	s_id = (dict_map->'site_id')::INT;
	c_id = (dict_map->'center_id')::INT;
	m_id = (dict_map->'master_id')::INT;
	s_name = COALESCE((dict_map->'site_name')::TEXT, '');
	c_name = COALESCE((dict_map->'center_name')::TEXT, '');
	m_name = COALESCE((dict_map->'master_name')::TEXT, '');
	c_year = (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;
	bill_no = (dict_map->'bill_no')::TEXT;
	bill_type = (dict_map->'bill_type')::TEXT;

	IF bill_type = '2' THEN
		topagent_id = (dict_map->'topagent_id')::INT;
		topagent_name = COALESCE((dict_map->'topagent_name')::TEXT, '');
	END IF;

	op = (dict_map->'op')::TEXT;
	IF op = 'I' THEN
		INSERT INTO station_bill (
		 	center_id, master_id, site_id,
		 	bill_num, amount_payable, bill_year, bill_month,
		 	amount_actual, create_time, topagent_id, topagent_name,
		 	bill_type, site_name, master_name, center_name
		) VALUES (
			c_id, m_id, s_id,
			bill_no, 0, c_year, c_month,
			0, now(), topagent_id, topagent_name,
			bill_type, s_name, m_name, c_name
		) RETURNING "id" into bill_id;
		--v1.01 bill_id改为returning获取，防止并发
		--SELECT currval(pg_get_serial_sequence('station_bill',  'id')) into bill_id;
		raise info 'station_bill.完成.键值:%', bill_id;
	ELSEIF op = 'U' THEN
		bill_id = (dict_map->'bill_id')::INT;
		amount = (dict_map->'amount')::FLOAT;
		UPDATE station_bill SET amount_payable = amount, amount_actual = amount WHERE id = bill_id;
	END IF;

	RETURN bill_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill(dict_map hstore)
IS 'Lins-站点账务-账务汇总';

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
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点账务-API
--v1.01  2016/05/20  Leisure  改用新的运营商占成函数
--v1.02  2016/05/25  Leisure	上期未结需要计算应付和实付
--v1.03  2016/05/28  Leisure	bill_other增加api占成总金额
--v1.04  2016/06/09  Leisure  如果未设置返还盈利、减免维护费，则不生成station_profit_loss记录
--v1.05  2016/10/29  Leisure  包网方案修改，对于BBIN和视讯类游戏，允许API互抵
--v1.06  2016/11/01  Leisure  未设置减免维护费，依然需要计算维护费
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

	occupy 		FLOAT:=0.00;			-- API占成（除视讯）
	occupy_tatol  FLOAT:=0.00;  -- API占成总金额 --v1.03  2016/05/28  Leisure
	occupy_live  FLOAT:=0.00;  -- 视讯类API占成

	assume 		BOOLEAN:=false;			-- 单个API是否盈亏共担
	fee 		FLOAT:=0.00;			-- 费用
	no_bill 	FLOAT:=0.00;			-- 上期未结金额
  maintenance_charges FLOAT:=0.00;	-- 维护费
	ensure_consume FLOAT:=0.00;			-- 保底消费
	reduction_maintenance_fee FLOAT:=0.00; 		-- 减免维护费
	redu_main_fee_actual FLOAT:=0.00;	-- 减免维护费（最高=维护费）
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
	--assume_map = net_maps[3]; --v1.05  2016/10/29  Leisure
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
		--v1.05  2016/10/29  Leisure
		--assume 			= COALESCE((assume_map->api)::BOOLEAN, FALSE); -- 是否盈亏共担
		assume 			= FALSE; --目前没有盈亏共担一说
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

			--BBIN和视讯类特殊处理 --v1.05  2016/10/29  Leisure
			IF rec.api_id = 10 OR game_type = 'LiveDealer' THEN
				occupy_live = occupy_live + COALESCE(occupy, 0.00);
			ELSE
				-- 盈亏不共担时且占成金额为负时，计0
				IF assume = FALSE AND occupy < 0.00 THEN
					occupy = 0.00;
				END IF;

				-- 累计占成金额
				--amount = amount + COALESCE(occupy, 0.00);
				occupy_tatol = occupy_tatol + COALESCE(occupy, 0.00); --v1.03  2016/05/28  Leisure
				--RAISE INFO 'occupy_tatol: %', occupy_tatol;

			END IF;

			SELECT put(map, 'api_id', api) into map;			-- API_ID
			SELECT put(map, 'game_type', game_type) into map;	-- API二级分类
			SELECT put(map, 'amount_payable', occupy::TEXT) into map; 		--应付金额
			SELECT put(map, 'occupy_proportion', '0') into map;				--占成比例
			SELECT put(map, 'profit_loss', profilt_amount::TEXT) into map;	--盈亏总和
			SELECT put(map, 'bill_id', bill_id::TEXT) into map;
			-- 新增各API占成金额
			perform gamebox_station_profit_loss(map);

		END IF;
		FETCH cur INTO rec;
	END LOOP;

	CLOSE cur;

	--v1.05  2016/10/29  Leisure
	IF occupy_live < 0 THEN
		occupy_live = 0.00;
	END IF;

	--amount := amount + occupy_tatol; --v1.03  2016/05/28  Leisure
	amount := amount + occupy_live + occupy_tatol; --v1.05  2016/10/29  Leisure

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

	-- 维护费 --v1.05  2016/10/29  Leisure
	maintenance_charges = COALESCE((net_map->'maintenance_charges')::FLOAT, 0.00);
	--RAISE INFO '维护费：%', maintenance_charges;
	--------- 减免维护费.START
	IF charge_map is not null THEN --v1.04  2016/06/09
		code = 'reduction_maintenance_fee';
		SELECT gamebox_operation_favorable_calculate(charge_map, amount) INTO cost_map;

		IF amount > 0 THEN
			reduction_maintenance_fee = COALESCE((cost_map->'value')::FLOAT, 0.00);
		ELSE
			reduction_maintenance_fee = 0.00;
		END IF;

		-- 减免维护费上限 = 全部维护费
		redu_main_fee_actual = reduction_maintenance_fee;
		IF redu_main_fee_actual > maintenance_charges THEN
			redu_main_fee_actual = maintenance_charges;
		END IF;

		SELECT put(map, 'code', code) into map;
		SELECT put(map, 'payable', reduction_maintenance_fee::TEXT) into map;
		SELECT put(map, 'actual', redu_main_fee_actual::TEXT) into map;
		SELECT put(map, 'fee', '0.00') into map;
		SELECT put(map, 'value', reduction_maintenance_fee::TEXT) into map;
		SELECT put(map, 'grads', COALESCE(cost_map->'grads', '0')) into map;
		SELECT put(map, 'way', COALESCE(cost_map->'way', '0')) into map;
		SELECT put(map, 'limit', COALESCE(cost_map->'limit', '0')) into map;

		map = cost_map||map;
		perform gamebox_station_bill_other(map);
		--------- 减免维护费.END
	END IF; --v1.05  2016/10/29  Leisure
		--------- 维护费.START
		code = 'maintenance_charges';
		actual_maintenance_charges = maintenance_charges - redu_main_fee_actual;
		SELECT put(map, 'payable', maintenance_charges::TEXT) into map;
		SELECT put(map, 'actual', actual_maintenance_charges::TEXT) into map;
		SELECT put(map, 'code', code) into map;
		SELECT put(map, 'fee', maintenance_charges::TEXT) into map;
		SELECT put(map, 'value', '0') into map;
		SELECT put(map, 'grads', '0') into map;
		SELECT put(map, 'way', '0') into map;
		SELECT put(map, 'limit', '0') into map;
		perform gamebox_station_bill_other(map);
  --END IF; --v1.05  2016/10/29  Leisure
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
	fee = amount + no_bill +  maintenance_charges - redu_main_fee_actual - actual_return_profit;
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

/**
 * Leisure-运营商占成计算.
 * @author 	Lins
 * @date 	2016-05-20
 * @param 	p_lower_values 	梯度下限数组.
 * @param 	p_limit_values 	梯度上限数组.
 * @param 	p_retios 			  梯度占成比例数组.
 * @param 	p_amount 			  盈亏额.
 * @param 	p_assume 			  是否盈亏共担.
**/
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
--v1.00  2016/05/20  Leisure  创建此函数: 运营商占成计算
--v1.01  2016/05/23  Leisure  修正一处bug，盈亏为负，共担为负
--v1.02  2016/05/25  Leisure  盈亏为正，最大上限取上限数组最大值
--v1.02  2016/10/29  Leisure  由于视讯类可以互抵，盈亏为负的情况，放在外层逻辑处理
*/
DECLARE

	f_occupy FLOAT := 0;
	f_occupy_tmp FLOAT := 0;
	f_lower_val FLOAT := 0; --落在当前梯度的金额:=
	f_limit_val	FLOAT := 0; --f_limit_val - f_lower_val
	n_length	INT := 0;

BEGIN

	n_length := array_length(p_retios, 1);

	--raise info 'API盈亏 = %', p_amount;

	IF array_length(p_lower_values, 1) <> array_length(p_retios, 1) OR
		array_length(p_limit_values, 1) <> array_length(p_retios, 1) THEN
		raise info '占成梯度设置有误，请检查！';
		RETURN 0.00;
	END IF;

	IF p_amount < 0 THEN
		/*--v1.02  2016/10/29  Leisure
		IF p_assume = false THEN
			raise info '盈亏不共担, 盈亏为负时, 占成计0';
			RETURN 0.00;	-- 盈亏不共担, 计税金额为负时, 占成计0.
		END IF;
		*/
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

/**
 * Lins-运营商占成计算.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	limit_values 	梯度限值.
 * @param 	retios 			占成值.
 * @param 	amount 			盈亏额
 * @param 	assume 			盈亏共担
)*/
drop function if exists gamebox_operation_occupy_calculate(FLOAT[], FLOAT[], FLOAT, BOOLEAN);
create or replace function gamebox_operation_occupy_calculate(
	limit_values 	FLOAT[],
	retios 			FLOAT[],
	amount 			FLOAT,
	assume 			BOOLEAN
) returns FLOAT as $$
DECLARE
	val 		FLOAT;
	pre_value 	FLOAT:=0.00;
	occupy 		FLOAT:=0.00;
	cal_amount 	FLOAT:=0.00;
	o_val 		FLOAT;
	c_val 		FLOAT;	-- 当前上限值.
	retio 		FLOAT;	-- 当前占成比例.
	re_occupy	FLOAT:=0.00;
BEGIN
	val = amount;
	IF assume AND val < 0 THEN
		amount = -amount;
	ELSEIF assume = false AND val < 0 THEN
		raise info '盈亏不共担, 盈亏为负时, 占成计0';
		RETURN 0.00;	-- 盈亏不共担, 计税金额为负时, 占成计0.
	END IF;

	raise info '各API盈亏 = %', amount;
	IF array_length(limit_values, 1) = array_length(retios, 1) THEN
		FOR i IN 1..array_length(limit_values, 1) LOOP
			IF amount < 0 THEN
			 	exit;
			END IF;

			c_val = limit_values[i];
			-- raise info '------ val = %, c_val1 = %', val, c_val;
			-- 盈亏共担 且 计税金额为负 且 当前梯度为负
			IF assume AND val < 0 AND c_val < 0 THEN
				c_val = -c_val;
			END IF;

			-- raise info '------ c_val2 = %', c_val;
			retio = retios[i];
			cal_amount = c_val - pre_value;
			amount = amount - cal_amount;
			-- raise info '------ retio = %, cal_amount = %, amount = %, pre_value = %', retio, cal_amount, amount, pre_value;

			/*
			IF amount < 0 THEN
				o_val = (amount + cal_amount) * retio / 100;
				occupy = occupy + o_val;
				exit;
			ELSE
				o_val = cal_amount * retio / 100;
				occupy = occupy + o_val;
				pre_value = c_val;
			END IF;
			*/
			IF amount > 0 THEN
				o_val = cal_amount * retio / 100;
				occupy = occupy + o_val;
				pre_value = c_val;
			END IF;
		END LOOP;
	END IF;

	-- raise info '------ occupy1 = %', occupy;

	-- raise info '各API盈亏remind = %', amount;
	IF amount > 0 THEN
		SELECT gamebox_occupy_calculate(limit_values, retios, amount, assume) into re_occupy;
	END IF;
	occupy = occupy + re_occupy;

	-- raise info '------ val = %, occupy1 = %', val, occupy;
	IF val < 0 THEN
		occupy = -occupy;
	END IF;
	-- raise info '------ occupy2 = %', occupy;

	-- raise info '各API盈亏 = %, 占成 = %', val, occupy;
	RETURN occupy;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_calculate(limit_values FLOAT[], retios FLOAT[], amount FLOAT, assume BOOLEAN)
IS 'Lins-运营商占成计算';

/**
 * Lins-运营商占成计算.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	limit_values 	梯度限值.
 * @param 	retios 			占成值.
 * @param 	amount 			盈亏额
 * @param 	assume 			盈亏共担
**/
drop function if exists gamebox_occupy_calculate(FLOAT[], FLOAT[], FLOAT, BOOLEAN);
create or replace function gamebox_occupy_calculate(
    limit_values 	FLOAT[],
    retios 			FLOAT[],
    amount 			FLOAT,
    assume 			BOOLEAN
) returns FLOAT as $$
DECLARE
	val 		FLOAT;
	pre_value 	FLOAT:=0.00;
	occupy 		FLOAT:=0.00;
	cal_amount 	FLOAT:=0.00;
	o_val 		FLOAT;
	c_val 		FLOAT;	-- 当前上限值.
	retio 		FLOAT;	-- 当前占成比例.
BEGIN
	val = amount;
	IF assume AND val < 0 THEN
		amount = -amount;
	ELSEIF assume = false AND val < 0 THEN
		raise info '盈亏不共担, 盈亏为负时, 占成计0';
		RETURN 0.00;	-- 盈亏不共担, 计税金额为负时, 占成计0.
	END IF;

	raise info '各API盈亏 = %', amount;
	IF array_length(limit_values,  1) = array_length(retios,  1) THEN
		FOR i IN 1..array_length(limit_values,  1) LOOP
			IF amount < 0 THEN
			 	exit;
			END IF;

			c_val = limit_values[i];
			 -- raise info '------ val = %, c_val1 = %', val, c_val;
			-- 盈亏共担 且 计税金额为负 且 当前梯度为负
			IF assume AND val < 0 AND c_val < 0 THEN
				c_val = -c_val;
			END IF;

			 -- raise info '------ c_val2 = %, amount = %', c_val, amount;
			retio = retios[i];
			cal_amount = c_val - pre_value;
			IF amount < cal_amount THEN
				cal_amount = amount;
				retio = retios[1];
			END IF;
			IF amount > 0 THEN
				amount = amount - cal_amount;
				o_val  = cal_amount * retio / 100;
				occupy = occupy + o_val;
				 -- raise info '------ 2 o_val = %, occupy = %', o_val, occupy;
				pre_value = c_val;
			END IF;
		END LOOP;
	END IF;

	 -- raise info '------ val = %, occupy1 = %, amount = %', val, occupy, amount;
	IF val < 0 THEN
		occupy = -occupy;
	END IF;
	-- raise info '------ occupy2 = %', occupy;

	-- raise info '各API盈亏 = %, 占成 = %', val, occupy;
	RETURN occupy;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_calculate(limit_values FLOAT[], retios FLOAT[], amount FLOAT, assume BOOLEAN)
IS 'Lins-运营商占成计算';

/**
 * Lins-包网方案-梯度转数组.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	梯度信息.
**/
drop function if exists gamebox_operation_occupy_to_array(TEXT, INT);
create or replace function gamebox_operation_occupy_to_array(
    val 		TEXT,
    subscript 	INT
) returns FLOAT[] as $$
DECLARE
	vals 	TEXT[];
	subs 	TEXT[];
	cs 		TEXT = '_';
	rs 		TEXT = '\^&\^';
	limit_values FLOAT[];
BEGIN
	-- "1_01"=>"0_1000000_50^&^1000000_2000000_40^&^2000000_3000000_30"
	-- API 1,GameType 01在0到1000000比例为50...
	IF val is not null THEN
		vals = regexp_split_to_array(val, rs);
		-- raise info 'vals = %', vals;

		IF vals is not null AND array_length(vals,  1) > 0 THEN

			FOR i IN 1..array_length(vals,  1) LOOP
				subs = regexp_split_to_array(vals[i], cs);

				IF subs is not null AND array_length(subs,  1) = 3 THEN
					IF limit_values is null THEN
						limit_values = array[subs[subscript]::FLOAT];
					ELSE
						limit_values = array_append(limit_values, subs[subscript]::FLOAT);
					END IF;
				END IF;

			END LOOP;

		END IF;
	END IF;
	RETURN limit_values;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_to_array(val TEXT, subscript INT)
IS 'Lins-包网方案-梯度转数组';

/**
 * Lins-站点账务-API游标.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	url 	站点库Dblink.
 * @param 	start_time 	周期开始时间(yyyy-mm-dd HH24:mm:ss)
 * @param 	end_time 	周期结束时间(yyyy-mm-dd HH24:mm:ss)
**/
DROP FUNCTION IF EXISTS gamebox_operation_occupy_api(TEXT, TEXT, TEXT);
create or replace function gamebox_operation_occupy_api(
    url 		TEXT,
    start_time 	TEXT,
    end_time 	TEXT
) returns refcursor as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点账务-API游标
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/10/05  Leisure  交易时间由bet_time改为payout_time；
                              增加限制条件
--v1.03  2017/02/07  Leisure  取消is_profit_loss = TRUE
*/
DECLARE
	cur refcursor;
BEGIN
    OPEN cur FOR
    	SELECT * FROM dblink(
    		url,
    		'SELECT o.api_id,
    		        o.game_type,
    		        COALESCE(sum(-o.profit_amount), 0.00) 			as profit_amount,
    		        COALESCE(sum(o.effective_trade_amount), 0.00)  	as trade_amount
			     FROM player_game_order o
			    --WHERE o.bet_time >='''||start_time||'''
				  --  AND o.bet_time < '''||end_time||'''
				  --v1.02  2016/10/05  Leisure
			    WHERE o.order_state = ''settle''
            --v1.03  2017/02/07  Leisure
			      --AND o.is_profit_loss = TRUE
			      AND o.payout_time >='''||start_time||'''
				    AND o.payout_time < '''||end_time||'''
			    GROUP BY o.api_id, o.game_type '
		) as p(api_id INT, game_type VARCHAR, profit_amount NUMERIC, trade_amount NUMERIC);
	return cur;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_api(conn_name TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-站点账务-API游标';

/**
 * 上期信息（未结金额，经办人）
 * @author 	Lins
 * @date 	2015.12.22
 * @param 	site_id 	站点ID
 * @param 	bill_year	账务年份
 * @param 	bill_month 	账务月份
 * @param 	bill_type	账务类型
**/
DROP FUNCTION if exists gamebox_station_bill_prev(INT, INT, INT, TEXT);
create or replace function gamebox_station_bill_prev(
    site_id 	INT,
    bill_year 	INT,
    bill_month 	INT,
    bill_type 	TEXT
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fei      创建此函数: 站点账务-上期信息
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

/*
 * Lins-运营商优惠计算.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	favorable_map 	优惠梯度.
 * @param 	amount 			占成额
**/
drop function if exists gamebox_operation_favorable_calculate(hstore, FLOAT);
create or replace function gamebox_operation_favorable_calculate(
    favorable_map 	hstore,
    amount 			FLOAT
)returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 运营商优惠计算
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

/*
SELECT gamebox_generate_order_no('B', '1', '04', 'host = 192.168.0.88 dbname = gamebox-master user = postgres password = postgres');
SELECT gamebox_operation_occupy_calculate(array[-100, -300, -700, -1000], array[1.3, 2.1, 2.8, 3.3], -839, TRUE);
SELECT gamebox_operation_occupy_calculate(array[-100, -300, -700, -1000], array[3.3, 2.8, 2.1, 1.3], -839, FALSE);
SELECT gamebox_operation_occupy_calculate(array[100, 300, 700, 1000], array[3.3, 2.8, 2.1, 1.3], 839, TRUE);
SELECT gamebox_operation_occupy_to_array('0_100_2^&^100_200_1^&^200_300_1^&^300_400_1^&^400_500_2');
--测试收集站点玩家数.
--站长账务
SELECT  * FROM gamebox_station_bill (
	'host = 192.168.0.88 dbname = gamebox-mainsite user = postgres password = postgres',
	'host = 192.168.0.88 dbname = gamebox-master user = postgres password = postgres',
	'2016-01-01',
	'2016-01-31',
	'\|',
	1
);

--总代账务
SELECT  * FROM gamebox_station_bill (
	'host = 192.168.0.88 dbname = gamebox-mainsite user = postgres password = postgres',
	'host = 192.168.0.88 dbname = gamebox-master user = postgres password = postgres',
	'2016-01-01',
	'2016-01-31',
	2
);
*/
