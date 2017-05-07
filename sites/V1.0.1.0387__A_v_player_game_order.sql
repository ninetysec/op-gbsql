-- auto gen by Administrator 2017-02-21 21:33:14
drop VIEW v_player_game_order;
CREATE OR REPLACE VIEW v_player_game_order AS
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
    g.username,
    g.agentid,
    g.agentusername,
    g.topagentid,
    g.topagentusername,
    g.terminal
   FROM player_game_order g;

COMMENT ON VIEW v_player_game_order IS '游戏注单记录视图-catban';