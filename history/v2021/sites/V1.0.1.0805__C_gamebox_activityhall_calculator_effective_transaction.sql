-- auto gen by linsen 2018-05-08 09:23:22
-- 计算时间范围内某玩家的有效交易量 by kobe
DROP FUNCTION IF EXISTS "gamebox_activityhall_calculator_effective_transaction"(playerid int4, starttime timestamp, endtime timestamp, activitymessageid int4);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_calculator_effective_transaction"(playerid int4, starttime timestamp, endtime timestamp, activitymessageid int4)
  RETURNS "pg_catalog"."numeric" AS $BODY$ DECLARE

	rec_game record;  --游戏

	game_condition VARCHAR; --添加的游戏条件

	sql_condition VARCHAR; --查询条件

	effective_transaction NUMERIC ; --有效交易量


BEGIN

FOR rec_game IN (SELECT * FROM activity_rule_include_game WHERE activity_message_id = activitymessageid)
LOOP
	IF (game_condition IS NULL)
		THEN game_condition = 'game_type =''' || rec_game.game_type || ''' AND api_id=''' || rec_game.api_id || '''';
	ELSE
		game_condition = game_condition || ' OR ' || 'game_type = ''' || rec_game.game_type || ''' AND api_id=''' || rec_game.api_id || '''';
	END IF;
END loop;
raise info '游戏条件:%',game_condition;

sql_condition = 'player_id = ''' || playerid || ''' AND payout_time >=''' || starttime || ''' AND payout_time <=''' || endtime || '''';
IF (game_condition IS NOT NULL)
 THEN sql_condition = sql_condition || ' AND ' || '(' ||game_condition || ')';
END IF;
raise info '条件:%',sql_condition;

EXECUTE 'SELECT sum(effective_trade_amount) FROM player_game_order WHERE ' || sql_condition INTO effective_transaction;

raise info '有效投注额:%',effective_transaction;

RETURN COALESCE (effective_transaction, 0) ;

END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gamebox_activityhall_calculator_effective_transaction"(playerid int4, starttime timestamp, endtime timestamp, activitymessageid int4) IS '计算时间范围内某玩家的有效交易量';