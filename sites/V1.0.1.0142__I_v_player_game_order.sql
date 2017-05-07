-- auto gen by admin 2016-05-10 16:33:27
DROP VIEW IF EXISTS v_player_game_order;

CREATE OR REPLACE VIEW  "v_player_game_order" AS
 SELECT g.id,
    g.game_id,
    g.player_id,
    g.order_no,
    g.create_time,
    g.game_result,
    g.single_amount,
    g.profit_amount,
    g.brokerage_amount,
    g.is_profit_loss,
    g.payout_time,
    g.result_json,
    g.effective_trade_amount,
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
    g.action_id_json,
		g.bet_time,
    u.username,
    u.site_id,
    u.user_type,
    agentuser.id AS agentid,
    agentuser.username AS agentusername,
    topagentuser.id AS topagentid,
    topagentuser.username AS topagentusername
   FROM (((player_game_order g
     LEFT JOIN sys_user u ON ((g.player_id = u.id)))
     LEFT JOIN sys_user agentuser ON ((u.owner_id = agentuser.id)))
     LEFT JOIN  sys_user topagentuser ON ((agentuser.owner_id = topagentuser.id)));

COMMENT ON VIEW "v_player_game_order" IS '交易记录视图-catban';

UPDATE player_transfer SET transfer_state='process' where transfer_state='pending_confirm';