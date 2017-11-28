

/*
	description:收集当前所有运营站点相关信息
	author:Lins
	date: 2015.10.27
  参数1:名称.mainhost,类型.字符串，用途：运营数据库配置信息.

*/
drop function IF EXISTS gamebox_collect_site_infor(text,int);
create or replace function gamebox_collect_site_infor(hostinfo text,site_id int) returns json as $$
declare
	rec record;
BEGIN
	SELECT into rec * FROM
	dblink (
		hostinfo,
		'select * from v_sys_site_info where siteid='||site_id||''
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
	);

	IF FOUND THEN
		return row_to_json(rec);
	ELSE
	  return (select '{"siteid": -1}'::json);
	END IF;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_collect_site_infor(
hostinfo text,site_id int
)
 IS 'Lins-经营报表-收集站点相关信息';


/**
 description:收集所有站点玩家游戏下单运营报表
 author:Lins
 date: 2015.10.27
 参数1:名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 参数2:名称.masterhost,类型.字符串数组,用途：所有站点数据库配置信息.
 每个参数格式：host=数据库IP port=数据库端口 dbname=数据库名 user=用户名 password=密码
 调用例子：
 select gamebox_operations_statement
 (
 'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 ,1,'2015-01-08 00:00:01','2015-12-18 23:59:59'
 );
*/

drop function IF EXISTS gamebox_operations_statement(text,int,text,text);
create or replace function gamebox_operations_statement(
mainhost text
,sid int
,start_time text
,end_time text
) returns text as $$
DECLARE
	curday date;
	rtn text:='';
	tmp text:='';
	--当前站点信息
	rec json;
	red record;
	vname text:='vp_site_game';
  cnum int:=0;
BEGIN
	--设置当前日期.
	select CURRENT_DATE into curday;
	--raise notice 'ip:%',hostinfo;
	if mainhost is null or rtrim(ltrim(mainhost))='' THEN
		raise info '运营商库信息没有设置';
		return '运营商库信息没有设置';
	end if;

	--关闭所有链接.
  --perform dblink_close_all();
	--收集当前所有运营站点相关信息.
  select gamebox_collect_site_infor(mainhost,sid) into rec;
	IF rec->>'siteid' ='-1' THEN
			rtn='运营商库中不存在当前站点的相关信息,请确保此站点是否合法.';
			raise info '%',rtn;
			return rtn;
	END IF;
	--创建临时游戏表.
	raise info '经营报表.site_game临时视图';
  perform gamebox_site_game(mainhost,vname,sid,'C');

	--拆分所有站点数据库信息.
  rtn=rtn||'1. 开始收集站点玩家下单信息';
	select gamebox_operations_player(start_time,end_time,curday,rec) into tmp;
	rtn=rtn||'||'||tmp;
	--raise info '%.收集完毕',i;

	--处理另外一些报表信息收集

	--统一执行代理以上的经营报表
	--执行代理经营报表
	rtn=rtn||'2.  开始执行代理经营报表';
	select gamebox_operations_agent(curday,rec) into tmp;
	rtn=rtn||'||'||tmp;
	--执行总代经营报表
	rtn=rtn||'3.  开始执行总代经营报表';
	select gamebox_operations_topagent(curday,rec) into tmp;
	rtn=rtn||'||'||tmp;

	--删除临时视图表.
	perform gamebox_site_game(mainhost,vname,sid,'D');

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(
mainhost text
,sid int
,start_time text
,end_time text
)
 IS 'Lins-经营报表-入口';

/*
description:收集玩家经营报表.
@author:Lins
@date:2015.10.27
@参数1:统计开始时间
@参数2:统计结束时间
@参数3:0时区当前日期
@参数4:当前站点信息
@return:返回执行LOG信息.
*/
drop function IF EXISTS gamebox_operations_player(text,text,date,json);
create or replace function gamebox_operations_player(
start_time text
,end_time text
,curday date
,rec json
) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;
		--curday date;
BEGIN
  --清除当天的统计信息，保证每天只作一次统计信息
	--select current_date into curday;
	--raise info '%',curday;
	rtn=rtn||'| |清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operating_report_players where statistical_date=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';
	--开始执行玩家经营报表信息收集
  --rtn=rtn||'| |开始执行'||curday||'玩家统计报表||';
	raise info '开始日期:%,结束日期:%',start_time,end_time;
 	INSERT INTO operating_report_players(
			site_id,top_agent_id,top_agent_name,
			agent_id,agent_name,
			user_id,user_name,api_id,
			api_type_id,game_type,
			statistical_date,create_time,
			transaction_order,
			transaction_volume,
			effective_transaction_volume,
			transaction_profit_loss)
  SELECT
	  u.site_id,topagent.id,topagent.username,
    agent.id,agent.username,
    p.player_id,u.username,p.api_id,
		p.api_type_id,p.game_type,
    CURRENT_DATE,now(),
    p.transaction_order,p.transaction_volume,
    p.effective_transaction_volume,p.transaction_profit_loss
   FROM (
						SELECT o.player_id,
            o.api_id,
            g.api_type_id,g.game_type,
            count(o.order_no) AS transaction_order,
            sum(COALESCE(o.single_amount,0.00)) AS transaction_volume,
            sum(COALESCE(o.profit_amount,0.00)) AS transaction_profit_loss,
            sum(COALESCE(o.effective_trade_amount,0.00)) AS effective_transaction_volume
           FROM player_game_order o,vp_site_game g
					 WHERE o.game_id=g.id and o.create_time>=start_time::TIMESTAMP
						and o.create_time<end_time::TIMESTAMP
          GROUP BY o.player_id, o.api_id, g.api_type_id,g.game_type
					order by o.player_id,o.api_id,g.api_type_id,g.game_type
		) p LEFT JOIN sys_user u ON p.player_id = u.id
     LEFT JOIN sys_user agent ON u.owner_id = agent.id
     LEFT JOIN sys_user topagent ON agent.owner_id = topagent.id
		 where u.user_type='24' and agent.user_type='23' and topagent.user_type='22';


	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'| |执行完毕,新增记录数: '||v_count||' 条||';
	--更新站点相关信息
	UPDATE operating_report_players SET SITE_NAME=rec->>'sitename',center_id=(rec->>'operationid')::int
		,center_name=rec->>'operationname',master_id=(rec->>'masterid')::int,master_name=rec->>'mastername' where statistical_date=curday AND site_id=(rec->>'siteid')::int;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次更新数据量 %', v_count;
	return rtn;
END
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(
start_time text
,end_time text
,curday date
,rec json
)
 IS 'Lins-经营报表-玩家报表';


/**
	description:代理经营报表
	author:Lins
	date:2015.10.28
	note:玩家一天多次下单在统计玩家人数时，只算一个
	@参数1:0时区当前日期
	@return:返回执行LOG信息.
*/

drop function IF EXISTS gamebox_operations_agent(date,json);
create or replace function gamebox_operations_agent(curday date,rec json) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;

BEGIN
  --清除当天的统计信息，保证每天只作一次统计信息
	raise info '清除当天的统计信息，保证每天只作一次统计信息';
  rtn=rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operating_report_agent where statistical_date=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';

	--开始执行代理经营报表信息收集
  rtn=rtn||'|开始执行'||curday||'代理经营报表||';
	--执行代理统计
	INSERT INTO operating_report_agent(
	center_id,center_name,master_id,master_name,
	site_id,top_agent_id,top_agent_name
  ,agent_id,agent_name,api_id
	,api_type_id,game_type,players_num
	,statistical_date,create_time
	,transaction_order
	,transaction_volume
	,effective_transaction_volume
	,transaction_profit_loss
	)
  select
	 -1,'',-1,''
	 ,p.site_id,p.top_agent_id,p.top_agent_name
	,p.agent_id,p.agent_name,p.api_id
  ,p.api_type_id,p.game_type,count(DISTINCT p.user_id)
	,curday,now(),
  SUM (order_num) as order_num,
	SUM (p.transaction_volume) as transaction_volume,
	SUM (p.effective_transaction_volume) as effective_transaction_volume,
	SUM (p.transaction_profit_loss) as transaction_profit_loss
from
(
  select
  site_id,agent_id,agent_name,top_agent_id,top_agent_name,
  user_id,api_id,game_type,api_type_id,
	SUM (COALESCE(transaction_order,0)) as order_num,
	SUM (COALESCE(transaction_volume,0.00)) as transaction_volume,
	SUM (COALESCE(effective_transaction_volume,0.00)) as effective_transaction_volume,
	SUM (COALESCE(transaction_profit_loss,0.00)) as transaction_profit_loss
	FROM
	operating_report_players where statistical_date=curday
	group by  site_id,agent_id,agent_name
	,top_agent_id,top_agent_name,
	user_id,api_id,game_type,api_type_id
) as p group by p.site_id,p.agent_id,p.agent_name
 ,p.top_agent_id,p.top_agent_name
 ,p.api_id,p.game_type,p.api_type_id;

--END
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'|执行完毕,新增记录数: '||v_count||' 条||';

	--更新站点相关信息
	UPDATE operating_report_agent SET SITE_NAME=rec->>'sitename',center_id=(rec->>'operationid')::int
		,center_name=rec->>'operationname',master_id=(rec->>'masterid')::int,master_name=rec->>'mastername' where statistical_date=curday AND site_id=(rec->>'siteid')::int;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次更新数据量 %', v_count;

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_agent(
curday date
,rec json
)
 IS 'Lins-经营报表-代理报表';

/**
	description:总代经营报表
	author:Lins
	date:2015.10.28
		@参数1:0时区当前日期
	@return:返回执行LOG信息.
*/

drop function IF EXISTS gamebox_operations_topagent(date,json);
create or replace function gamebox_operations_topagent(curday date,rec json) returns text as $$
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
	 center_id,center_name,master_id,master_name
	,site_id,top_agent_id,top_agent_name
	,api_id,api_type_id,game_type
	,players_num,statistical_date,create_time
	,transaction_order,transaction_volume,effective_transaction_volume
	,transaction_profit_loss
	)
  select
  -1,'',-1,'',
	site_id,top_agent_id,top_agent_name,
  api_id,api_type_id,game_type,
	SUM(players_num) as players_num,curday,now(),
	SUM (COALESCE(transaction_order,0)) as transaction_order,
	SUM (COALESCE(transaction_volume,0.00)) as transaction_volume,
	SUM (COALESCE(effective_transaction_volume,0.00)) as effective_transaction_volume,
	SUM (COALESCE(transaction_profit_loss,0.00)) as transaction_profit_loss
  from operating_report_agent
  where statistical_date=curday
  group by site_id,top_agent_id,top_agent_name,api_id,game_type,api_type_id;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'|执行完毕,新增记录数: '||v_count||' 条||';

	--更新站点相关信息
	UPDATE operating_report_top_agent SET SITE_NAME=rec->>'sitename',center_id=(rec->>'operationid')::int
		,center_name=rec->>'operationname',master_id=(rec->>'masterid')::int,master_name=rec->>'mastername' where statistical_date=curday AND site_id=(rec->>'siteid')::int;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次更新数据量 %', v_count;

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_topagent(
curday date
,rec json
)
 IS 'Lins-经营报表-总代报表';

/**
	description:站点经营报表
	author:Lins
	date:2015.10.28
	@参数1:0时区当前日期
	@return:返回执行LOG信息.
*/
drop function if exists gamebox_operations_site(TEXT);
create or replace function gamebox_operations_site(curday text) returns SETOF record as $$
DECLARE
	rec record;
BEGIN
	FOR rec IN
  select site_id,api_id,game_type,api_type_id,
	SUM (players_num) as players_num,
	SUM (transaction_order) as transaction_order,
	SUM (transaction_volume) as transaction_volume,
	SUM (effective_transaction_volume) as effective_transaction_volume,
	SUM (transaction_profit_loss) as transaction_profit_loss
	from operating_report_top_agent
	where statistical_date=curday::date
	group by site_id,api_id,game_type,api_type_id
	LOOP
		RETURN NEXT rec;
	END LOOP;
END
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_site(
curday TEXT
)
 IS 'Lins-经营报表-站点报表';

/*

 select gamebox_operations_statement
 (
 'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 ,1,'2015-01-08 00:00:01','2015-12-18 23:59:59'
 );

*/