-- auto gen by admin 2016-04-26 11:10:38
/**
 * 游戏概况-入口.
 * @author 	Fly
 * @date 	2016-02-16
 * @param 	master_url 	站点库dblink格式URL
 * @param 	sid 		站点ID
 */
drop function if exists gamebox_game_survey(TEXT, INT, TEXT);
drop function if exists gamebox_game_survey(TEXT, INT, TIMESTAMP, TIMESTAMP);
create or replace function gamebox_game_survey(
	dblink_url 	TEXT,
	sid			INT,
	start_time 	TIMESTAMP,
	end_time	TIMESTAMP
) returns void as $$
DECLARE
	rec 	record;
	gs_id 	INT;

BEGIN
	IF ltrim(rtrim(dblink_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	raise info '清除 %-% 号统计数据...', start_time, end_time;
	DELETE FROM game_survey WHERE site_id = sid AND statistics_time = end_time;

 	raise info '统计 %-% 号游戏数据.START', start_time, end_time;
	FOR rec IN
		SELECT s.operationid, s.masterid, s.siteid, o.api_id, o.api_type_id, o.transaction_order,
			   o.effective_transaction_volume, o.transaction_profit_loss, o.transaction_player
		  FROM dblink (dblink_url,
			' SELECT gamebox_current_site() 			as site_id,
					 pgo.api_id,
					 pgo.api_type_id,
					 SUM(pgo.single_amount)				as transaction_order,
					 SUM(pgo.effective_trade_amount)	as effective_transaction_volume,
					 SUM(pgo.profit_amount)				as transaction_profit_loss,
		 			 COUNT(DISTINCT pgo.player_id) 		as transaction_player
				FROM player_game_order pgo
		 	   WHERE pgo.create_time >= '''||start_time||'''
		 	     AND pgo.create_time < '''||end_time||'''
		 	   GROUP BY site_id, pgo.api_id, pgo.api_type_id')
				  AS o(site_id int, api_id int, api_type_id int, transaction_order numeric,
				  	  effective_transaction_volume numeric, transaction_profit_loss numeric, transaction_player int)
		  LEFT JOIN sys_site_info s ON o.site_id = s.siteid
		 WHERE s.siteid = sid

	LOOP
		raise info 'api_id = %, api_type_id = %', rec.api_id, rec.api_type_id;

		INSERT INTO game_survey (
			center_id, master_id, site_id, statistics_time, api_id, api_type_id,
			transaction_order, effective_transaction_volume, transaction_profit_loss, transaction_player
		) VALUES (
			rec.operationid, rec.masterid, rec.siteid, end_time, rec.api_id, rec.api_type_id,
			rec.transaction_order, rec.effective_transaction_volume, rec.transaction_profit_loss, rec.transaction_player
		);
		SELECT currval(pg_get_serial_sequence('game_survey', 'id')) into gs_id;
		raise info 'game_survey.新增.键值 = %', gs_id;

	END LOOP;
 	raise info '统计 %-% 号游戏数据.END', start_time, end_time;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_game_survey(dblink_url TEXT, sid INT, start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Fly-游戏概况-入口';

/**
 * 经营概况-入口.
 * @author 	Fly
 * @date 	2016-02-16
 * @param 	master_url 	站点库dblink格式URL
 * @param 	sid 		站点ID
 */
drop function if exists gamebox_operation_profile(TEXT, INT, TEXT);
drop function if exists gamebox_operation_profile(TEXT, INT, TIMESTAMP, TIMESTAMP);
create or replace function gamebox_operation_profile(
	dblink_url 	TEXT,
	sid			INT,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP
) returns void as $$
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
			   o.effective_transaction_volume, o.transaction_player, o.transaction_profit_loss
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
					(SELECT SUM(transaction_money)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
						AND transaction_type = ''deposit''
						AND status = ''success'') 		as deposit_amount,
					(SELECT COUNT(DISTINCT player_id)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
						AND transaction_type = ''deposit''
						AND status = ''success'') 		as deposit_player,
					(SELECT SUM(COALESCE(transaction_money, 0.00))
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
						AND transaction_type = ''withdrawals''
						AND status = ''success'') 		as withdrawal_amount,
					(SELECT COUNT(DISTINCT player_id)
					   FROM player_transaction
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||'''
						AND transaction_type = ''withdrawals''
						AND status = ''success'') 		as withdrawal_player,
					(SELECT SUM(COALESCE(effective_trade_amount, 0.00))
					   FROM player_game_order
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||''') as effective_transaction_volume,
					(SELECT COUNT(DISTINCT player_id)
					   FROM player_game_order
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||''') as transaction_player,
					(SELECT SUM(COALESCE(profit_amount, 0.00))
					   FROM player_game_order
					  WHERE create_time >= '''||start_time||''' AND create_time < '''||end_time||''') as transaction_profit_loss')
				  AS o(site_id int, new_player int, new_agent int, new_player_deposit numeric,
				  	  deposit_amount numeric, deposit_player int, withdrawal_amount numeric, withdrawal_player int,
				  	  effective_transaction_volume numeric, transaction_player int, transaction_profit_loss numeric)
		  LEFT JOIN sys_site_info s ON o.site_id = s.siteid
		 WHERE s.siteid = sid

	LOOP
		INSERT INTO operation_profile (
			center_id, master_id, site_id,
			statistics_time, new_player, new_player_deposit, new_agent,
			deposit_amount, deposit_player, withdrawal_amount, withdrawal_player,
			effective_transaction_volume, transaction_player, transaction_profit_loss
		) VALUES (
			rec.operationid, rec.masterid, rec.siteid,
			end_time, rec.new_player, rec.new_player_deposit, rec.new_agent,
			rec.deposit_amount, rec.deposit_player, rec.withdrawal_amount, rec.withdrawal_player,
			rec.effective_transaction_volume, rec.transaction_player, rec.transaction_profit_loss
		);
		SELECT currval(pg_get_serial_sequence('operation_profile', 'id')) into gs_id;
		raise info 'operation_profile.新增.键值 = %', gs_id;

	END LOOP;
	raise info '统计 %-% 号经营数据.END', start_time, end_time;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_profile(dblink_url TEXT, sid INT, start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Fly-经营概况';
