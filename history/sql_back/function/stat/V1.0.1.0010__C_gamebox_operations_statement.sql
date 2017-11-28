
/*
description:关闭当前所有跨数据库链接
author:Lins
date:2015.10.27
*/
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


/*
	description:收集当前所有运营站点相关信息
	author:Lins
	date: 2015.10.27
  参数1:名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 select gamebox_operations_statement(
 'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 );
*/
create or replace function gamebox_collect_site_infor(hostinfo text) returns void as $$
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
--drop function gamebox_player_statement(text,int,text,text,date);
create or replace function gamebox_player_statement(conn text,siteid int,startTime text,endTime text,curday date) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;
		curday date;
BEGIN
  --清除当天的统计信息，保证每天只作一次统计信息
	select current_date into curday;
	--raise info '%',curday;
	rtn=rtn||'| |清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operating_report_players where statistical_date=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';
	--开始执行玩家经营报表信息收集
	--raise info '%',sql0||sql;
  --rtn=rtn||'| |开始执行'||curday||'玩家统计报表||';
		raise info '开始日期:%,结束日期:%',startTime,endTime;
 	INSERT INTO operating_report_players(
			site_id,site_name,
			operator_id,operator_name,
			master_id,master_name,
			top_agent_id,top_agent_name,
			agent_id,agent_name,
			user_id,user_name,
			api_id,
			game_type_parent,game_type,
			statistical_date,create_time,
			transaction_order,
			transaction_volume,
			effective_transaction_volume,
			transaction_profit_loss)
 SELECT s.siteid,s.sitename,s.operationid,s.operationname,s.masterid,s.mastername,p.topagentid,p.topagentusername,p.agentid,p.agentusername
			,p.playerId,p.player,p.api,p.gametypeparent,p.gametype,curday,now() create_time,p.transaction_order,p.transaction_volume,p.effective_transaction_volume,p.transaction_profit_loss
	FROM
		dblink (conn,
			'select * from player_operation_statement('||siteid||','''||startTime||''','''||endTime||''')
		 AS Q(
				player VARCHAR,
				playerId int4,
				site_id int4,
				top_agent_id int4,
				top_agent_user_name VARCHAR,
				agent_id int4,
				agent_user_name VARCHAR,
				api int4,
				game_id int4,
				game_type VARCHAR,
				game_type_parent VARCHAR,
				transaction_order BIGINT,
				transaction_volume NUMERIC,
				transaction_profit_loss NUMERIC,
				effective_transaction_volume NUMERIC
			)'
		) AS p(
			player VARCHAR,
			playerid int4,
			siteid int4,
			topagentid int4,
			topagentusername VARCHAR,
			agentid int4,
			agentusername VARCHAR,
			api int4,
			gameid int4,
			gametype VARCHAR,
			gametypeparent VARCHAR,
			transaction_order BIGINT,
			transaction_volume NUMERIC,
			transaction_profit_loss NUMERIC,
			effective_transaction_volume NUMERIC
		) left join sys_site_info s on p.siteid=s.siteid ;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'| |执行完毕,新增记录数: '||v_count||' 条||';
	return rtn;
END
$$ LANGUAGE plpgsql;


/**
	description:代理经营报表
	author:Lins
	date:2015.10.28
	note:玩家一天多次下单在统计玩家人数时，只算一个
	@参数1:0时区当前日期
	@return:返回执行LOG信息.
*/
--drop function gamebox_agent_statement(date);
create or replace function gamebox_agent_statement(curday date) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;

BEGIN
  --清除当天的统计信息，保证每天只作一次统计信息
	raise info '清除当天的统计信息，保证每天只作一次统计信息';
  rtn=rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operating_report_agent where statistical_date=curday::date;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';

	--开始执行代理经营报表信息收集
  rtn=rtn||'|开始执行'||curday||'代理经营报表||';
	--执行代理统计
	INSERT INTO operating_report_agent(
	site_id,site_name
	,operator_id,operator_name
  ,master_id,master_name
  ,top_agent_id,top_agent_name
  ,agent_id,agent_name
	,players_num,api_id
	,game_type_parent,game_type
	,statistical_date,create_time
	,transaction_order
	,transaction_volume
	,effective_transaction_volume
	,transaction_profit_loss
	)
select s.siteid,s.sitename
	,s.operationid,s.operationname
  ,s.masterid,s.mastername
  ,a.top_agent_id,a.top_agent_name
  ,a.agent_id,a.agent_name
	,a.player_num,a.api_id
	,a.game_type_parent,a.game_type
  ,current_date sta_date,now() create_time
	,a.order_num
	,a.transaction_volume
	,a.effective_transaction_volume
	,a.transaction_profit_loss
from
(
  select p.site_id,p.agent_id,agent_name,top_agent_id,top_agent_name,
  p.api_id,p.game_type,p.game_type_parent,
	count(p.user_id) as player_num,
  SUM (order_num) as order_num,
	SUM (p.transaction_volume) as transaction_volume,
	SUM (p.effective_transaction_volume) as effective_transaction_volume,
	SUM (p.transaction_profit_loss) as transaction_profit_loss
from
(
  select
  site_id,agent_id,agent_name,top_agent_id,top_agent_name,
  user_id,api_id,game_type,game_type_parent,
	SUM (transaction_order) as order_num,
	SUM (transaction_volume) as transaction_volume,
	SUM (effective_transaction_volume) as effective_transaction_volume,
	SUM (transaction_profit_loss) as transaction_profit_loss
	FROM
	operating_report_players where statistical_date=curday::date
	group by  site_id,agent_id,agent_name
	,top_agent_id,top_agent_name,
	user_id,api_id,game_type,game_type_parent
) as p group by p.site_id,p.agent_id,p.agent_name
 ,p.top_agent_id,p.top_agent_name
 ,p.api_id,p.game_type,p.game_type_parent
order by p.site_id,p.agent_id
)
 as a left join sys_site_info s on a.site_id=s.siteid;
--END
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'|执行完毕,新增记录数: '||v_count||' 条||';
	return rtn;
END
$$ LANGUAGE plpgsql;



/**
	description:总代经营报表
	author:Lins
	date:2015.10.28
		@参数1:0时区当前日期
	@return:返回执行LOG信息.
*/
--drop function gamebox_topagent_statement(date);
create or replace function gamebox_topagent_statement(curday date) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;


BEGIN
  --清除当天的统计信息，保证每天只作一次统计信息
	rtn=rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operating_report_top_agent where statistical_date=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';
	--开始执行总代经营报表信息收集
  rtn=rtn||'|开始执行'||curday||'总代经营报表||';


	INSERT INTO operating_report_top_agent(
	site_id,site_name
	,operator_id,operator_name
  ,master_id,master_name
  ,top_agent_id,top_agent_name
	,players_num,api_id
	,game_type_parent,game_type
	,statistical_date,create_time
	,transaction_order
	,transaction_volume
	,effective_transaction_volume
	,transaction_profit_loss
	)
  select s.siteid,s.sitename
	,s.operationid,s.operationname
  ,s.masterid,s.mastername
  ,a.top_agent_id,a.top_agent_name
	,a.players_num,a.api_id
	,a.game_type_parent,a.game_type
  ,current_date sta_date,now() create_time
	,a.transaction_order
	,a.transaction_volume
	,a.effective_transaction_volume
	,a.transaction_profit_loss
from
(
  select site_id,top_agent_id,top_agent_name,
  api_id,game_type,game_type_parent,
	SUM(players_num) as players_num,
	SUM (transaction_order) as transaction_order,
	SUM (transaction_volume) as transaction_volume,
	SUM (effective_transaction_volume) as effective_transaction_volume,
	SUM (transaction_profit_loss) as transaction_profit_loss
  from operating_report_agent
  where statistical_date=curday
  group by site_id,top_agent_id,top_agent_name,api_id,game_type,game_type_parent
)as a left join sys_site_info s on a.site_id=s.siteid;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'|执行完毕,新增记录数: '||v_count||' 条||';
	return rtn;
END
$$ LANGUAGE plpgsql;

/**
	description:站点经营报表
	author:Lins
	date:2015.10.28
	@参数1:0时区当前日期
	@return:返回执行LOG信息.
*/
--drop function gamebox_site_statement(date);
create or replace function gamebox_site_statement(curday date) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;

BEGIN
	--清除当天的统计信息，保证每天只作一次统计信息
  rtn=rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operating_report_site where statistical_date=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';

  --开始执行站点经营报表信息收集
  rtn=rtn||'|开始执行'||curday||'站点经营报表||';
	INSERT INTO operating_report_site(
	site_id,site_name
	,operator_id,operator_name
  ,master_id,master_name
	,players_num,api_id
	,game_type_parent,game_type
	,statistical_date,create_time
	,transaction_order
	,transaction_volume
	,effective_transaction_volume
	,transaction_profit_loss
	)
  select s.siteid,s.sitename
	,s.operationid,s.operationname
  ,s.masterid,s.mastername
	,a.players_num,a.api_id
	,a.game_type_parent,a.game_type
  ,current_date sta_date,now() create_time
	,a.transaction_order
	,a.transaction_volume
	,a.effective_transaction_volume
	,a.transaction_profit_loss
from
(
  select site_id,api_id,game_type,game_type_parent,
	SUM(players_num) as players_num,
	SUM (transaction_order) as transaction_order,
	SUM (transaction_volume) as transaction_volume,
	SUM (effective_transaction_volume) as effective_transaction_volume,
	SUM (transaction_profit_loss) as transaction_profit_loss
	from operating_report_top_agent
	where statistical_date=curday
	group by site_id,api_id,game_type,game_type_parent

)as a left join sys_site_info s on a.site_id=s.siteid;
	--END
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'|执行完毕,新增记录数: '||v_count||' 条||';
	return rtn;
END
$$ LANGUAGE plpgsql;



/**
 description:收集所有站点玩家游戏下单运营报表
 author:Lins
 date: 2015.10.27
 参数1:名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 参数2:名称.masterhost,类型.字符串数组,用途：所有站点数据库配置信息.
 参数3:名称.splitchar,类型.字符串,用途:用来标示各个站点数据库配置信息的分隔符,如’|‘
 每个参数格式：host=数据库IP port=数据库端口 dbname=数据库名 user=用户名 password=密码
 调用例子：
 select gamebox_operations_statement(
 'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres',
 'host=192.168.0.88 port=5432 dbname=gamebox-master user=postgres password=postgres|host=192.168.0.88 port=5432 dbname=gamebox-master user=postgres password=postgres','|'
 );
*/
--drop function IF EXISTS gamebox_operations_statement(text,text,text,text,text);
create or replace function gamebox_operations_statement(mainhost text,masterhost text,startTime text,endTime text,splitchar text) returns text as $$
DECLARE
	masterhosts varchar[];
	startTimes varchar[];
	endTimes varchar[];
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
	if array_length(masterhosts,1)>0 THEN
		for i in 1..array_length(masterhosts,1) loop
			raise notice '名称:%',masterhosts[i];
		end loop;
		select gamebox_operations_statement(mainhost,masterhosts,startTimes,endTimes) into rtn;
	end if;
	--return '运行成功';
	raise info '%',rtn;
return rtn;
END
$$ language plpgsql;


/**
 description:收集所有站点玩家游戏下单运营报表
 author:Lins
 date: 2015.10.27
 参数1:名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 参数2:名称.masterhost,类型.字符串数组,用途：所有站点数据库配置信息.
 每个参数格式：host=数据库IP port=数据库端口 dbname=数据库名 user=用户名 password=密码
 调用例子：
 select f_player_order_statistication(
 'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres',
 array['host=192.168.0.88 port=5432 dbname=gamebox-master user=postgres password=postgres']
 );
*/
--drop function IF EXISTS gamebox_operations_statement(text,text[],text[],text[]);
create or replace function gamebox_operations_statement(mainhost text,masterhost text[],startTimes text[],endTimes text[]) returns text as $$
DECLARE
	curday date;
	rtn text:='';
	tmp text:='';
BEGIN
	--设置当前日期.
	select CURRENT_DATE into curday;
	--raise notice 'ip:%',hostinfo;
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
			select gamebox_player_statement('master',1,startTimes[i],endTimes[i],curday) into tmp;
			rtn=rtn||'||'||tmp;
		  raise info '%.收集完毕',i;
			--处理另外一些报表信息收集
			--@todo
		  perform dblink_disconnect('master');
	end loop;
			--统一执行代理以上的经营报表
			--执行代理经营报表
			rtn=rtn||'2.  开始执行代理经营报表';
			select gamebox_agent_statement(curday) into tmp;
			rtn=rtn||'||'||tmp;
			--执行总代经营报表
			rtn=rtn||'3.  开始执行总代经营报表';
			select gamebox_topagent_statement(curday) into tmp;
			rtn=rtn||'||'||tmp;
			--执行站点经营报表
			rtn=rtn||'4.  开始执行站点经营报表';
			select gamebox_site_statement(curday) into tmp;
			rtn=rtn||'||'||tmp;

	--return '运营信息收集完毕';
return rtn;
END
$$ LANGUAGE plpgsql;

