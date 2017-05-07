/**
 * 游戏概况-入口.
 * @author 	Fly
 * @date 	2016-02-16
 * @param 	master_url 	站点库dblink格式URL
 * @param 	sid 		站点ID
**/
--drop function if exists gamebox_game_survey(TEXT, INT, TEXT);
drop function if exists gamebox_game_survey(TEXT, INT, TIMESTAMP, TIMESTAMP);
create or replace function gamebox_game_survey(
	dblink_url 	TEXT,
	sid			INT,
	start_time 	TIMESTAMP,
	end_time	TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fly      创建此函数: 游戏概况-入口（已停用）
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/09/19  Leisure  增加统计日期，统计开始、结束时间，
                              pgo增加order_state判断
--v1.03  2016/09/20  Leisure  bet_time改为payout_time，增加删除记录日志
--v1.04  2016/10/01  Leisure  游戏概况改由经营报表——站点经营报表获取
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
	DELETE FROM game_survey WHERE site_id = sid AND static_date = stat_date;
	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次删除记录数 %', n_count;

	raise info '统计 % 号游戏数据.START', stat_date;
	FOR rec IN
		SELECT s.operationid, s.masterid, s.siteid, o.api_id, o.api_type_id, o.transaction_order,
			   o.effective_transaction_volume, o.transaction_profit_loss, o.transaction_player
		  FROM dblink (dblink_url,
			' SELECT gamebox_current_site() 	as site_id,
							 pgo.api_id,
							 pgo.api_type_id,
							 SUM(pgo.single_amount) 	as transaction_order,
							 SUM(pgo.effective_trade_amount) 	as effective_transaction_volume,
							 SUM(pgo.profit_amount) 	as transaction_profit_loss,
							 COUNT(DISTINCT pgo.player_id) 	as transaction_player
			    FROM player_game_order pgo
			   WHERE pgo.payout_time >= '''||start_time||'''
			     AND pgo.payout_time < '''||end_time||'''
			     AND pgo.order_state = ''settle''
			   GROUP BY site_id, pgo.api_id, pgo.api_type_id')
		AS o(site_id int, api_id int, api_type_id int, transaction_order numeric,
				 effective_transaction_volume numeric, transaction_profit_loss numeric, transaction_player int)
		  LEFT JOIN sys_site_info s ON o.site_id = s.siteid
		 WHERE s.siteid = sid
	LOOP
		raise info 'api_id = %, api_type_id = %', rec.api_id, rec.api_type_id;

		INSERT INTO game_survey (
			center_id, master_id, site_id, api_id, api_type_id,
			transaction_order, effective_transaction_volume, transaction_profit_loss, transaction_player,
			static_date, static_time, static_time_end
		) VALUES (
			rec.operationid, rec.masterid, rec.siteid, rec.api_id, rec.api_type_id,
			rec.transaction_order, rec.effective_transaction_volume, rec.transaction_profit_loss, rec.transaction_player,
			stat_date, start_time, end_time
		) RETURNING id into gs_id;

		raise info 'game_survey.新增.键值 = %', gs_id;

	END LOOP;

	raise info '统计 % 号游戏数据.END', stat_date;

END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_game_survey(dblink_url TEXT, sid INT, start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Fly-游戏概况-入口（已停用）';

/*
SELECT gamebox_game_survey(
	'host=192.168.0.88 dbname=gb-sites user=gb-site-2 password=postgres',
	70,
	'2016-04-01 00:23:33'::TIMESTAMP,
	'2016-04-30 12:30:24'::TIMESTAMP
);
*/
