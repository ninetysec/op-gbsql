-- auto gen by Lins 2015-12-22 09:31:14

/*
description:关闭当前所有跨数据库链接
author:Lins
date:2015.10.27
*/
drop function IF EXISTS dblink_close_all();
create or replace function dblink_close_all() returns void as $$
declare dbnames varchar[];
declare dbname varchar;
BEGIN
	select dblink_get_connections() into dbname;
	if dbname is not null THEN
	raise notice '当前所有跨数据库连接名称:%',dbname;
	dbname:=replace(dbname,'{','');
	dbname:=replace(dbname,'}','');
  dbnames:=regexp_split_to_array(dbname,',');
	if array_length(dbnames,1)>0 THEN
	for i in 1..array_length(dbnames,1) loop
		raise notice '名称:%',dbnames[i];
		--perform dblink_close(dbnames[i]);
		perform dblink_disconnect(dbnames[i]);
	end loop;
	end if;
	else
		raise notice '当前没有连接';
	end if;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION dblink_close_all() IS 'Lins-关闭所有dblink连接.';


/*
	description:收集当前所有运营站点相关信息
	author:Lins
	date: 2015.10.27
  参数1:名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 select gamebox_operations_statement(
 'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 );
*/
drop function IF EXISTS gamebox_collect_site_infor(text);
create or replace function gamebox_collect_site_infor(
hostinfo text
) returns void as $$
declare
	sql text:='';
	rec record;
BEGIN
	--perform dblink_close_all();
	perform dblink_connect('mainsite',hostinfo);
	sql:='SELECT s.siteid,s.sitename,s.masterid,s.mastername,s.usertype,s.subsyscode,s.operationid,s.operationname,s.operationusertype,s.operationsubsyscode FROM
	dblink (
		''mainsite'',
		''select * from v_sys_site_info''
	) AS s (
		--站点ID
		siteid int4,
		--站点名称
		sitename VARCHAR,
		--站长ID
		masterid int4,
		--站长名称
		mastername VARCHAR,
		--用户类型
		usertype VARCHAR,
		subsyscode VARCHAR,
		--运营商ID
		operationid int4,
		--运营商名称
		operationname VARCHAR,
		operationusertype VARCHAR,
		operationsubsyscode VARCHAR
	)';
	for rec in EXECUTE sql loop
		raise notice 'name:%',rec.sitename;
	end loop;
	execute 'truncate table sys_site_info';
	execute 'insert into sys_site_info '|| sql;

	perform dblink_disconnect('mainsite');
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_collect_site_infor
(
hostinfo text
)
IS 'Lins-经营报表-收集站点相关信息';

/*
description:通过Dblink方式收集玩家经营报表.
@author:Lins
@date:2015.10.27
@参数1:dblink CONNECTION
@参数2:站点ID
@参数3:统计开始时间
@参数4:统计结束时间
@参数5:0时区当前日期
@return:返回执行LOG信息.
*/
drop function IF EXISTS gamebox_master_operation_statement(text,int,text,text,date,text);
CREATE
OR REPLACE FUNCTION gamebox_master_operation_statement (
	conn TEXT,
	siteid INT,
	startTime TEXT,
	endTime TEXT,
	curday DATE,
	url text
) RETURNS TEXT AS $$
DECLARE
	rtn TEXT := '' ;
BEGIN
	SELECT
		INTO rtn P .msg
	FROM
		dblink (conn,
			'select * from gamebox_operations_statement(
'''||url||''','||siteid||','''||startTime||''','''||endTime||''')
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
	@参数1:0时区当前日期
	@return:返回执行LOG信息.
*/
drop function IF EXISTS gamebox_operation_site(text,date);
create or replace function gamebox_operation_site(
conn text
,curday date
) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;

BEGIN
	--清除当天的统计信息，保证每天只作一次统计信息
  rtn=rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from site_operate where to_char(static_time,'YYYY-MM-DD')=to_char(curday,'YYYY-MM-DD');
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';

  --开始执行站点经营报表信息收集
  rtn=rtn||'|开始执行'||curday||'站点经营报表||';
	INSERT INTO site_operate(
	site_id,site_name
	,center_id,center_name
  ,master_id,master_name
	,player_num,api_id
	,api_type_id,game_type
	,static_time,create_time
	,transaction_order
	,transaction_volume
	,effective_transaction
	,profit_loss
	,agent_num
	,top_agent_num
	,site_num
	)
  select s.siteid,s.sitename
	,s.operationid,s.operationname
  ,s.masterid,s.mastername
	,a.players_num,a.api_id
	,a.api_type_id,a.game_type
  ,current_date,now()
	,a.transaction_order
	,a.transaction_volume
	,a.effective_transaction_volume
	,a.transaction_profit_loss
	,0,0,0
	FROM
		dblink (conn,
			'select * from gamebox_operations_site('''||curday::text||''')
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
		) left join sys_site_info s on a.siteid=s.siteid;


	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'|执行完毕,新增记录数: '||v_count||' 条||';
	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_site
(
conn text
,curday date
)
IS 'Lins-经营报表-站点报表';




/**
 description:收集所有站点玩家游戏下单运营报表
 author:Lins
 date: 2015.10.27
 参数1:名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 参数2:名称.masterhost,类型.字符串数组,用途：所有站点数据库配置信息.
 参数3:开始时间
 参数4:结束时间
 参数5:站点ID
 参数6.splitchar,类型.字符串,用途:用来标示各个站点数据库配置信息的分隔符,如’|‘
 每个参数格式：host=数据库IP port=数据库端口 dbname=数据库名 user=用户名 password=密码
 调用例子：
 select gamebox_operations_statement(
 'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 ,'host=192.168.0.88 port=5432 dbname=gamebox-master user=postgres password=postgres'
 ,'2015-01-01 00:00:01','2015-12-29 23:59:59'
 ,'1|2','\|'
 );
*/
drop function IF EXISTS gamebox_operations_statement(text,text,text,text,text,text);
drop function IF EXISTS gamebox_operations_statement(text,text,text,text,text,text);
create or replace function gamebox_operations_statement(
mainhost text
,masterhost text
,startTime text
,endTime text
,sids text
,splitchar text
) returns text as $$
DECLARE
	masterhosts varchar[];
	startTimes varchar[];
	endTimes varchar[];
	siteids varchar[];
	rtn text:='';
BEGIN
	if mainhost is null or rtrim(ltrim(mainhost))='' THEN
		raise info '运营商库信息没有设置';
		return '运营商库信息没有设置';
	end if;

	if masterhost is null or rtrim(ltrim(masterhost))='' THEN
		raise info '站点库信息没有设置';
		return '站点库信息没有设置';
	end if;

  masterhosts:=regexp_split_to_array(masterhost,splitchar);
  startTimes:=regexp_split_to_array(startTime,splitchar);
	endTimes:=regexp_split_to_array(endTime,splitchar);
  siteids:=regexp_split_to_array(sids,splitchar);
	if array_length(masterhosts,1)>0 THEN
		for i in 1..array_length(masterhosts,1) loop
			raise notice '名称:%',masterhosts[i];
		end loop;
		--select gamebox_operations_statement(mainhost,masterhosts,startTimes,endTimes) into rtn;
		select gamebox_operations_statement(mainhost,masterhosts,startTimes,endTimes,siteids) into rtn;
	end if;
	--return '运行成功';
	raise info '%',rtn;
return rtn;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement
(
mainhost text
,masterhost text
,startTime text
,endTime text
,sids text
,splitchar text
)
IS 'Lins-经营报表-单站点报表-入口';


/**
 description:收集所有站点玩家游戏下单运营报表
 author:Lins
 date: 2015.10.27
 参数1:名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 参数2:名称.masterhost,类型.字符串数组,用途：所有站点数据库配置信息.
 每个参数格式：host=数据库IP port=数据库端口 dbname=数据库名 user=用户名 password=密码
 调用例子：
*/
drop function IF EXISTS gamebox_operations_statement(text,text[],text[],text[]);
drop function IF EXISTS gamebox_operations_statement(text,text[],text[],text[],text[]);
create or replace function gamebox_operations_statement(
mainhost text
,masterhost text[]
,startTimes text[]
,endTimes text[]
,siteids text[]
) returns text as $$
DECLARE
	curday date;
	rtn text:='';
	tmp text:='';
BEGIN
	--设置当前日期.
	select CURRENT_DATE into curday;
	if mainhost is null or rtrim(ltrim(mainhost))='' THEN
		raise info '运营商库信息没有设置';
		return '运营商库信息没有设置';
	end if;

	if masterhost is null or array_length(masterhost, 1)<0 THEN
		raise info '站点库信息没有设置';
		return '站点库信息没有设置';
	end if;

	--关闭所有链接.
  perform dblink_close_all();
	--收集当前所有运营站点相关信息.
  perform gamebox_collect_site_infor(mainhost);
	--拆分所有站点数据库信息.
  rtn=rtn||'1.  开始执行各个站点玩家经营报表';
	for i in 1..array_length(masterhost, 1) loop
     raise notice '%.当前站点库信息：%',i,masterhost[i];
			if rtrim(ltrim(masterhost[i]))='' THEN
				return '站点库信息不能为空';
			end if;
			--连接站点库
		  perform dblink_connect('master',masterhost[i]);
			--执行玩家经营报表
			raise info '%.开始收集站点%的玩家下单信息',i,masterhost[i];
			rtn=rtn||'|||1.'||i||'.开始收集.站点.'||i||'.玩家报表.';
			select gamebox_master_operation_statement('master',siteids[i]::int,startTimes[i],endTimes[i],curday,mainhost) into tmp;
			rtn=rtn||'||'||tmp;
		  raise info '%.收集完毕',i;
			--收集站点经营报表
			rtn=rtn||'2.  开始执行站点经营报表';
			select gamebox_operation_site('master',curday) into tmp;
			rtn=rtn||'||'||tmp;
		  perform dblink_disconnect('master');
	end loop;
return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement
(
mainhost text
,masterhost text[]
,startTimes text[]
,endTimes text[]
,siteids text[]
)
IS 'Lins-经营报表-多站点入口';

/*

 select gamebox_operations_statement(
 'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 ,'host=192.168.0.88 port=5432 dbname=gamebox-master user=postgres password=postgres'
 ,'2015-01-01 00:00:01','2015-12-29 23:59:59'
 ,'1|2','\|'
 );


*/
