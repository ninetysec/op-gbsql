-- auto gen by cherry 2017-07-24 14:36:46
CREATE TABLE IF NOT EXISTS topagent_occupy_api (
id serial4 PRIMARY KEY,
occupy_bill_no VARCHAR(32) NOT NULL,
occupy_year INT,
occupy_month INT,
topagent_id int4,
topagent_name varchar(32),
api_id int4,
api_type_id int4,
game_type varchar(32),
profit_amount numeric(20,2) DEFAULT 0,
operation_retio numeric(4,2) DEFAULT 0,
operation_occupy numeric(20,2) DEFAULT 0,
occupy_retio numeric(4,2) DEFAULT 0,
occupy_value numeric(20,2) DEFAULT 0
);

COMMENT ON TABLE topagent_occupy_api IS '总代API占成';

COMMENT ON COLUMN topagent_occupy_api."id" IS '主键';
COMMENT ON COLUMN topagent_occupy_api.occupy_bill_no IS '占成结算账单编号';
COMMENT ON COLUMN topagent_occupy_api.occupy_year IS '年份';
COMMENT ON COLUMN topagent_occupy_api.occupy_month IS '月份';
COMMENT ON COLUMN topagent_occupy_api.topagent_id IS '总代ID';
COMMENT ON COLUMN topagent_occupy_api.topagent_name IS '总代账号';
COMMENT ON COLUMN topagent_occupy_api.api_id IS 'API_ID';
COMMENT ON COLUMN topagent_occupy_api.api_type_id IS 'API二级分类ID';
COMMENT ON COLUMN topagent_occupy_api.game_type IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN topagent_occupy_api.profit_amount IS '盈亏';
COMMENT ON COLUMN topagent_occupy_api.operation_retio IS '运营商占比';
COMMENT ON COLUMN topagent_occupy_api.operation_occupy IS '运营商占成';
COMMENT ON COLUMN topagent_occupy_api.occupy_retio IS '占成比率';
COMMENT ON COLUMN topagent_occupy_api.occupy_value IS '占成金额';


CREATE INDEX IF NOT EXISTS idx_topagent_occupy_api_topagent_id ON topagent_occupy_api USING btree (topagent_id);
CREATE INDEX IF NOT EXISTS idx_topagent_occupy_api_occupy_bill_id ON topagent_occupy_api USING btree (occupy_bill_no);


CREATE TABLE IF NOT EXISTS topagent_occupy (
id serial4 PRIMARY KEY,
occupy_bill_no VARCHAR(32) NOT NULL,
occupy_year INT,
occupy_month INT,
topagent_id int4 NOT NULL,
topagent_name varchar(32),
profit_amount numeric(20,2) DEFAULT 0,
operation_occupy numeric(20,2) DEFAULT 0,
topagent_occupy numeric(20,2) DEFAULT 0,
poundage numeric(20,2) DEFAULT 0,
favorable numeric(20,2) DEFAULT 0,
recommend numeric(20,2) DEFAULT 0,
refund_fee numeric(20,2) DEFAULT 0,
rakeback numeric(20,2) DEFAULT 0,
rebate numeric(20,2) DEFAULT 0,
apportion_retio numeric(20,2) DEFAULT 0,
apportion_value numeric(20,2) DEFAULT 0
);

COMMENT ON TABLE topagent_occupy IS '总代占成';

COMMENT ON COLUMN topagent_occupy."id" IS '主键';
COMMENT ON COLUMN topagent_occupy.occupy_bill_no IS '占成结算账单编号';
COMMENT ON COLUMN topagent_occupy.occupy_year IS '年份';
COMMENT ON COLUMN topagent_occupy.occupy_month IS '月份';
COMMENT ON COLUMN topagent_occupy.topagent_id IS '总代ID';
COMMENT ON COLUMN topagent_occupy.topagent_name IS '总代账号';
COMMENT ON COLUMN topagent_occupy.profit_amount IS '盈亏';
COMMENT ON COLUMN topagent_occupy.operation_occupy IS '运营商占成';
COMMENT ON COLUMN topagent_occupy.topagent_occupy IS '总代占成';
COMMENT ON COLUMN topagent_occupy.poundage IS '行政费用';
COMMENT ON COLUMN topagent_occupy.favorable IS '优惠费用';
COMMENT ON COLUMN topagent_occupy.recommend IS '推荐费用';
COMMENT ON COLUMN topagent_occupy.refund_fee IS '返手续费';
COMMENT ON COLUMN topagent_occupy.rakeback IS '返水费用';
COMMENT ON COLUMN topagent_occupy.rebate IS '返佣费用';
COMMENT ON COLUMN topagent_occupy.apportion_retio IS '费用承担比率';
COMMENT ON COLUMN topagent_occupy.apportion_value IS '费用承担金额';

CREATE INDEX IF not EXISTS idx_topagent_occupy_topagent_id ON topagent_occupy USING btree (topagent_id);
CREATE INDEX IF not EXISTS idx_topagent_occupy_occupy_bill_id ON topagent_occupy USING btree (occupy_bill_no);