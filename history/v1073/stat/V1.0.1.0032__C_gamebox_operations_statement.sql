-- auto gen by admin 2016-07-07 20:25:10
drop function IF EXISTS gamebox_operations_statement(text, text, text, text, text, text);

drop function IF EXISTS gamebox_operations_statement(text, text, text, text, text, text, text);

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





drop function IF EXISTS gamebox_operations_statement(text, text[], text[], text[], text[]);

drop function IF EXISTS gamebox_operations_statement(text, text, text[], text[], text[], text[]);

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

*/

DECLARE

	--curday date;

	rtn text:='';

	tmp text:='';

	center_id int;



BEGIN

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

		--SELECT gamebox_master_operation_statement('master', siteids[i]::int, startTimes[i], endTimes[i], static_date, mainhost) into tmp;

		SELECT gamebox_master_operation_statement('master', siteids[i], static_date, startTimes[i], endTimes[i], mainhost) into tmp;

		rtn = rtn||'||'||tmp;

		raise info '%.收集完毕', i;

		--收集站点经营报表

		rtn = rtn||'4.  开始执行站点经营报表';

		--SELECT gamebox_operation_site('master', curday) into tmp; --v1.02  2016/05/31  Leisure

		SELECT gamebox_operation_site('master', siteids[i], static_date, startTimes[i], endTimes[i]) into tmp;

		rtn = rtn||'||'||tmp;

		perform dblink_disconnect('master');

	END LOOP;



	rtn = rtn||'5.  开始执行站长经营报表';

	--v1.02  2016/07/07  Leisure

	SELECT gamebox_operation_master(master_id, static_date) into tmp;

	rtn = rtn||'||'||tmp;

	rtn = rtn||'6.  开始执行运营商经营报表';

	--v1.02  2016/07/07  Leisure

	SELECT gamebox_operation_company(center_id::TEXT, static_date) into tmp;

	rtn = rtn||'||'||tmp;



return rtn;

END;

$$ LANGUAGE plpgsql;



COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, master_id text, static_date	text, masterhost text[], startTimes text[], endTimes text[], siteids text[])

IS 'Lins-经营报表-多站点入口';





drop function IF EXISTS gamebox_master_operation_statement(text, int, text, text, text, text);

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

*/

DECLARE

	rtn TEXT:='';

BEGIN

	SELECT

		INTO rtn P .msg

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





drop function IF EXISTS gamebox_operation_site(text, date);

drop function IF EXISTS gamebox_operation_site(TEXT, TEXT, TEXT, TEXT);

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

	rtn = rtn||'||执行完毕, 删除记录数: '||v_count||' 条||';



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

		rtn = rtn||'|执行完毕, 新增记录数: '||v_count||' 条||';

	return rtn;

END;

$$ LANGUAGE plpgsql;



COMMENT ON FUNCTION gamebox_operation_site(	conn TEXT, siteid TEXT, curday TEXT, start_time TEXT, end_time TEXT)

IS 'Lins-经营报表-站点报表';





drop function IF EXISTS gamebox_operation_master(TEXT);

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

	rtn = rtn||'||执行完毕, 删除记录数: '||v_count||'条||';

	--开始执行总代经营报表信息收集

	rtn = rtn||'|开始执行'||curday||'站长经营报表||';



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

	rtn = rtn||'|执行完毕, 新增记录数: '||v_count||' 条||';



	return rtn;

END;

$$ LANGUAGE plpgsql;



COMMENT ON FUNCTION gamebox_operation_master(masterid TEXT, curday TEXT)

IS 'Fly - 经营报表-站长报表';





drop function IF EXISTS gamebox_operation_company(TEXT);

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

	rtn = rtn||'| |执行完毕, 删除记录数: '||v_count||' 条||';

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

	rtn = rtn||'||执行完毕, 新增记录数: '||v_count||'条||';



	return rtn;

END;

$$ LANGUAGE plpgsql;



COMMENT ON FUNCTION gamebox_operation_company(centerid TEXT, curday TEXT)

IS 'Fly - 经营报表-运营商报表';