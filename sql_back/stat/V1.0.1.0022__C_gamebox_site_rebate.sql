-- auto gen by Lins 2015-12-15 05:44:05
/*
* 统计站点返佣.
* @author:Lins
* @date:2015-12-14
* 参数1.运营商库.dblink格式URL
* 参数2.站点库.dblink格式URL(多库,以分隔符分开)
* 参数3.开始时间
* 参数4.结束时间
* 参数5.分隔符.
*/
drop function if exists gamebox_site_rebate(TEXT,TEXT,TEXT,TEXT,TEXT);
create or replace function gamebox_site_rebate(
main_url TEXT
,master_urls TEXT
,start_times TEXT
,end_times TEXT
,split TEXT
)
returns TEXT as $$
DECLARE
	dblink_urls TEXT[];
	start_time TEXT[];
	end_time TEXT[];
BEGIN
	--start_time='2015-01-01';
	--end_time='2015-12-30';
	IF ltrim(rtrim(main_url))='' THEN
		raise info '1-运营商URL为空';
		RETURN '1-运营商URL为空';
	ELSEIF ltrim(rtrim(master_urls))='' THEN
		raise info '1-站点库URL为空';
		RETURN '1-站点库URL为空';
	ELSEIF ltrim(rtrim(split))='' THEN
		raise info '1-分隔符为空';
		RETURN '1-分隔符为空';
  END IF;
	dblink_urls:=regexp_split_to_array(master_urls,split);
	start_time:=regexp_split_to_array(start_times,split);
	end_time:=regexp_split_to_array(end_times,split);
	IF array_length(dblink_urls, 1)>0
		AND array_length(dblink_urls, 1)=array_length(start_time, 1)
		AND array_length(dblink_urls, 1)=array_length(end_time, 1)
	THEN
		perform dblink_close_all();
		perform gamebox_collect_site_infor(main_url);
		FOR i IN 1..array_length(dblink_urls, 1) LOOP
			perform gamebox_site_rebate(main_url,dblink_urls[i],start_time[i],end_time[i]);
		END LOOP;
	ELSE
		raise info '1-参数格式或者数量不一致';
		RETURN '1-参数格式或者数量不一致';
	END IF;
	RETURN '0';
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate(
main_url TEXT
,master_urls TEXT
,split TEXT
,start_time TEXT
,end_time TEXT
) IS 'Lins-站点返佣-入口';



/*
* 收集站点总代.代理.玩家等信息.
* @author:Lins
* @date:2015-12-14
* 参数1.运营商库.dblink格式URL
* 参数2.站点库.dblink格式URL
* 参数3.开始时间
* 参数4.结束时间
*/
drop function if exists gamebox_site_rebate(TEXT,TEXT,TEXT,TEXT);
create or replace function gamebox_site_rebate(
main_url TEXT
,master_url TEXT
,start_time TEXT
,end_time TEXT
)
returns TEXT as $$
DECLARE
	rec record;
	cnum INT;
	expense_map hstore;
	maps hstore[];
	category TEXT:='API';
	keys TEXT[];
	sub_keys TEXT[];
	sub_key TEXT:='';
	col_split TEXT:='_';
	num_map hstore;
	api_map hstore;
	dict_map hstore;
	param TEXT:='';
	sid INT;--站点ID.
	val FLOAT;
	date_time TIMESTAMP;
	c_year INT;
	c_month INT;
	player_num INT;
BEGIN
	IF ltrim(rtrim(master_url))='' THEN
		RAISE EXCEPTION '-1,站点库URL为空';
	END IF;
	perform dblink_close_all();
	perform dblink_connect('master', master_url);

	select * from dblink('master'
	,'select * from gamebox_rebate_map(
	'''||main_url||''','''||start_time||''','''||end_time||'''
	,'''||category||''')') as p(h hstore[]) INTO maps;

	IF array_length(maps, 1)<2 THEN
		RETURN '1.站点库返回信息有误';
	END IF;

	api_map=maps[1];
	expense_map=maps[2];

	--raise info '%',api_map;
	--raise info '%',expense_map;
	sid=(expense_map->'site_id')::INT;
  SELECT gamebox_site_map(sid) INTO dict_map;
	date_time=end_time::TIMESTAMP;
	select extract(year from date_time) INTO c_year;
	select extract(month from date_time) INTO c_month;
	dict_map=(SELECT ('year=>'||c_year)::hstore)||dict_map;
	dict_map=(SELECT ('month=>'||c_month)::hstore)||dict_map;

	raise info '站点返佣.GAME_TYPE';
	perform gamebox_site_rebate_gametype(api_map,dict_map);
	raise info '站点返佣.API';
	perform gamebox_site_rebate_api(dict_map);
	raise info '站点返佣';
	perform gamebox_site_rebate(expense_map,dict_map);

	perform dblink_disconnect('master');
	RETURN '0';
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate(
main_url TEXT
,master_url TEXT
,start_time TEXT
,end_time TEXT
) IS 'Lins-站点返佣-入口';



/*
* 站点返佣.GAME_TYPE统计.
* @author:Lins
* @date:2015-12-14
* 参数1.API返佣map
* 参数2.站点信息map
*/
drop function if exists gamebox_site_rebate_gametype(hstore,hstore);
create or replace function gamebox_site_rebate_gametype(
api_map hstore
,dict_map hstore
)
returns void as $$
DECLARE
	keys TEXT[];
	sub_keys TEXT[];
	val FLOAT;
	col_split TEXT:='_';
	sid INT;
	center_id INT;
	master_id INT;
	c_year INT;
	c_month INT;
BEGIN

	sid=(dict_map->'site_id')::INT;
	center_id=(dict_map->'center_id')::INT;
	master_id=(dict_map->'master_id')::INT;
	c_year=(dict_map->'year')::INT;
	c_month=(dict_map->'month')::INT;
	DELETE FROM site_rebate_gametype WHERE site_id=sid AND rebate_year=c_year AND rebate_month=c_month;
	keys=akeys(api_map);
	IF api_map is null OR array_length(keys, 1) is null THEN
		RETURN;
	END IF;
	--raise info 'len=%',array_length(keys, 1);
	FOR i IN 1..array_length(keys, 1) LOOP
		val=(api_map->keys[i])::FLOAT;
		sub_keys=regexp_split_to_array(keys[i],col_split);
		INSERT INTO site_rebate_gametype(
			center_id
			,master_id
			,site_id
			,api_id
			,game_type
			,rebate_year
			,rebate_month
			,static_time
			,rebate_total
		)VALUES(
			center_id
			,master_id
			,sid
			,sub_keys[1]::INT
			,sub_keys[2]
			,c_year
			,c_month
			,now()
			,val
		);
	END LOOP;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate_gametype(
api_map hstore
,dict_map hstore
) IS 'Lins-站点返佣.GAME_TYPE';



/*
* 站点返佣.API.
* @author:Lins
* @date:2015-12-14
* 参数1.站点信息map
*/
drop function if exists gamebox_site_rebate_api(hstore);
create or replace function gamebox_site_rebate_api(
dict_map hstore
)
returns void as $$
DECLARE
	sid INT;
	c_id INT;
	m_id INT;
	c_year INT;
	c_month INT;
BEGIN

	sid=(dict_map->'site_id')::INT;
	c_id=(dict_map->'center_id')::INT;
	m_id=(dict_map->'master_id')::INT;
	c_year=(dict_map->'year')::INT;
	c_month=(dict_map->'month')::INT;
	DELETE FROM site_rebate_api WHERE site_id=sid AND rebate_year=c_year AND rebate_month=c_month;
	INSERT INTO site_rebate_api(
  center_id
  ,master_id
  ,site_id
  ,rebate_year
  ,rebate_month
  ,static_time
	,api_id
  ,rebate_total
	) SELECT
	c_id
	,m_id
	,sid
	,c_year
	,c_month
	,now()
	,api_id
	,SUM(rebate_total)
	FROM site_rebate_gametype
  WHERE site_id=sid AND rebate_year=c_year AND rebate_month=c_month
	GROUP BY api_id;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate_api(
dict_map hstore
) IS 'Lins-站点返佣.API';


/*
* 站点返佣
* @author:Lins
* @date:2015-12-14
* 参数1.站点信息map
*/
drop function if exists gamebox_site_rebate(hstore,hstore);
create or replace function gamebox_site_rebate(
expense_map hstore
,dict_map hstore
)
returns void as $$
DECLARE
	val FLOAT;
	sid INT;
	c_id INT;
	m_id INT;
	c_year INT;
	c_month INT;
	player_num INT;
	refund_fee FLOAT;
	amount FLOAT;
	loss FLOAT;
	favorable FLOAT;
	backwater FLOAT;
	apportion FLOAT;
BEGIN
	sid=(dict_map->'site_id')::INT;
	c_id=(dict_map->'center_id')::INT;
	m_id=(dict_map->'master_id')::INT;
	c_year=(dict_map->'year')::INT;
	c_month=(dict_map->'month')::INT;

	player_num=(expense_map->'player_num')::INT;
	amount=(expense_map->'effective_trade_amount')::FLOAT;
	loss=(expense_map->'profit_amount')::FLOAT;
	refund_fee=(expense_map->'refund_fee')::FLOAT;
	favorable=(expense_map->'favourable')::FLOAT;
	backwater=(expense_map->'backwater')::FLOAT;
	apportion=(expense_map->'apportion')::FLOAT;

	DELETE FROM site_rebate WHERE site_id=sid AND rebate_year=c_year AND rebate_month=c_month;

	SELECT sum(rebate_total) INTO val FROM site_rebate_gametype
	WHERE site_id=sid AND rebate_year=c_year AND rebate_month=c_month;
	INSERT INTO site_rebate(
  center_id
  ,master_id
  ,site_id
  ,rebate_year
  ,rebate_month
  ,static_time
  ,rebate_total
	,effective_player
	,effective_transaction
	,profit_loss
	,preferential_value
	,refund_fee
	,rakeback
	,apportion
	) VALUES(
	c_id
	,m_id
	,sid
	,c_year
	,c_month
	,now()
	,val
	,player_num
	,amount
	,loss
	,favorable
	,refund_fee
	,backwater
	,apportion
	);
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_site_rebate(
expense_map hstore
,dict_map hstore
) IS 'Lins-站点返佣';



/*

--测试收集站点玩家数.

SELECT * FROM gamebox_site_rebate(
'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'host=192.168.0.88 dbname=gamebox-master user=postgres password=postgres'
,'2015-01-01','2015-12-31','\|');

SELECT * FROM gamebox_site_rebate(
'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'host=192.168.0.88 dbname=gamebox-master user=postgres password=postgres'
,'2015-01-01','2015-12-31');

select extract(month from now());
*/