-- auto gen by george 2017-11-20 11:06:15
create TABLE IF NOT EXISTS credit_reset_profit_record(
	id serial4 not null PRIMARY key,
  site_id int4,
  create_time TIMESTAMP(6),
  orgin_profit NUMERIC(20,2)
);
COMMENT ON COLUMN "credit_reset_profit_record"."id" IS '主键';
COMMENT ON COLUMN "credit_reset_profit_record"."site_id" IS '站点ID';
COMMENT ON COLUMN "credit_reset_profit_record"."create_time" IS '记录时间';
COMMENT ON COLUMN "credit_reset_profit_record"."orgin_profit" IS '恢复前额度';
COMMENT ON TABLE credit_reset_profit_record IS '站点恢复默认额度记录表--younger';