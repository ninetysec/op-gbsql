-- auto gen by marz 2017-12-17 08:56:45
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT
'log', 'log_type', '39', '39', '赔率修改', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE module='log' AND dict_type='log_type' AND dict_code='39');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT
'log', 'log_type', '34', '34', '撤单', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE module='log' AND dict_type='log_type' AND dict_code='34');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT
'log', 'log_type', '40', '40', '限额修改', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE module='log' AND dict_type='log_type' AND dict_code='40');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT
'lottery', 'transaction_type', '6', '6', '重结扣款', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE module='lottery' AND dict_type='transaction_type' AND dict_code='6');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT
'lottery', 'order_status', '4', '4', '已撤销', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE module='lottery' AND dict_type='order_status' AND dict_code='4');
