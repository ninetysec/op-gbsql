-- auto gen by cherry 2016-09-12 22:07:33
drop function if exists gamebox_operation_profile(TEXT, INT, TIMESTAMP, TIMESTAMP);
create or replace function gamebox_operation_profile(
	dblink_url 	TEXT,
	sid			INT,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fly      创建此函数: 经营概况
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/09/11  Leisure  经营概况，增加各种费用的统计
--v1.03  2016/09/12  Leisure  修改single_amount由order_no获取
*/
DECLARE
	rec 	record;
	gs_id 	INT;

BEGIN
	IF ltrim(rtrim(dblink_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	raise info '清除 %-% 号统计数据...', start_time, end_time;
	DELETE FROM operation_profile WHERE site_id = sid AND statistics_time = end_time;

	raise info '统计 %-% 号经营数据.START', start_time, end_time;
	FOR rec IN
		SELECT s.operationid, s.masterid, s.siteid, o.new_player, o.new_player_deposit, o.new_agent,
					 o.deposit_amount, o.deposit_player, o.withdrawal_amount, o.withdrawal_player,
					 o.effective_transaction_volume, o.transaction_player, o.transaction_profit_loss,
					 o.deposit_new_player, o.rakeback_amount + o.favorable_amount + o.recommend_amount + o.refund_amount + o.rebate_amount as expenditure,
					 o.rakeback_player, o.rakeback_amount, o.favorable_player, o.favorable_amount,
					 o.recommend_player, o.recommend_amount, o.refund_player, o.refund_amount,
					 o.rebate_player, o.rebate_amount, o.single_amount
			FROM dblink (dblink_url,
					'SELECT (SELECT gamebox_current_site()) 	as site_id,
					(SELECT COUNT(1) FROM sys_user
					  WHERE user_type = ''24''
					    AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''') as new_player,
					(SELECT COUNT(1) FROM sys_user
					  WHERE user_type = ''23''
					    AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''') as new_agent,

					(SELECT COUNT(DISTINCT player_id)
					   FROM player_transaction
					  WHERE player_id IN (SELECT id FROM sys_user WHERE user_type = ''24'' AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''')
					    AND create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''deposit''
					    AND status = ''success'') 		as new_player_deposit,

					(SELECT COALESCE(SUM(transaction_money), 0.00)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''deposit''
					    AND status = ''success'') 		as deposit_amount,
					(SELECT COUNT(DISTINCT player_id)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''deposit''
					    AND status = ''success'') 		as deposit_player,

					(SELECT COALESCE(SUM(transaction_money), 0.00)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''withdrawals''
					    AND status = ''success'') 		as withdrawal_amount,
					(SELECT COUNT(DISTINCT player_id)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''withdrawals''
					    AND status = ''success'') 		as withdrawal_player,

					(SELECT COALESCE(SUM(effective_trade_amount), 0.00)
					   FROM player_game_order
					  WHERE bet_time >= '''||start_time||''' AND bet_time < '''||end_time||''') as effective_transaction_volume,
					(SELECT COUNT(DISTINCT player_id)
					   FROM player_game_order
					  WHERE bet_time >= '''||start_time||''' AND bet_time < '''||end_time||''') as transaction_player,
					(SELECT COALESCE(SUM(profit_amount), 0.00)
					   FROM player_game_order
					  WHERE bet_time >= '''||start_time||''' AND bet_time < '''||end_time||''') as transaction_profit_loss,

					(SELECT COALESCE(SUM(transaction_money), 0.00)
					   FROM player_transaction
					  WHERE player_id IN (SELECT id FROM sys_user WHERE user_type = ''24'' AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''')
					    AND create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''deposit''
					    AND status = ''success'') 		as new_player_deposit,

					(SELECT COUNT(DISTINCT player_id)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''backwater''
					    AND status = ''success'') 		as rakeback_player,
					(SELECT COALESCE(SUM(transaction_money), 0.00)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''backwater''
					    AND status = ''success'') 		as rakeback_amount,

					(SELECT COUNT(DISTINCT player_id)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND (fund_type = ''favourable'' OR
					         (fund_type = ''artificial_deposit'' AND transaction_type = ''favorable''))
					    AND status = ''success'') 		as favorable_player,
					(SELECT COALESCE(SUM(transaction_money), 0.00)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND (fund_type = ''favourable'' OR
					        (fund_type = ''artificial_deposit'' AND transaction_type = ''favorable''))
					    AND status = ''success'') 		as favorable_amount,

					(SELECT COUNT(DISTINCT player_id)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''recommend''
					    AND status = ''success'') 		as recommend_player,
					(SELECT COALESCE(SUM(transaction_money), 0.00)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''recommend''
					    AND status = ''success'') 		as recommend_amount,

					(SELECT COUNT(DISTINCT player_id)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''refund_fee''
					    AND status = ''success'') 		as refund_player,
					(SELECT COALESCE(SUM(transaction_money), 0.00)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
					    AND transaction_type = ''refund_fee''
					    AND status = ''success'') 		as refund_amount,

					(SELECT COUNT(DISTINCT ra.agent_id)
					   FROM rebate_agent ra
					  WHERE ra.settlement_time >= '''||start_time||''' AND ra.settlement_time < '''||end_time||'''
					    AND ra.settlement_state = ''lssuing'') 		as rebate_player,
					(SELECT COALESCE(SUM(ra.rebate_actual), 0.00)
					   FROM rebate_agent ra
					  WHERE ra.settlement_time >= '''||start_time||''' AND ra.settlement_time < '''||end_time||'''
					    AND ra.settlement_state = ''lssuing'') 		as rebate_amount,

					(SELECT COUNT(order_no)
					   FROM player_game_order
					  WHERE bet_time >= '''||start_time||''' AND bet_time < '''||end_time||'''
					    AND order_state = ''settle'') 		as single_amount
		')
			AS o(site_id int, new_player int, new_agent int, new_player_deposit numeric,
					 deposit_amount numeric, deposit_player int, withdrawal_amount numeric, withdrawal_player int,
					 effective_transaction_volume numeric, transaction_player int, transaction_profit_loss numeric,
					 deposit_new_player numeric, rakeback_player int, rakeback_amount numeric, favorable_player int, favorable_amount numeric,
					 recommend_player int, recommend_amount numeric, refund_player int, refund_amount numeric,
					 rebate_player int, rebate_amount numeric, single_amount numeric)
		  LEFT JOIN sys_site_info s ON o.site_id = s.siteid
		 WHERE s.siteid = sid

	LOOP
		INSERT INTO operation_profile (
		  center_id, master_id, site_id,
		  statistics_time, new_player, new_player_deposit, new_agent,
		  deposit_amount, deposit_player, withdrawal_amount, withdrawal_player,
		  effective_transaction_volume, transaction_player, transaction_profit_loss,
		  deposit_new_player, expenditure, rakeback_player, rakeback_amount, favorable_player, favorable_amount,
		  recommend_player, recommend_amount, refund_player, refund_amount,
		  rebate_player, rebate_amount, single_amount
		) VALUES (
		  rec.operationid, rec.masterid, rec.siteid,
		  end_time, rec.new_player, rec.new_player_deposit, rec.new_agent,
		  rec.deposit_amount, rec.deposit_player, rec.withdrawal_amount, rec.withdrawal_player,
		  rec.effective_transaction_volume, rec.transaction_player, rec.transaction_profit_loss,
		  rec.deposit_new_player, rec.expenditure, rec.rakeback_player, rec.rakeback_amount, rec.favorable_player, rec.favorable_amount,
		  rec.recommend_player, rec.recommend_amount, rec.refund_player, rec.refund_amount,
		  rec.rebate_player, rec.rebate_amount, rec.single_amount
		);
		SELECT currval(pg_get_serial_sequence('operation_profile', 'id')) into gs_id;
		raise info 'operation_profile.新增.键值 = %', gs_id;

	END LOOP;
	raise info '统计 %-% 号经营数据.END', start_time, end_time;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_profile(dblink_url TEXT, sid INT, start_time TIMESTAMP, end_time TIMESTAMP) IS 'Fly-经营概况';