-- auto gen by Alvin 2016-10-01 12:40:41

DROP TABLE IF EXISTS api_order;
select redo_sqls($$
CREATE TABLE api_order (
  id serial NOT NULL, -- 主键
  bet_id character varying(64) NOT NULL, -- 注单号码
  game_code character varying(64), -- 游戏code
  account character varying(32) NOT NULL, -- api账号
  site_id integer, -- 站点id
  single_amount numeric(20,2), -- 投注金额
  bet_time timestamp(6) without time zone, -- 投注时间
  profit_amount numeric(20,2), -- 派彩金额
  payout_time timestamp(6) without time zone, -- 派彩时间
  is_profit_loss boolean, -- 是否有盈亏：t-有盈亏 f-和局
  effective_trade_amount numeric(20,2), -- 有效交易量
  order_state character varying(32), -- game.order_state:未结算,已结算,订单取消
  currency_code character varying(30), -- 币种
  result_json text, -- 游戏结果json
  action_id_json text, -- 爆点记录的action_id,格式为action_id:profitAmount
  winning_amount numeric(20,2), -- 中奖金额
  winning_flag boolean, -- 中奖标识
  winning_time timestamp(6) without time zone, -- 中奖时间
  game_id integer, -- 游戏外键
  game_type character varying(32), -- 游戏分类
  api_type_id integer, -- api分类
  api_id integer, -- api表id
  create_time timestamp(6) without time zone, -- 入库时间
  distribute_state character varying(32), -- 分发状态(未分发,已分发,待重新分发)
  terminal character varying(8) -- 注单终端:1-PC 2-MOBILE
);
COMMENT ON TABLE api_order IS '玩家游戏投注表 ';
COMMENT ON COLUMN api_order.id IS '主键';
COMMENT ON COLUMN api_order.bet_id IS '注单号码';
COMMENT ON COLUMN api_order.game_code IS '游戏code';
COMMENT ON COLUMN api_order.account IS 'api账号';
COMMENT ON COLUMN api_order.site_id IS '站点id';
COMMENT ON COLUMN api_order.single_amount IS '投注金额 ';
COMMENT ON COLUMN api_order.bet_time IS '投注时间';
COMMENT ON COLUMN api_order.profit_amount IS '派彩金额';
COMMENT ON COLUMN api_order.payout_time IS '派彩时间';
COMMENT ON COLUMN api_order.is_profit_loss IS '是否有盈亏：t-有盈亏 f-和局';
COMMENT ON COLUMN api_order.effective_trade_amount IS '有效交易量';
COMMENT ON COLUMN api_order.order_state IS 'game.order_state:未结算,已结算,订单取消';
COMMENT ON COLUMN api_order.currency_code IS '币种';
COMMENT ON COLUMN api_order.result_json IS '游戏结果json';
COMMENT ON COLUMN api_order.action_id_json IS '爆点记录的action_id,格式为action_id:profitAmount';
COMMENT ON COLUMN api_order.winning_amount IS '中奖金额';
COMMENT ON COLUMN api_order.winning_flag IS '中奖标识';
COMMENT ON COLUMN api_order.winning_time IS '中奖时间';
COMMENT ON COLUMN api_order.game_id IS '游戏外键';
COMMENT ON COLUMN api_order.game_type IS '游戏分类';
COMMENT ON COLUMN api_order.api_type_id IS 'api分类';
COMMENT ON COLUMN api_order.api_id IS 'api表id';
COMMENT ON COLUMN api_order.create_time IS '入库时间';
COMMENT ON COLUMN api_order.distribute_state IS '分发状态(未分发,已分发,待重新分发)';
COMMENT ON COLUMN api_order.terminal IS '注单终端:1-PC 2-MOBILE';


CREATE INDEX fk_api_order_api_id ON api_order USING btree (api_id);
CREATE INDEX fk_api_order_bet_id ON api_order USING btree (bet_id);
CREATE INDEX fk_api_order_account ON api_order USING btree (account);
CREATE INDEX fk_api_order_game_bet_time ON api_order USING btree (bet_time);
CREATE INDEX fk_api_order_game_id ON api_order USING btree (game_id);
CREATE INDEX fk_api_order_payout_time ON api_order USING btree (payout_time);
CREATE INDEX fk_api_order_site_id ON api_order USING btree (site_id);

ALTER TABLE api_order ADD UNIQUE (api_id, bet_id);
ALTER TABLE api_order ADD PRIMARY KEY (id);
$$);