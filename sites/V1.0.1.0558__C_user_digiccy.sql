-- auto gen by cherry 2017-10-16 17:05:37
CREATE TABLE if not EXISTS user_digiccy(
id serial4 not null PRIMARY key,
user_id int4 not null,
user_name varchar(32),
currency varchar(16),
amount numeric(20,8),
syn_time timestamp(6),
syn_state varchar(2),
address varchar(128),
address_qrcode_url varchar(256),
freeze_amount numeric(20,8)
);

COMMENT ON TABLE user_digiccy is '用户货币信息表';
COMMENT on COLUMN user_digiccy.id is '主键';
COMMENT on COLUMN user_digiccy.user_id is '用户id';
COMMENT on COLUMN user_digiccy.user_name is '用户账号';
COMMENT on COLUMN user_digiccy.currency is '数字货币标志 字典 common digiccy';
COMMENT on COLUMN user_digiccy.amount is '数字货币余额';
COMMENT on COLUMN user_digiccy.syn_time is '同步时间';
COMMENT on COLUMN user_digiccy.syn_state is '同步状态：0-成功 1-失败';
COMMENT on COLUMN user_digiccy.address is '数字货币地址';
COMMENT on COLUMN user_digiccy.address_qrcode_url is '地址二维码图片展示url';
COMMENT on COLUMN user_digiccy.freeze_amount is '冻结的数字货币余额';

 select redo_sqls($$
	ALTER TABLE user_digiccy ADD CONSTRAINT us_user_digiccy UNIQUE(user_id,currency);
$$);

CREATE TABLE if not EXISTS digiccy_history(
id serial4 not null PRIMARY key,
order_no varchar(32),
type varchar(2),
transaction_type varchar(2),
amount numeric(20,8),
date TIMESTAMP(6),
confirmations int4,
address varchar(128),
remote_address VARCHAR(128),
description text,
update_time timestamp(6),
order_id varchar(32),
txid VARCHAR(128),
syn_amount_flag BOOLEAN
);

COMMENT on TABLE digiccy_history is '数字货币历史记录';
COMMENT on COLUMN digiccy_history.id is '主键';
COMMENT on COLUMN digiccy_history.order_no is '第三方交易号';
COMMENT on COLUMN digiccy_history.type is '类型：0-信用 1-借贷';
COMMENT on COLUMN digiccy_history.transaction_type is '交易类型：5-trade 6-trade费用 7-transfer 8-transfer费用 9-achievement';
COMMENT on COLUMN digiccy_history.amount is '交易金额';
COMMENT on COLUMN digiccy_history.date is '交易日期';
COMMENT on COLUMN digiccy_history.confirmations is '用于链接加密事务';
COMMENT on COLUMN digiccy_history.address is '地址';
COMMENT on COLUMN digiccy_history.remote_address is '目标地址';
COMMENT on COLUMN digiccy_history.description is '详细';
COMMENT on COLUMN digiccy_history.update_time is '入库更新时间';
COMMENT on COLUMN digiccy_history.order_id is '相关交易号';
COMMENT on COLUMN digiccy_history.txid is 'txid';
COMMENT on COLUMN digiccy_history.syn_amount_flag is '是否同步金额';

  select redo_sqls($$
       ALTER TABLE digiccy_history ADD CONSTRAINT digiccy_history_order_no_uc UNIQUE(order_no);
$$);


CREATE TABLE if not EXISTS digiccy_history_log(
id serial4 not null PRIMARY key,
code varchar(16),
currency varchar(16),
from_date TIMESTAMP(6)
);
COMMENT on TABLE digiccy_history_log is '数字货币历史记录拉取点';
COMMENT ON COLUMN digiccy_history_log.id is '主键';
COMMENT ON COLUMN digiccy_history_log.code is '数字货币提供渠道code';
COMMENT ON COLUMN digiccy_history_log.currency is '数字货币标识';
COMMENT ON COLUMN digiccy_history_log.from_date is '开始时间';

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'fund', 'fund', 'digiccy_provider_account_info', '', '', NULL, '', NULL, 't', NULL
WHERE not EXISTS (SELECT id FROM sys_param WHERE module='fund' AND param_type='fund' and param_code='digiccy_provider_account_info');

INSERT INTO "digiccy_history_log" ("code", "currency", "from_date")
SELECT  'draglet', 'BTC', now()
WHERE not EXISTS(SELECT id FROM digiccy_history_log where code='draglet' AND currency='BTC');