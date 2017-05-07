-- auto gen by cheery 2015-10-10 11:45:36
--修改退佣金额类型

DROP VIEW IF EXISTS v_player_game_order;

ALTER TABLE player_game_order ALTER COLUMN brokerage_amount type numeric(20,2);

CREATE OR REPLACE VIEW  v_player_game_order AS
 SELECT api.id,
    api.game_id,
    api.player_id,
    api.order_no,
    api.create_time,
    api.innings,
    api.desk,
    api.scene,
    api.game_result,
    api.single_amount,
    api.profit_amount,
    api.brokerage_amount,
    api.is_profit_loss,
    api.payout_time,
    api.result_json,
    api.effective_trade_amount,
    api.api_id,
    api.order_state,
    api.username,
    api.site_id,
    api.user_type,
    game.game_type,
    game.game_type_parent
   FROM (( SELECT g.id,
            g.game_id,
            g.player_id,
            g.order_no,
            g.create_time,
            g.innings,
            g.desk,
            g.scene,
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
            u.username,
            u.site_id,
            u.user_type
           FROM (player_game_order g
             LEFT JOIN sys_user u ON ((g.player_id = u.id)))) api
     LEFT JOIN site_game game ON ((api.api_id = game.api_id)));
