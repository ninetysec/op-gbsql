/**
 * 关闭当前所有跨数据库链接
 * @author 	Lins
 * @date 	2015.10.27
**/
drop function IF EXISTS dblink_close_all();
create or replace function dblink_close_all() returns void as $$
declare dbnames varchar[];
declare dbname varchar;
BEGIN
	SELECT dblink_get_connections() into dbname;

	IF dbname IS NOT NULL THEN

		raise notice '当前所有跨数据库连接名称:%', dbname;

		dbname:=replace(dbname, '{', '');
		dbname:=replace(dbname, '}', '');
	  	dbnames:=regexp_split_to_array(dbname, ',');

		IF array_length(dbnames, 1) > 0 THEN
			FOR i in 1..array_length(dbnames, 1)
			LOOP
				raise notice '名称:%', dbnames[i];
				perform dblink_disconnect(dbnames[i]);
			END LOOP;
		END IF;

	ELSE
		raise notice '当前没有连接';
	END IF;
END

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION dblink_close_all()
IS 'Lins-关闭所有dblink连接.';

/**
 * 收集当前所有运营站点相关信息
 * @author 	Lins
 * @date 	2015.10.27
 * @param 	mainhost	运营数据库配置信息
**/
drop function IF EXISTS gamebox_collect_site_infor(text);
create or replace function gamebox_collect_site_infor(
	hostinfo text
) returns void as $$

declare
	sql text:='';
	rec record;

BEGIN
	perform dblink_connect('mainsite', hostinfo);
	sql:='SELECT s.siteid, 				s.sitename,
				 s.masterid, 			s.mastername,
				 s.usertype, 			s.subsyscode,
		  		 s.operationid, 		s.operationname,
		  		 s.operationusertype, 	s.operationsubsyscode
		    FROM dblink (''mainsite'', ''SELECT * from v_sys_site_info'') as s
		    	 (
					siteid int4, 		sitename VARCHAR,
					masterid int4, 		mastername VARCHAR,
					usertype VARCHAR, 	subsyscode VARCHAR,
					operationid int4, 	operationname VARCHAR,
					operationusertype VARCHAR, operationsubsyscode VARCHAR
				 )';

	FOR rec in EXECUTE sql LOOP
		raise notice 'name:%', rec.sitename;
	END LOOP;

	execute 'truncate table sys_site_info';
	execute 'insert into sys_site_info '||sql;

	perform dblink_disconnect('mainsite');
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_collect_site_infor(hostinfo text)
IS 'Lins-经营报表-收集站点相关信息';
/*
description:经营报表-入口
@author:Lins
@date:2017.02.23
@param:dblink CONNECTION
@param:站长ID
@param:统计日期
@param:站点URLS
@param:统计开始时间S
@param:统计结束时间S
@param:站点IDS
@param:分隔符
@param:统计统计日期后N天的数据（包括传入日期）
@return:返回执行LOG信息.
*/
drop function IF EXISTS gb_operations_statement_master(text, text, text, text, text, text, text, text, int);
create or replace function gb_operations_statement_master(
  p_comp_url    text,
  p_master_id   text,
  p_static_date text,
  p_site_urls   text,
  p_start_times text,
  p_end_times   text,
  p_siteids     text,
  p_splitchar   text,
  p_stat_days   int
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/02/23  Leisure  创建此函数: 经营报表-入口
*/
DECLARE
  v_site_urls     varchar[];
  v_start_times   varchar[];
  v_end_times     varchar[];
  v_siteids       varchar[];
  n_center_id     int;
  tmp             text:='';
  rtn             text:='';

  v_static_date  varchar;
  v_start_time   varchar;
  v_end_time     varchar;

BEGIN
  IF p_comp_url is null or trim(p_comp_url) = '' THEN
    raise info '运营商库信息没有设置';
    return '运营商库信息没有设置';
  END IF;

  IF p_site_urls is null or trim(p_site_urls) = '' THEN
    raise info '站点库信息没有设置';
    return '站点库信息没有设置';
  END IF;

  --关闭所有链接.
  perform dblink_close_all();
  --收集当前所有运营站点相关信息.
  perform gamebox_collect_site_infor(p_comp_url);

  --获取当前运营商id
  SELECT operationid INTO n_center_id FROM sys_site_info WHERE masterid = p_master_id::INT LIMIT 1;
  IF n_center_id is null or n_center_id = 0 THEN
    raise info '获取运营商id失败';
    return '获取运营商id失败';
  END IF;

  --拆分所有站点数据库信息.
  v_site_urls:=regexp_split_to_array(p_site_urls, p_splitchar);
  v_start_times :=regexp_split_to_array(p_start_times, p_splitchar);
  v_end_times   :=regexp_split_to_array(p_end_times, p_splitchar);
  v_siteids    :=regexp_split_to_array(p_siteids, p_splitchar);

  rtn = '【开始执行经营报表】';
  rtn = rtn || '站长ID：' || p_master_id || '，运营商ID：' || n_center_id::TEXT;

  IF array_length(v_siteids, 1) > 0 THEN
    FOR i_day IN 0..p_stat_days-1 LOOP

      v_static_date := (p_static_date::DATE + (i_day||'day')::INTERVAL)::DATE::TEXT;
      rtn = rtn||chr(13)||chr(10)||' ┣1.开始执行日期['|| v_static_date ||']站点经营报表  ';

      FOR i_site in 1..array_length(v_siteids, 1)
      LOOP

        v_start_time  := (v_start_times[i_site]::TIMESTAMP + (i_day||'day')::INTERVAL)::TEXT;
        v_end_time    := (v_end_times[i_site]::TIMESTAMP + (i_day||'day')::INTERVAL)::TEXT;

        SELECT gb_operations_statement_site(p_comp_url, v_static_date, v_site_urls[i_site], v_start_time, v_end_time, v_siteids[i_site], 1) into tmp;
        rtn = rtn || tmp;
      END LOOP;

      rtn = rtn||chr(13)||chr(10)||' ┣2.开始执行站长经营报表  ';
      SELECT gamebox_operation_master(p_master_id, v_static_date) into tmp;
      rtn = rtn||'||'||tmp;

      rtn = rtn||chr(13)||chr(10)||' ┗3.开始执行运营商经营报表';
      SELECT gamebox_operation_company(n_center_id::TEXT, v_static_date) into tmp;
      rtn = rtn||'||'||tmp||chr(13)||chr(10);

    END LOOP;
  END IF;

  rtn = rtn||chr(13)||chr(10)||'【执行经营报表完毕】'||chr(13)||chr(10);

  --raise info '%', rtn;
  return rtn;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gb_operations_statement_master(p_comp_url text, p_master_id text, p_static_date  text, p_site_urls text, p_start_times text, p_end_times text, p_siteids text, p_splitchar text, p_stat_days  int)
IS 'Leisure-经营报表-入口';

/*
description:经营报表-站点报表
@ author:Leisure
@date:2017.02.23
@param: p_comp_url 运营商dblink
@param: p_static_date 统计日期
@param: p_site_url 站点URL
@param: p_start_time 统计开始时间
@param: p_end_time 统计结束时间S
@param: p_siteid 站点IDS
@param: p_stat_days 统计统计日期后N天的数据（包括传入日期）
@return:返回执行LOG信息.
*/
DROP FUNCTION IF EXISTS gb_operations_statement_site(text, text, text, text, text, text, int);
CREATE OR REPLACE FUNCTION gb_operations_statement_site(
  p_comp_url    text,
  p_static_date text,
  p_site_url    text,
  p_start_time  text,
  p_end_time    text,
  p_siteid      text,
  p_stat_days   int
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/02/23  Leisure  创建此函数: 经营报表-站点报表
*/
DECLARE

  rtn text:='';
  tmp text:='';
  v_static_date  varchar;
  v_start_time   varchar;
  v_end_time     varchar;

BEGIN

  FOR i IN 0..p_stat_days - 1 LOOP

    v_static_date := (p_static_date::DATE + (i||'day')::INTERVAL)::DATE::TEXT;
    v_start_time  := (p_start_time::TIMESTAMP + (i||'day')::INTERVAL)::TEXT;
    v_end_time    := (p_end_time::TIMESTAMP + (i||'day')::INTERVAL)::TEXT;

    RAISE INFO '%, %, %', v_static_date, v_start_time, v_end_time;

    --raise notice '当前站点库信息：%', p_site_url;
    IF p_site_url is null OR trim(p_site_url) = '' THEN
      return '站点库信息不能为空';
    END IF;

    --连接站点库
    perform dblink_connect('master', p_site_url);

    tmp = '    ┗ 开始收集站点id['||p_siteid||'],日期['|| v_static_date ||']经营报表';
    raise notice '%', tmp;
    --执行玩家经营报表
    rtn = rtn||chr(13)||chr(10)||tmp;
    SELECT P .msg
      FROM
      dblink (p_site_url,
              'SELECT * from gamebox_operations_statement('''||p_comp_url||''', '||p_siteid||', '''||v_static_date||''', '''||v_start_time||''', '''||v_end_time||''')'
      ) AS P (msg TEXT)
      INTO tmp ;
    rtn = rtn||tmp;
    raise notice '收集完毕';
    --收集站点经营报表
    rtn = rtn||chr(13)||chr(10)||'        ┗4.正在执行站点经营报表';
    SELECT gamebox_operation_site('master', p_siteid, v_static_date, v_start_time, v_end_time) into tmp;
    rtn = rtn||'||'||tmp;
    perform dblink_disconnect('master');

    rtn = rtn||chr(13)||chr(10)||'    ┗收集完毕';
  END LOOP;

  return rtn;

END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gb_operations_statement_site(p_comp_url text, p_static_date  text, p_site_url text, p_start_time text, p_end_time text, p_siteid text, p_stat_days  int)
IS 'Lins-经营报表-站点经营报表';

/*
description:通过Dblink方式收集玩家经营报表.
@author:Lins
@date:2015.10.27
@param:dblink CONNECTION
@param:站点ID
@param:统计开始时间
@param:统计结束时间
@param:0时区当前日期
@return:返回执行LOG信息.
*/
--drop function IF EXISTS gamebox_master_operation_statement(text, int, text, text, date, text);
--drop function IF EXISTS gamebox_master_operation_statement(text, int, text, text, text, text);
/*
drop function IF EXISTS gamebox_master_operation_statement(text, text, text, text, text, text);
CREATE OR REPLACE FUNCTION gamebox_master_operation_statement(
	conn 		TEXT,
	siteid 		TEXT,
	curday 		TEXT,--v1.01  2016/05/31  Leisure
	startTime 	TEXT,
	endTime 		TEXT,
	url 		TEXT
) RETURNS TEXT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-玩家.代理.总代报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
--v1.02  2016/07/07  Leisure  修改参数类型
/
DECLARE
	rtn TEXT:='';
BEGIN
	SELECT
		INTO rtn P.msg
	FROM
		dblink (conn,
			--v1.01  2016/05/31  Leisure
			'SELECT * from gamebox_operations_statement('''||url||''', '||siteid||', '''||curday::TEXT||''', '''||startTime||''', '''||endTime||''')'
		) AS P (msg TEXT);
	RETURN rtn ;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_master_operation_statement(conn TEXT, siteid TEXT, curday TEXT, startTime TEXT, endTime TEXT, url TEXT)
IS 'Lins-经营报表-玩家.代理.总代报表';
*/

/**
	description:站点经营报表
	author:Lins
	date:2015.10.28
	@param:0时区当前日期
	@return:返回执行LOG信息.
*/
/*
drop function IF EXISTS gamebox_operation_site(text, date);
create or replace function gamebox_operation_site(
	conn 	text,
	curday 	date
) returns text as $$

DECLARE
	rtn 	text:='';
	v_count	int:=0;

BEGIN
	--清除当天的统计信息，保证每天只作一次统计信息
  	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from site_operate where to_char(static_time, 'YYYY-MM-DD') = to_char(curday, 'YYYY-MM-DD');
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %',  v_count;
  	rtn = rtn||'|执行完毕,删除记录数: '||v_count||' 条||';

  --开始执行站点经营报表信息收集
  	rtn = rtn||'|开始执行'||curday||'站点经营报表||';
	INSERT INTO site_operate(
		site_id, site_name, center_id, center_name, master_id, master_name, player_num,
		api_id, api_type_id, game_type, static_time, create_time, transaction_order,
		transaction_volume, effective_transaction, profit_loss
	) SELECT
		s.siteid, s.sitename, s.operationid, s.operationname, s.masterid, s.mastername, a.players_num,
		a.api_id, a.api_type_id, a.game_type, current_date, now(), a.transaction_order,
		a.transaction_volume, a.effective_transaction_volume, a.transaction_profit_loss
	FROM
		dblink (conn,
			'SELECT * from gamebox_operations_site('''||curday::text||''')
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
END

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operation_site(conn text, curday date)
IS 'Lins-经营报表-站点报表';
*/

/**
	description:站点经营报表
	author:Lins
	date:2015.10.28
	@param:0时区当前日期
	@return:返回执行LOG信息.
*/
--drop function IF EXISTS gamebox_operation_site(text, date);
--drop function IF EXISTS gamebox_operation_site(TEXT, TEXT, TEXT, TEXT);
drop function IF EXISTS gamebox_operation_site(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_operation_site(
	conn 	TEXT,
	siteid  TEXT,
	curday 	TEXT,
	start_time 	TEXT,
	end_time 		TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-站点报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取，
                              站点报表增加参数startTime TEXT, endTime TEXT
--v1.02  2016/07/07  Leisure  增加参数siteid，清除数据时，只清除当前站点的数据
--v1.03  2016/07/08  Leisure  优化输出日志
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
	--v1.02  2016/07/07  Leisure
	--DELETE FROM site_operate WHERE static_date = d_static_date;
	DELETE FROM site_operate WHERE static_date = d_static_date AND site_id = siteid::INT;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %',  v_count;
	rtn = rtn||'|执行完毕,删除记录数: '||v_count||' 条||';

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
		rtn = rtn||'|执行完毕,新增记录数: '||v_count||' 条||';
	return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_site(	conn TEXT, siteid TEXT, curday TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-经营报表-站点报表';

/**
 * 站长经营报表
 * @author:Fly
 * @date:2015-12-29
 * @param date: 0时区当前日期
 * @return: 返回执行LOG信息.
**/
--drop function IF EXISTS gamebox_operation_master(TEXT);
drop function IF EXISTS gamebox_operation_master(TEXT, TEXT);
create or replace function gamebox_operation_master(
	masterid TEXT,
	curday TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fly      创建此函数: 经营报表-站长报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取；
                              经营报表增加字段static_date统计日期
--v1.02  2016/07/07  Leisure  增加参数siteid，清除数据时，只清除当前站长的数据
--v1.03  2016/07/08  Leisure  优化输出日志
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
	--v1.02  2016/07/07  Leisure
	--DELETE FROM master_operate WHERE static_date = d_static_date;
	DELETE FROM master_operate WHERE static_date = d_static_date AND master_id = masterid::INT;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
	rtn = rtn||'|执行完毕,删除记录数: '||v_count||' 条||';
	--开始执行总代经营报表信息收集
	rtn = rtn||'|开始执行'||curday||'站长经营报表  ||';

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
	rtn = rtn||'|执行完毕,新增记录数: '||v_count||' 条||';

	return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_master(masterid TEXT, curday TEXT)
IS 'Fly - 经营报表-站长报表';

/**
 * 运营商经营报表
 * @author:Fly
 * @date:2015-12-29
 * @param curday: 0时区当前日期
 * @return: 返回执行LOG信息.
**/
--drop function IF EXISTS gamebox_operation_company(TEXT);
drop function IF EXISTS gamebox_operation_company(TEXT, TEXT);
create or replace function gamebox_operation_company(
	centerid TEXT,
	curday TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fly      创建此函数: 经营报表-运营商报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
                              经营报表增加字段static_date统计日期
--v1.02  2016/07/07  Leisure  增加参数centerid，清除数据时，只清除当前运营商的数据
--v1.03  2016/07/08  Leisure  优化输出日志
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
	--v1.02  2016/07/07  Leisure
	--DELETE FROM company_operate WHERE static_date = d_static_date;
	DELETE FROM company_operate WHERE static_date = d_static_date AND operator_id = centerid::INT;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %',  v_count;
	rtn = rtn||'|执行完毕,删除记录数: '||v_count||' 条||';
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
	rtn = rtn||'|执行完毕,新增记录数: '||v_count||' 条||';

	return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_company(centerid TEXT, curday TEXT)
IS 'Fly - 经营报表-运营商报表';

/**
 * 收集所有站点玩家游戏下单运营报表
 * @author 	Lins
 * @date 	2015.10.27
 * @param 	mainhost 	运营数据库配置信息.
 * @param 	masterhost 	所有站点数据库配置信息.
 * @param 	startTime 	开始时间
 * @param 	endTime 	结束时间
 * @param 	sids 		站点ID
 * @param 	splitchar 	用来标示各个站点数据库配置信息的分隔符, 如’\|‘
**/
/*
drop function IF EXISTS gamebox_operations_statement(text, text, text, text, text, text);
create or replace function gamebox_operations_statement(
	mainhost 	text,
	masterhost 	text,
	startTime 	text,
	endTime 	text,
	sids 		text,
	splitchar 	text
) returns text as $$
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
		SELECT gamebox_operations_statement(mainhost, masterhosts, startTimes, endTimes, siteids) into rtn;
	END IF;

	raise info '%', rtn;
return rtn;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, masterhost text, startTime text, endTime text, sids text, splitchar text)
IS 'Lins-经营报表-单站点报表-入口';
*/

/**
 * 收集所有站点玩家游戏下单运营报表
 * @author 	Lins
 * @date 	2015.10.27
 * @param 	mainhost 	运营数据库配置信息.
 * @param 	static_date 	统计日期.
 * @param 	masterhost 	所有站点数据库配置信息.
 * @param 	startTime 	开始时间
 * @param 	endTime 	结束时间
 * @param 	sids 		站点ID
 * @param 	splitchar 	用来标示各个站点数据库配置信息的分隔符, 如’\|‘
**/
--drop function IF EXISTS gamebox_operations_statement(text, text, text, text, text, text);
--drop function IF EXISTS gamebox_operations_statement(text, text, text, text, text, text, text);
drop function IF EXISTS gamebox_operations_statement(text, text, text, text, text, text, text, text);
create or replace function gamebox_operations_statement(
	mainhost 	text,
	masterid 	text,
	static_date	text,
	masterhost 	text,
	startTime 	text,
	endTime 	text,
	sids 		text,
	splitchar 	text
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-单站点报表-入口
--v1.01  2016/05/27  Leisure  增加参数static_date统计日期
--v1.02  2016/07/07  Leisure  增加参数masterid站长ID
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
		--v1.02  2016/07/07  Leisure
		SELECT gamebox_operations_statement(mainhost, masterid, static_date, masterhosts, startTimes, endTimes, siteids) into rtn;
	END IF;

	raise info '%', rtn;
return rtn;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, masterid text, static_date	text, masterhost text, startTime text, endTime text, sids text, splitchar text)
IS 'Lins-经营报表-单站点报表-入口';

/**
 * 收集所有站点玩家游戏下单运营报表
 * @author 	Lins
 * @date 	2015.10.27
 * @param 	mainhost 	运营数据库配置信息.
 * @param 	masterhost 	所有站点数据库配置信息.
**/
/*
drop function IF EXISTS gamebox_operations_statement(text, text[], text[], text[], text[]);
create or replace function gamebox_operations_statement(
	mainhost 	text,
	masterhost 	text[],
	startTimes 	text[],
	endTimes 	text[],
	siteids 	text[]
) returns text as $$
DECLARE
	curday date;
	rtn text:='';
	tmp text:='';

BEGIN
	--设置当前日期.
	SELECT CURRENT_DATE into curday;
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
		SELECT gamebox_master_operation_statement('master', siteids[i]::int, startTimes[i], endTimes[i], curday, mainhost) into tmp;
		rtn = rtn||'||'||tmp;
	  	raise info '%.收集完毕', i;
		--收集站点经营报表
		rtn = rtn||'4.  开始执行站点经营报表';
		SELECT gamebox_operation_site('master', curday) into tmp;
		rtn = rtn||'||'||tmp;
		perform dblink_disconnect('master');
	END LOOP;

	rtn = rtn||'5.  开始执行站长经营报表';
	SELECT gamebox_operation_master(curday::TEXT) into tmp;
	rtn = rtn||'||'||tmp;
	rtn = rtn||'6.  开始执行运营商经营报表';
	SELECT gamebox_operation_company(curday::TEXT) into tmp;
	rtn = rtn||'||'||tmp;

return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, masterhost text[], startTimes text[], endTimes text[], siteids text[])
IS 'Lins-经营报表-多站点入口';
*/

/**
 * 收集所有站点玩家游戏下单运营报表
 * @author 	Lins
 * @date 	2015.10.27
 * @param 	mainhost 	运营数据库配置信息.
 * @param 	masterhost 	所有站点数据库配置信息.
**/
--drop function IF EXISTS gamebox_operations_statement(text, text[], text[], text[], text[]);
--drop function IF EXISTS gamebox_operations_statement(text, text, text[], text[], text[], text[]);
drop function IF EXISTS gamebox_operations_statement(text, text, text, text[], text[], text[], text[]);
create or replace function gamebox_operations_statement(
	mainhost 	text,
	master_id 	text,
	static_date	text,
	masterhost 	text[],
	startTimes 	text[],
	endTimes 	text[],
	siteids 	text[]
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-多站点入口
--v1.01  2016/05/27  Leisure  增加参数static_date统计日期
--v1.02  2016/05/31  Leisure  站点报表增加参数startTime TEXT, endTime TEXT
--v1.03  2016/07/07  Leisure  增加参数master_id站长ID
--v1.04  2016/07/08  Leisure  优化输出日志
*/
DECLARE
	--curday date;
	rtn text:='';
	tmp text:='';
	center_id int;

BEGIN
	rtn = '【开始执行经营报表】';
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

	--获取当前运营商id
	SELECT operationid INTO center_id FROM sys_site_info WHERE masterid = master_id::INT LIMIT 1;
	IF center_id is null or center_id = 0 THEN
		raise info '获取运营商id失败';
		return '获取运营商id失败';
	END IF;

	rtn = rtn || '站长ID：' || master_id || '，运营商ID：' || center_id::TEXT;

	--拆分所有站点数据库信息.
	rtn = rtn||chr(13)||chr(10)||'┣1.正在执行站点经营报表';

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
		rtn = rtn||chr(13)||chr(10)||'    ┗1.'||i||'.开始收集站点ID['||siteids[i]||']经营报表';
		--SELECT gamebox_master_operation_statement('master', siteids[i]::int, startTimes[i], endTimes[i], static_date, mainhost) into tmp;
		SELECT gamebox_master_operation_statement('master', siteids[i], static_date, startTimes[i], endTimes[i], mainhost) into tmp;
		rtn = rtn||tmp;
		raise info '%.收集完毕', i;
		--收集站点经营报表
		rtn = rtn||chr(13)||chr(10)||'        ┗4.正在执行站点经营报表';
		--SELECT gamebox_operation_site('master', curday) into tmp; --v1.02  2016/05/31  Leisure
		SELECT gamebox_operation_site('master', siteids[i], static_date, startTimes[i], endTimes[i]) into tmp;
		rtn = rtn||'||'||tmp;
		perform dblink_disconnect('master');
	END LOOP;

	rtn = rtn||chr(13)||chr(10)||'┣2.开始执行站长经营报表  ';
	--v1.02  2016/07/07  Leisure
	SELECT gamebox_operation_master(master_id, static_date) into tmp;
	rtn = rtn||'||'||tmp;
	rtn = rtn||chr(13)||chr(10)||'┗3.开始执行运营商经营报表';
	--v1.02  2016/07/07  Leisure
	SELECT gamebox_operation_company(center_id::TEXT, static_date) into tmp;
	rtn = rtn||'||'||tmp;

	rtn = rtn||chr(13)||chr(10)||'【执行经营报表完毕】'||chr(13)||chr(10);
	return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, master_id text, static_date	text, masterhost text[], startTimes text[], endTimes text[], siteids text[])
IS 'Lins-经营报表-多站点入口';

/*
SELECT gamebox_operations_statement(
	'host = 192.168.0.88 port = 5432 dbname = gamebox-mainsite user = postgres password = postgres',
	'host = 192.168.0.88 port = 5432 dbname = gamebox-master user = postgres password = postgres',
	'2015-01-01 00:00:01',
	'2015-12-29 23:59:59',
	'1|2',
	'\|'
);
*/
