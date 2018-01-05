-- auto gen by george 2017-12-17 20:19:05
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'content', 'ctt_announcement_type', '3', '3', '注册公告', NULL, 't'
WHERE '3' not in (SELECT dict_code from sys_dict where module = 'content' and dict_type = 'ctt_announcement_type');
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active") SELECT 'content', 'ctt_announcement_type', '4', '4', '登录公告', NULL, 't'
WHERE '4' not in (SELECT dict_code from sys_dict where module = 'content' and dict_type = 'ctt_announcement_type');