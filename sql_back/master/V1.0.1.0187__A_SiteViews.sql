-- auto gen by tony 2015-11-17 09:13:41
select redo_sqls($$
    ALTER TABLE player_game_order
      ADD COLUMN game_type character varying(32);
$$);

select redo_sqls($$
    ALTER TABLE player_game_order
      ADD COLUMN game_type_parent character varying(32);
$$);



CREATE OR REPLACE VIEW v_ctt_draft AS
 SELECT a.id,
    a.child_id,
    a.parent_id,
    a.title,
    a.content,
    a.language,
    a.create_user,
    a.create_time,
    a.update_user,
    a.update_time,
    a.is_internal,
    a.status,
    a.publish_time,
    a.default_content,
    ( SELECT count(1) AS count
           FROM ctt_draft c
          WHERE c.child_id = a.child_id AND length(c.content::text) > 0) AS language_count,
    ( SELECT count(1) AS count
           FROM ctt_draft b
          WHERE b.parent_id = a.child_id AND b.language::text = a.language::text) AS child_count,
    0::BIGINT AS language_total
   FROM ctt_draft a;

ALTER TABLE v_ctt_draft
  OWNER TO postgres;
COMMENT ON VIEW v_ctt_draft
  IS '文案视图--lorne';


-- View: v_player_game_order

DROP VIEW v_player_game_order;

CREATE OR REPLACE VIEW v_player_game_order AS
  SELECT g.id,
						g.api_id,
            g.game_id,
						g.game_type,
						g.game_type_parent,
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
            g.order_state,
            u.username,
            u.site_id,
            u.user_type,
            agentuser.id AS agentid,
            agentuser.username AS agentusername,
            topagentuser.id AS topagentid,
            topagentuser.username AS topagentusername
           FROM player_game_order g
             LEFT JOIN sys_user u ON g.player_id = u.id
             LEFT JOIN sys_user agentuser ON u.owner_id = agentuser.id
             LEFT JOIN sys_user topagentuser ON agentuser.owner_id = topagentuser.id;

ALTER TABLE v_player_game_order
  OWNER TO postgres;
COMMENT ON VIEW v_player_game_order
  IS '交易记录视图-jerry';


CREATE OR REPLACE VIEW v_player_order_gen AS
 SELECT u.username AS player,
    p.player_id AS id,
    u.site_id AS siteid,
    topagent.id AS topagentid,
    topagent.username AS topagentusername,
    agent.id AS agentid,
    agent.username AS agentusername,
    p.api_id AS api,
    p.game_id AS gameid,
    p.game_type AS gametype,
    p.game_type_parent AS gametypeparent,
    p.transaction_order,
    p.transaction_volume,
    p.transaction_profit_loss,
    p.effective_transaction_volume,
    to_char('now'::text::date::timestamp with time zone, 'yyyy-mm-dd'::text) AS cur_date
   FROM ( SELECT player_game_order.player_id,
            player_game_order.api_id,
            player_game_order.game_id,
            player_game_order.game_type,
            player_game_order.game_type_parent,
            count(player_game_order.player_id) AS transaction_order,
            sum(player_game_order.single_amount) AS transaction_volume,
            sum(player_game_order.profit_amount) AS transaction_profit_loss,
            sum(player_game_order.effective_trade_amount) AS effective_transaction_volume
           FROM player_game_order
          WHERE to_char('now'::text::date::timestamp with time zone, 'yyyy-mm-dd'::text) = to_char(player_game_order.create_time, 'yyyy-mm-dd'::text)
          GROUP BY player_game_order.player_id, player_game_order.api_id, player_game_order.game_id,
            player_game_order.game_type,
            player_game_order.game_type_parent) p
     LEFT JOIN sys_user u ON p.player_id = u.id
     LEFT JOIN sys_user agent ON u.owner_id = agent.id
     LEFT JOIN sys_user topagent ON agent.owner_id = topagent.id;


CREATE OR REPLACE VIEW v_operating_report_players AS
 SELECT  g.id,
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
						u.user_type,
						g.game_type,
						g.game_type_parent,
            agentuser.id AS agentid,
            agentuser.username AS agentusername,
            topagentuser.id AS topagentid,
            topagentuser.username AS topagentusername
           FROM player_game_order g
             LEFT JOIN sys_user u ON g.player_id = u.id
             LEFT JOIN sys_user agentuser ON u.owner_id = agentuser.id
             LEFT JOIN sys_user topagentuser ON agentuser.owner_id = topagentuser.id;
ALTER TABLE v_operating_report_players
  OWNER TO postgres;


  CREATE OR REPLACE VIEW v_player_api AS
 SELECT t1.id,
    t1.api_id,
    t1.player_id,
    t1.synchronization_time,
    t1.money,
    t1.is_transaction,
    t1.synchronization_status,
    t1.abnormal_reason,
    t1.last_recovery_time,
    t1.last_recovery_status,
    0::bigint AS views
   FROM player_api t1;

ALTER TABLE v_player_api
  OWNER TO postgres;

  DROP VIEW IF EXISTS  v_site_api_type_relation;
  DROP VIEW IF EXISTS  v_site_api;
  DROP VIEW IF EXISTS  v_site_api_type;
  DROP VIEW IF EXISTS  v_site_contacts;
  DROP VIEW IF EXISTS  v_site_game;

  DROP TABLE IF EXISTS  site_api;
  DROP TABLE IF EXISTS  site_api_i18n;
  DROP TABLE IF EXISTS  site_api_type;
  DROP TABLE IF EXISTS  site_api_type_i18n;
  DROP TABLE IF EXISTS  site_api_type_relation;
  DROP TABLE IF EXISTS  site_confine_area;
  DROP TABLE IF EXISTS  site_confine_ip;
  DROP TABLE IF EXISTS  site_contacts;
  DROP TABLE IF EXISTS  site_contacts_notice;
  DROP TABLE IF EXISTS  site_contacts_position;
DROP TABLE IF EXISTS  site_currency;
DROP TABLE IF EXISTS  site_customer_service;
DROP TABLE IF EXISTS  site_game;
DROP TABLE IF EXISTS  site_game_i18n;
DROP TABLE IF EXISTS  site_i18n;
DROP TABLE IF EXISTS  site_language;
DROP TABLE IF EXISTS  site_operate_area;


/*
DROP TABLE IF EXISTS user_master;
DROP TABLE IF EXISTS v_user_master;
DROP TABLE IF EXISTS currency_exchange_rate;
*/
