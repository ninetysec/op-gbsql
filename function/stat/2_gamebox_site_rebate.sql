/**
 * 统计站点返佣.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	main_url 	运营商库.dblink格式URL
 * @param 	master_urls 站点库.dblink格式URL(多库, 以分隔符分开)
 * @param 	start_times 开始时间
 * @param 	end_times 	结束时间
 * @param 	split 		分隔符.
**/
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
--v1.00  2015/01/01  Lins     创建此函数: 站点返佣-入口
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

/**
 * 收集站点总代.代理.玩家等信息.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	main_url 	运营商库.dblink格式URL
 * @param 	master_url 	站点库.dblink格式URL
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
**/
drop function if exists gamebox_site_rebate(TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_site_rebate(
	main_url 	TEXT,
	master_url 	TEXT,
	start_time 	TEXT,
	end_time 	TEXT
) returns TEXT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点返佣-入口
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

/**
 * 站点返佣.GAME_TYPE统计.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	api_map 	API返佣map
 * @param 	dict_map 	站点信息map
**/
drop function if exists gamebox_site_rebate_gametype(hstore, hstore);
create or replace function gamebox_site_rebate_gametype(
	api_map 	hstore,
	dict_map 	hstore
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点返佣.GAME_TYPE
--v1.01  2016/06/17  Leisure  返佣统计改为每期（原来为每月）执行一次，去除DELETE逻辑
--v1.02  2016/07/05  Leisure  撤销--v1.01的修改
*/
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

	--v1.01  2016/06/17  Leisure
	--v1.02  2016/07/05  Leisure
	DELETE FROM site_rebate_gametype WHERE site_id = sid AND rebate_year = c_year AND rebate_month = c_month;

	keys = akeys(api_map);
	IF api_map is null OR array_length(keys, 1) is null THEN
		RETURN;
	END IF;

	FOR i IN 1..array_length(keys, 1)
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
**/
drop function if exists gamebox_site_rebate_api(hstore);
create or replace function gamebox_site_rebate_api(
	dict_map hstore
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点返佣.GAME_TYPE
--v1.01  2016/06/17  Leisure  返佣统计改为每期（原来为每月）执行一次，去除DELETE逻辑
--v1.02  2016/07/05  Leisure  撤销--v1.01的修改
*/
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

	--v1.01  2016/06/17  Leisure
	--v1.02  2016/07/05  Leisure
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
**/
drop function if exists gamebox_site_rebate(hstore, hstore);
create or replace function gamebox_site_rebate(
	expense_map hstore,
	dict_map 	hstore
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点返佣
--v1.01  2016/06/09  Leisure  增加上期未结费用计算
--v1.02  2016/06/18  Leisure  返佣统计改为每期（原来为每月）执行一次，去除DELETE逻辑
--v1.03  2016/07/05  Leisure  撤销--v1.02的修改
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

	--v1.02  2016/06/18  Leisure
	--v1.03  2016/07/05  Leisure
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

/*
--测试收集站点玩家数.
SELECT * FROM gamebox_site_rebate (
	'host = 192.168.0.88 dbname = gb-companies user = gb-companies password = postgres',
	'host = 192.168.0.88 dbname = gb-sites user = gb-site- password = postgres',
	'2015-01-01',
	'2015-12-31',
	'\|'
);

SELECT * FROM gamebox_site_rebate (
	'host = 192.168.0.88 dbname = gb-companies user = gb-companies password = postgres',
	'host = 192.168.0.88 dbname = gb-sites user = gb-site- password = postgres',
	'2015-01-01',
	'2015-12-31'
);

SELECT extract(month FROM now());
*/
