-- auto gen by cheery 2016-03-04 10:06:52

/**
 * 游戏概况-入口.
 * @author 	Fly
 * @date 	2016-02-16
 * @param 	master_url 	站点库dblink格式URL
 * @param 	sid 		站点ID
 * @param 	sta_date	统计时间
 */
drop function if exists gamebox_game_survey(TEXT, INT, TEXT);
create or replace function gamebox_game_survey(
	dblink_url 	TEXT,
	sid			INT,
	sta_date 	TEXT
) returns void as $$
DECLARE
	rec 	record;
	gs_id 	INT;

BEGIN
	IF ltrim(rtrim(dblink_url)) = '' THEN
		RAISE EXCEPTION '-1, 站点库URL为空';
	END IF;

	raise info '清除 % 号统计数据...', sta_date;
	DELETE FROM game_survey WHERE site_id = sid AND to_char(statistics_time, 'yyyy-MM-dd') = sta_date;

	raise '统计　%　号游戏数据.START', sta_date;
	FOR rec IN
		SELECT s.operationid, s.masterid, s.siteid,
			   o.api_id, o.api_type_id,
			   o.transaction_order, o.effective_transaction_volume, o.transaction_profit_loss, o.transaction_player
		  FROM dblink (
			dblink_url,
			' SELECT gamebox_current_site() 			as site_id,
					 pgo.api_id,
					 pgo.api_type_id,
					 SUM(pgo.single_amount)				as transaction_order,
					 SUM(pgo.effective_trade_amount)	as effective_transaction_volume,
					 SUM(pgo.profit_amount)				as transaction_profit_loss,
		 			 COUNT(DISTINCT pgo.player_id) 		as transaction_player
				FROM player_game_order pgo
		 	   WHERE to_char(pgo.create_time, ''yyyy-MM-dd'') = to_char('''||sta_date||'''::TIMESTAMP, ''yyyy-MM-dd'')
		 	   GROUP BY site_id, pgo.api_id, pgo.api_type_id')
				  AS o(site_id int, api_id int, api_type_id int, transaction_order numeric,
				  	  effective_transaction_volume numeric, transaction_profit_loss numeric, transaction_player int)
		  LEFT JOIN sys_site_info s ON o.site_id = s.siteid
		 WHERE s.siteid = sid

	LOOP
		raise info 'api_id = %, api_type_id = %', rec.api_id, rec.api_type_id;

		INSERT INTO game_survey (
			center_id, master_id, site_id,
			statistics_time, api_id, api_type_id,
			transaction_order, effective_transaction_volume, transaction_profit_loss, transaction_player
		) VALUES (
			rec.operationid, rec.masterid, rec.siteid,
			sta_date::TIMESTAMP, rec.api_id, rec.api_type_id,
			rec.transaction_order, rec.effective_transaction_volume, rec.transaction_profit_loss, rec.transaction_player
		);
		SELECT currval(pg_get_serial_sequence('game_survey',  'id')) into gs_id;
		raise info 'game_survey.新增.键值 = %', gs_id;

	END LOOP;
	raise '统计　%　号游戏数据.END', sta_date;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_game_survey(dblink_url TEXT, sid INT, sta_date TEXT)
IS 'Fly-游戏概况-入口';

/*
SELECT * FROM gamebox_game_survey
(
	'host=192.168.0.88 dbname=gamebox-master user=postgres password=postgres',
	1,
	'2016-01-25'
);
*/