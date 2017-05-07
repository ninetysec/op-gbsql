-- auto gen by admin 2016-06-27 14:48:55
drop function if exists gamebox_valid_player_num(TIMESTAMP, TIMESTAMP, INT, FLOAT);

create or replace function gamebox_valid_player_num(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	agent_id	INT,

	valid_value	FLOAT

) returns INT as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Fei      创建此函数：计算有效玩家数

--v1.01  2016/05/12  Leisure  修改为计算某代理的有效玩家数

--v1.02  2016/06/22  Leisure  <= end_time改为< end_time

*/

DECLARE

	player_num 	INT:=0;



BEGIN

	SELECT COUNT(1)

	  FROM (SELECT pgo.player_id, SUM(pgo.effective_trade_amount) effeTa

	         FROM player_game_order pgo LEFT JOIN sys_user su ON pgo.player_id = su."id"

	        WHERE pgo.create_time >= start_time

	          AND pgo.create_time < end_time

	          AND pgo.order_state = 'settle'

	          AND pgo.is_profit_loss = TRUE

	          AND su.owner_id = agent_id

	        GROUP BY pgo.player_id) pn

	 WHERE pn.effeTa >= valid_value

	  INTO player_num;

	RETURN player_num;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_valid_player_num(start_time TIMESTAMP, end_time TIMESTAMP, agent_id INT, valid_value FLOAT)

IS 'Fei-计算有效玩家数';