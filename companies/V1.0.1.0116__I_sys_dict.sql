-- auto gen by admin 2016-06-27 14:40:47
DELETE FROM sys_dict  WHERE "module"='fund' and dict_type='recharge_type' and parent_code='company_deposit';

INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") VALUES ('fund', 'recharge_type', 'online_bank', '1', '公司入款:网银存款', 'company_deposit', 't');
INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") VALUES ('fund', 'recharge_type', 'alipay_fast', '2', '公司入款:支付宝电子支付', 'company_deposit', 't');
INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") VALUES ('fund', 'recharge_type', 'wechatpay_fast', '3', '公司入款:微信电子支付', 'company_deposit', 't');
INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") VALUES ( 'fund', 'recharge_type', 'atm_money', '4', '公司入款：柜员机现金存款', 'company_deposit', 't');
INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") VALUES ( 'fund', 'recharge_type', 'atm_recharge', '5', '公司入款：柜员机转账', 'company_deposit', 't');
INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") VALUES ( 'fund', 'recharge_type', 'atm_counter', '6', '公司入款：银行柜台存款', 'company_deposit', 't');


INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'online_deposit', '7', '线上支付：线上支付', 'online_deposit', 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict WHERE module='fund' and dict_type='recharge_type' AND dict_code='online_deposit' AND parent_code='online_deposit');

INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'wechatpay_scan', '8', '线上支付：微信扫码支付', 'online_deposit', 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict WHERE module='fund' and dict_type='recharge_type' AND dict_code='wechatpay_scan' AND parent_code='online_deposit');

INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'alipay_scan', ' 9', '线上支付：支付宝扫码支付', 'online_deposit', 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict WHERE module='fund' and dict_type='recharge_type' AND dict_code='alipay_scan' AND parent_code='online_deposit');

DELETE FROM sys_dict WHERE "module"='common' AND dict_type='fund_type' AND dict_code='company_deposit';

INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'online_bank', '2', '资金类型:网银存款', null, 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='fund_type' AND dict_code='online_bank');

INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'atm_counter', '7', '资金类型:柜员机/柜台存款', null, 't'
WHERE not EXISTS(SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='fund_type' AND dict_code='atm_counter');

UPDATE sys_dict SET order_num='1'  WHERE module='common' and dict_type='fund_type' AND dict_code='online_deposit';

UPDATE sys_dict SET order_num='3'  WHERE module='common' and dict_type='fund_type' AND dict_code='wechatpay_scan';

UPDATE sys_dict SET order_num='4'  WHERE module='common' and dict_type='fund_type' AND dict_code='alipay_scan';

UPDATE sys_dict SET order_num='5'  WHERE module='common' and dict_type='fund_type' AND dict_code='wechatpay_fast';

UPDATE sys_dict SET order_num='6'  WHERE module='common' and dict_type='fund_type' AND dict_code='alipay_fast';

UPDATE sys_dict SET order_num='8'  WHERE module='common' and dict_type='fund_type' AND dict_code='artificial_deposit';

UPDATE sys_dict SET order_num='9'  WHERE module='common' and dict_type='fund_type' AND dict_code='artificial_withdraw';

UPDATE sys_dict SET order_num='10'  WHERE module='common' and dict_type='fund_type' AND dict_code='player_withdraw';

UPDATE sys_dict SET order_num='11'  WHERE module='common' and dict_type='fund_type' AND dict_code='transfer_into';

UPDATE sys_dict SET order_num='12'  WHERE module='common' and dict_type='fund_type' AND dict_code='transfer_out';

UPDATE sys_dict SET order_num='13'  WHERE module='common' and dict_type='fund_type' AND dict_code='backwater';

UPDATE sys_dict SET order_num='14'  WHERE module='common' and dict_type='fund_type' AND dict_code='favourable';

UPDATE sys_dict SET order_num='15'  WHERE module='common' and dict_type='fund_type' AND dict_code='recommend';

UPDATE sys_dict SET order_num='16'  WHERE module='common' and dict_type='fund_type' AND dict_code='refund_fee';

DELETE FROM sys_dict  WHERE  "module"='common' AND "dict_type"='transaction_way' and "dict_code"='online'  ;

DELETE FROM sys_dict  WHERE  "module"='common' AND "dict_type"='transaction_way' and "dict_code"='mobile_bank'  ;

UPDATE "sys_dict" SET remark='银行柜台存款' WHERE  "module"='common' AND "dict_type"='transaction_way' and "dict_code"='atm_counter' ;

UPDATE "sys_dict" SET remark='柜员机现金存款' WHERE  "module"='common' AND "dict_type"='transaction_way' and "dict_code"='atm_money' ;

UPDATE "sys_dict" SET "dict_code"='atm_recharge' ,remark='柜员机转账' WHERE  "module"='common' AND "dict_type"='transaction_way' and "dict_code"='counter' ;

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")

  select  'content', 'ctt_announcement_type', '1', '1', '站点公告', NULL, 't'

  where '1' not in (select dict_code from sys_dict where dict_type = 'ctt_announcement_type' and dict_code = '1');


INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")

  select  'content', 'ctt_announcement_type', '2', '2', '银行公告', NULL, 't'

  where '2' not in (select dict_code from sys_dict where dict_type = 'ctt_announcement_type' and dict_code = '2');