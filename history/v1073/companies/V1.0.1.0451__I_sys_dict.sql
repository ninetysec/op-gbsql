-- auto gen by cherry 2017-10-25 10:33:46
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'digiccy_scan', '14', '线上支付：数字货币支付', 'online_deposit', 't'
where not EXISTS (SELECT id FROM sys_dict where module='fund' and dict_type='recharge_type' and dict_code='digiccy_scan');
