-- auto gen by admin 2016-06-14 14:45:50
drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, text, text);

create or replace function gamebox_expense_gather(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	row_split 	text,

	col_split 	text

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     分摊费用

--v1.01  2016/05/12  Leisure  修正统计优惠信息的条件（返佣）

--v1.02  2016/06/06  Leisure  公司存款/线上支付增加微信/支付宝存款/支付

*/

DECLARE

	rec 		record;

	hash 		hstore;

	mhash 		hstore;

	param 		text:='';

	user_id 	text:='';

	money 		float:=0.00;



BEGIN

	FOR rec IN

		SELECT pt.*, su.owner_id

		  FROM (SELECT player_id,

		               fund_type,

		               SUM(transaction_money) as transaction_money

		          FROM (SELECT player_id,

		                       fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND fund_type in ('backwater', 'refund_fee', 'artificial_deposit',

		                                     'artificial_withdraw', 'player_withdraw')

		                   AND create_time >= start_time

		                   AND create_time < end_time

		                   AND NOT (fund_type = 'artificial_deposit' AND

		                            transaction_type = 'favorable')



		                UNION ALL

		                --优惠、推荐

		                SELECT player_id,

		                       --fund_type||transaction_type,

		                       'favourable' fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND (fund_type = 'favourable' OR

		                        fund_type = 'recommend'  OR

		                        (fund_type = 'artificial_deposit' AND transaction_type = 'favorable'))

		                   AND create_time >= start_time

		                   AND create_time < end_time



		                UNION ALL

		                --公司存款 --v1.02  2016/06/06  Leisure

		                SELECT player_id,

		                       --fund_type||transaction_type,

		                       'company_deposit' fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND fund_type IN ('company_deposit','wechatpay_fast' ,'alipay_fast')

		                   AND create_time >= start_time

		                   AND create_time < end_time



		                UNION ALL

		                --线上支付 --v1.02  2016/06/06  Leisure

		                SELECT player_id,

		                       --fund_type||transaction_type,

		                       'online_deposit' fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND fund_type IN ('online_deposit','wechatpay_scan' ,'alipay_scan')

		                   AND create_time >= start_time

		                   AND create_time < end_time

		               ) ptu

		         GROUP BY player_id, fund_type

		       ) pt

		       LEFT JOIN

		       sys_user su ON pt.player_id = su."id"

		 WHERE su.user_type = '24'

	LOOP

		user_id = rec.player_id::text;

		money 	= rec.transaction_money;

		IF isexists(hash, user_id) THEN

			param = hash->user_id;

			param = param||row_split||rec.fund_type||col_split||money::text;

		ELSE

			param = rec.fund_type||col_split||money::text;

		END IF;



		IF position('agent_id' IN param) = 0  THEN

			param = param||row_split||'agent_id'||col_split||rec.owner_id::TEXT;

		END IF;



		SELECT user_id||'=>'||param into mhash;

		IF hash is null THEN

			hash = mhash;

		ELSE

			hash = hash||mhash;

		END IF;

	END LOOP;



	return hash;

END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP, row_split text, col_split text)

IS 'Lins-分摊费用';



drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, TEXT);

create or replace function gamebox_expense_gather(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	category 	TEXT

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：分摊费用

--v1.01  2016/05/12  Leisure  修正统计优惠信息的条件（占成）

--v1.02  2016/06/06  Leisure  公司存款、线上支付增加微信、支付宝存款、支付

*/

DECLARE

	rec 	record;

	hash 	hstore;

	mhash 	hstore;

	param 	text:='';

	user_id 	text:='';

	money 	float:=0.00;

	name 	TEXT:='';

	cols 	TEXT;

	tables 	TEXT;

	grups 	TEXT;



	sys_config hstore;

	sp TEXT:='@';

	rs TEXT:='\~';

	cs TEXT:='\^';

BEGIN

	--取得系统变量

	SELECT sys_config() INTO sys_config;

	sp = sys_config->'sp_split';

	rs = sys_config->'row_split';

	cs = sys_config->'col_split';



	IF category = 'TOP' THEN

		cols = 'u.topagent_id as id, u.topagent_name as name, ';

		tables= 'player_transaction p, v_sys_user_tier u';

		grups= 'u.topagent_id, u.topagent_name ';

	ELSEIF category ='AGENT' THEN

		cols = 'u.agent_id as id, u.agent_name as name, ';

		tables = 'player_transaction p, v_sys_user_tier u';

		grups = 'u.agent_id, u.agent_name ';

	ELSE

		cols = 'p.player_id as id, u.username as name, ';

		tables = 'player_transaction p, v_sys_user_tier u';

		grups = 'p.player_id, u.username ';

	END IF;

	FOR rec IN EXECUTE

		'SELECT id,

		        name,

		        fund_type,

		        SUM(transaction_money) as transaction_money

		   FROM (SELECT '||cols||'

		                p.fund_type,

		                transaction_money

		           FROM '||tables||'

		          WHERE p.player_id = u.id

		            AND p.fund_type IN (''backwater'', ''refund_fee'', ''artificial_deposit'',

		                                ''artificial_withdraw'', ''player_withdraw'')

		            AND p.status = ''success''

		            AND NOT (fund_type = ''artificial_deposit'' AND

                         transaction_type = ''favorable'')

		            AND p.create_time >= $1

		            AND p.create_time < $2



		         UNION ALL

		         --优惠、推荐

		         SELECT '||cols||'

		                --p.fund_type||p.transaction_type,

		                ''favourable'' fund_type,

		                transaction_money

		           FROM '||tables||'

		          WHERE p.player_id = u.id

                AND (fund_type = ''favourable'' OR

		                 fund_type = ''recommend'' OR

		                 (fund_type = ''artificial_deposit'' AND transaction_type = ''favorable''))

		            AND status = ''success''

		            AND create_time >= $1

		            AND create_time < $2



		         UNION ALL

		         --公司存款 --v1.02  2016/06/06  Leisure

		         SELECT '||cols||'

		                --p.fund_type||p.transaction_type,

		                ''company_deposit'' fund_type,

		                transaction_money

		           FROM '||tables||'

		          WHERE p.player_id = u.id

                AND fund_type IN (''company_deposit'', ''wechatpay_fast'', ''alipay_fast'')

		            AND status = ''success''

		            AND create_time >= $1

		            AND create_time < $2



		         UNION ALL

		         --线上支付 --v1.02  2016/06/06  Leisure

		         SELECT '||cols||'

		                --p.fund_type||p.transaction_type,

		                ''online_deposit'' fund_type,

		                transaction_money

		           FROM '||tables||'

		          WHERE p.player_id = u.id

                AND fund_type IN (''online_deposit'', ''wechatpay_scan'', ''alipay_scan'')

		            AND status = ''success''

		            AND create_time >= $1

		            AND create_time < $2) fund_union

		  GROUP BY id, name, fund_type'

		USING start_time, end_time

	LOOP

		user_id = rec.id::text;

		money 	= rec.transaction_money;

		name 	= rec.name;



		IF isexists(hash,user_id) THEN

			param = hash->user_id;

			param = param||rs||rec.fund_type||cs||money::text;

		ELSE

			param = 'user_name'||cs||name||rs||rec.fund_type||cs||money::text;

		END IF;



		SELECT user_id||'=>'||param INTO mhash;



		IF hash is null THEN

			hash = mhash;

		ELSE

			hash = hash||mhash;

		END IF;

	END LOOP;

	return hash;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT)

IS 'Lins-分摊费用';



drop function if exists gamebox_expense_leaving(TIMESTAMP, TIMESTAMP);

CREATE OR REPLACE FUNCTION gamebox_expense_leaving(

	p_start_time TIMESTAMP,

	p_end_time TIMESTAMP

)

  RETURNS "public"."hstore" AS $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2016/06/09  Leisure  创建此函数：返佣——上期未结费用

*/

DECLARE

	leaving_map 	hstore;

	f_expense_leaving		FLOAT := 0.00;

BEGIN



	SELECT COALESCE(SUM(rao.rebate_actual), 0.00)

		FROM rebate_agent rao, rebate_bill rb

	 WHERE rao.rebate_bill_id = rb.id

		 AND rao.settlement_state = 'next_lssuing'

		 AND rb.end_time <= p_end_time

		 AND rao.rebate_bill_id > (

			 SELECT COALESCE(MAX(rebate_bill_id), 0)

				 FROM rebate_agent rai

				WHERE rai.settlement_state <> 'next_lssuing'

					AND rai.agent_id = rao.agent_id

		 ) INTO f_expense_leaving;



	leaving_map := (SELECT ('expense_leaving=>'||f_expense_leaving)::hstore);



	RETURN leaving_map;

END;



$$ LANGUAGE 'plpgsql';

COMMENT ON FUNCTION gamebox_expense_leaving(p_start_time timestamp, p_end_time timestamp)

IS 'Leisure-返佣——上期未结费用';



drop function if exists gamebox_expense_map(TIMESTAMP, TIMESTAMP, hstore);

create or replace function gamebox_expense_map(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	sys_map 	hstore

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：返佣-其它费用.外调

--v1.01  2016/06/09  Leisure  增加上期未结费用计算

*/

DECLARE

	cost_map 	hstore;

	share_map 	hstore;

	leaving_map		hstore; --v1.01  2016/06/29  Leisure

	sid INT;

BEGIN

	SELECT gamebox_expense_gather(start_time, end_time) INTO cost_map;

	SELECT gamebox_expense_share(cost_map, sys_map) INTO share_map;

	--v1.01  2016/06/29  Leisure

	SELECT gamebox_expense_leaving(start_time, end_time) INTO leaving_map;

	SELECT gamebox_current_site() INTO sid;

	share_map = (SELECT ('site_id=>'||sid)::hstore)||share_map;

	RETURN cost_map||share_map||leaving_map;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense_map(start_time TIMESTAMP, end_time TIMESTAMP, sys_map hstore)

IS 'Lins-返佣-其它费用.外调';



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

--v1.02  2016/06/13  Leisure  修正一处bug

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

--v1.03  2016/06/13  Leisure  is_profit_loss=false的记录也需要统计by acheng

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

								--AND is_profit_loss = TRUE --v1.03  2016/06/13  Leisure

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