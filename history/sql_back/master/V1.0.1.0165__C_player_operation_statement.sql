
/**
* description:统计玩家经营报表
* @author:Lins
* @date 2015.10.27
*	@参数1:站点ID
* @参数2:开始时间
* @参数3:结束时间
* @return 返回统计记录.
*/
CREATE OR REPLACE FUNCTION player_operation_statement(siteId int4,startTime text,endTime text) returns SETOF record as
 $$
DECLARE
	rec record;
BEGIN
	for rec in SELECT
    u.username AS player,
    p.player_id AS id,
    u.site_id AS siteid,
    topagent.id AS topagentid,
    topagent.username AS topagentusername,
    agent.id AS agentid,
    agent.username AS agentusername,
    p.api_id AS api,
    p.game_id AS gameid,
    game.game_type AS gametype,
    game.game_type_parent AS gametypeparent,
    p.transaction_order,
    p.transaction_volume,
    p.transaction_profit_loss,
    p.effective_transaction_volume
   FROM ((((( SELECT player_game_order.player_id,
            player_game_order.api_id,
            player_game_order.game_id,
            count(player_game_order.player_id) AS transaction_order,
            sum(player_game_order.single_amount) AS transaction_volume,
            sum(player_game_order.profit_amount) AS transaction_profit_loss,
            sum(player_game_order.effective_trade_amount) AS effective_transaction_volume
           FROM player_game_order
					 WHERE create_time>=startTime::TIMESTAMP and create_time<endTime::TIMESTAMP
          GROUP BY player_game_order.player_id, player_game_order.api_id, player_game_order.game_id) p
     LEFT JOIN site_game game ON ((p.game_id = game.id)))
     LEFT JOIN sys_user u ON ((p.player_id = u.id)))
     LEFT JOIN sys_user agent ON ((u.owner_id = agent.id)))
     LEFT JOIN sys_user topagent ON ((agent.owner_id = topagent.id))) loop
		return next rec;
	end loop;
return;
END
$$ language plpgsql;