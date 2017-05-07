-- auto gen by cheery 2015-12-03 20:07:43

CREATE TABLE IF NOT EXISTS site_rebate (
      id SERIAL4 PRIMARY KEY NOT NULL,
      center_id INTEGER NOT NULL, -- 运营商ID
      master_id INTEGER NOT NULL, -- 站长ID
      site_id INTEGER NOT NULL, -- 站点ID
      effective_player INTEGER, -- 有效玩家数
      effective_transaction NUMERIC(20,2), -- 有效交易量
      profit_loss NUMERIC(20,2), -- 交易盈亏
      deposit_amount NUMERIC(20,2), -- 存款
      withdrawal_amount NUMERIC(20,2), -- 取款
      preferential_value NUMERIC(20,2), -- 优惠及推荐
      refund_fee NUMERIC(20,2), -- 返手续费
      deduct_expenses NUMERIC(20,2), -- 分摊费用
      rebate_total NUMERIC(20,2), -- 应付返佣
      rebate_actual NUMERIC(20,2), -- 实付返佣
      rebate_year INTEGER, -- 返佣年份
      rebate_month INTEGER, -- 返佣月份
      static_time TIMESTAMP WITHOUT TIME ZONE, -- 统计时间
      rakeback NUMERIC(20,2) DEFAULT 0 -- 返水
);
COMMENT ON TABLE site_rebate IS '站点返佣汇总 -- Fly';
COMMENT ON COLUMN site_rebate.id IS '主键';
COMMENT ON COLUMN site_rebate.center_id IS '运营商ID';
COMMENT ON COLUMN site_rebate.master_id IS '站长ID';
COMMENT ON COLUMN site_rebate.site_id IS '站点ID';
COMMENT ON COLUMN site_rebate.effective_player IS '有效玩家数';
COMMENT ON COLUMN site_rebate.effective_transaction IS '有效交易量';
COMMENT ON COLUMN site_rebate.profit_loss IS '交易盈亏';
COMMENT ON COLUMN site_rebate.deposit_amount IS '存款';
COMMENT ON COLUMN site_rebate.withdrawal_amount IS '取款';
COMMENT ON COLUMN site_rebate.preferential_value IS '优惠及推荐';
COMMENT ON COLUMN site_rebate.refund_fee IS '返手续费';
COMMENT ON COLUMN site_rebate.deduct_expenses IS '分摊费用';
COMMENT ON COLUMN site_rebate.rebate_total IS '应付返佣';
COMMENT ON COLUMN site_rebate.rebate_actual IS '实付返佣';
COMMENT ON COLUMN site_rebate.rebate_year IS '返佣年份';
COMMENT ON COLUMN site_rebate.rebate_month IS '返佣月份';
COMMENT ON COLUMN site_rebate.static_time IS '统计时间';
COMMENT ON COLUMN site_rebate.rakeback IS '返水';


CREATE TABLE IF NOT EXISTS site_rebate_api (
      id SERIAL4 PRIMARY KEY NOT NULL ,
      center_id INTEGER NOT NULL, -- 运营商ID
      master_id INTEGER NOT NULL, -- 站长ID
      site_id INTEGER NOT NULL, -- 站点ID
      api_id INTEGER NOT NULL, -- API主键
      rebate_total NUMERIC(20,2), -- 应付返佣
      rebate_year INTEGER, -- 返佣年份
      rebate_month INTEGER, -- 返佣月份
      static_time TIMESTAMP WITHOUT TIME ZONE -- 统计时间
);
COMMENT ON TABLE site_rebate_api IS '站点API返佣汇总 -- Fly';
COMMENT ON COLUMN site_rebate_api.id IS '主键';
COMMENT ON COLUMN site_rebate_api.center_id IS '运营商ID';
COMMENT ON COLUMN site_rebate_api.master_id IS '站长ID';
COMMENT ON COLUMN site_rebate_api.site_id IS '站点ID';
COMMENT ON COLUMN site_rebate_api.api_id IS 'API主键';
COMMENT ON COLUMN site_rebate_api.rebate_total IS '应付返佣';
COMMENT ON COLUMN site_rebate_api.rebate_year IS '返佣年份';
COMMENT ON COLUMN site_rebate_api.rebate_month IS '返佣月份';
COMMENT ON COLUMN site_rebate_api.static_time IS '统计时间';

CREATE TABLE IF NOT EXISTS  site_rebate_gametype (
      id SERIAL4 PRIMARY KEY NOT NULL ,
      center_id INTEGER NOT NULL, -- 运营商ID
      master_id INTEGER NOT NULL, -- 站长ID
      site_id INTEGER NOT NULL, -- 站点ID
      api_id INTEGER NOT NULL, -- API主键
      game_type CHARACTER VARYING(2), -- 游戏二级类别(字典:game.game_type)
      rebate_total NUMERIC(20,2), -- 应付返佣
      rebate_year INTEGER, -- 返佣年份
      rebate_month INTEGER, -- 返佣月份
      static_time TIMESTAMP WITHOUT TIME ZONE -- 统计时间
);
COMMENT ON TABLE site_rebate_gametype IS '站点游戏分类返佣汇总 -- Fly';
COMMENT ON COLUMN site_rebate_gametype.id IS '主键';
COMMENT ON COLUMN site_rebate_gametype.center_id IS '运营商ID';
COMMENT ON COLUMN site_rebate_gametype.master_id IS '站长ID';
COMMENT ON COLUMN site_rebate_gametype.site_id IS '站点ID';
COMMENT ON COLUMN site_rebate_gametype.api_id IS 'API主键';
COMMENT ON COLUMN site_rebate_gametype.game_type IS '游戏二级类别(字典:game.game_type)';
COMMENT ON COLUMN site_rebate_gametype.rebate_total IS '应付返佣';
COMMENT ON COLUMN site_rebate_gametype.rebate_year IS '返佣年份';
COMMENT ON COLUMN site_rebate_gametype.rebate_month IS '返佣月份';
COMMENT ON COLUMN site_rebate_gametype.static_time IS '统计时间';

