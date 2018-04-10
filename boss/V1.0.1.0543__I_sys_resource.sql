-- auto gen by linsen 2018-04-09 10:07:28
-- 总控api资金管理菜单功能权限  by pack

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '914', 'API资金管理', 'VPlayerApi/list.html', 'API资金管理', '9', '', '4', 'boss', 'api:vplayerApi', '1', '', 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where id='914');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '91401', 'API回收资金', 'VPlayerApi/withdrawBalance.html', 'API回收资金', '914', '', '1', 'boss', 'api:vplayerapi_recovery', '2', '', 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where id='91401');