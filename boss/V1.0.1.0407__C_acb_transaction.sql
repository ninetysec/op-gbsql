-- auto gen by cherry 2017-09-02 10:27:08
CREATE TABLE if not EXISTS acb_transaction(
	id serial4 not null PRIMARY key,
site_id int4,
transaction_no varchar(128),
bank_code varchar(32),
card_login_name varchar(32),
card_number varchar(32),
pay_username varchar(32),
amount numeric(18,2),
create_time TIMESTAMP(6),
status varchar(16),
order_id int8,
result text,
source_id int4,
player_id int4
);

COMMENT on TABLE acb_transaction is '上分交易记录';
COMMENT on COLUMN acb_transaction.site_id is '主键';
COMMENT on COLUMN acb_transaction.transaction_no is '主键';
COMMENT on COLUMN acb_transaction.bank_code is '主键';
COMMENT on COLUMN acb_transaction.card_login_name is '主键';
COMMENT on COLUMN acb_transaction.card_number is '主键';
COMMENT on COLUMN acb_transaction.pay_username is '主键';
COMMENT on COLUMN acb_transaction.amount is '主键';
COMMENT on COLUMN acb_transaction.create_time is '主键';
COMMENT on COLUMN acb_transaction.status is '主键';
COMMENT on COLUMN acb_transaction.order_id is '主键';
COMMENT on COLUMN acb_transaction.result is '主键';
COMMENT on COLUMN acb_transaction.source_id is '主键';
COMMENT on COLUMN acb_transaction.player_id is '主键';
