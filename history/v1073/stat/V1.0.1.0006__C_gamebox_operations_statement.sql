-- auto gen by cheery 2016-03-04 10:06:30
/**
 * 关闭当前所有跨数据库链接
 * @author 	Lins
 * @date 	2015.10.27
 */
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
	  	dbnames:=regexp_split_to_array(dbname, ', ');

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
 */
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
drop function IF EXISTS gamebox_master_operation_statement(text, int, text, text, date, text);
CREATE
OR REPLACE FUNCTION gamebox_master_operation_statement (conn TEXT, siteid INT, startTime TEXT, endTime TEXT, curday DATE, url text
) RETURNS TEXT AS $$
DECLARE
	rtn TEXT := '' ;
BEGIN
	SELECT
		INTO rtn P .msg
	FROM
		dblink (conn,
			'SELECT * from gamebox_operations_statement(
'''||url||''', '||siteid||', '''||startTime||''', '''||endTime||''')
'
		) AS P (msg TEXT) ;
	RETURN rtn ;
	END $$ LANGUAGE plpgsql;


COMMENT ON FUNCTION gamebox_master_operation_statement
(
	conn TEXT,
	siteid INT,
	startTime TEXT,
	endTime TEXT,
	curday DATE,
	url text
)
IS 'Lins-经营报表-玩家.代理.总代报表';


/**
	description:站点经营报表
	author:Lins
	date:2015.10.28
	@param:0时区当前日期
	@return:返回执行LOG信息.
*/
drop function IF EXISTS gamebox_operation_site(text, date);
create or replace function gamebox_operation_site(conn text, curday date
) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;

BEGIN
	--清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from site_operate where to_char(static_time, 'YYYY-MM-DD')=to_char(curday, 'YYYY-MM-DD');
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %',  v_count;
  rtn = rtn||'| |执行完毕, 删除记录数: '||v_count||' 条||';

  --开始执行站点经营报表信息收集
  rtn = rtn||'|开始执行'||curday||'站点经营报表||';
	INSERT INTO site_operate(
	site_id, site_name
	, center_id, center_name
  	, master_id, master_name
	, player_num, api_id
	, api_type_id, game_type
	, static_time, create_time
	, transaction_order
	, transaction_volume
	, effective_transaction
	, profit_loss
	)
  SELECT s.siteid, s.sitename
	, s.operationid, s.operationname
  , s.masterid, s.mastername
	, a.players_num, a.api_id
	, a.api_type_id, a.game_type
  , current_date, now()
	, a.transaction_order
	, a.transaction_volume
	, a.effective_transaction_volume
	, a.transaction_profit_loss
	FROM
		dblink (conn,
			'SELECT * from gamebox_operations_site('''||curday::text||''')
		 AS Q(
			siteid int,
			api_id int,
			game_type varchar,
			api_type_id int,
			players_num bigint ,
			transaction_order NUMERIC ,
			transaction_volume NUMERIC,
			effective_transaction_volume NUMERIC,
			transaction_profit_loss NUMERIC
			)'
		) AS a(
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
	raise notice '本次插入数据量 %',  v_count;
  rtn = rtn||'|执行完毕, 新增记录数: '||v_count||' 条||';
	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_site
(
conn text
, curday date
)
IS 'Lins-经营报表-站点报表';

/**
 * 站长经营报表
 * @author:Fly
 * @date:2015-12-29
 * @param date: 0时区当前日期
 * @return: 返回执行LOG信息.
 */
drop function IF EXISTS gamebox_operation_master(TEXT);
create or replace function gamebox_operation_master(curday TEXT) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;
BEGIN
  	--清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from master_operate where to_char(static_time,  'YYYY-MM-dd')=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %',  v_count;
  	rtn = rtn||'| |执行完毕, 删除记录数: '||v_count||' 条||';
	--开始执行总代经营报表信息收集
  	rtn = rtn||'|开始执行'||curday||'站长经营报表||';

  	INSERT INTO master_operate(center_id,  center_name,  master_id,  master_name,  api_id,  api_type_id,  game_type,
  		player_num,  transaction_order,  transaction_volume,  effective_transaction,  profit_loss,  static_time,  create_time)
	SELECT center_id,  center_name,  master_id,  master_name,  api_id,  api_type_id, 	game_type,
		player_num,  transaction_order,  transaction_volume,  effective_transaction,  profit_loss,  CURRENT_DATE,  now()
	FROM (
		SELECT center_id,  center_name,  master_id,  master_name,  api_id,  api_type_id, 	game_type,
			   SUM(player_num) player_num,  SUM(transaction_order) transaction_order,  SUM(transaction_volume) transaction_volume,
			   SUM(effective_transaction) effective_transaction,  SUM(profit_loss) profit_loss
		FROM site_operate
	   	GROUP BY center_id,  center_name,  master_id,  master_name,  api_id,  api_type_id,  game_type
	) o;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %',  v_count;
  	rtn = rtn||'|执行完毕, 新增记录数: '||v_count||' 条||';

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_master(curday TEXT)
IS 'Fly - 经营报表-站长报表';

/**
 * 运营商经营报表
 * @author:Fly
 * @date:2015-12-29
 * @param curday: 0时区当前日期
 * @return: 返回执行LOG信息.
 */
drop function IF EXISTS gamebox_operation_company(TEXT);
create or replace function gamebox_operation_company(curday TEXT) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;
BEGIN
  	--清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from company_operate where to_char(create_time,  'YYYY-MM-dd')=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %',  v_count;
  	rtn = rtn||'| |执行完毕, 删除记录数: '||v_count||' 条||';
	--开始执行总代经营报表信息收集
  	rtn = rtn||'|开始执行'||curday||'运营商经营报表||';

  	INSERT INTO company_operate(operator_id,  operator_name,  api_id,  api_type_id,  game_type,  transaction_order,  transaction_volume,
		effective_transaction_volume,  transaction_profit_loss,  static_year,  static_month,  create_time)
	SELECT center_id,  center_name,  api_id,  api_type_id, 	game_type,  transaction_order,  transaction_volume,
		effective_transaction,  profit_loss,  (SELECT EXTRACT(year from now())::int4),  (SELECT EXTRACT(month from now())::int4),  now()
	FROM (
		SELECT center_id,  center_name,  api_id,  api_type_id::int4, 	game_type,
					 SUM(transaction_order) transaction_order,  SUM(transaction_volume) transaction_volume,
					 SUM(effective_transaction) effective_transaction,  SUM(profit_loss) profit_loss
			FROM master_operate
	   GROUP BY center_id,  center_name,  api_id,  api_type_id,  game_type
	) o;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %',  v_count;
  	rtn = rtn||'|执行完毕, 新增记录数: '||v_count||' 条||';

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_company(curday TEXT)
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
 */
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
	IF mainhost is null or rtrim(ltrim(mainhost))='' THEN
		raise info '运营商库信息没有设置';
		return '运营商库信息没有设置';
	END IF;

	IF masterhost is null or rtrim(ltrim(masterhost))='' THEN
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

/**
 * 收集所有站点玩家游戏下单运营报表
 * @author 	Lins
 * @date 	2015.10.27
 * @param 	mainhost 	运营数据库配置信息.
 * @param 	masterhost 	所有站点数据库配置信息.
 */
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
  	rtn = rtn||'1.  开始执行各个站点玩家经营报表';

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