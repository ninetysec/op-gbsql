-- auto gen by cheery 2015-12-10 10:08:42
CREATE TABLE if not EXISTS company_operate (
  id SERIAL4 PRIMARY KEY NOT NULL,
  operator_id INT4,
  operator_name VARCHAR(100),
  api_id INT4,
  api_type_id INT4,
  game_type VARCHAR(32),
  static_year INT4,
  static_month INT4,
  create_time TIMESTAMP,
  transaction_order NUMERIC(20,2),
  transaction_volume NUMERIC(20,2),
  effective_transaction_volume NUMERIC(20,2),
  transaction_profit_loss NUMERIC(20,2)
);

ALTER TABLE company_operate OWNER TO postgres;
COMMENT ON TABLE company_operate IS '运营商经营报表 - eagle';
COMMENT ON COLUMN company_operate.id IS '主键';
COMMENT ON COLUMN company_operate.operator_id IS '运营商ID';
COMMENT ON COLUMN company_operate.operator_name IS '运营商名称';
COMMENT ON COLUMN company_operate.api_id IS 'api外键';
COMMENT ON COLUMN company_operate.api_type_id IS 'api分类';
COMMENT ON COLUMN company_operate.game_type IS '游戏分类,即api二级分类';
COMMENT ON COLUMN company_operate.static_year IS '统计年份';
COMMENT ON COLUMN company_operate.static_month IS '统计月份';
COMMENT ON COLUMN company_operate.create_time IS '创建时间';
COMMENT ON COLUMN company_operate.transaction_order IS '当月交易单量';
COMMENT ON COLUMN company_operate.transaction_volume IS '当月交易量';
COMMENT ON COLUMN company_operate.effective_transaction_volume IS '当月有效交易量';
COMMENT ON COLUMN company_operate.transaction_profit_loss IS '当月交易盈亏';

ALTER TABLE station_bill DROP COLUMN IF EXISTS bill_name;
ALTER TABLE station_bill DROP COLUMN IF EXISTS start_time;
ALTER TABLE station_bill DROP COLUMN IF EXISTS end_time;
ALTER TABLE station_bill DROP COLUMN IF EXISTS last_operate_time;
ALTER TABLE station_bill DROP COLUMN IF EXISTS user_id;
ALTER TABLE station_bill DROP COLUMN IF EXISTS user_name;
ALTER TABLE station_bill DROP COLUMN IF EXISTS top_agent_id;
ALTER TABLE station_bill DROP COLUMN IF EXISTS top_agent_name;

ALTER TABLE station_profit_loss DROP COLUMN IF EXISTS game_id;
ALTER TABLE station_profit_loss DROP COLUMN IF EXISTS payout;
ALTER TABLE station_profit_loss DROP COLUMN IF EXISTS accounted_proportion;
ALTER TABLE station_profit_loss DROP COLUMN IF EXISTS minimum_guarantee;
ALTER TABLE station_profit_loss DROP COLUMN IF EXISTS remark;

ALTER TABLE station_bill_other DROP COLUMN IF EXISTS project_name;
ALTER TABLE station_bill_other DROP COLUMN IF EXISTS remark;

select redo_sqls($$
    ALTER TABLE station_bill ADD COLUMN bill_year INT4;
    ALTER TABLE station_bill ADD COLUMN bill_month INT4;
    ALTER TABLE station_bill ADD COLUMN amount_actual numeric(20,2);
    ALTER TABLE station_bill ADD COLUMN create_time TIMESTAMP;

    ALTER TABLE station_bill ADD COLUMN topagent_id INT4;
    ALTER TABLE station_bill ADD COLUMN topagent_name varchar(32);
    ALTER TABLE station_bill ADD COLUMN bill_type varchar(32);
    ALTER TABLE station_bill ADD COLUMN last_operate_time TIMESTAMP;
    ALTER TABLE station_bill ADD COLUMN operate_user_id INT4;
    ALTER TABLE station_bill ADD COLUMN operate_user_name varchar(32);

    ALTER TABLE station_profit_loss ADD COLUMN game_type INT4;
   
    ALTER TABLE station_bill_other ADD COLUMN project_code varchar(32);
    ALTER TABLE station_bill_other ADD COLUMN amount_actual numeric(20,2);
    ALTER TABLE station_bill_other ADD COLUMN maintenance_charges numeric(20,2);
    ALTER TABLE station_bill_other ADD COLUMN ensure_consume numeric(20,2);
    ALTER TABLE station_bill_other ADD COLUMN favourable_grads numeric(20,2);
    ALTER TABLE station_bill_other ADD COLUMN favourable_way varchar(32);
    ALTER TABLE station_bill_other ADD COLUMN favourable_value numeric(20,2);
    ALTER TABLE station_bill_other ADD COLUMN favourable_limit numeric(20,2);
    ALTER TABLE station_bill_other ADD COLUMN operate_user_name varchar(32);
    
    ALTER TABLE "station_bill_other"
    ADD CONSTRAINT "station_bill_other_pkey" PRIMARY KEY ("id");
    ALTER TABLE "station_bill_other"
    ADD CONSTRAINT "station_bill_other_pkey" PRIMARY KEY ("id");
  $$);

COMMENT ON COLUMN station_bill.bill_year IS '账单结算年份';
COMMENT ON COLUMN station_bill.bill_month IS '账单结算月份';
COMMENT ON COLUMN station_bill.amount_actual IS '实付金额,即修改金额';
COMMENT ON COLUMN station_bill.create_time IS '账单生成时间';
COMMENT ON COLUMN station_profit_loss.game_type IS '游戏分类,即api二级分类';
COMMENT ON COLUMN station_bill_other.project_code IS '项目代码(维护费,保底消费,返还盈利,减免维护费,上期未结)';
COMMENT ON COLUMN station_bill_other.amount_actual IS '实付金额';
COMMENT ON COLUMN station_bill_other.maintenance_charges IS '维护费用';
COMMENT ON COLUMN station_bill_other.ensure_consume IS '保底费用';
COMMENT ON COLUMN station_bill_other.favourable_grads IS '优惠满足梯度(只有减免维护费和返还盈利该字段有值)';
COMMENT ON COLUMN station_bill_other.favourable_way IS '优惠方式(固定或者比例,只有减免维护费和返还盈利该字段有值)';
COMMENT ON COLUMN station_bill_other.favourable_value IS '优惠值(只有减免维护费和返还盈利该字段有值)';
COMMENT ON COLUMN station_bill_other.favourable_limit IS '优惠上限(只有减免维护费和返还盈利该字段有值)';
COMMENT ON COLUMN station_bill_other.operate_user_name IS '经手人账号(只有上期未结该字段有值)';

COMMENT ON COLUMN station_bill.topagent_id IS '总代ID';
COMMENT ON COLUMN station_bill.topagent_name IS '总代名称';
COMMENT ON COLUMN station_bill.bill_type IS '账单类型(站长账单,总代账单)';
COMMENT ON COLUMN station_bill.last_operate_time IS '最后操作时间';
COMMENT ON COLUMN station_bill.operate_user_id IS '最后操作人ID';
COMMENT ON COLUMN station_bill.operate_user_name IS '最后操作人';
