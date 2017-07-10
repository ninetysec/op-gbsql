/**
 * 收集当前所有运营站点相关信息
 * @author	Lins
 * @date 	2015.10.27
 * @param 	hostinfo	名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 * @param 	site_id		站长ID
**/
drop function IF EXISTS gamebox_collect_site_infor(text, int);
create or replace function gamebox_collect_site_infor(
  hostinfo   text,
  site_id   int
) returns json as $$
declare
  rec record;
BEGIN
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-收集站点相关信
--v1.10  2017/07/01  Leisure  修改DBLINK的连接方式
*/
  --v1.10  2017/07/01  Leisure
  perform dblink_connect_u('mainsite', hostinfo);

  SELECT into rec * FROM
  dblink (
    'mainsite',  -- hostinfo, --v1.01  2017/07/01  Leisure
    'SELECT * from v_sys_site_info WHERE siteid='||site_id||''
  ) AS s (
    siteid     int4,    --站点ID
    sitename   VARCHAR,    --站点名称
    masterid   int4,    --站长ID
    mastername   VARCHAR,    --站长名称
    usertype   VARCHAR,    --用户类型
    subsyscode   VARCHAR,
    operationid int4,    --运营商ID
    operationname     VARCHAR,    --运营商名称
    operationusertype   VARCHAR,
    operationsubsyscode VARCHAR
  );

  perform dblink_disconnect('mainsite');

  IF FOUND THEN
    return row_to_json(rec);
  ELSE
    return (SELECT '{"siteid": -1}'::json);
  END IF;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_collect_site_infor(hostinfo text,site_id int)
IS 'Lins-经营报表-收集站点相关信息';

/**
 * description:收集所有站点玩家游戏下单运营报表
 * author 	Lins
 * date 	2015.10.27
 * @param 	mainhost 	名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 * @param 	sid 		站点ID
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
**/
/*
drop function IF EXISTS gamebox_operations_statement(text,int,text,text);
create or replace function gamebox_operations_statement(
	mainhost 	text,
	sid 	int,
	start_time 	text,
	end_time 	text
) returns text as $$
DECLARE
	curday 	TEXT;
	rtn 	text:='';
	tmp 	text:='';
	rec 	json;
	red 	record;
	vname 	text:='vp_site_game';
	cnum 	int:=0;
BEGIN
	--设置当前日期.
	SELECT CURRENT_DATE::TEXT into curday;
	--raise notice 'ip:%',hostinfo;
	if mainhost is null or rtrim(ltrim(mainhost)) = '' THEN
		return '运营商库信息没有设置';
	end if;

	--收集当前所有运营站点相关信息.
	SELECT gamebox_collect_site_infor(mainhost, sid) into rec;
	IF rec->>'siteid' = '-1' THEN
		rtn = '运营商库中不存在当前站点的相关信息,请确保此站点是否合法.';
		raise info '%', rtn;
		return rtn;
	END IF;

	--拆分所有站点数据库信息.
	rtn = rtn||'1. 开始收集站点玩家下单信息';
	SELECT gamebox_operations_player(start_time, end_time, curday, rec) into tmp;
	rtn = rtn||'||'||tmp;
	--raise info '%.收集完毕',i;

	--处理另外一些报表信息收集

	--统一执行代理以上的经营报表
	--执行代理经营报表
	rtn = rtn||'2.  开始执行代理经营报表';
	SELECT gamebox_operations_agent(curday, rec) into tmp;
	rtn = rtn||'||'||tmp;
	--执行总代经营报表
	rtn = rtn||'3.  开始执行总代经营报表';
	SELECT gamebox_operations_topagent(curday, rec) into tmp;
	rtn = rtn||'||'||tmp;

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, sid int, start_time text, end_time text)
IS 'Lins-经营报表-入口';
*/
/**
 * description:收集所有站点玩家游戏下单运营报表
 * author 	Lins
 * date 	2015.10.27
 * @param 	mainhost 	名称.mainhost,类型.字符串，用途：运营数据库配置信息.
 * @param 	sid 		站点ID
  * @param 	sid 		curday  统计时间
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
**/
--drop function IF EXISTS gamebox_operations_statement(text,int,text,text);
--drop function IF EXISTS gamebox_operations_statement(text,int,text,text,text);
drop function IF EXISTS gamebox_operations_statement(text,int,text,text,text);
create or replace function gamebox_operations_statement(
	mainhost 	text,
	sid 		int,
	curday 	text, --v1.01  2016/05/31  Leisure
	start_time 	text,
	end_time 	text
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-入口
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
--v1.02  2016/07/08  Leisure  优化输出日志
*/
DECLARE
	--curday 	TEXT;
	rtn 	text:='';
	tmp 	text:='';
	rec 	json;
	red 	record;
	vname 	text:='vp_site_game';
	cnum 	int:=0;
BEGIN
	--v1.01  2016/05/31  Leisure
	--设置当前日期.
	--SELECT CURRENT_DATE::TEXT into curday;

	--raise notice 'ip:%',hostinfo;
	if mainhost is null or rtrim(ltrim(mainhost)) = '' THEN
		return '运营商库信息没有设置';
	end if;

	--收集当前所有运营站点相关信息.
	SELECT gamebox_collect_site_infor(mainhost, sid) into rec;
	IF rec->>'siteid' = '-1' THEN
		rtn = '运营商库中不存在当前站点的相关信息,请确保此站点是否合法.';
		raise info '%', rtn;
		return rtn;
	END IF;

	--拆分所有站点数据库信息.
	rtn = rtn||chr(13)||chr(10)||'        ┣1.正在收集玩家下单信息';
	SELECT gamebox_operations_player(start_time, end_time, curday, rec) into tmp;
	rtn = rtn||'||'||tmp;
	--raise info '%.收集完毕',i;

	--处理另外一些报表信息收集

	--统一执行代理以上的经营报表
	--执行代理经营报表
	rtn = rtn||chr(13)||chr(10)||'        ┣2.正在执行代理经营报表';
	--SELECT gamebox_operations_agent(curday, rec) into tmp; --v1.01  2016/05/31  Leisure
	SELECT gamebox_operations_agent(start_time, end_time, curday, rec) into tmp;
	rtn = rtn||'||'||tmp;
	--执行总代经营报表
	rtn = rtn||chr(13)||chr(10)||'        ┣3.正在执行总代经营报表';
	--SELECT gamebox_operations_topagent(curday, rec) into tmp; --v1.01  2016/05/31  Leisure
	SELECT gamebox_operations_topagent(start_time, end_time, curday, rec) into tmp;
	rtn = rtn||'||'||tmp;

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, sid int, curday text, start_time text, end_time text)
IS 'Lins-经营报表-入口';

/**
 * description:收集玩家经营报表.
 * @author 	Lins
 * @date 	2015.10.27
 * @param 	统计开始时间
 * @param 	统计结束时间
 * @param 	0时区当前日期
 * @param 	当前站点信息
 * @return 	返回执行LOG信息.
**/
drop function IF EXISTS gamebox_operations_player(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_player(
	start_time 	TEXT,
	end_time 	TEXT,
	curday 		TEXT,
	rec 		JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-玩家报表
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.03  2016/06/13  Leisure  is_profit_loss=false的记录也需要统计by acheng
--v1.04  2016/06/27  Leisure  统计时间由bet_time改为payout_time --by acheng
--v1.05  2016/07/08  Leisure  优化输出日志
--v1.05  2016/10/05  Leisure  撤销v1.03的修改 by kitty
*/
DECLARE
	rtn 		text:='';
	n_count		INT:=0;
	site_id 	INT;
	master_id 	INT;
	center_id 	INT;
	site_name 	TEXT:='';
	master_name TEXT:='';
	center_name TEXT:='';
	d_static_date DATE; --v1.02  2016/05/31
BEGIN
	--v1.02  2016/05/31  Leisure
	d_static_date := to_date(curday, 'YYYY-MM-DD');

	--清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	--delete from operate_player WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
	delete from operate_player WHERE static_date = d_static_date;

	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次删除记录数 %', n_count;
	rtn = rtn||'|执行完毕,删除记录数: '||n_count||' 条||';

	--开始执行玩家经营报表信息收集
	site_id 	= COALESCE((rec->>'siteid')::INT, -1);
	site_name	= COALESCE(rec->>'sitename', '');
	master_id	= COALESCE((rec->>'masterid')::INT, -1);
	master_name	= COALESCE(rec->>'mastername', '');
	center_id	= COALESCE((rec->>'operationid')::INT, -1);
	center_name	= COALESCE(rec->>'operationname', '');

	raise info '开始日期:%, 结束日期:%', start_time, end_time;
	INSERT INTO operate_player(
		center_id, center_name, master_id, master_name,
		site_id, site_name, topagent_id, topagent_name,
		agent_id, agent_name, player_id, player_name,
		api_id, api_type_id, game_type,
		--static_time, create_time, --v1.02  2016/05/31  Leisure
		static_date, static_time, static_time_end, create_time,
		transaction_order, transaction_volume, effective_transaction, profit_loss
		) SELECT
				center_id, center_name, master_id, master_name,
				site_id, site_name, u.topagent_id, u.topagent_name,
				u.agent_id, u.agent_name, u.id, u.username,
				p.api_id, p.api_type_id, p.game_type,
				--now(), now(), --v1.02  2016/05/31  Leisure
				d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
				p.transaction_order, p.transaction_volume, p.effective_transaction, p.profit_loss
				FROM (SELECT
								player_id, api_id, api_type_id, game_type,
								COUNT(order_no)  							as transaction_order,
								SUM(COALESCE(single_amount, 0.00))  		as transaction_volume,
								SUM(COALESCE(profit_amount, 0.00))  		as profit_loss,
								SUM(COALESCE(effective_trade_amount, 0.00)) as effective_transaction
							 FROM player_game_order
							--WHERE bet_time >= start_time::TIMESTAMP
							--	AND bet_time < end_time::TIMESTAMP
							WHERE payout_time >= start_time::TIMESTAMP
							  AND payout_time < end_time::TIMESTAMP
								AND order_state = 'settle'
								AND is_profit_loss = TRUE --v1.03  2016/06/13  Leisure
							GROUP BY player_id, api_id, api_type_id, game_type
							) p, v_sys_user_tier u
	     WHERE p.player_id = u.id;

	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次插入数据量 %', n_count;
	rtn = rtn||'|执行完毕,新增记录数: '||n_count||' 条||';

	return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-玩家报表';

/**
 * description:代理经营报表, 玩家一天多次下单在统计玩家人数时，只算一个
 * @author 	Lins
 * @date 	2015.10.28
 * @param 	curday 	0时区当前日期
 * @return 	返回执行LOG信息.
**/
/*drop function IF EXISTS gamebox_operations_agent(TEXT,json);
create or replace function gamebox_operations_agent(
	curday 	TEXT,
	rec 	json
) returns text as $$
DECLARE
	rtn 		text:='';
	v_COUNT		int4:=0;
	s_id 		INT;
	m_id 		INT;
	c_id 		INT;
	s_name 		TEXT:='';
	m_name 		TEXT:='';
	c_name 		TEXT:='';
BEGIN
	--清除当天的统计信息，保证每天只作一次统计信息
	raise info '清除当天的统计信息，保证每天只作一次统计信息';
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	delete from operate_agent WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次删除记录数 %', v_COUNT;
	rtn = rtn||'|执行完毕,删除记录数: '||v_COUNT||' 条||';

	--开始执行代理经营报表信息收集
	rtn = rtn||'|开始执行'||curday||'代理经营报表||';

	s_id 	= COALESCE((rec->>'siteid')::INT,-1);
	s_name 	= COALESCE(rec->>'sitename','');
	m_id 	= COALESCE((rec->>'masterid')::INT,-1);
	m_name 	= COALESCE(rec->>'mastername','');
	c_id 	= COALESCE((rec->>'operationid')::INT,-1);
	c_name 	= COALESCE(rec->>'operationname','');
	--执行代理统计
	INSERT INTO operate_agent(
		center_id, center_name, master_id, master_name,
		site_id, site_name, topagent_id, topagent_name,
		agent_id, agent_name, api_id, api_type_id, game_type,
		static_time, create_time,
		player_num, transaction_order, transaction_volume, effective_transaction, profit_loss
	) SELECT
		c_id, c_name, m_id, m_name,
		s_id, s_name, topagent_id, topagent_name,
		agent_id, agent_name, api_id, api_type_id, game_type,
		now(), now(),
		COUNT(DISTINCT player_id)					 	as player_num,
		SUM (COALESCE(transaction_order, 0)) 			as transaction_order,
		SUM (COALESCE(transaction_volume, 0.00)) 		as transaction_volume,
		SUM (COALESCE(effective_transaction, 0.00)) 	as effective_transaction,
		SUM (COALESCE(profit_loss, 0.00)) 				as profit_loss
	 FROM operate_player
	WHERE to_char(static_time,  'YYYY-MM-dd') = curday
	GROUP BY topagent_id, topagent_name, agent_id, agent_name, api_id, api_type_id, game_type;

	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次插入数据量 %', v_COUNT;
	rtn = rtn||'|执行完毕,新增记录数: '||v_COUNT||' 条||';

	return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_agent(curday TEXT, rec json)
IS 'Lins-经营报表-代理报表';
*/

/**
 * description:代理经营报表, 玩家一天多次下单在统计玩家人数时，只算一个
 * @author 	Lins
 * @date 	2015.10.28
 * @param 	curday 	0时区当前日期
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @return 	返回执行LOG信息.
**/
--drop function IF EXISTS gamebox_operations_agent(TEXT,json);
drop function IF EXISTS gamebox_operations_agent(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_agent(
	start_time 	TEXT,
	end_time 	TEXT,
	curday 	TEXT,
	rec 	JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-代理报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.02  2016/06/13  Leisure  修正一处bug
--v1.03  2016/07/08  Leisure  优化输出日志
*/
DECLARE
	rtn 		text:='';
	v_COUNT		int4:=0;
	s_id 		INT;
	m_id 		INT;
	c_id 		INT;
	s_name 		TEXT:='';
	m_name 		TEXT:='';
	c_name 		TEXT:='';
	d_static_date DATE; --v1.01  2016/05/31
BEGIN
	--v1.01  2016/05/31  Leisure
	d_static_date := to_date(curday, 'YYYY-MM-DD');

	--清除当天的统计信息，保证每天只作一次统计信息
	--raise info '清除当天的统计信息，保证每天只作一次统计信息';
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	--delete from operate_agent WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
	delete from operate_agent WHERE static_date = d_static_date;

	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次删除记录数 %', v_COUNT;
	rtn = rtn||'|执行完毕,删除记录数: '||v_COUNT||' 条||';

	--开始执行代理经营报表信息收集
	rtn = rtn||'|开始执行'||curday||'代理经营报表||';

	s_id 	= COALESCE((rec->>'siteid')::INT,-1);
	s_name 	= COALESCE(rec->>'sitename','');
	m_id 	= COALESCE((rec->>'masterid')::INT,-1);
	m_name 	= COALESCE(rec->>'mastername','');
	c_id 	= COALESCE((rec->>'operationid')::INT,-1);
	c_name 	= COALESCE(rec->>'operationname','');
	--执行代理统计
	INSERT INTO operate_agent(
		center_id, center_name, master_id, master_name,
		site_id, site_name, topagent_id, topagent_name,
		agent_id, agent_name, api_id, api_type_id, game_type,
		--static_time, create_time, --v1.01  2016/05/31  Leisure
		static_date, static_time, static_time_end, create_time,
		player_num, transaction_order, transaction_volume, effective_transaction, profit_loss
	) SELECT
		c_id, c_name, m_id, m_name,
		s_id, s_name, topagent_id, topagent_name,
		agent_id, agent_name, api_id, api_type_id, game_type,
		--now(), now(), --v1.01  2016/05/31  Leisure
		--t_static_time, now(), --v1.02  2016/06/13  Leisure
		d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
		COUNT(DISTINCT player_id)					 	as player_num,
		SUM (COALESCE(transaction_order, 0)) 			as transaction_order,
		SUM (COALESCE(transaction_volume, 0.00)) 		as transaction_volume,
		SUM (COALESCE(effective_transaction, 0.00)) 	as effective_transaction,
		SUM (COALESCE(profit_loss, 0.00)) 				as profit_loss
	 FROM operate_player
	--WHERE to_char(static_time,  'YYYY-MM-dd') = curday
	WHERE static_date = d_static_date --v1.01  2016/05/31  Leisure
	GROUP BY topagent_id, topagent_name, agent_id, agent_name, api_id, api_type_id, game_type;

	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次插入数据量 %', v_COUNT;
	rtn = rtn||'|执行完毕,新增记录数: '||v_COUNT||' 条||';

	return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_agent(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-代理报表';

/**
 * 总代经营报表
 * author 	Lins
 * date 	2015.10.28
 * @参数1 	curday 	0时区当前日期
 * @return 	返回执行LOG信息.
**/
/*drop function IF EXISTS gamebox_operations_topagent(TEXT, json);
create or replace function gamebox_operations_topagent(
	curday 	TEXT,
	rec 	json
) returns text as $$
DECLARE
	rtn 		text:='';
	v_COUNT		int4:=0;
	s_id 		INT;
	m_id 		INT;
	c_id 		INT;
	s_name 		TEXT:='';
	m_name 		TEXT:='';
	c_name 		TEXT:='';
BEGIN
  --清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	DELETE FROM operate_topagent WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次删除记录数 %', v_COUNT;
	rtn = rtn||'|执行完毕,删除记录数: '||v_COUNT||' 条||';
	--开始执行总代经营报表信息收集
	rtn = rtn||'|开始执行'||curday||'总代经营报表||';

	s_id 	= COALESCE((rec->>'siteid')::INT, -1);
	s_name 	= COALESCE(rec->>'sitename', '');
	m_id 	= COALESCE((rec->>'masterid')::INT, -1);
	m_name 	= COALESCE(rec->>'mastername', '');
	c_id 	= COALESCE((rec->>'operationid')::INT, -1);
	c_name 	= COALESCE(rec->>'operationname', '');

	INSERT INTO operate_topagent(
		center_id, center_name, master_id, master_name,
		site_id, site_name, topagent_id, topagent_name,
		api_id, api_type_id, game_type,
		static_time, create_time,
		player_num, transaction_order, transaction_volume, effective_transaction, profit_loss
	) SELECT
		c_id, c_name, m_id, m_name,
		s_id, s_name, topagent_id, topagent_name,
		api_id, api_type_id, game_type,
		now(), now(),
		SUM (player_num)							as player_num,
		SUM (COALESCE(transaction_order, 0)) 		as transaction_order,
		SUM (COALESCE(transaction_volume, 0.00)) 	as transaction_volume,
		SUM (COALESCE(effective_transaction, 0.00)) as effective_transaction,
		SUM (COALESCE(profit_loss, 0.00)) 			as profit_loss
	 FROM operate_agent
	WHERE to_char(static_time,  'YYYY-MM-dd') = curday
	GROUP BY topagent_id, topagent_name, api_id, api_type_id, game_type;

	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次插入数据量 %',  v_COUNT;
	rtn = rtn||'|执行完毕,新增记录数: '||v_COUNT||' 条||';

	return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_topagent(curday TEXT, rec json)
IS 'Lins-经营报表-总代报表';
*/

/**
 * 总代经营报表
 * author 	Lins
 * date 	2015.10.28
 * @参数1 	start_time 	开始时间
 * @参数1 	end_time 	结束时间
 * @参数1 	curday 	0时区当前日期
 * @return 	返回执行LOG信息.
**/
--drop function IF EXISTS gamebox_operations_topagent(TEXT, json);
drop function IF EXISTS gamebox_operations_topagent(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_topagent(
	start_time 	TEXT,
	end_time 	TEXT,
	curday 	TEXT,
	rec 	JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-总代报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.02  2016/07/08  Leisure  优化输出日志
*/
DECLARE
	rtn 		text:='';
	v_COUNT		int4:=0;
	s_id 		INT;
	m_id 		INT;
	c_id 		INT;
	s_name 		TEXT:='';
	m_name 		TEXT:='';
	c_name 		TEXT:='';
	d_static_date DATE; --v1.01  2016/05/31
BEGIN
	--v1.01  2016/05/31  Leisure
	d_static_date := to_date(curday, 'YYYY-MM-DD');
	--清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	--DELETE FROM operate_topagent WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
	DELETE FROM operate_topagent WHERE static_date = d_static_date;
	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次删除记录数 %', v_COUNT;
	rtn = rtn||'|执行完毕,删除记录数: '||v_COUNT||' 条||';
	--开始执行总代经营报表信息收集
	rtn = rtn||'|开始执行'||curday||'总代经营报表||';

	s_id 	= COALESCE((rec->>'siteid')::INT, -1);
	s_name 	= COALESCE(rec->>'sitename', '');
	m_id 	= COALESCE((rec->>'masterid')::INT, -1);
	m_name 	= COALESCE(rec->>'mastername', '');
	c_id 	= COALESCE((rec->>'operationid')::INT, -1);
	c_name 	= COALESCE(rec->>'operationname', '');

	INSERT INTO operate_topagent(
		center_id, center_name, master_id, master_name,
		site_id, site_name, topagent_id, topagent_name,
		api_id, api_type_id, game_type,
		--static_time, create_time, --v1.01  2016/05/31  Leisure
		static_date, static_time, static_time_end, create_time,
		player_num, transaction_order, transaction_volume, effective_transaction, profit_loss
	) SELECT
		c_id, c_name, m_id, m_name,
		s_id, s_name, topagent_id, topagent_name,
		api_id, api_type_id, game_type,
		--now(), now(), --v1.01  2016/05/31  Leisure
		d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
		SUM (player_num)  							as player_num,
		SUM (COALESCE(transaction_order, 0)) 		as transaction_order,
		SUM (COALESCE(transaction_volume, 0.00)) 	as transaction_volume,
		SUM (COALESCE(effective_transaction, 0.00)) as effective_transaction,
		SUM (COALESCE(profit_loss, 0.00)) 			as profit_loss
	 FROM operate_agent
	--WHERE to_char(static_time,  'YYYY-MM-dd') = curday
	WHERE static_date = d_static_date --v1.01  2016/05/31  Leisure
	GROUP BY topagent_id, topagent_name, api_id, api_type_id, game_type;

	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次插入数据量 %',  v_COUNT;
		rtn = rtn||'|执行完毕,新增记录数: '||v_COUNT||' 条||';

	return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_topagent(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-总代报表';

/**
 * 站点经营报表
 * author 	Lins
 * date 	2015.10.28
 * @param 	curday 	0时区当前日期
 * @return 	返回执行LOG信息.
**/
drop function if exists gamebox_operations_site(TEXT);
create or replace function gamebox_operations_site(
	curday text
) returns SETOF record as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-站点报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
*/
DECLARE
	rec record;
	d_static_date DATE; --v1.01  2016/05/31
BEGIN
	--v1.01  2016/05/31  Leisure
	d_static_date := to_date(curday, 'YYYY-MM-DD');

	FOR rec IN
			SELECT site_id, api_id, game_type, api_type_id,
			   SUM (player_num) 			as players_num,
			   SUM (transaction_order) 		as transaction_order,
			   SUM (transaction_volume) 	as transaction_volume,
			   SUM (effective_transaction) 	as effective_transaction_volume,
			   SUM (profit_loss) 			as transaction_profit_loss
			  FROM operate_topagent
			 --WHERE to_char(static_time, 'YYYY-MM-dd') = curday
			 WHERE static_date = d_static_date
			 GROUP BY site_id,api_id,game_type,api_type_id
	LOOP
		RETURN NEXT rec;
	END LOOP;

END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_site(curday TEXT)
IS 'Lins-经营报表-站点报表';

/*
SELECT gamebox_operations_statement (
 	'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres',
 	1,
 	'2015-01-08 00:00:00',
 	'2015-12-18 23:59:59'
);
*/
