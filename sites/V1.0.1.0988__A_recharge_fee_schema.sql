-- auto gen by steffan 2018-09-23 14:55:01
 select redo_sqls($$
    alter table recharge_fee_schema add column "recharge_type" varchar(50) ;
    alter table recharge_fee_schema add column "bank_code" varchar(512)  ;
    alter table recharge_fee_schema add column "all_bank_code" boolean  ;
  $$);
  COMMENT ON COLUMN recharge_fee_schema.recharge_type IS '存款类型（1公司入款；2线上支付）(字典表pay_account_type)';
  COMMENT ON COLUMN recharge_fee_schema."bank_code" IS '渠道(bank表的bank_name）';
  COMMENT ON COLUMN recharge_fee_schema."all_bank_code" IS '是否所有渠道:recharge_type=1所有的公司入款,recharge_type=2所有的线上支付';