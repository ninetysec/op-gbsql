-- auto gen by cherry 2017-08-16 10:28:53
SELECT redo_sqls($$
ALTER TABLE IF EXISTS rebate_agent_nosettled RENAME TO rebate_agent_nosettled_old;
ALTER TABLE rebate_agent_nosettled_old RENAME CONSTRAINT rebate_agent_nosettled_id_pkey TO rebate_agent_nosettled_old_pkey;
ALTER SEQUENCE IF EXISTS rebate_agent_nosettled_id_seq RENAME TO rebate_agent_nosettled_old_id_seq;

ALTER TABLE IF EXISTS rebate_bill_nosettled RENAME TO rebate_bill_nosettled_old;
ALTER TABLE rebate_bill_nosettled_old RENAME CONSTRAINT rebate_bill_nosettled_pkey TO rebate_bill_nosettled_old_pkey;
ALTER SEQUENCE IF EXISTS rebate_bill_nosettled_id_seq RENAME TO rebate_bill_nosettled_old_id_seq;

ALTER TABLE IF EXISTS rebate_agent_api RENAME TO rebate_agent_api_old;
ALTER TABLE rebate_agent_api_old RENAME CONSTRAINT rebate_agent_api_pkey TO rebate_agent_api_old_pkey;
ALTER SEQUENCE IF EXISTS rebate_agent_api_id_seq RENAME TO rebate_agent_api_old_id_seq;

ALTER TABLE IF EXISTS rebate_agent RENAME TO rebate_agent_old;
ALTER TABLE rebate_agent_old RENAME CONSTRAINT rebate_agent_pkey TO rebate_agent_old_pkey;
ALTER SEQUENCE IF EXISTS rebate_agent_id_seq RENAME TO rebate_agent_old_id_seq;

ALTER TABLE IF EXISTS rebate_bill RENAME TO rebate_bill_old;
--ALTER TABLE rebate_bill_old RENAME CONSTRAINT rebate_bill_pkey TO rebate_bill_old_pkey;
ALTER SEQUENCE IF EXISTS rebate_bill_id_seq RENAME TO rebate_bill_old_id_seq;
$$);

--DROP TABLE IF EXISTS rebate_agent_api_nosettled;
CREATE TABLE IF NOT EXISTS rebate_agent_api_nosettled (
id serial4 PRIMARY KEY,
rebate_bill_id int4 NOT NULL,
agent_id int4,
agent_name varchar(32),
agent_rank int4,
parent_id int4,
rebate_set_id int4,
rebate_grads_id int4,
max_rebate numeric(20,2),
effective_player int4,
api_id int4,
game_type varchar(32),
agent_array int[],
effective_transaction numeric(20,2),
profit_loss numeric(20,2),
rebate_ratio numeric(4,2),
parent_ratio numeric(4,2),
rebate_parent numeric(20,2),
effective_self numeric(20,2),
profit_self numeric(20,2),
rebate_self numeric(20,2),
rebate_sun numeric(20,2)
);

COMMENT ON TABLE rebate_agent_api_nosettled IS '代理API返佣';
COMMENT ON COLUMN rebate_agent_api_nosettled.id IS '主键';
--COMMENT ON COLUMN rebate_agent_api_nosettled.settle_flag IS '结算标志：Y=已结，N=未结';
COMMENT ON COLUMN rebate_agent_api_nosettled.rebate_bill_id IS '返佣结算账单ID';
COMMENT ON COLUMN rebate_agent_api_nosettled.agent_id IS '代理ID';
COMMENT ON COLUMN rebate_agent_api_nosettled.agent_name IS '代理账号';
COMMENT ON COLUMN rebate_agent_api_nosettled.agent_rank IS '代理层级';
COMMENT ON COLUMN rebate_agent_api_nosettled.parent_id IS '上级代理ID';
COMMENT ON COLUMN rebate_agent_api_nosettled.rebate_set_id IS '返佣方案ID';
COMMENT ON COLUMN rebate_agent_api_nosettled.rebate_grads_id IS '返佣梯度ID';
COMMENT ON COLUMN rebate_agent_api_nosettled.max_rebate IS '返佣上限';
--COMMENT ON COLUMN rebate_agent_api_nosettled.rebate_grads_api_id IS '返佣API比率ID';
COMMENT ON COLUMN rebate_agent_api_nosettled.effective_player IS '有效玩家数';
COMMENT ON COLUMN rebate_agent_api_nosettled.api_id IS 'API_ID';
COMMENT ON COLUMN rebate_agent_api_nosettled.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN rebate_agent_api_nosettled.agent_array IS '贡献该API代理ID数组';
COMMENT ON COLUMN rebate_agent_api_nosettled.effective_transaction IS '该分支总有效交易量';
COMMENT ON COLUMN rebate_agent_api_nosettled.profit_loss IS '该分支总盈亏';
--COMMENT ON COLUMN rebate_agent_api_nosettled.operation_retio IS '运营商占比';
--COMMENT ON COLUMN rebate_agent_api_nosettled.operation_occupy IS '运营商占成';
COMMENT ON COLUMN rebate_agent_api_nosettled.rebate_ratio IS '返佣比率';
COMMENT ON COLUMN rebate_agent_api_nosettled.parent_ratio IS '上级代理返佣比率';
COMMENT ON COLUMN rebate_agent_api_nosettled.rebate_parent IS '上级代理抽佣金额';
--COMMENT ON COLUMN rebate_agent_api_nosettled.effective_player_self IS '自身有效玩家数';
COMMENT ON COLUMN rebate_agent_api_nosettled.effective_self IS '自身有效交易量';
COMMENT ON COLUMN rebate_agent_api_nosettled.profit_self IS '自身盈亏';
COMMENT ON COLUMN rebate_agent_api_nosettled.rebate_self IS '自身佣金';
COMMENT ON COLUMN rebate_agent_api_nosettled.rebate_sun IS '下级贡献佣金';

--CREATE INDEX rebate_agent_api_nosettled_agent_id_idx ON rebate_agent_api_nosettled USING btree (agent_id);
--CREATE INDEX rebate_agent_api_nosettled_rebate_bill_id_idx ON rebate_agent_api_nosettled USING btree (rebate_bill_id);

--DROP TABLE IF EXISTS rebate_player_fee_nosettled;
CREATE TABLE IF not EXISTS rebate_player_fee_nosettled (
id serial4 PRIMARY KEY,
rebate_bill_id int4 NOT NULL,
topagent_id int4,
topagent_name varchar(32),
agent_id int4,
agent_name varchar(32),
player_id int4,
player_name varchar(32),
deposit_amount numeric(20,2),
withdraw_amount numeric(20,2),
rakeback_amount numeric(20,2),
favorable_amount numeric(20,2),
other_amount numeric(20,2)
);

COMMENT ON TABLE rebate_player_fee_nosettled IS '代理返佣_玩家费用';
COMMENT ON COLUMN rebate_player_fee_nosettled.id IS '主键';
COMMENT ON COLUMN rebate_player_fee_nosettled.rebate_bill_id IS '返佣账单ID';
COMMENT ON COLUMN rebate_player_fee_nosettled.topagent_id IS '总代id';
COMMENT ON COLUMN rebate_player_fee_nosettled.topagent_name IS '总代账号';
COMMENT ON COLUMN rebate_player_fee_nosettled.agent_id IS '代理id';
COMMENT ON COLUMN rebate_player_fee_nosettled.agent_name IS '代理账号';
COMMENT ON COLUMN rebate_player_fee_nosettled.player_id IS '玩家id';
COMMENT ON COLUMN rebate_player_fee_nosettled.player_name IS '玩家账号';
COMMENT ON COLUMN rebate_player_fee_nosettled.deposit_amount IS '存款金额';
COMMENT ON COLUMN rebate_player_fee_nosettled.withdraw_amount IS '取款金额';
COMMENT ON COLUMN rebate_player_fee_nosettled.rakeback_amount IS '返水金额';
COMMENT ON COLUMN rebate_player_fee_nosettled.favorable_amount IS '优惠金额';
COMMENT ON COLUMN rebate_player_fee_nosettled.other_amount IS '其他金额';


CREATE TABLE IF NOT EXISTS rebate_agent_nosettled (
id serial4 PRIMARY KEY,
rebate_bill_id int4 NOT NULL,
agent_id int4,
agent_name varchar(32),
agent_rank int4,
parent_id int4,
parent_array int[],
rebate_set_id int4,
rebate_grads_id int4,
max_rebate numeric(20,2),
effective_player int4,
effective_transaction numeric(20,2),
profit_loss numeric(20,2),
rebate_parent numeric(20,2),
effective_self numeric(20,2),
profit_self numeric(20,2),
rebate_self numeric(20,2),
rebate_self_history numeric(20,2),
rebate_sun numeric(20,2),
rebate_sun_history numeric(20,2),
deposit_amount numeric(20,2),
deposit_radio numeric(5,2),
deposit_fee numeric(20,2),
withdraw_amount numeric(20,2),
withdraw_radio numeric(5,2),
withdraw_fee numeric(20,2),
rakeback_amount numeric(20,2),
rakeback_radio numeric(5,2),
rakeback_fee numeric(20,2),
favorable_amount numeric(20,2),
favorable_radio numeric(5,2),
favorable_fee numeric(20,2),
other_amount numeric(20,2),
other_radio numeric(5,2),
other_fee numeric(20,2),
fee_amount numeric(20,2),
fee_history numeric(20,2),
rebate_total numeric(20,2)
);
--ALTER TABLE rebate_agent_nosettled
--ADD CONSTRAINT rebate_agent_nosettled_rebate_bill_id_fkey FOREIGN KEY (rebate_bill_id) REFERENCES rebate_bill_nosettled ("id");
--ALTER TABLE rebate_agent_nosettled
--ADD CONSTRAINT "rebate_agent_nosettled_deposit_radio_check" CHECK (deposit_radio >= 0 AND deposit_radio <= 100);

COMMENT ON TABLE rebate_agent_nosettled IS '代理返佣';
COMMENT ON COLUMN rebate_agent_nosettled.id IS '主键';
COMMENT ON COLUMN rebate_agent_nosettled.rebate_bill_id IS '返佣结算账单ID';
COMMENT ON COLUMN rebate_agent_nosettled.agent_id IS '代理ID';
COMMENT ON COLUMN rebate_agent_nosettled.agent_name IS '代理账号';
COMMENT ON COLUMN rebate_agent_nosettled.agent_rank IS '代理层级';
COMMENT ON COLUMN rebate_agent_nosettled.parent_id IS '上级代理ID';
COMMENT ON COLUMN rebate_agent_nosettled.parent_array IS '上级代理ID数组';
COMMENT ON COLUMN rebate_agent_nosettled.rebate_set_id IS '返佣方案ID';
COMMENT ON COLUMN rebate_agent_nosettled.rebate_grads_id IS '返佣梯度ID';
COMMENT ON COLUMN rebate_agent_nosettled.max_rebate IS '返佣上限';
COMMENT ON COLUMN rebate_agent_nosettled.effective_player IS '有效玩家数';
COMMENT ON COLUMN rebate_agent_nosettled.effective_transaction IS '该分支总有效交易量';
COMMENT ON COLUMN rebate_agent_nosettled.profit_loss IS '该分支总盈亏';
COMMENT ON COLUMN rebate_agent_nosettled.rebate_parent IS '上级代理抽佣金额';
COMMENT ON COLUMN rebate_agent_nosettled.effective_self IS '自身有效交易量';
COMMENT ON COLUMN rebate_agent_nosettled.profit_self IS '自身盈亏';
COMMENT ON COLUMN rebate_agent_nosettled.rebate_self IS '占成佣金';
COMMENT ON COLUMN rebate_agent_nosettled.rebate_self_history IS '累积未结占成佣金';
COMMENT ON COLUMN rebate_agent_nosettled.rebate_sun IS '下级贡献佣金';
COMMENT ON COLUMN rebate_agent_nosettled.rebate_sun_history IS '累积未结下级贡献佣金';
COMMENT ON COLUMN rebate_agent_nosettled.deposit_amount IS '存款金额';
COMMENT ON COLUMN rebate_agent_nosettled.deposit_radio IS '存款手续费比率';
COMMENT ON COLUMN rebate_agent_nosettled.deposit_fee IS '存款手续费';
COMMENT ON COLUMN rebate_agent_nosettled.withdraw_amount IS '取款金额';
COMMENT ON COLUMN rebate_agent_nosettled.withdraw_radio IS '取款手续费比率';
COMMENT ON COLUMN rebate_agent_nosettled.withdraw_fee IS '取款手续费';
COMMENT ON COLUMN rebate_agent_nosettled.rakeback_amount IS '返水金额';
COMMENT ON COLUMN rebate_agent_nosettled.rakeback_radio IS '返水承担比率';
COMMENT ON COLUMN rebate_agent_nosettled.rakeback_fee IS '返水费用';
COMMENT ON COLUMN rebate_agent_nosettled.favorable_amount IS '优惠金额';
COMMENT ON COLUMN rebate_agent_nosettled.favorable_radio IS '优惠承担比率';
COMMENT ON COLUMN rebate_agent_nosettled.favorable_fee IS '优惠费用';
COMMENT ON COLUMN rebate_agent_nosettled.other_amount IS '其他费用总额';
COMMENT ON COLUMN rebate_agent_nosettled.other_radio IS '其他费用承担比率';
COMMENT ON COLUMN rebate_agent_nosettled.other_fee IS '其他费用';
COMMENT ON COLUMN rebate_agent_nosettled.fee_amount IS '当期费用总和';
COMMENT ON COLUMN rebate_agent_nosettled.fee_history IS '累积未结费用';
COMMENT ON COLUMN rebate_agent_nosettled.rebate_total IS '应付佣金=占成佣金+下级贡献佣金-费用(所有金额包括本期和累积)';


--ALTER TABLE rebate_bill_nosettled RENAME TO rebate_bill_nosettled_old;
--ALTER TABLE rebate_bill_nosettled_old RENAME CONSTRAINT rebate_bill_nosettled_pkey TO rebate_bill_nosettled_old_pkey;
--ALTER SEQUENCE rebate_bill_nosettled_id_seq RENAME TO rebate_bill_nosettled_old_id_seq;
--DROP TABLE IF EXISTS rebate_bill_nosettled;
CREATE TABLE IF not EXISTS rebate_bill_nosettled (
id serial4 PRIMARY KEY,
period varchar(32) NOT NULL,
start_time timestamp(6) NOT NULL,
end_time timestamp(6) NOT NULL,
effective_transaction numeric(20,2) DEFAULT 0,
profit_loss numeric(20,2) DEFAULT 0,
rebate_total numeric(20,2),
rebate_actual numeric(20,2),
lssuing_state varchar(32),
agent_count int4,
agent_lssuing_count int4,
agent_reject_count int4,
create_time timestamp(6),
last_operate_time timestamp(6),
last_operate_user_id int4,
last_operate_username varchar(100)
);

COMMENT ON TABLE rebate_bill_nosettled IS '返佣账单表';
COMMENT ON COLUMN rebate_bill_nosettled.id IS '主键';
COMMENT ON COLUMN rebate_bill_nosettled.period IS '返佣周期: YYYY-MM';
COMMENT ON COLUMN rebate_bill_nosettled.start_time IS '返佣起始时间';
COMMENT ON COLUMN rebate_bill_nosettled.end_time IS '返佣结束时间';
COMMENT ON COLUMN rebate_bill_nosettled.effective_transaction IS '有效交易量';
COMMENT ON COLUMN rebate_bill_nosettled.profit_loss IS '总交易盈亏';
COMMENT ON COLUMN rebate_bill_nosettled.rebate_total IS '应付返佣';
COMMENT ON COLUMN rebate_bill_nosettled.rebate_actual IS '实际返佣';
COMMENT ON COLUMN rebate_bill_nosettled.lssuing_state IS '发放状态operation.lssuing_state';
COMMENT ON COLUMN rebate_bill_nosettled.agent_count IS '参与代理数';
COMMENT ON COLUMN rebate_bill_nosettled.agent_lssuing_count IS '发放代理数';
COMMENT ON COLUMN rebate_bill_nosettled.agent_reject_count IS '拒绝发放玩家数';
COMMENT ON COLUMN rebate_bill_nosettled.create_time IS '创建时间';
COMMENT ON COLUMN rebate_bill_nosettled.last_operate_time IS '最后操作时间';
COMMENT ON COLUMN rebate_bill_nosettled.last_operate_user_id IS '最后操作人ID';
COMMENT ON COLUMN rebate_bill_nosettled.last_operate_username IS '最后操作人';


--ALTER TABLE rebate_agent_api RENAME TO rebate_agent_api_old;
--ALTER TABLE rebate_agent_api_old RENAME CONSTRAINT rebate_agent_api_pkey TO rebate_agent_api_old_pkey;
--ALTER SEQUENCE rebate_agent_api_id_seq RENAME TO rebate_agent_api_old_id_seq;
--DROP TABLE IF EXISTS rebate_agent_api;
CREATE TABLE IF NOT EXISTS rebate_agent_api (
id serial4 PRIMARY KEY,
rebate_bill_id int4 NOT NULL,
agent_id int4,
agent_name varchar(32),
agent_rank int4,
parent_id int4,
rebate_set_id int4,
rebate_grads_id int4,
max_rebate numeric(20,2),
effective_player int4,
api_id int4,
game_type varchar(32),
agent_array int[],
effective_transaction numeric(20,2),
profit_loss numeric(20,2),
rebate_ratio numeric(4,2),
parent_ratio numeric(4,2),
rebate_parent numeric(20,2),
effective_self numeric(20,2),
profit_self numeric(20,2),
rebate_self numeric(20,2),
rebate_sun numeric(20,2)
);

COMMENT ON TABLE rebate_agent_api IS '代理API返佣';
COMMENT ON COLUMN rebate_agent_api.id IS '主键';
--COMMENT ON COLUMN rebate_agent_api.settle_flag IS '结算标志：Y=已结，N=未结';
COMMENT ON COLUMN rebate_agent_api.rebate_bill_id IS '返佣结算账单ID';
COMMENT ON COLUMN rebate_agent_api.agent_id IS '代理ID';
COMMENT ON COLUMN rebate_agent_api.agent_name IS '代理账号';
COMMENT ON COLUMN rebate_agent_api.agent_rank IS '代理层级';
COMMENT ON COLUMN rebate_agent_api.parent_id IS '上级代理ID';
COMMENT ON COLUMN rebate_agent_api.rebate_set_id IS '返佣方案ID';
COMMENT ON COLUMN rebate_agent_api.rebate_grads_id IS '返佣梯度ID';
COMMENT ON COLUMN rebate_agent_api.max_rebate IS '返佣上限';
--COMMENT ON COLUMN rebate_agent_api.rebate_grads_api_id IS '返佣API比率ID';
COMMENT ON COLUMN rebate_agent_api.effective_player IS '有效玩家数';
COMMENT ON COLUMN rebate_agent_api.api_id IS 'API_ID';
COMMENT ON COLUMN rebate_agent_api.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN rebate_agent_api.agent_array IS '贡献该API代理ID数组';
COMMENT ON COLUMN rebate_agent_api.effective_transaction IS '该分支总有效交易量';
COMMENT ON COLUMN rebate_agent_api.profit_loss IS '该分支总盈亏';
--COMMENT ON COLUMN rebate_agent_api.operation_retio IS '运营商占比';
--COMMENT ON COLUMN rebate_agent_api.operation_occupy IS '运营商占成';
COMMENT ON COLUMN rebate_agent_api.rebate_ratio IS '返佣比率';
COMMENT ON COLUMN rebate_agent_api.parent_ratio IS '上级代理返佣比率';
COMMENT ON COLUMN rebate_agent_api.rebate_parent IS '上级代理抽佣金额';
--COMMENT ON COLUMN rebate_agent_api.effective_player_self IS '自身有效玩家数';
COMMENT ON COLUMN rebate_agent_api.effective_self IS '自身有效交易量';
COMMENT ON COLUMN rebate_agent_api.profit_self IS '自身盈亏';
COMMENT ON COLUMN rebate_agent_api.rebate_self IS '自身佣金';
COMMENT ON COLUMN rebate_agent_api.rebate_sun IS '下级贡献佣金';

CREATE INDEX IF not EXISTS rebate_agent_api_agent_id_idx ON rebate_agent_api USING btree (agent_id);
CREATE INDEX IF not EXISTS rebate_agent_api_rebate_bill_id_idx ON rebate_agent_api USING btree (rebate_bill_id);

--DROP TABLE IF EXISTS rebate_player_fee;
CREATE TABLE if not EXISTS rebate_player_fee (
id serial4 PRIMARY KEY,
rebate_bill_id int4 NOT NULL,
topagent_id int4,
topagent_name varchar(32),
agent_id int4,
agent_name varchar(32),
player_id int4,
player_name varchar(32),
deposit_amount numeric(20,2),
withdraw_amount numeric(20,2),
rakeback_amount numeric(20,2),
favorable_amount numeric(20,2),
other_amount numeric(20,2)
);

COMMENT ON TABLE rebate_player_fee IS '代理返佣_玩家费用';
COMMENT ON COLUMN rebate_player_fee.id IS '主键';
COMMENT ON COLUMN rebate_player_fee.rebate_bill_id IS '返佣账单ID';
COMMENT ON COLUMN rebate_player_fee.topagent_id IS '总代id';
COMMENT ON COLUMN rebate_player_fee.topagent_name IS '总代账号';
COMMENT ON COLUMN rebate_player_fee.agent_id IS '代理id';
COMMENT ON COLUMN rebate_player_fee.agent_name IS '代理账号';
COMMENT ON COLUMN rebate_player_fee.player_id IS '玩家id';
COMMENT ON COLUMN rebate_player_fee.player_name IS '玩家账号';
COMMENT ON COLUMN rebate_player_fee.deposit_amount IS '存款金额';
COMMENT ON COLUMN rebate_player_fee.withdraw_amount IS '取款金额';
COMMENT ON COLUMN rebate_player_fee.rakeback_amount IS '返水金额';
COMMENT ON COLUMN rebate_player_fee.favorable_amount IS '优惠金额';
COMMENT ON COLUMN rebate_player_fee.other_amount IS '其他金额';


--ALTER TABLE rebate_agent RENAME TO rebate_agent_old;
--ALTER TABLE rebate_agent_old RENAME CONSTRAINT rebate_agent_pkey TO rebate_agent_old_pkey;
--ALTER SEQUENCE rebate_agent_id_seq RENAME TO rebate_agent_old_id_seq;
--DROP TABLE IF EXISTS rebate_agent;
CREATE TABLE IF NOT EXISTS rebate_agent (
id serial4 PRIMARY KEY,
rebate_bill_id int4 NOT NULL,
agent_id int4,
agent_name varchar(32),
agent_rank int4,
parent_id int4,
parent_array int[],
rebate_set_id int4,
rebate_grads_id int4,
max_rebate numeric(20,2),
effective_player int4,
effective_transaction numeric(20,2),
profit_loss numeric(20,2),
rebate_parent numeric(20,2),
effective_self numeric(20,2),
profit_self numeric(20,2),
rebate_self numeric(20,2),
rebate_self_history numeric(20,2),
rebate_sun numeric(20,2),
rebate_sun_history numeric(20,2),
deposit_amount numeric(20,2),
deposit_radio numeric(5,2),
deposit_fee numeric(20,2),
withdraw_amount numeric(20,2),
withdraw_radio numeric(5,2),
withdraw_fee numeric(20,2),
rakeback_amount numeric(20,2),
rakeback_radio numeric(5,2),
rakeback_fee numeric(20,2),
favorable_amount numeric(20,2),
favorable_radio numeric(5,2),
favorable_fee numeric(20,2),
other_amount numeric(20,2),
other_radio numeric(5,2),
other_fee numeric(20,2),
fee_amount numeric(20,2),
fee_history numeric(20,2),
rebate_total numeric(20,2),
rebate_actual numeric(20,2),
settlement_state varchar(32),
settlement_time timestamp(6),
operate_user_id int4,
operate_username varchar(100)
);
--ALTER TABLE rebate_agent
--ADD CONSTRAINT rebate_agent_rebate_bill_id_fkey FOREIGN KEY (rebate_bill_id) REFERENCES rebate_bill ("id");
--ALTER TABLE rebate_agent
--ADD CONSTRAINT "rebate_agent_deposit_radio_check" CHECK (deposit_radio >= 0 AND deposit_radio <= 100);

COMMENT ON TABLE rebate_agent IS '代理返佣';
COMMENT ON COLUMN rebate_agent.id IS '主键';
COMMENT ON COLUMN rebate_agent.rebate_bill_id IS '返佣结算账单ID';
COMMENT ON COLUMN rebate_agent.agent_id IS '代理ID';
COMMENT ON COLUMN rebate_agent.agent_name IS '代理账号';
COMMENT ON COLUMN rebate_agent.agent_rank IS '代理层级';
COMMENT ON COLUMN rebate_agent.parent_id IS '上级代理ID';
COMMENT ON COLUMN rebate_agent.parent_array IS '上级代理ID数组';
COMMENT ON COLUMN rebate_agent.rebate_set_id IS '返佣方案ID';
COMMENT ON COLUMN rebate_agent.rebate_grads_id IS '返佣梯度ID';
COMMENT ON COLUMN rebate_agent.max_rebate IS '返佣上限';
COMMENT ON COLUMN rebate_agent.effective_player IS '有效玩家数';
COMMENT ON COLUMN rebate_agent.effective_transaction IS '该分支总有效交易量';
COMMENT ON COLUMN rebate_agent.profit_loss IS '该分支总盈亏';
COMMENT ON COLUMN rebate_agent.rebate_parent IS '上级代理抽佣金额';
COMMENT ON COLUMN rebate_agent.effective_self IS '自身有效交易量';
COMMENT ON COLUMN rebate_agent.profit_self IS '自身盈亏';
COMMENT ON COLUMN rebate_agent.rebate_self IS '占成佣金';
COMMENT ON COLUMN rebate_agent.rebate_self_history IS '累积未结占成佣金';
COMMENT ON COLUMN rebate_agent.rebate_sun IS '下级贡献佣金';
COMMENT ON COLUMN rebate_agent.rebate_sun_history IS '累积未结下级贡献佣金';
COMMENT ON COLUMN rebate_agent.deposit_amount IS '存款金额';
COMMENT ON COLUMN rebate_agent.deposit_radio IS '存款手续费比率';
COMMENT ON COLUMN rebate_agent.deposit_fee IS '存款手续费';
COMMENT ON COLUMN rebate_agent.withdraw_amount IS '取款金额';
COMMENT ON COLUMN rebate_agent.withdraw_radio IS '取款手续费比率';
COMMENT ON COLUMN rebate_agent.withdraw_fee IS '取款手续费';
COMMENT ON COLUMN rebate_agent.rakeback_amount IS '返水金额';
COMMENT ON COLUMN rebate_agent.rakeback_radio IS '返水承担比率';
COMMENT ON COLUMN rebate_agent.rakeback_fee IS '返水费用';
COMMENT ON COLUMN rebate_agent.favorable_amount IS '优惠金额';
COMMENT ON COLUMN rebate_agent.favorable_radio IS '优惠承担比率';
COMMENT ON COLUMN rebate_agent.favorable_fee IS '优惠费用';
COMMENT ON COLUMN rebate_agent.other_amount IS '其他费用总额';
COMMENT ON COLUMN rebate_agent.other_radio IS '其他费用承担比率';
COMMENT ON COLUMN rebate_agent.other_fee IS '其他费用';
COMMENT ON COLUMN rebate_agent.fee_amount IS '当期费用总和';
COMMENT ON COLUMN rebate_agent.fee_history IS '累积未结费用';
COMMENT ON COLUMN rebate_agent.rebate_total IS '应付佣金=占成佣金+下级贡献佣金-费用(所有金额包括本期和累积)';
COMMENT ON COLUMN rebate_agent.rebate_actual IS '实付佣金';
COMMENT ON COLUMN rebate_agent.settlement_state IS '结算状态 operation.settlement_state';
COMMENT ON COLUMN rebate_agent.settlement_time IS '结算时间';
COMMENT ON COLUMN rebate_agent.operate_user_id IS '操作人ID';
COMMENT ON COLUMN rebate_agent.operate_username IS '操作人账号';


--ALTER TABLE rebate_bill RENAME TO rebate_bill_old;
--ALTER TABLE rebate_bill_old RENAME CONSTRAINT rebate_bill_pkey TO rebate_bill_old_pkey;
--ALTER SEQUENCE rebate_bill_id_seq RENAME TO rebate_bill_old_id_seq;
--DROP TABLE IF EXISTS rebate_bill;
CREATE TABLE if not EXISTS rebate_bill (
id serial4 PRIMARY KEY,
period varchar(32) NOT NULL,
start_time timestamp(6) NOT NULL,
end_time timestamp(6) NOT NULL,
effective_transaction numeric(20,2) DEFAULT 0,
profit_loss numeric(20,2) DEFAULT 0,
rebate_total numeric(20,2),
rebate_actual numeric(20,2),
lssuing_state varchar(32),
agent_count int4,
agent_lssuing_count int4,
agent_reject_count int4,
create_time timestamp(6),
last_operate_time timestamp(6),
last_operate_user_id int4,
last_operate_username varchar(100)
);

COMMENT ON TABLE rebate_bill IS '返佣账单表';
COMMENT ON COLUMN rebate_bill.id IS '主键';
COMMENT ON COLUMN rebate_bill.period IS '返佣周期: YYYY-MM';
COMMENT ON COLUMN rebate_bill.start_time IS '返佣起始时间';
COMMENT ON COLUMN rebate_bill.end_time IS '返佣结束时间';
COMMENT ON COLUMN rebate_bill.effective_transaction IS '有效交易量';
COMMENT ON COLUMN rebate_bill.profit_loss IS '总交易盈亏';
COMMENT ON COLUMN rebate_bill.rebate_total IS '应付返佣';
COMMENT ON COLUMN rebate_bill.rebate_actual IS '实际返佣';
COMMENT ON COLUMN rebate_bill.lssuing_state IS '发放状态operation.lssuing_state';
COMMENT ON COLUMN rebate_bill.agent_count IS '参与代理数';
COMMENT ON COLUMN rebate_bill.agent_lssuing_count IS '发放代理数';
COMMENT ON COLUMN rebate_bill.agent_reject_count IS '拒绝发放玩家数';
COMMENT ON COLUMN rebate_bill.create_time IS '创建时间';
COMMENT ON COLUMN rebate_bill.last_operate_time IS '最后操作时间';
COMMENT ON COLUMN rebate_bill.last_operate_user_id IS '最后操作人ID';
COMMENT ON COLUMN rebate_bill.last_operate_username IS '最后操作人';

CREATE INDEX IF NOT EXISTS rebate_bill_period_idx ON rebate_bill USING btree (period);
CREATE INDEX IF NOT EXISTS rebate_bill_start_time_idx ON rebate_bill USING btree (start_time);

--DROP TABLE IF EXISTS rebate_grads_set;
CREATE TABLE IF NOT EXISTS rebate_grads_set (
id SERIAL4 PRIMARY KEY,
name varchar(50),
status varchar(1) DEFAULT 1 NOT NULL,
valid_value int4 DEFAULT 0,
remark varchar(256),
create_time timestamp(6),
create_user_id int4,
owner_id int4
)
;

COMMENT ON TABLE rebate_grads_set IS '返佣梯度方案';
COMMENT ON COLUMN rebate_grads_set."id" IS '主键';
COMMENT ON COLUMN rebate_grads_set.name IS '名称';
COMMENT ON COLUMN rebate_grads_set.status IS '状态（0停用，1正常，2删除）字典类型program_settings';
COMMENT ON COLUMN rebate_grads_set.valid_value IS '有效玩家交易量';
COMMENT ON COLUMN rebate_grads_set.remark IS '备注';
COMMENT ON COLUMN rebate_grads_set.create_time IS '创建时间';
COMMENT ON COLUMN rebate_grads_set.create_user_id IS '创建人ID';
COMMENT ON COLUMN rebate_grads_set.owner_id IS '所有者';

SELECT redo_sqls($$
ALTER TABLE rebate_set ADD COLUMN rebate_grads_set_id INT;
COMMENT ON COLUMN rebate_set.rebate_grads_set_id IS '返佣梯度方案ID';

ALTER TABLE rebate_grads ADD COLUMN rebate_grads_set_id INT;
COMMENT ON COLUMN rebate_grads.rebate_grads_set_id IS '返佣梯度方案ID';

ALTER TABLE rebate_grads_api ADD COLUMN rebate_set_id INT;
COMMENT ON COLUMN rebate_grads_api.rebate_set_id IS '返佣方案ID';

ALTER TABLE user_agent ADD COLUMN agent_rank INT DEFAULT 1;
COMMENT ON COLUMN user_agent.agent_rank IS '代理层级';

ALTER TABLE user_agent ADD COLUMN parent_array INT[];
COMMENT ON COLUMN user_agent.agent_rank IS '上级代理路径数组(不包括总代)';

COMMENT ON COLUMN user_agent.parent_id IS '上级代理ID/总代ID';
$$);

CREATE INDEX IF NOT EXISTS rebate_grads_api_rgi_rsi_idx ON rebate_grads_api(rebate_grads_id, rebate_set_id);

CREATE INDEX IF NOT EXISTS user_agent_parent_array_idx ON user_agent USING GIN (parent_array);


UPDATE rebate_set SET rebate_grads_set_id = 0 WHERE id = 0;

UPDATE rebate_set rs SET rebate_grads_set_id = rownum
  FROM
    ( SELECT row_number() OVER (ORDER BY id) as rownum ,* from rebate_set WHERE id <> 0 ) t
 WHERE rs.id = t.id;

--TRUNCATE TABLE rebate_grads_set;
INSERT INTO rebate_grads_set (id, status, valid_value, create_time, create_user_id)
SELECT rebate_grads_set_id, status, valid_value, create_time, create_user_id FROM rebate_set ORDER BY rebate_grads_set_id
ON CONFLICT (id) DO NOTHING;

SELECT setval('rebate_grads_set_id_seq', (SELECT MAX(id) FROM rebate_grads_set) );

UPDATE rebate_grads rg
   SET rebate_grads_set_id = rs.rebate_grads_set_id
  FROM rebate_set rs
 WHERE rg.rebate_id = rs.id
   AND rg.rebate_grads_set_id IS NULL
   AND rs.rebate_grads_set_id IS NOT NULL;

UPDATE rebate_grads_api rga
   SET rebate_set_id = rs.id
  FROM rebate_set rs JOIN rebate_grads rg ON rs.id = rg.rebate_id
 WHERE rga.rebate_grads_id = rg.id;


UPDATE user_agent ua SET agent_rank = 0, parent_id = NULL WHERE EXISTS (SELECT 1 FROM sys_user su WHERE user_type = '22' AND su.id = ua.id);

WITH recursive ur AS (
SELECT id, agent_rank, parent_id, NULL::INT[] id_array FROM user_agent ua WHERE NOT EXISTS (SELECT 1 FROM user_agent WHERE ua.parent_id = id)
  UNION ALL
SELECT ua.id, ur.agent_rank + 1, ua.parent_id, COALESCE(id_array, ARRAY[]::INT[]) || ua.parent_id FROM ur, user_agent ua WHERE ua.parent_id = ur.id
) --SELECT * FROM ur ORDER BY agent_rank, id_array;
UPDATE user_agent ua
   SET agent_rank = ur.agent_rank, parent_array = id_array
  FROM ur
 WHERE ua.id = ur.id
   AND EXISTS (SELECT 1 FROM sys_user su WHERE user_type = '23' AND su.id = ua.id);


ALTER TABLE rebate_set ALTER COLUMN rebate_grads_set_id SET NOT NULL;

ALTER TABLE rebate_grads ALTER COLUMN rebate_grads_set_id SET NOT NULL;

ALTER TABLE rebate_grads_api ALTER COLUMN rebate_set_id SET NOT NULL;

ALTER TABLE user_agent ALTER COLUMN agent_rank SET NOT NULL;
