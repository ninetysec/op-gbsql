-- auto gen by cherry 2018-01-26 09:53:29
CREATE TABLE IF not EXISTS pay_account_disable_log(
id serial4 not null PRIMARY key,
site_id int4,
account varchar(200),
pay_account_id int4,
disable_time TIMESTAMP(6),
pay_log text,
error_type varchar(32),
transaction_no varchar(32),
channel_code varchar(32),
operate_id int4,
operator varchar(32),
site_name varchar(128)
);

COMMENT on TABLE pay_account_disable_log is '停用收款帐号日志';
COMMENT on COLUMN pay_account_disable_log.id is '主键';
COMMENT on COLUMN pay_account_disable_log.site_id is '站点id';
COMMENT on COLUMN pay_account_disable_log.account is '商户号';
COMMENT on COLUMN pay_account_disable_log.pay_account_id is '收款帐号id';
COMMENT on COLUMN pay_account_disable_log.disable_time is '停用时间';
COMMENT on COLUMN pay_account_disable_log.pay_log is '支付返回错误日志';
COMMENT on COLUMN pay_account_disable_log.error_type is '支付错误类型';
COMMENT on COLUMN pay_account_disable_log.transaction_no is '支付交易号';
COMMENT on COLUMN pay_account_disable_log.channel_code is '渠道';
COMMENT on COLUMN pay_account_disable_log.operate_id is '操作者id';
COMMENT on COLUMN pay_account_disable_log.operator is '操作者';
COMMENT on COLUMN pay_account_disable_log.site_name is '站点名称';