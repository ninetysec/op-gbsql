-- auto gen by cherry 2016-12-13 20:51:43
DROP VIEW IF EXISTS v_player_game_order;
CREATE OR REPLACE VIEW "v_player_game_order" AS
 SELECT g.id,
    g.game_id,
    g.player_id,
    g.single_amount,
    g.profit_amount,
    g.is_profit_loss,
    g.payout_time,
    g.effective_trade_amount,
    g.contribution_amount,
    g.api_id,
    g.order_state,
    g.game_type,
    g.currency_code,
    g.api_type_id,
    g.account,
    g.bet_id,
    g.winning_amount,
		g.winning_flag,
		g.winning_time,
    g.bet_time,
    g.bet_detail,
    u.username,
    u.site_id,
    u.user_type,
    agentuser.id AS agentid,
    agentuser.username AS agentusername,
    topagentuser.id AS topagentid,
    topagentuser.username AS topagentusername,
    g.terminal
   FROM (((player_game_order g
     LEFT JOIN sys_user u ON ((g.player_id = u.id)))
     LEFT JOIN sys_user agentuser ON ((u.owner_id = agentuser.id)))
     LEFT JOIN sys_user topagentuser ON ((agentuser.owner_id = topagentuser.id)));

COMMENT ON VIEW "v_player_game_order" IS '游戏注单记录视图-catban';