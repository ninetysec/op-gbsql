-- auto gen by cherry 2016-10-22 14:39:42
CREATE TABLE IF NOT EXISTS rebate_agent_api (
id serial PRIMARY KEY,
settle_flag varchar(1) NOT NULL,
rebate_bill_id int4 NOT NULL,
agent_id int4,
agent_name varchar(32),
api_id int4,
game_type varchar(32),
effective_transaction numeric(20,2),
effective_player_num int4,
profit_loss numeric(20,2),
operation_retio numeric(4,2),
operation_occupy numeric(20,2),
rebate_set_id int4,
rebate_grads_id int4,
rebate_grads_api_id int4,
rebate_retio numeric(4,2),
rebate_value numeric(20,2)
);

COMMENT ON TABLE rebate_agent_api IS '代理API返佣';
COMMENT ON COLUMN rebate_agent_api.id IS '主键';
COMMENT ON COLUMN rebate_agent_api.settle_flag IS '结算标志：Y=已结，N=未结';
COMMENT ON COLUMN rebate_agent_api.rebate_bill_id IS '返佣结算账单ID';
COMMENT ON COLUMN rebate_agent_api.agent_id IS '代理ID';
COMMENT ON COLUMN rebate_agent_api.agent_name IS '代理账号';
COMMENT ON COLUMN rebate_agent_api.api_id IS 'API_ID';
COMMENT ON COLUMN rebate_agent_api.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN rebate_agent_api.effective_transaction IS '有效交易量';
COMMENT ON COLUMN rebate_agent_api.effective_player_num IS '有效玩家数';
COMMENT ON COLUMN rebate_agent_api.profit_loss IS '盈亏';
COMMENT ON COLUMN rebate_agent_api.operation_retio IS '运营商占比';
COMMENT ON COLUMN rebate_agent_api.operation_occupy IS '运营商占成';
COMMENT ON COLUMN rebate_agent_api.rebate_set_id IS '返佣方案ID';
COMMENT ON COLUMN rebate_agent_api.rebate_grads_id IS '返佣梯度ID';
COMMENT ON COLUMN rebate_agent_api.rebate_grads_api_id IS '返佣API比率ID';
COMMENT ON COLUMN rebate_agent_api.rebate_retio IS '返佣比率';
COMMENT ON COLUMN rebate_agent_api.rebate_value IS '返佣金额';
CREATE INDEX IF NOT EXISTS fk_rebate_agent_api_agent_id ON rebate_agent_api USING btree (agent_id);
CREATE INDEX IF NOT EXISTS fk_rebate_agent_api_occupy_bill_id ON rebate_agent_api USING btree (rebate_bill_id);