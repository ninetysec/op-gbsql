-- auto gen by bruce 2016-06-05 15:43:57
 select redo_sqls($$
    ALTER TABLE  operate_agent  ADD COLUMN static_date date;
    ALTER TABLE  operate_player  ADD COLUMN static_date date;
    ALTER TABLE  operate_topagent  ADD COLUMN static_date date;
    ALTER TABLE  operate_agent  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  operate_player  ADD COLUMN static_time_end timestamp;
    ALTER TABLE  operate_topagent  ADD COLUMN static_time_end timestamp;
$$);
COMMENT ON COLUMN  operate_agent. static_date IS '统计日期';
COMMENT ON COLUMN  operate_player. static_date IS '统计日期';
COMMENT ON COLUMN  operate_topagent. static_date IS '统计日期';
COMMENT ON COLUMN  operate_agent. static_time IS '统计起始时间';
COMMENT ON COLUMN  operate_player. static_time IS '统计起始时间';
COMMENT ON COLUMN  operate_topagent. static_time IS '统计起始时间';
COMMENT ON COLUMN  operate_agent. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  operate_player. static_time_end IS '统计截止时间';
COMMENT ON COLUMN  operate_topagent. static_time_end IS '统计截止时间';

UPDATE  operate_agent  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  operate_player  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  operate_topagent  SET static_date = static_time::date WHERE static_date IS null;
UPDATE  operate_agent  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;
UPDATE  operate_player  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;
UPDATE  operate_topagent  SET static_time_end = static_time + '1 day' WHERE static_time_end IS null;

drop function IF EXISTS gamebox_rakeback(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_rakeback(
	name 		text,
	startTime 	text,
	endTime 	text,
	url 		text,
	flag 		TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：返水-玩家返水入口
--v1.01  2016/05/30  Leisure  增加重跑标识，默认禁止重跑
*/
DECLARE
	stTime 	TIMESTAMP;
	edTime 	TIMESTAMP;
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
	bill_id 		INT:=-1;
	sid 			INT;
	bill_count	INT :=0;
	redo_status BOOLEAN := false; --重跑标识，默认禁止重跑
BEGIN
	raise info '开始统计( % )的返水, 周期( %-% )', name, startTime, endTime;
	raise info '创建站点游戏视图';

	SELECT gamebox_current_site() INTO sid;

	stTime = startTime::TIMESTAMP;
	edTime = endTime::TIMESTAMP;

	IF flag = 'Y' THEN
		SELECT COUNT("id")
		 INTO bill_count
			FROM rakeback_bill rb
		 WHERE rb.period = name
			 AND rb."start_time" = stTime
			 AND rb."end_time" = edTime;

		IF bill_count > 0 THEN
			IF redo_status THEN
				DELETE FROM rakeback_api ra WHERE ra.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
				DELETE FROM rakeback_player rp WHERE rp.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
				DELETE FROM rakeback_bill rb WHERE "id" IN (SELECT "id" FROM rakeback_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
			ELSE
				raise info '已生成本期返水账单，无需重新生成。';
				RETURN;
			END IF;
		END IF;
	END IF;

	raise info '返水总表数据预新增.';
	SELECT gamebox_rakeback_bill(name, stTime, edTime, bill_id, 'I', flag) INTO bill_id;

	-- 收集每个API下每个玩家的返水.
	raise info '统计玩家API返水';
	perform gamebox_rakeback_api(bill_id, stTime, edTime, flag);
	raise info '统计玩家API返水.完成';

	raise info '统计玩家返水';
	perform gamebox_rakeback_player(bill_id, flag);
	raise info '统计玩家返水.完成';

	raise info '更新返水总表';
	perform gamebox_rakeback_bill(name, stTime, edTime, bill_id, 'U', flag);

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback(name text, startTime text, endTime text, url text, flag TEXT)
IS 'Lins-返水-玩家返水入口';


DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rakeback_bill (
	name 			TEXT,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	INOUT bill_id 	INT,
	op 				TEXT,
	flag 			TEXT
) returns INT as $$
/*版本更新说明
版本   时间        作者     内容
v1.00  2015/01/01  Lins     创建此函数：返水-返水周期主表
v1.01  2016/05/30  Leisure  改为returning，防止并发 Leisure 20160530
*/
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
	rec 			record;
	max_back_water 	float:=0.00;
	backwater 		float:=0.00;
	rp_count		INT:=0;	-- rakeback_player 条数
BEGIN
	IF flag='Y' THEN--已出账

		IF op='I' THEN
			--先插入返水总记录并取得键值.
			INSERT INTO rakeback_bill (
			 	period, start_time, end_time,
			 	player_count, player_lssuing_count, player_reject_count, rakeback_total, rakeback_actual,
			 	create_time, lssuing_state
			) VALUES (
			 	name, start_time, end_time,
			 	0, 0, 0, 0, 0,
			 	now(), pending_pay
			) returning id into bill_id;

			--改为returning，防止并发 Leisure 20160530
			--SELECT currval(pg_get_serial_sequence('rakeback_bill',  'id')) into bill_id;

		ELSE
			SELECT COUNT(1) FROM rakeback_player WHERE rakeback_bill_id = bill_id INTO rp_count;
			IF rp_count > 0 THEN
				FOR rec IN
					SELECT rakeback_bill_id,
						   COUNT(DISTINCT player_id) 	as cl,
						   SUM(rakeback_total) 			as sl
					  FROM rakeback_player
					 WHERE rakeback_bill_id = bill_id
					 GROUP BY rakeback_bill_id
				LOOP
					UPDATE rakeback_bill SET player_count = rec.cl, rakeback_total = rec.sl WHERE id = bill_id;
				END LOOP;
			ELSE
				DELETE FROM rakeback_bill WHERE id = bill_id;
			END IF;
		END IF;

	ELSEIF flag='N' THEN--未出账

		IF op='I' THEN
			--先插入返水总记录并取得键值.
			INSERT INTO rakeback_bill_nosettled (
			 	start_time, end_time, rakeback_total, create_time
			) VALUES (
			 	start_time, end_time, 0, now()
			);
			SELECT currval(pg_get_serial_sequence('rakeback_bill_nosettled', 'id')) into bill_id;
		ELSE
			SELECT COUNT(1) FROM rakeback_player_nosettled WHERE rakeback_bill_nosettled_id = bill_id INTO rp_count;
			-- raise info '---- rp_count = %', rp_count;
			IF rp_count > 0 THEN
				FOR rec in
					SELECT rakeback_bill_nosettled_id,
						   COUNT(DISTINCT player_id) 	as cl,
						   SUM(rakeback_total) 			as sl
					  FROM rakeback_player_nosettled
					 WHERE rakeback_bill_nosettled_id = bill_id
					 GROUP BY rakeback_bill_nosettled_id
				LOOP
					UPDATE rakeback_bill_nosettled SET rakeback_total = rec.sl WHERE id = bill_id;
				END LOOP;
				DELETE FROM rakeback_bill_nosettled WHERE id <> bill_id;
			ELSE
				DELETE FROM rakeback_bill_nosettled WHERE id = bill_id;
			END IF;
		END IF;

	END IF;
	raise info 'rakeback_bill.完成.键值:%', bill_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, bill_id INT, op TEXT, flag TEXT)
IS 'Lins-返水-返水周期主表';

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
--v1.00  2015/01/01  Lins     创建此函数：经营报表-入口
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
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
	rtn = rtn||'1. 开始收集站点玩家下单信息';
	SELECT gamebox_operations_player(start_time, end_time, curday, rec) into tmp;
	rtn = rtn||'||'||tmp;
	--raise info '%.收集完毕',i;

	--处理另外一些报表信息收集

	--统一执行代理以上的经营报表
	--执行代理经营报表
	rtn = rtn||'2.  开始执行代理经营报表';
	--SELECT gamebox_operations_agent(curday, rec) into tmp; --v1.01  2016/05/31  Leisure
	SELECT gamebox_operations_agent(start_time, end_time, curday, rec) into tmp;
	rtn = rtn||'||'||tmp;
	--执行总代经营报表
	rtn = rtn||'3.  开始执行总代经营报表';
	--SELECT gamebox_operations_topagent(curday, rec) into tmp; --v1.01  2016/05/31  Leisure
	SELECT gamebox_operations_topagent(start_time, end_time, curday, rec) into tmp;
	rtn = rtn||'||'||tmp;

	return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, sid int, curday text, start_time text, end_time text)
IS 'Lins-经营报表-入口';

drop function IF EXISTS gamebox_operations_player(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_player(
	start_time 	TEXT,
	end_time 	TEXT,
	curday 		TEXT,
	rec 		JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：经营报表-玩家报表
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期

*/
DECLARE
	rtn 		text:='';
	v_COUNT		int4:=0;
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
	rtn = rtn||'| |清除当天的统计信息，保证每天只作一次统计信息||';
	--delete from operate_player WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
	delete from operate_player WHERE static_date = d_static_date;

	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次删除记录数 %', v_COUNT;
	rtn = rtn||'| |执行完毕,删除记录数: '||v_COUNT||' 条||';

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
							WHERE bet_time >= start_time::TIMESTAMP
								AND bet_time < end_time::TIMESTAMP
								AND order_state = 'settle'
								AND is_profit_loss = TRUE
							GROUP BY player_id, api_id, api_type_id, game_type
							) p, v_sys_user_tier u
	WHERE p.player_id = u.id;

	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次插入数据量 %', v_COUNT;
		rtn = rtn||'| |执行完毕,新增记录数: '||v_COUNT||' 条||';

	return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-玩家报表';

drop function IF EXISTS gamebox_operations_agent(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_agent(
	start_time 	TEXT,
	end_time 	TEXT,
	curday 	TEXT,
	rec 	JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：经营报表-代理报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期

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
	rtn = rtn||'| |执行完毕,删除记录数: '||v_COUNT||' 条||';

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
		d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
		t_static_time, now(),
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

drop function IF EXISTS gamebox_operations_topagent(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_topagent(
	start_time 	TEXT,
	end_time 	TEXT,
	curday 	TEXT,
	rec 	JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：经营报表-代理报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
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
	rtn = rtn||'| |执行完毕,删除记录数: '||v_COUNT||' 条||';
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

drop function if exists gamebox_operations_site(TEXT);
create or replace function gamebox_operations_site(
	curday text
) returns SETOF record as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：经营报表-站点报表
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


drop function if exists gamebox_occupy(text, text, text, text);
create or replace function gamebox_occupy(
	name 		text,
	start_time 	text,
	end_time 	text,
	url 		text
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：总代占成-入口
--v1.01  2016/06/01  Leisure  返水函数改用gamebox_rakeback_api_map获取
*/
DECLARE
	rec 					record;
	sys_map 				hstore;	--系统设置各种承担比例.
	occupy_map 				hstore;	--各API的返佣设置
	operation_occupy_map 	hstore;	--运营商各API占成比例.
	rebate_grads_map 		hstore;	--返佣梯度设置.
	agent_map 				hstore;	--代理默认梯度.
	agent_check_map 		hstore;	--代理满足的梯度.
	cost_map 				hstore;	--费用分摊
	rakeback_map 			hstore;	--玩家API返水.
	numhash 				hstore;	--存储每个总代的玩家数.
	mhash 					hstore;	--临时
	occupy_value 			FLOAT;	--返佣值

	keyId 	int;
	tmp 	int;
	a1 		text;
	a2 		text;
	a3 		text;
	stTime 	TIMESTAMP;
	edTime 	TIMESTAMP;

	pending_lssuing 	text:='pending_lssuing';
	pending_pay 		text:='pending_pay';
	row_split_char 		text:='^&^';	--分隔符
	col_split_char 		text:='^';

	--vname 				text:='v_site_game';
	sid 				INT;--站点ID.
	bill_id 			INT;

	is_max 				BOOLEAN:=true;
	key_type 			int:=4;
	category 			TEXT:='AGENT';

	rakebackhash		hstore; -- 玩家返水
	rebatehash			hstore; -- 玩家返佣
BEGIN
	stTime = start_time::TIMESTAMP;
	edTime = end_time::TIMESTAMP;

	raise info '统计( % )的占成, 时间( %-% )', name, start_time, end_time;

	raise info '占成.玩家API返水';
	--v1.01  2016/06/01  Leisure
	--SELECT gamebox_rakeback_map(stTime, edTime, url, 'API') INTO rakeback_map;
	SELECT gamebox_rakeback_api_map(stTime, edTime, 'API') INTO rakeback_map;

	raise info '占成.取得当前站点ID';
	SELECT gamebox_current_site() INTO sid;

	raise info '返佣.梯度设置信息';
	SELECT gamebox_rebate_api_grads() into rebate_grads_map;

	raise info '返佣.代理默认方案';
	SELECT gamebox_rebate_agent_default_set() into agent_map;

	raise info '返佣.代理满足的梯度';
	SELECT gamebox_rebate_agent_check(rebate_grads_map, agent_map, stTime, edTime, 'Y') into agent_check_map;

	--取得各API的运营商占成.
	raise info '取得运营商各API占成';
	SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type, 'Y') into operation_occupy_map;

	raise info '取得当前返佣梯度设置信息';
	SELECT gamebox_occupy_api_set() into occupy_map;

	raise info '占成.总表新增';
	SELECT gamebox_occupy_bill(name, stTime, edTime, bill_id, 'I') into bill_id;
	raise info 'occupy_bill.键值:%', bill_id;

	raise info '总代.玩家API贡献度';
	perform gamebox_occupy_api(bill_id, stTime, edTime, occupy_map, operation_occupy_map, rakeback_map, rebate_grads_map, agent_check_map);

	raise info '占成.各种分摊费用';
	SELECT gamebox_occupy_expense_gather(bill_id, stTime, edTime) into cost_map;

	raise info '占成.系统各种分摊比例参数';
	SELECT gamebox_sys_param('apportionSetting') into sys_map;

	raise info '各个玩家返水,从返水账单取值';
	SELECT gamebox_rebate_rakeback_map(stTime, edTime) INTO rakebackhash;

	SELECT gamebox_occupy_rebate_map(stTime, edTime) INTO rebatehash;

	-- raise info '占成.玩家贡献度.cost_map = %, sys_map = %, rakebackhash = %, rebatehash = %', cost_map, sys_map, rakebackhash, rebatehash;
	perform gamebox_occupy_player(bill_id, cost_map, sys_map, rakebackhash, rebatehash);

	raise info '占成.代理贡献度.';
	perform gamebox_occupy_agent(bill_id);

	raise info '占成.总代明细';
	perform gamebox_occupy_topagent(bill_id);

	raise info '占成.总表更新';
	perform gamebox_occupy_bill(name, stTime, edTime, bill_id, 'U');

	--异常处理
	-- PG_EXCEPTION_DETAIL
	-- WHEN OTHERS THEN
	-- GET STACKED DIAGNOSTICS a1 = MESSAGE_TEXT, a2 = PG_EXCEPTION_DETAIL, a3 = PG_EXCEPTION_HINT;
	-- raise EXCEPTION '异常:%, %, %', a1, a2, a3;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy(name text, start_time text, end_time text, url text)
IS 'Lins-总代占成-入口';

DROP FUNCTION IF EXISTS gamebox_rakeback_api_map(TIMESTAMP, TIMESTAMP, TEXT);
create or replace function gamebox_rakeback_api_map(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	--gradshash 	hstore, --v1.01  2016/06/01
	--agenthash 	hstore, --v1.01  2016/06/01
	category 	TEXT
) returns hstore as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：返水-玩家[API]返水-返佣调用
--v1.01  2016/06/01  Leisure  修改参数，返水梯度改为内部获取
*/
DECLARE
	hash 		hstore;--玩家API或玩家返水.
	rakeback 	FLOAT:=0.00;
	val 		FLOAT:=0.00;
	key 		TEXT:='';
	col_split 	TEXT:='_';
	rec 		record;
	param 		TEXT:='';
	sql 		TEXT:='';
	gradshash 	hstore; --v1.01  2016/06/01  Leisure
	agenthash 	hstore; --v1.01  2016/06/01  Leisure
BEGIN

	--SELECT gamebox_rakeback_api_grads() into gradshash;
	--SELECT gamebox_agent_rakeback() into agenthash;

	SELECT '-1=>-1' INTO hash;
	IF category = 'GAME_TYPE' THEN
		sql = 'SELECT rab.api_id,
					  rab.game_type,
					  rab.player_id,
					  COUNT(DISTINCT rab.player_id) 					as player_num,
				 FROM rakeback_api_base rab
			    WHERE rab.rakeback_time >= $1
				  AND rab.rakeback_time < $2
				  AND up.rakeback_id IS NOT NULL
			    GROUP BY rab.api_id, rab.game_type, rab.player_id';
	ELSE
		sql = 'SELECT rab.api_id,
					  rab.game_type,
					  rab.player_id,
					  SUM(rakeback)	rakeback
				 FROM rakeback_api_base rab
				WHERE rab.rakeback_time >= $1
				  AND rab.rakeback_time < $2
				GROUP BY rab.api_id, rab.game_type, rab.player_id';
	END IF;

	FOR rec IN EXECUTE sql USING start_time, end_time
	LOOP
		-- SELECT gamebox_rakeback_calculator(gradshash, agenthash, row_to_json(rec), NULL) into rakeback;

	  IF category = 'GAME_TYPE' THEN
			key 	= rec.api_id||col_split||rec.game_type;
			param 	= key||'=>'||rec.rakeback||col_split||rec.player_num;
			hash 	= (SELECT param::hstore)||hash;
		ELSEIF category = 'API' THEN
			key 	= rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
			param 	= key||'=>'||rec.rakeback;
			hash 	= (SELECT param::hstore)||hash;
		ELSE
			key 	= rec.player_id;
			param 	= key||'=>'||rakeback;
			IF isexists(hash,  key) THEN
				val = (hash->key)::FLOAT;
				val = val + rakeback;
				param = key||'=>'||val;
			END IF;
			hash = (SELECT param::hstore)||hash;
		END IF;
	END LOOP;
	-- raise info 'Last Hash = %',  hash;

	RETURN hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_map(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT)
IS 'Lins-返水-玩家[API]返水-返佣调用';

DROP FUNCTION IF EXISTS gamebox_rakeback_map(TIMESTAMP, TIMESTAMP, TEXT);
create or replace function gamebox_rakeback_map(
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP,
	--url 		TEXT, --v1.02  2016/06/01  Leisure
	category 	TEXT
) returns hstore[] as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：返水-玩家入口-返佣调用
--v1.01  2016/05/25  Leisure  返回值类型由hstore[]改为hstore
--v1.02  2016/06/01  Leisure  修改参数，返水梯度改为内部获取，
                              返回值类型由hstore改回hstore[]
*/
DECLARE
  gradshash 	hstore;
	agenthash 	hstore;
	hash 		hstore;
	sid 		INT:=-1;
	maps 		hstore[];
	rhash 		hstore;		-- 玩家返水

BEGIN
	SELECT gamebox_current_site() INTO sid;
	--取得当前返水梯度设置信息.
	--SELECT gamebox_rakeback_api_grads() into gradshash;
	--SELECT gamebox_agent_rakeback() into agenthash;

	raise info '统计玩家API返水';
	--v1.02  2016/06/01  Leisure
	--SELECT gamebox_rakeback_api_map(startTime, endTime, gradshash, agenthash, category) INTO hash;
	SELECT gamebox_rakeback_api_map(startTime, endTime, category) INTO hash;

	SELECT gamebox_rakeback_act(startTime, endTime) INTO rhash;

	--hash = hash || rhash;
	--RETURN hash;

	maps = array[hash];
	maps = array_append(maps, rhash);

	RETURN maps;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_map(startTime TIMESTAMP, endTime TIMESTAMP, category TEXT)
IS 'Lins-返水-玩家入口-返佣调用';

drop function if exists gamebox_station_bill(TEXT, TEXT, TEXT, TEXT, INT);
create or replace function gamebox_station_bill(
	main_url 	TEXT,
	master_url 	TEXT,
	start_time 	TEXT,
	end_time 	TEXT,
	flag 	INT
)	returns TEXT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：账务(站长、总代)-入口
--v1.01  2016/06/04  Leisure  取dict_map之前，先同步site_info表,
                              如果账务日期不为1号，则取1号日期
*/
DECLARE
	rec 		record;
	cnum 		INT;

	category 	TEXT:='API';
	keys 		TEXT[];
	sub_keys 	TEXT[];
	sub_key 	TEXT:='';
	col_split 	TEXT:='_';
	num_map 	hstore;

	maps 		hstore[];
	sys_map 	hstore;		-- 优惠分摊比例
	api_map 	hstore;
	expense_map hstore;
	dict_map 	hstore;		-- 运营商，站长，账务类型等信息
	param 		TEXT:='';
	sid 		INT;		-- 站点ID.
	val 		FLOAT;
	date_time 	TIMESTAMP;
	c_year 		INT;
	c_month 	INT;

	player_num 	INT;
	bill_id 	INT;
	rtn 		TEXT;
	bill_no 	TEXT;		-- 账务流水号
BEGIN
	IF ltrim(rtrim(master_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	perform dblink_close_all();
	perform dblink_connect('master',  master_url);

	SELECT  * FROM dblink(
		'master', 'SELECT  * FROM gamebox_sys_param(''apportionSetting'')'
	) as p(h hstore) INTO sys_map;

	raise info 'sys_map: %', sys_map;

	sid = (sys_map->'site_id')::INT;

	--v1.01  2016/06/04  Leisure
	perform gamebox_collect_site_infor(main_url);
	SELECT gamebox_site_map(sid) INTO dict_map;

	--v1.01  2016/06/04  Leisure
	date_time = start_time::TIMESTAMP;
	IF extract(day FROM date_time) <> '1' THEN
		date_time = date_time + '1 day';
	END IF;

	SELECT extract(year FROM date_time) INTO c_year;
	SELECT extract(month FROM date_time) INTO c_month;

	dict_map = (SELECT ('year=>'||c_year)::hstore)||dict_map;
	dict_map = (SELECT ('month=>'||c_month)::hstore)||dict_map;

	SELECT put(dict_map, 'bill_type', flag::TEXT) into dict_map; 	-- 账务类型

	raise info 'dict_map: %', dict_map;

	-- raise info '运营商，站长，账务类型等信息(dict_map) = %', dict_map;

	SELECT put(sys_map, 'backwater_percent', sys_map->'topagent.rakeback.percent') 		into sys_map;
	SELECT put(sys_map, 'refund_fee_percent', sys_map->'topagent.poundage.percent') 	into sys_map;
	SELECT put(sys_map, 'favourable_percent', sys_map->'topagent.preferential.percent') 	into sys_map;
	SELECT put(sys_map, 'rebate_percent', sys_map->'topagent.rebate.percent') 			into sys_map;

	-- raise info '优惠分摊比例(sys_map) = %', sys_map;

	-- 删除重复运行记录.
	DELETE FROM station_bill_other WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT);
	DELETE FROM station_profit_loss WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT);
	DELETE FROM station_bill WHERE site_id = sid AND bill_year = c_year AND bill_month = c_month AND bill_type = flag::TEXT;

	IF flag = 1 THEN 		-- 计算站长账务
		-- 站长账单流水号
		SELECT gamebox_generate_order_no('B', sid::TEXT, '03', 'master') INTO bill_no;
		SELECT put(dict_map, 'bill_no', bill_no) into dict_map;
		SELECT gamebox_station_bill_master(sys_map, dict_map, 'master', main_url, start_time, end_time) INTO rtn;
	ELSEIF flag = 2 THEN	-- 计算总代账务
		-- 总代账单流水号
		SELECT gamebox_generate_order_no('B', sid::TEXT, '04', 'master') INTO bill_no;
		SELECT put(dict_map, 'bill_no', bill_no) into dict_map;
		SELECT gamebox_station_bill_top(sys_map, dict_map, 'master', main_url, start_time, end_time) INTO rtn;
	END IF;

	--关闭连接
	perform dblink_disconnect('master');

	RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill(main_url TEXT, master_url TEXT, start_time TEXT, end_time TEXT, flag INT)
IS 'Lins-账务(站长、总代)-入口';