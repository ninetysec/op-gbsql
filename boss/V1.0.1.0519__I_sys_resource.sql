-- auto gen by linsen 2018-02-28 21:11:28
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT
'1008', '请求地址验证', 'payLinkStatus/list.html', '请求地址验证', '10', '', '8', 'boss', 'maintenance:requestVerification', '1', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE url='payLinkStatus/list.html');
