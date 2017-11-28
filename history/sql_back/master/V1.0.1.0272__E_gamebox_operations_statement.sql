-- auto gen by Lins 2015-12-22 06:59:34


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
 参数2:站点ID
 参数3:开始时间
 参数4:结束时间
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
	curday TEXT;
	rtn text:='';
	tmp text:='';
	--当前站点信息
	rec json;
	red record;
	vname text:='vp_site_game';
  cnum int:=0;
BEGIN
	--设置当前日期.
	select CURRENT_DATE::TEXT into curday;
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
	--raise info '经营报表.site_game临时视图';
 -- perform gamebox_site_game(mainhost,vname,sid,'C');

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
	--perform gamebox_site_game(mainhost,vname,sid,'D');

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
drop function IF EXISTS gamebox_operations_player(text,text,TEXT,json);
create or replace function gamebox_operations_player(
start_time text
,end_time text
,curday TEXT
,rec json
) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;
		--curday date;

		site_id INT;
		master_id INT;
		center_id INT;
		site_name TEXT:='';
		master_name TEXT:='';
		center_name TEXT:='';
BEGIN
  --清除当天的统计信息，保证每天只作一次统计信息
	--select current_date into curday;
	--raise info '%',curday;
	rtn=rtn||'| |清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operate_player where to_char(static_time, 'YYYY-MM-dd')=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';
	--开始执行玩家经营报表信息收集
  --rtn=rtn||'| |开始执行'||curday||'玩家统计报表||';

	site_id=COALESCE((rec->>'siteid')::INT,-1);
	site_name=COALESCE(rec->>'sitename','');
	master_id=COALESCE((rec->>'masterid')::INT,-1);
	master_name=COALESCE(rec->>'mastername','');
	center_id=COALESCE((rec->>'operationid')::INT,-1);
	center_name=COALESCE(rec->>'operationname','');

	raise info '开始日期:%,结束日期:%',start_time,end_time;
 	INSERT INTO operate_player
	(
			center_id,center_name
			,master_id,master_name
			,site_id,site_name
			,topagent_id,topagent_name
			,agent_id,agent_name
			,player_id,player_name
			,api_id,api_type_id,game_type
			,static_time,create_time
			,transaction_order
			,transaction_volume
			,effective_transaction
			,profit_loss
  )SELECT
	  center_id,center_name
		,master_id,master_name
		,site_id,site_name
		,u.topagent_id,u.topagent_name
    ,u.agent_id,u.agent_name
    ,u.id,u.username
		,p.api_id,p.api_type_id,p.game_type
    ,now(),now()
    ,p.transaction_order,p.transaction_volume
    ,p.effective_transaction,p.profit_loss
   FROM (
						SELECT
						player_id,
            api_id,
            api_type_id,
						game_type,
            count(order_no) AS transaction_order,
            sum(COALESCE(single_amount,0.00)) AS transaction_volume,
            sum(COALESCE(profit_amount,0.00)) AS profit_loss,
            sum(COALESCE(effective_trade_amount,0.00)) AS effective_transaction
           FROM player_game_order
					 WHERE  create_time>=start_time::TIMESTAMP and create_time<end_time::TIMESTAMP
           GROUP BY player_id, api_id, api_type_id,game_type
		) p,v_sys_user_tier u
	where p.player_id=u.id ;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'| |执行完毕,新增记录数: '||v_count||' 条||';

	return rtn;
END
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(
start_time text
,end_time text
,curday TEXT
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

drop function IF EXISTS gamebox_operations_agent(TEXT,json);
create or replace function gamebox_operations_agent(curday TEXT,rec json) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;
		s_id INT;
		m_id INT;
		c_id INT;
		s_name TEXT:='';
		m_name TEXT:='';
		c_name TEXT:='';
BEGIN
  --清除当天的统计信息，保证每天只作一次统计信息
	raise info '清除当天的统计信息，保证每天只作一次统计信息';
  rtn=rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operate_agent where to_char(static_time, 'YYYY-MM-dd')=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';

	--开始执行代理经营报表信息收集
  rtn=rtn||'|开始执行'||curday||'代理经营报表||';

	s_id=COALESCE((rec->>'siteid')::INT,-1);
	s_name=COALESCE(rec->>'sitename','');
	m_id=COALESCE((rec->>'masterid')::INT,-1);
	m_name=COALESCE(rec->>'mastername','');
	c_id=COALESCE((rec->>'operationid')::INT,-1);
	c_name=COALESCE(rec->>'operationname','');
	--执行代理统计
	INSERT INTO operate_agent(
			center_id,center_name
			,master_id,master_name
			,site_id,site_name
			,topagent_id,topagent_name
			,agent_id,agent_name
			,api_id,api_type_id,game_type
			,static_time,create_time
			,player_num
			,transaction_order
			,transaction_volume
			,effective_transaction
			,profit_loss
	)
  SELECT
	c_id,c_name
	,m_id,m_name
	,s_id,s_name
	,topagent_id,topagent_name,agent_id,agent_name
	,api_id,api_type_id,game_type
	,now(),now(),
	COUNT(DISTINCT player_id) as player_num,
	SUM (COALESCE(transaction_order,0)) as transaction_order,
	SUM (COALESCE(transaction_volume,0.00)) as transaction_volume,
	SUM (COALESCE(effective_transaction,0.00)) as effective_transaction,
	SUM (COALESCE(profit_loss,0.00)) as profit_loss
	FROM operate_player
	where to_char(static_time, 'YYYY-MM-dd')=curday
	group by topagent_id,topagent_name,agent_id,agent_name
	,api_id,api_type_id,game_type;

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'|执行完毕,新增记录数: '||v_count||' 条||';

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_agent(
curday TEXT
,rec json
)IS 'Lins-经营报表-代理报表';

/**
	description:总代经营报表
	author:Lins
	date:2015.10.28
		@参数1:0时区当前日期
	@return:返回执行LOG信息.
*/

drop function IF EXISTS gamebox_operations_topagent(TEXT,json);
create or replace function gamebox_operations_topagent(curday TEXT,rec json) returns text as $$
DECLARE
		rtn text:='';
		v_count	int4:=0;
		s_id INT;
		m_id INT;
		c_id INT;
		s_name TEXT:='';
		m_name TEXT:='';
		c_name TEXT:='';
BEGIN
  --清除当天的统计信息，保证每天只作一次统计信息
	rtn=rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operate_topagent where to_char(static_time, 'YYYY-MM-dd')=curday;
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次删除记录数 %', v_count;
  rtn=rtn||'| |执行完毕,删除记录数: '||v_count||' 条||';
	--开始执行总代经营报表信息收集
  rtn=rtn||'|开始执行'||curday||'总代经营报表||';

	s_id=COALESCE((rec->>'siteid')::INT,-1);
	s_name=COALESCE(rec->>'sitename','');
	m_id=COALESCE((rec->>'masterid')::INT,-1);
	m_name=COALESCE(rec->>'mastername','');
	c_id=COALESCE((rec->>'operationid')::INT,-1);
	c_name=COALESCE(rec->>'operationname','');

	INSERT INTO operate_topagent(
			center_id,center_name
			,master_id,master_name
			,site_id,site_name
			,topagent_id,topagent_name
			,api_id,api_type_id,game_type
			,static_time,create_time
			,agent_num,player_num
			,transaction_order
			,transaction_volume
			,effective_transaction
			,profit_loss
	)
  SELECT
	c_id,c_name
	,m_id,m_name
	,s_id,s_name
	,topagent_id,topagent_name
	,api_id,api_type_id,game_type
	,now(),now(),
	COUNT(DISTINCT agent_id) as agent_num,
	SUM(player_num) as player_num,
	SUM (COALESCE(transaction_order,0)) as transaction_order,
	SUM (COALESCE(transaction_volume,0.00)) as transaction_volume,
	SUM (COALESCE(effective_transaction,0.00)) as effective_transaction,
	SUM (COALESCE(profit_loss,0.00)) as profit_loss
	FROM operate_agent
	where to_char(static_time, 'YYYY-MM-dd')=curday
	group by topagent_id,topagent_name
	,api_id,api_type_id,game_type;


	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '本次插入数据量 %', v_count;
  rtn=rtn||'|执行完毕,新增记录数: '||v_count||' 条||';

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_topagent(
curday TEXT
,rec json
)IS 'Lins-经营报表-总代报表';

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
	SUM (player_num) as players_num,
	SUM (transaction_order) as transaction_order,
	SUM (transaction_volume) as transaction_volume,
	SUM (effective_transaction) as effective_transaction_volume,
	SUM (profit_loss) as transaction_profit_loss
	from operate_topagent
	where to_char(static_time, 'YYYY-MM-dd')=curday
	group by site_id,api_id,game_type,api_type_id
	LOOP
		RETURN NEXT rec;
	END LOOP;
END
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_site(
curday TEXT
)IS 'Lins-经营报表-站点报表';

/*

 select gamebox_operations_statement
 (
 'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 ,1,'2015-01-08 00:00:01','2015-12-18 23:59:59'
 );

*/