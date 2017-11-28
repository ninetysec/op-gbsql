-- auto gen by bruce 2016-10-02 11:04:35
drop function if exists gamebox_operation_profile(TEXT, INT, DATE, TIMESTAMP, TIMESTAMP);
create or replace function gamebox_operation_profile(
	dblink_url 	TEXT,
	sid 	INT,
	stat_date 	DATE,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fly      创建此函数: 经营概况
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/09/11  Leisure  经营概况，增加各种费用的统计
--v1.03  2016/09/12  Leisure  修改single_amount由order_no获取
--v1.04  2016/09/18  Leisure  增加统计日期，统计开始、结束时间，
                              统计代理增加已审核条件，
                              修正fund_type条件，
                              player_transaction表create_time改为completion_time
--v1.05  2016/09/20  Leisure  bet_time改为payout_time，增加删除记录日志
--v1.06  2016/09/21  Leisure  存取款不再包含手动存取款，新增代理状态包含123
--v1.07  2016/09/25  Leisure  抛弃for循环，交易量从经营报表获取
--v1.08  2016/09/29  Leisure  存取款，包含手动存取
--v1.09  2016/10/01  Leisure  增加取款总额，存款总额统计
--v1.10  2016/10/02  Leisure  优惠不包含返手续费、修正反水条件（人工反水不属于人工存款）
*/
DECLARE
	rec 	record;
	gs_id 	INT;
	n_count 	INT;

BEGIN
	IF ltrim(rtrim(dblink_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	raise info '清除 % 号统计数据...', stat_date;
	DELETE FROM operation_profile WHERE site_id = sid AND static_date = stat_date;
	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次删除记录数 %', n_count;

	raise info '统计 % 号经营数据.START', stat_date;

	SELECT s.operationid, s.masterid, s.siteid, o.new_player, o.new_agent, o.new_player_deposit, o.deposit_new_player,
				 o.deposit_player, o.deposit_amount, o.deposit_total, o.withdrawal_player, o.withdrawal_amount, o.withdrawal_total,
				 o.rakeback_amount + o.favorable_amount + o.recommend_amount + o.refund_amount + o.rebate_amount as expenditure,
				 o.rakeback_player, o.rakeback_amount, o.favorable_player, o.favorable_amount,
				 o.recommend_player, o.recommend_amount, o.refund_player, o.refund_amount,
				 o.rebate_player, o.rebate_amount, o.transaction_player,
				 so.effective_transaction_volume, so.transaction_profit_loss, so.single_amount
		INTO rec
		FROM dblink (dblink_url,
				'SELECT (SELECT gamebox_current_site()) 	as site_id, --站点ID
				(SELECT COUNT(1) FROM sys_user
				  WHERE user_type = ''24''
				    AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''') as new_player, --新增玩家
				(SELECT COUNT(1) FROM sys_user
				  WHERE user_type = ''23''
				    AND status IN (''1'', ''2'', ''3'')
				    AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''') as new_agent, --新增代理

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE player_id IN (SELECT id FROM sys_user WHERE user_type = ''24'' AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''')
				    AND completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND (fund_type <> ''artificial_deposit'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as new_player_deposit, --新玩家存款人数

				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE player_id IN (SELECT id FROM sys_user WHERE user_type = ''24'' AND create_time >= '''||start_time||''' AND create_time < '''||end_time||''')
				    AND completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND (fund_type <> ''artificial_deposit'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as deposit_new_player, --新增玩家存款（包含人工存款——人工存取）

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND (fund_type <> ''artificial_deposit'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as deposit_player, --当日存款人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND (fund_type <> ''artificial_deposit'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as deposit_amount, --当日存款（包含人工存款——人工存取）
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''deposit''
				    AND status = ''success'') 		as deposit_total, --当日存款总额（包含所有人工存款）

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''withdrawals''
				    AND (fund_type <> ''artificial_withdraw'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as withdrawal_player, --当日取款人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''withdrawals''
				    AND (fund_type <> ''artificial_withdraw'' OR transaction_way = ''manual_deposit'')
				    AND status = ''success'') 		as withdrawal_amount, --当日取款（包含人工取款——人工存取）
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND transaction_type = ''withdrawals''
				    AND status = ''success'') 		as withdrawal_total, --当日取款（包含所有人工取款）

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND (transaction_type = ''backwater'' OR
				        --包含人工反水
				         (transaction_type = ''favorable'' AND transaction_way = ''manual_rakeback''))
				    AND status = ''success'') 		as rakeback_player, --反水人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND (transaction_type = ''backwater'' OR
				       --包含人工反水
				         (transaction_type = ''favorable'' AND transaction_way = ''manual_rakeback''))
				    AND status = ''success'') 		as rakeback_amount, --反水金额

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND (transaction_type = ''favorable''
				         --包含人工存入优惠，不包含人工反水、返手续费
				         AND fund_type <> ''refund_fee''
				         AND transaction_way <> ''manual_rakeback'')
				    AND status = ''success'') 		as favorable_player, --优惠人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND (transaction_type = ''favorable''
				         --包含人工存入优惠，不包含人工反水、返手续费
				         AND fund_type <> ''refund_fee''
				         AND transaction_way <> ''manual_rakeback'')
				    AND status = ''success'') 		as favorable_amount, --优惠金额

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND fund_type = ''recommend''
				    AND status = ''success'') 		as recommend_player, --推荐人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND fund_type = ''recommend''
				    AND status = ''success'') 		as recommend_amount, --推荐金额

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND fund_type = ''refund_fee''
				    AND status = ''success'') 		as refund_player, --返手续费人数
				(SELECT COALESCE(SUM(transaction_money), 0.00)
				   FROM player_transaction
				  WHERE completion_time >= '''||start_time||''' AND completion_time < '''||end_time||'''
				    AND fund_type = ''refund_fee''
				    AND status = ''success'') 		as refund_amount, --返手续费金额

				(SELECT COUNT(DISTINCT ra.agent_id)
				   FROM rebate_agent ra
				  WHERE ra.settlement_time >= '''||start_time||''' AND ra.settlement_time < '''||end_time||'''
				    AND ra.settlement_state = ''lssuing'') 		as rebate_player, --返佣人数
				(SELECT COALESCE(SUM(ra.rebate_actual), 0.00)
				   FROM rebate_agent ra
				  WHERE ra.settlement_time >= '''||start_time||''' AND ra.settlement_time < '''||end_time||'''
				    AND ra.settlement_state = ''lssuing'') 		as rebate_amount, --返佣金额

				(SELECT COUNT(DISTINCT player_id)
				   FROM player_game_order
				  WHERE payout_time >= '''||start_time||''' AND payout_time < '''||end_time||'''
				    AND order_state = ''settle'') as transaction_player --当日交易玩家数
				')
/*--v1.07  2016/09/25  Leisure
				(SELECT COALESCE(SUM(effective_trade_amount), 0.00)
				   FROM player_game_order
				  WHERE payout_time >= '''||start_time||''' AND payout_time < '''||end_time||'''
				    AND order_state = ''settle'') as effective_transaction_volume, --当日有效交易量

				(SELECT COALESCE(SUM(profit_amount), 0.00)
				   FROM player_game_order
				  WHERE payout_time >= '''||start_time||''' AND payout_time < '''||end_time||'''
				    AND order_state = ''settle'') as transaction_profit_loss, --当日盈亏

				(SELECT COUNT(order_no)
				   FROM player_game_order
				  WHERE payout_time >= '''||start_time||''' AND payout_time < '''||end_time||'''
				    AND order_state = ''settle'') 		as single_amount --交易单量
*/

			AS o(site_id int, new_player int, new_agent int, new_player_deposit int, deposit_new_player numeric,
				 deposit_player int, deposit_amount numeric, deposit_total numeric, withdrawal_player int, withdrawal_amount numeric, withdrawal_total numeric,
				 rakeback_player int, rakeback_amount numeric, favorable_player int, favorable_amount numeric,
				 recommend_player int, recommend_amount numeric, refund_player int, refund_amount numeric,
				 rebate_player int, rebate_amount numeric, transaction_player int)
				 /*,--v1.07  2016/09/25  Leisure
				 effective_transaction_volume numeric, transaction_profit_loss numeric, single_amount numeric
				 */
		LEFT JOIN sys_site_info s ON o.site_id = s.siteid
		LEFT JOIN (SELECT site_id 	siteid,
										  master_id masterid,
										  center_id 	operationid,
										  --SUM(transaction_volume) 	transaction_volume,
										  SUM(effective_transaction) 	effective_transaction_volume,
										  SUM(profit_loss) 	transaction_profit_loss,
										  SUM(transaction_order) 	single_amount
								 FROM site_operate so
								WHERE site_id = sid
								  AND static_date = stat_date
								GROUP BY site_id, master_id, center_id) so
		ON o.site_id = so.siteid;

	INSERT INTO operation_profile (
	  center_id, master_id, site_id, static_time,
	  new_agent, new_player, new_player_deposit, deposit_new_player,
	  deposit_player, deposit_amount, deposit_total, withdrawal_player, withdrawal_amount, withdrawal_total,
	  expenditure, rakeback_player, rakeback_amount, favorable_player, favorable_amount,
	  recommend_player, recommend_amount, refund_player, refund_amount,
	  rebate_player, rebate_amount, single_amount, static_date, static_time_end, transaction_player,
	  effective_transaction_volume, transaction_profit_loss
	) VALUES (
	  rec.operationid, rec.masterid, rec.siteid, start_time,
	  rec.new_agent, rec.new_player, rec.new_player_deposit, rec.deposit_new_player,
	  rec.deposit_player, rec.deposit_amount, rec.deposit_total, rec.withdrawal_player, rec.withdrawal_amount, rec.withdrawal_total,
	  rec.expenditure, rec.rakeback_player, rec.rakeback_amount, rec.favorable_player, rec.favorable_amount,
	  rec.recommend_player, rec.recommend_amount, rec.refund_player, rec.refund_amount,
	  rec.rebate_player, rec.rebate_amount, rec.single_amount, stat_date, end_time, rec.transaction_player,
	  rec.effective_transaction_volume, rec.transaction_profit_loss
	) RETURNING id into gs_id;

	raise info 'operation_profile.新增.键值 = %', gs_id;

	raise info '统计 % 号经营数据.END', stat_date;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_profile(dblink_url TEXT, sid INT, stat_date DATE, start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Fly-经营概况';