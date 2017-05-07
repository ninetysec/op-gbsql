-- auto gen by orange 2016-01-08 18:35:23

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")  select  'fund', 'audit_type', 'manual_audit', '2', '手动稽核', NULL, TRUE
where 'manual_audit' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'audit_type');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")  select  'fund', 'audit_type', 'automatic_audit', '1', '自动稽核', NULL, TRUE
where 'automatic_audit' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'audit_type');