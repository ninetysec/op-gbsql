-- auto gen by cheery 2015-12-23 18:18:55
-- player_game_order 字段调整
-- drop unused view:v_operating_report_players
DROP VIEW IF EXISTS v_operating_report_players;

--v_player_order_gen 	: alter column "game_type_parent" to "api_type_id"
DROP VIEW IF EXISTS v_player_order_gen;

-- v_player_game_order : alter column "game_type_parent" to "api_type_id" and delete columns (inning,desk,scene)which not exists in table player_game_order
DROP VIEW IF EXISTS v_player_game_order;

ALTER TABLE "player_game_order" DROP COLUMN IF EXISTS "innings";
ALTER TABLE "player_game_order" DROP COLUMN IF EXISTS "desk";
ALTER TABLE "player_game_order" DROP COLUMN IF EXISTS "scene";
ALTER TABLE "player_game_order" DROP COLUMN IF EXISTS "game_type_parent";
select redo_sqls($$
	ALTER TABLE "player_game_order" ADD COLUMN "currency_code" varchar(30);
	ALTER TABLE "player_game_order" ADD COLUMN "api_type_id" int4;
	ALTER TABLE "player_game_order" ADD COLUMN "account" varchar(32);
$$);

COMMENT ON COLUMN "player_game_order"."currency_code" IS '币种';

COMMENT ON COLUMN "player_game_order"."api_type_id" IS 'api分类';

COMMENT ON COLUMN "player_game_order"."account" IS '账号';








CREATE OR REPLACE VIEW "v_player_game_order" AS
 SELECT g.id,
    g.api_id,
    g.game_id,
    g.game_type,
    g.api_type_id,
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
    g.order_state,
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
     LEFT JOIN sys_user topagentuser ON ((agentuser.owner_id = topagentuser.id)));

ALTER TABLE "v_player_game_order" OWNER TO "postgres";

COMMENT ON VIEW "v_player_game_order" IS '交易记录视图-catban';