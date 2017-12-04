-- auto gen by cherry 2017-09-05 11:43:02
INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'log', 'log_type', '28', '28', '银行卡修改', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='log_type' AND dict_code='28');