-- auto gen by george 2017-12-11 15:25:47
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT
'fund', 'recharge_type', 'jdpay_scan', '15', '线上支付：京东钱包支付', 'online_deposit', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='recharge_type' AND dict_code='jdpay_scan');
