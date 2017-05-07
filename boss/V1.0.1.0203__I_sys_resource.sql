-- auto gen by kobe 2016-10-23 10:37:38

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '515', '支付账号', 'payAccountCollection/payAccountList.html', '支付日志', '5', '', '15', 'boss', 'maintenance:order', '1', '', 'f', 't', 't' WHERE NOT EXISTS(SELECT id from sys_resource where id='515');

