-- auto gen by george 2018-01-11 10:54:56
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'state', 'CN', '810000', '1', '香港', NULL, 't'
WHERE '810000' not in (SELECT dict_code from sys_dict where module = 'state' and dict_type = 'CN');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'state', 'CN', '820000', '1', '澳门', NULL, 't'
WHERE '820000' not in (SELECT dict_code from sys_dict where module = 'state' and dict_type = 'CN');

INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'state', 'CN', '710000', '1', '台湾', NULL, 't'
WHERE '710000' not in (SELECT dict_code from sys_dict where module = 'state' and dict_type = 'CN');