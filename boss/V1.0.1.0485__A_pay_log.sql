-- auto gen by george 2018-01-08 10:21:07
select  redo_sqls ($$
    ALTER TABLE pay_log ADD COLUMN channel_code  varchar(32) ;
    ALTER TABLE pay_log ADD COLUMN merchant_code varchar(32);
    ALTER TABLE pay_log ADD COLUMN terminal varchar(2) ;
    ALTER TABLE pay_log ADD COLUMN error_log TEXT;
    ALTER TABLE pay_log ADD COLUMN provider varchar(32);
$$);

COMMENT ON COLUMN pay_log.channel_code is '支付渠道';
COMMENT ON COLUMN pay_log.merchant_code is '商户号';
COMMENT ON COLUMN pay_log.terminal is '终端';
COMMENT ON COLUMN pay_log.error_log is '错误信息';
COMMENT ON COLUMN pay_log.provider is '提供商';