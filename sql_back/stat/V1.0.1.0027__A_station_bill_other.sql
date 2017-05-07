-- auto gen by cheery 2015-12-23 18:26:52
ALTER TABLE station_bill_other DROP COLUMN IF EXISTS maintenance_charges;
ALTER TABLE station_bill_other DROP COLUMN IF EXISTS ensure_consume;

select redo_sqls($$
    ALTER TABLE station_bill_other ADD COLUMN fee numeric(20,2);
    ALTER TABLE station_bill ADD COLUMN remark varchar(200);
  $$);

COMMENT ON COLUMN station_bill.remark IS '备注';
COMMENT ON COLUMN station_bill.amount_payable IS '站长应付金额';
COMMENT ON COLUMN station_bill.amount_actual IS '站长实付金额,即修改金额';

select redo_sqls($$
    ALTER TABLE station_profit_loss ADD COLUMN occupy_proportion numeric(20,2);
    ALTER TABLE station_bill_other ADD COLUMN apportion_proportion numeric(20,2);
    ALTER TABLE station_bill ADD COLUMN site_name varchar(32);
    ALTER TABLE station_bill ADD COLUMN master_name varchar(32);
    ALTER TABLE station_bill ADD COLUMN center_name varchar(32);
  $$);

COMMENT ON COLUMN station_profit_loss.occupy_proportion IS '占成比例(站长占成或总代占成)';
COMMENT ON COLUMN station_bill_other.amount_payable IS '站长应付金额';
COMMENT ON COLUMN station_bill_other.amount_actual IS '站长实付金额';
COMMENT ON COLUMN station_bill_other.apportion_proportion IS '分摊比例(总代分摊比例)';
COMMENT ON COLUMN station_bill_other.fee IS '费用(保底费用或者维护费用)';
COMMENT ON COLUMN station_bill.site_name IS '站点名称';
COMMENT ON COLUMN station_bill.master_name IS '站长账号';
COMMENT ON COLUMN station_bill.center_name IS '运营商账号';

ALTER TABLE "station_profit_loss" ALTER COLUMN "game_type" TYPE varchar(32);





