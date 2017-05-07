-- auto gen by cherry 2016-01-08 17:53:47
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT  'operation', 'activity_apply_check_status', '0', '4', '玩家申请优惠状态：待确认(不展示)', NULL, 't'
WHERE '0' NOT in (SELECT dict_code FROM sys_dict WHERE module='operation' AND dict_type='activity_apply_check_status');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT  'operation', 'activity_apply_check_status', '1', '1', '玩家申请优惠状态：待处理', NULL, 't'
WHERE '1' NOT in (SELECT dict_code FROM sys_dict WHERE module='operation' AND dict_type='activity_apply_check_status');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT  'operation', 'activity_apply_check_status', '2', '2', '玩家申请优惠状态：成功', NULL, 't'
WHERE '2' NOT in (SELECT dict_code FROM sys_dict WHERE module='operation' AND dict_type='activity_apply_check_status');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT  'operation', 'activity_apply_check_status', '3', '3', '玩家申请优惠状态：失败', NULL, 't'
WHERE '3' NOT in (SELECT dict_code FROM sys_dict WHERE module='operation' AND dict_type='activity_apply_check_status');


DELETE FROM sys_dict where "module"='operation' AND dict_type = 'check_status';



