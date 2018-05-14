-- auto gen by linsen 2018-03-25 17:45:21
-- 字典表添加买分管理-转账超额 by linsen
INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'credit', 'credit_use_status', '2', '3', '买分使用状态:转账超额', NULL, 't'
WHERE NOT EXISTS (SELECT ID FROM sys_dict WHERE module='credit' AND dict_type='credit_use_status' AND dict_code='2');
