-- auto gen by steffan 2018-05-18 17:55:36

CREATE TABLE IF NOT EXISTS player_api_transfer(
  id SERIAL4 NOT NULL ,
  transaction_no varchar(32),
  user_id INT4,
  user_name varchar(32),
  transfer_type varchar(32),
  transfer_amount NUMERIC(20,2),
  before_amount NUMERIC(20,2),
  after_amount NUMERIC(20,2),
  transfer_time TIMESTAMP(6),
  api_id INT4,
  transfer_source varchar(32),
  operate_id INT4,
  operator VARCHAR(32),
  CONSTRAINT "player_api_transfer_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE "player_api_transfer" IS '玩家api余额记录表';
COMMENT ON COLUMN player_api_transfer.id IS '主键id';
COMMENT ON COLUMN player_api_transfer.transaction_no IS '交易号';
COMMENT ON COLUMN player_api_transfer.user_id IS '玩家ID';
COMMENT ON COLUMN player_api_transfer.user_name IS '玩家账号';
COMMENT ON COLUMN player_api_transfer.transfer_type IS '转账类型fund_type.transfer_type(转出,转入)';
COMMENT ON COLUMN player_api_transfer.transfer_amount IS '转账金额';
COMMENT ON COLUMN player_api_transfer.before_amount IS '转账前金额';
COMMENT ON COLUMN player_api_transfer.after_amount IS '转账后金额';
COMMENT ON COLUMN player_api_transfer.transfer_time IS '转账时间';
COMMENT ON COLUMN player_api_transfer.api_id IS 'api表对应id';
COMMENT ON COLUMN player_api_transfer.transfer_source IS '转账来源：1-player:玩家转账、2-recovery:回收资金转账';
COMMENT ON COLUMN player_api_transfer.operate_id IS '转账来源操作者id';
COMMENT ON COLUMN player_api_transfer.operator IS '操作者账号';