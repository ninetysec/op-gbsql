-- auto gen by kobe 2016-10-15 13:57:13

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '514', '支付日志', 'payLog/payLogList.html', '支付日志', '5', NULL, '14', 'boss', 'maintenance:order', '1', NULL, 'f', 't', 't'  WHERE NOT EXISTS(SELECT id from sys_resource where id='514');

