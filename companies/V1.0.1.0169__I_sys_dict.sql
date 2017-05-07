-- auto gen by bruce 2016-09-05 10:45:48
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'notice', 'auto_event_type', 'ACCOUNT_NOT_EXIST', NULL, '玩家账号不存在', '', 't'
  WHERE 'ACCOUNT_NOT_EXIST' NOT IN (SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');