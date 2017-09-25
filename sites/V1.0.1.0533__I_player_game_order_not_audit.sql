-- auto gen by cherry 2017-09-23 17:57:39
--添加玩家投注未稽核表
CREATE TABLE IF NOT EXISTS player_game_order_not_audit (
  id INT PRIMARY KEY,
  api_id INT,
  bet_id VARCHAR(64),
  player_id INT,
  effective_trade_amount numeric(20,2),
  payout_time TIMESTAMP,
  order_state VARCHAR(32)
);
COMMENT ON TABLE  player_game_order_not_audit IS '玩家未稽核注单';
COMMENT ON COLUMN player_game_order_not_audit.id IS 'ID';
COMMENT ON COLUMN player_game_order_not_audit.api_id IS 'api_id';
COMMENT ON COLUMN player_game_order_not_audit.bet_id IS '注单号码';
COMMENT ON COLUMN player_game_order_not_audit.player_id IS '玩家ID';
COMMENT ON COLUMN player_game_order_not_audit.effective_trade_amount IS '未稽核有效交易量';
COMMENT ON COLUMN player_game_order_not_audit.payout_time IS '派彩时间';
COMMENT ON COLUMN player_game_order_not_audit.order_state IS '注单状态';

CREATE INDEX IF not EXISTS player_game_order_not_audit_ppo_idx ON player_game_order_not_audit (player_id, payout_time, order_state);