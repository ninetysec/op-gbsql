-- auto gen by wayne 2016-04-13 22:23:24
DROP TABLE IF EXISTS pay_api_param;

CREATE TABLE pay_api_param
(
  id serial NOT NULL, -- 主键
  channel_code character varying(20) NOT NULL, -- 支付渠道代码
  param_name character varying(50) NOT NULL, -- 参数名称
  param_mean character varying(100) NOT NULL, -- 参数国际化key值
  param_order integer, -- 参数顺序
  is_enable boolean, -- 是否可用
  remark character varying(500),
  CONSTRAINT pk_pay_api_param PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE pay_api_param
  IS '支付相关开户参数--Mark';
COMMENT ON COLUMN pay_api_param.id IS '主键';
COMMENT ON COLUMN pay_api_param.channel_code IS '支付渠道代码';
COMMENT ON COLUMN pay_api_param.param_name IS '参数名称';
COMMENT ON COLUMN pay_api_param.param_mean IS '参数国际化key值';
COMMENT ON COLUMN pay_api_param.param_order IS '参数顺序';
COMMENT ON COLUMN pay_api_param.is_enable IS '是否可用';


INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('53', 'bbpay_new', 'key', 'key', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('1', 'gopay', 'merchantID', 'merchantCode', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('2', 'gopay', 'virCardNoIn', 'gopayChange', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('3', 'gopay', 'payDomain', 'payDomain', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('4', 'gopay', 'key', 'identificationCode', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('11', 'baofoo', 'MemberID', 'merchantCode', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('12', 'baofoo', 'TerminalID', 'terminalId', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('13', 'baofoo', 'key', 'key', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('14', 'baofoo', 'payDomain', 'payDomain', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('21', 'yeepay', 'p1_MerId', 'merchantCode', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('22', 'yeepay', 'payDomain', 'payDomain', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('23', 'yeepay', 'key', 'key', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('31', 'reapal', 'merchant_ID', 'merchantCode', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('32', 'reapal', 'seller_email', 'seller_email', NULL, 't', '在融宝的注册Email');
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('33', 'reapal', 'payDomain', 'payDomain', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('34', 'reapal', 'key', 'key', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('27', 'ips_3', 'key', 'key', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('25', 'ips_3', 'Mer_code', 'merchantCode', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('26', 'ips_3', 'payDomain', 'payDomain', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('41', 'ips_7', 'MerCode', 'merchantCode', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('42', 'ips_7', 'Account', 'Account', NULL, 't', '交易账户号');
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('51', 'bbpay_new', 'merchantaccount', 'merchantCode', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('52', 'bbpay_new', 'payDomain', 'payDomain', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('61', 'bbpay_old', 'p3_bn', 'merchantCode', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('43', 'ips_7', 'payDomain', 'payDomain', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('44', 'ips_7', 'key', 'key', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('62', 'bbpay_old', 'payDomain', 'payDomain', NULL, 't', NULL);
INSERT INTO "pay_api_param" ("id", "channel_code", "param_name", "param_mean", "param_order", "is_enable", "remark") VALUES ('63', 'bbpay_old', 'key', 'key', NULL, 't', NULL);

ALTER TABLE pay_log ALTER COLUMN object_params TYPE text;
