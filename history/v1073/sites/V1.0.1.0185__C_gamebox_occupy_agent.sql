-- auto gen by admin 2016-06-30 15:37:20
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

--v1.04  2016/06/27  Leisure  统计时间由bet_time改为payout_time --by acheng

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



							--WHERE bet_time >= start_time::TIMESTAMP

							--	AND bet_time < end_time::TIMESTAMP

							WHERE payout_time >= start_time::TIMESTAMP

							  AND payout_time < end_time::TIMESTAMP

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





drop function if exists gamebox_occupy_agent(INT);

create or replace function gamebox_occupy_agent(

	bill_id INT

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：总代占成-代理贡献

--v1.01  2016/06/28  Leisure  增加返佣上限判断

*/

DECLARE

	pending_lssuing text:='pending_lssuing';

	pending_pay 	text:='pending_pay';

	n_max_rebate	FLOAT;

	rec record;



BEGIN

--v1.01  2016/06/28  Leisure

/*

	INSERT INTO occupy_agent(

		occupy_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,

		preferential_value, rakeback, occupy_total, refund_fee, recommend, apportion, rebate, lssuing_state

	)

	SELECT a1.*, pending_pay

	  	FROM (SELECT

	  			p.occupy_bill_id, a.id, a.username,

	  			COUNT(distinct p.player_id), sum(p.effective_transaction), SUM(p.profit_loss),

	  			SUM(preferential_value), SUM(rakeback), SUM(occupy_total), SUM(refund_fee),

	  			SUM(recommend), SUM(apportion), SUM(rebate)

	 		  FROM occupy_player p, sys_user u, sys_user a

	 		 WHERE p.player_id = u.id

     		   AND p.occupy_bill_id = bill_id

	   		   AND u.owner_id = a.id

	   		   AND u.user_type = '24'

	   		   AND a.user_type = '23'

	  		 GROUP BY p.occupy_bill_id, a.id, a.username

	 ) a1;

*/



  FOR rec IN

		SELECT p.occupy_bill_id, a.id agent_id, a.username,

		       COUNT(distinct p.player_id) cnum, sum(p.effective_transaction) effective_transaction, SUM(p.profit_loss) profit_loss,

		       SUM(preferential_value) preferential_value, SUM(rakeback) rakeback, SUM(occupy_total) occupy_total, SUM(refund_fee) refund_fee,

		       SUM(recommend) recommend, SUM(apportion) apportion, SUM(rebate) rebate, pending_pay pending_pay

	 	  FROM occupy_player p, sys_user u, sys_user a

	 	 WHERE p.player_id = u.id

       AND p.occupy_bill_id = bill_id

	     AND u.owner_id = a.id

 		   AND u.user_type = '24'

	     AND a.user_type = '23'

	   GROUP BY p.occupy_bill_id, a.id, a.username

	LOOP



		SELECT COALESCE(MAX(max_rebate), 0)

		  INTO n_max_rebate

		  FROM (

		        SELECT ua.user_id, rg.valid_player_num, rg.total_profit, rg.max_rebate

		          FROM rebate_grads rg, user_agent_rebate ua

		         WHERE ua.rebate_id = rg.rebate_id) arg

		 WHERE arg.user_id = rec.agent_id

		   AND rec.cnum >= arg.valid_player_num

		   AND rec.profit_loss >= arg.total_profit;



		--raise info 'rec.rebate: % , n_max_rebate: %', rec.rebate, n_max_rebate;



		IF n_max_rebate <> 0 AND rec.rebate > n_max_rebate THEN

			rec.rebate = n_max_rebate;

		END IF;



		INSERT INTO occupy_agent(

			occupy_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,

			preferential_value, rakeback, occupy_total, refund_fee, recommend, apportion, rebate, lssuing_state

		)

    VALUES(rec.occupy_bill_id, rec.agent_id, rec.username,

		       rec.cnum, rec.effective_transaction, rec.profit_loss,

		       rec.preferential_value, rec.rakeback, rec.occupy_total, rec.refund_fee,

		       rec.recommend, rec.apportion, rec.rebate, rec.pending_pay

		);



	END LOOP;



  raise info '总代占成-代理贡献度.完成';



END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_agent(INT)

IS 'Lins-总代占成-代理贡献';