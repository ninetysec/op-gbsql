-- auto gen by linsen 2018-07-15 20:03:38
-- 出款添加字典“其他” by kobe
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'withdraw_check_status', 'other', '4', '其他', NULL, 't'
WHERE 'other' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'withdraw_check_status');