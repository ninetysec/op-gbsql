-- auto gen by cheery 2015-11-24 07:54:47
DROP VIEW IF EXISTS v_player_api;

--更新返水url地址
UPDATE sys_resource SET url='operation/rakebackBill/list.html' WHERE subsys_code='mcenter' AND name='返水结算';

SELECT * from sys_resource;

DROP VIEW IF EXISTS v_backwater_report;
DROP VIEW IF EXISTS v_report_fund;

ALTER TABLE IF EXISTS settlement_backwater rename to rakeback_bill;
ALTER TABLE IF EXISTS settlement_backwater_player rename to rakeback_player;
ALTER TABLE IF EXISTS settlement_backwater_detail rename to rakeback_api;

ALTER SEQUENCE IF EXISTS settlement_backwater_id_seq rename to rakeback_bill_id_seq;
ALTER SEQUENCE IF EXISTS settlement_backwater_player_id_seq rename to rakeback_player_id_seq;
ALTER SEQUENCE IF EXISTS settlement_backwater_detail_id_seq rename to rakeback_api_id_seq;

ALTER TABLE rakeback_bill DROP COLUMN IF EXISTS settlement_name;
ALTER TABLE rakeback_bill DROP COLUMN IF EXISTS backwater_actual;
ALTER TABLE rakeback_bill DROP COLUMN IF EXISTS backwater_total;

ALTER TABLE rakeback_player DROP COLUMN IF EXISTS settlement_backwater_id;
ALTER TABLE rakeback_player DROP COLUMN IF EXISTS backwater_total;
ALTER TABLE rakeback_player DROP COLUMN IF EXISTS backwater_actual;

ALTER TABLE rakeback_api DROP COLUMN IF EXISTS settlement_backwater_id;
ALTER TABLE rakeback_api DROP COLUMN IF EXISTS game_type_parent;
ALTER TABLE rakeback_api DROP COLUMN IF EXISTS backwater;

select redo_sqls($$
  ALTER TABLE rakeback_bill ADD COLUMN period VARCHAR(32);
  ALTER TABLE rakeback_bill ADD COLUMN rakeback_total NUMERIC(20,2);
  ALTER TABLE rakeback_bill ADD COLUMN rakeback_actual NUMERIC(20,2);

  ALTER TABLE rakeback_player ADD COLUMN rakeback_bill_id INT4;
  ALTER TABLE rakeback_player ADD COLUMN rakeback_total NUMERIC(20,2);
  ALTER TABLE rakeback_player ADD COLUMN rakeback_actual NUMERIC(20,2);
  ALTER TABLE rakeback_player ADD COLUMN agent_id INT4;
  ALTER TABLE rakeback_player ADD COLUMN top_agent_id INT4;

  ALTER TABLE rakeback_api ADD COLUMN rakeback_bill_id INT4;
  ALTER TABLE rakeback_api ADD COLUMN api_type_id INT4;
  ALTER TABLE rakeback_api ADD COLUMN rakeback NUMERIC(20,2);
$$);

COMMENT ON COLUMN rakeback_bill.period IS '期数';
COMMENT ON COLUMN rakeback_bill.rakeback_total IS '应付返水';
COMMENT ON COLUMN rakeback_bill.rakeback_actual IS '实际返水';

COMMENT ON COLUMN rakeback_player.rakeback_bill_id IS '账单ID';
COMMENT ON COLUMN rakeback_player.rakeback_total IS '应付返水';
COMMENT ON COLUMN rakeback_player.rakeback_actual IS '实际返水';
COMMENT ON COLUMN rakeback_player.agent_id IS '代理ID';
COMMENT ON COLUMN rakeback_player.top_agent_id IS '总代ID';

COMMENT ON COLUMN rakeback_api.rakeback_bill_id IS '账单ID';
COMMENT ON COLUMN rakeback_api.rakeback IS '返水';
COMMENT ON COLUMN rakeback_api.api_type_id IS 'api分类';

CREATE OR REPLACE VIEW v_backwater_report AS SELECT sb.id,
                                                      bp.player_id,
                                                      bp.username AS player_name,
                                                      bp.rakeback_total AS backwater_total,
                                                      bp.rakeback_actual AS backwater_actual,
                                                      bp.agent_id,
                                                      bp.top_agent_id,
                                                      sb.lssuing_state,
                                                      sb.start_time,
                                                      sb.end_time,
                                                      sb.period,
                                                      su1.username AS agent_name,
                                                      su2.username AS topagent_name,
                                                      bd.api_id
                                                    FROM ((((rakeback_player bp
                                                    LEFT JOIN rakeback_bill sb ON ((bp.rakeback_bill_id = sb.id)))
                                                             LEFT JOIN sys_user su1 ON ((bp.agent_id = su1.id)))
                                                            LEFT JOIN sys_user su2 ON ((bp.top_agent_id = su2.id)))
                                                           LEFT JOIN rakeback_api bd ON ((bp.rakeback_bill_id = bd.rakeback_bill_id)))
                                                    WHERE ((sb.end_time >= (now() - '90 days'::interval)) AND (bp.player_id = bd.player_id))