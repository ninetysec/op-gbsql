-- auto gen by cherry 2017-07-19 16:16:20
CREATE TABLE IF NOT EXISTS digiccy_transaction(
id serial4 not null PRIMARY KEY,
transaction_no varchar(32),
response_text text,
amount numeric(20,8),
update_time TIMESTAMP,
operate_user int4,
operator varchar(32),
currency varchar(16),
hash_verification varchar(100),
status varchar(2),
type varchar(32),
transaction_time TIMESTAMP,
txId varchar(64),
request_text text
);

COMMENT ON TABLE digiccy_transaction is '数字货币交易信息';

COMMENT ON COLUMN digiccy_transaction.id is '主键';
COMMENT ON COLUMN digiccy_transaction.transaction_no is '交易号';
COMMENT ON COLUMN digiccy_transaction.response_text is '交易数据：第三方返回报文,json格式储存';
COMMENT ON COLUMN digiccy_transaction.amount is '涉及交易数字货币金额';
COMMENT ON COLUMN digiccy_transaction.update_time is '更新时间';
COMMENT ON COLUMN digiccy_transaction.operate_user is '操作者id';
COMMENT ON COLUMN digiccy_transaction.operator is '操作者';
COMMENT ON COLUMN digiccy_transaction.currency is '数字货币代码:比特币-BTC';
COMMENT ON COLUMN digiccy_transaction.hash_verification is 'hash防重验证';
COMMENT ON COLUMN digiccy_transaction.status is '1-交易成功 2-交易失败 3-交易处理中';
COMMENT ON COLUMN digiccy_transaction.type is '交易类型';
COMMENT ON COLUMN digiccy_transaction.transaction_time is '交易时间';
COMMENT ON COLUMN digiccy_transaction.txId is '数字货币方交易号';
COMMENT ON COLUMN digiccy_transaction.request_text is '请求第三方存储信息 json格式储存';
