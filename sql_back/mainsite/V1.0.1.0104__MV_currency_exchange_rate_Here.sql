-- auto gen by longer 2015-11-24 15:13:17

CREATE TABLE IF NOT EXISTS currency_exchange_rate (
  id INTEGER PRIMARY KEY NOT NULL,
  ifrom_currency CHARACTER VARYING(32), -- 主币种
  ito_currency CHARACTER VARYING(32), -- 兑换币种
  rate NUMERIC(20,4), -- 汇率
  remark CHARACTER VARYING(200) -- 备注
);

COMMENT ON TABLE currency_exchange_rate IS '币种汇率表--lorne';
COMMENT ON COLUMN currency_exchange_rate.ifrom_currency IS '主币种';
COMMENT ON COLUMN currency_exchange_rate.ito_currency IS '兑换币种';
COMMENT ON COLUMN currency_exchange_rate.rate IS '汇率';
COMMENT ON COLUMN currency_exchange_rate.remark IS '备注';


INSERT INTO currency_exchange_rate (id, ifrom_currency, ito_currency, rate, remark) SELECT 1, 'CNY', 'CNY', 1.0000, null
                                                                                           where not exists( select id from currency_exchange_rate where id = 1);