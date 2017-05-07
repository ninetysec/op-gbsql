-- auto gen by cheery 2015-11-02 12:00:07
CREATE TABLE IF NOT EXISTS player_transfer(
  id SERIAL4 NOT NULL ,
  player_transaction_id INT4,
  transaction_no varchar(32),
  user_id INT4,
  user_name varchar(32),
  transfer_type varchar(32),
  transfer_amount NUMERIC(20,2),
  transfer_time TIMESTAMP(6),
  transfer_state varchar(32),
  transfer_failture_reason varchar(1000),
  api_id INT4,
  CONSTRAINT "player_transfer_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "player_transfer" OWNER TO "postgres";

COMMENT ON TABLE "player_transfer" IS '玩家转账表-susu';
COMMENT ON COLUMN player_transfer.id IS '主键id';
COMMENT ON COLUMN player_transfer.player_transaction_id IS '交易表对应id';
COMMENT ON COLUMN player_transfer.transaction_no IS '交易号';
COMMENT ON COLUMN player_transfer.user_id IS '玩家ID';
COMMENT ON COLUMN player_transfer.user_name IS '玩家账号';
COMMENT ON COLUMN player_transfer.transfer_type IS '转账类型fund_type.transfer_type(转出,转入)';
COMMENT ON COLUMN player_transfer.transfer_amount IS '转账金额';
COMMENT ON COLUMN player_transfer.transfer_time IS '转账时间';
COMMENT ON COLUMN player_transfer.transfer_state IS '转账状态fund.transfer_state(待确认,成功,失败)';
COMMENT ON COLUMN player_transfer.transfer_failture_reason IS '转账失败原因';
COMMENT ON COLUMN player_transfer.api_id IS 'api表对应id';