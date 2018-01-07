-- auto gen by george 2018-01-07 14:08:45
select  redo_sqls ($$
    ALTER TABLE pay_log ADD COLUMN channel_code  varchar(32) ;
    ALTER TABLE pay_log ADD COLUMN merchant_code varchar(32);
    ALTER TABLE pay_log ADD COLUMN terminal varchar(2) ;
    ALTER TABLE pay_log ADD COLUMN error_log varchar(255) ;
$$);

COMMENT ON COLUMN pay_log.channel_code is '支付渠道';
COMMENT ON COLUMN pay_log.merchant_code is '商户号';
COMMENT ON COLUMN pay_log.terminal is '终端';
COMMENT ON COLUMN pay_log.error_log is '错误信息';