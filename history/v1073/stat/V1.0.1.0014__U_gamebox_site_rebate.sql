-- auto gen by fei 2016-04-12 21:43:30

/**
 * 统计站点返佣.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	main_url 	运营商库.dblink格式URL
 * @param 	master_urls 站点库.dblink格式URL(多库, 以分隔符分开)
 * @param 	start_times 开始时间
 * @param 	end_times 	结束时间
 * @param 	split 		分隔符.
 */
drop function if exists gamebox_site_rebate(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_site_rebate(
	main_url 	TEXT,
	master_urls TEXT,
	start_times TEXT,
	end_times 	TEXT,
	split 		TEXT
) returns TEXT as $$
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
		AND array_length(dblink_urls, 1) = array_length(start_time, 1)
		AND array_length(dblink_urls, 1) = array_length(end_time, 1)
	THEN
		perform dblink_close_all();
		perform gamebox_collect_site_infor(main_url);

		FOR i IN 1..array_length(dblink_urls,  1) LOOP
			perform gamebox_site_rebate(main_url, dblink_urls[i], start_time[i], end_time[i]);
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

/**
 * 收集站点总代.代理.玩家等信息.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	main_url 	运营商库.dblink格式URL
 * @param 	master_url 	站点库.dblink格式URL
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 */
drop function if exists gamebox_site_rebate(TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_site_rebate(
	main_url 	TEXT,
	master_url 	TEXT,
	start_time 	TEXT,
	end_time 	TEXT
) returns TEXT as $$
DECLARE
	rec 		record;
	cnum 		INT;
	expense_map hstore;
	maps 		hstore[];
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
	IF ltrim(rtrim(master_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	perform dblink_close_all();
	perform dblink_connect('master',  master_url);

	SELECT  * FROM dblink(
		'master',
		'SELECT  * FROM gamebox_rebate_map('''||main_url||''', '''||start_time||''', '''||end_time||''', '''||category||''')'
	) as p(h hstore[]) INTO maps;

	IF array_length(maps, 1) < 2 THEN
		RETURN '1.站点库返回信息有误';
	END IF;

	api_map = maps[1];
	expense_map = maps[2];
	sid = (expense_map->'site_id')::INT;
	perform gamebox_collect_site_infor(main_url);
  	SELECT gamebox_site_map(sid) INTO dict_map;
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

/**
 * 站点返佣.GAME_TYPE统计.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	api_map 	API返佣map
 * @param 	dict_map 	站点信息map
 */
drop function if exists gamebox_site_rebate_gametype(hstore, hstore);
create or replace function gamebox_site_rebate_gametype(
	api_map 	hstore,
	dict_map 	hstore
) returns void as $$
DECLARE
	keys 		TEXT[];
	sub_keys 	TEXT[];
	val 		FLOAT;
	col_split 	TEXT:='_';
	sid 		INT;
	center_id 	INT;
	master_id 	INT;
	c_year 		INT;
	c_month 	INT;

BEGIN
	sid = (dict_map->'site_id')::INT;
	center_id = (dict_map->'center_id')::INT;
	master_id = (dict_map->'master_id')::INT;
	c_year = (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;

	DELETE FROM site_rebate_gametype WHERE site_id = sid AND rebate_year = c_year AND rebate_month = c_month;

	keys = akeys(api_map);
	IF api_map is null OR array_length(keys, 1) is null THEN
		RETURN;
	END IF;

	FOR i IN 1..array_length(keys,  1)
	LOOP
		val = (api_map->keys[i])::FLOAT;
		sub_keys = regexp_split_to_array(keys[i], col_split);
		INSERT INTO site_rebate_gametype(
			center_id, master_id, site_id,
			api_id, game_type,
			rebate_year, rebate_month, static_time, rebate_total
		)VALUES(
			center_id, master_id, sid,
			sub_keys[1]::INT, sub_keys[2],
			c_year, c_month, now(), val
		);
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate_gametype(api_map hstore, dict_map hstore)
IS 'Lins-站点返佣.GAME_TYPE';

/**
 * 站点返佣.API.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	dict_map 	站点信息map
 */
drop function if exists gamebox_site_rebate_api(hstore);
create or replace function gamebox_site_rebate_api(
	dict_map hstore
) returns void as $$
DECLARE
	sid 	INT;
	c_id 	INT;
	m_id 	INT;
	c_year 	INT;
	c_month INT;
BEGIN
	sid = (dict_map->'site_id')::INT;
	c_id = (dict_map->'center_id')::INT;
	m_id = (dict_map->'master_id')::INT;
	c_year = (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;

	DELETE FROM site_rebate_api WHERE site_id = sid AND rebate_year = c_year AND rebate_month = c_month;

	INSERT INTO site_rebate_api(
		center_id, master_id, site_id,
		rebate_year, rebate_month, static_time,
		api_id, rebate_total
	) SELECT
		c_id, m_id, sid,
		c_year, c_month, now(),
		api_id, SUM(rebate_total)
		FROM site_rebate_gametype
  	   WHERE site_id = sid
  	   	 AND rebate_year = c_year
  	   	 AND rebate_month = c_month
	   GROUP BY api_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate_api(dict_map hstore)
IS 'Lins-站点返佣.API';

/**
 * 站点返佣
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	站点信息map
 */
drop function if exists gamebox_site_rebate(hstore, hstore);
create or replace function gamebox_site_rebate(
	expense_map hstore,
	dict_map 	hstore
) returns void as $$
DECLARE
	val 		FLOAT;
	sid 		INT;
	c_id 		INT;
	m_id 		INT;
	c_year 		INT;
	c_month 	INT;
	player_num 	INT;
	refund_fee 	FLOAT;
	amount 		FLOAT;
	loss 		FLOAT;
	favorable 	FLOAT;
	recommend 	float:=0.00;					-- 推荐费用
  	artificial_depositfavorable		float:=0.00;-- 手动存入优惠
	backwater 	FLOAT;
	apportion 	FLOAT;

	deposit 		float:=0.00;	-- 存款
	company_deposit float:=0.00;	-- 存款:公司入款
	online_deposit	float:=0.00;	-- 存款:线上支付
	artificial_deposit float:=0.00; -- 存款:手动存款

	withdraw 		float:=0.00;	-- 取款
	artificial_withdraw	float:=0.00;-- 取款:手动取款
	player_withdraw	float:=0.00;	-- 取款:玩家取款
BEGIN
	sid = (dict_map->'site_id')::INT;
	c_id = (dict_map->'center_id')::INT;
	m_id = (dict_map->'master_id')::INT;
	c_year = (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;

	player_num = (expense_map->'player_num')::INT;
	amount = (expense_map->'effective_trade_amount')::FLOAT;
	loss = (expense_map->'profit_amount')::FLOAT;
	refund_fee = (expense_map->'refund_fee')::FLOAT;

	favorable = (expense_map->'favourable')::FLOAT;
	recommend = (expense_map->'recommend')::FLOAT;
	artificial_depositfavorable = (expense_map->'artificial_depositfavorable')::FLOAT;
	favorable = favorable + recommend + artificial_depositfavorable;

	backwater = (expense_map->'backwater')::FLOAT;
	apportion = (expense_map->'apportion')::FLOAT;

	company_deposit = (expense_map->'company_deposit')::FLOAT;
	online_deposit = (expense_map->'online_deposit')::FLOAT;
	artificial_deposit = (expense_map->'artificial_deposit')::FLOAT;
	deposit = company_deposit + online_deposit + artificial_deposit;

	artificial_withdraw = (expense_map->'artificial_withdraw')::FLOAT;
	player_withdraw = (expense_map->'player_withdraw')::FLOAT;
	withdraw = artificial_withdraw + player_withdraw;

	DELETE FROM site_rebate WHERE site_id = sid AND rebate_year = c_year AND rebate_month = c_month;

	SELECT sum(rebate_total) INTO val FROM site_rebate_gametype
	WHERE site_id = sid AND rebate_year = c_year AND rebate_month = c_month;
	INSERT INTO site_rebate(
  		center_id, master_id, site_id,
  		rebate_year, rebate_month, static_time,
  		rebate_total, effective_player, effective_transaction, profit_loss,
  		preferential_value, refund_fee, rakeback, apportion,
  		deposit_amount, withdrawal_amount
	) VALUES (
		c_id, m_id, sid,
		c_year, c_month, now(),
		val, player_num, amount, loss,
		favorable, refund_fee, backwater, apportion,
		deposit, withdraw
	);
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate(expense_map hstore, dict_map hstore)
IS 'Lins-站点返佣';

/*
--测试收集站点玩家数.
SELECT * FROM gamebox_site_rebate (
	'host = 192.168.0.88 dbname = gamebox-mainsite user = postgres password = postgres',
	'host = 192.168.0.88 dbname = gamebox-master user = postgres password = postgres',
	'2015-01-01',
	'2015-12-31',
	'\|'
);

SELECT * FROM gamebox_site_rebate (
	'host = 192.168.0.88 dbname = gamebox-mainsite user = postgres password = postgres',
	'host = 192.168.0.88 dbname = gamebox-master user = postgres password = postgres',
	'2015-01-01',
	'2015-12-31'
);

SELECT extract(month FROM now());
*/
