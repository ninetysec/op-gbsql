-- auto gen by steffan 2018-09-24 10:44:16
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '1010', '支付渠道使用排名', 'payLogAnalyze/sort.html', '支付渠道使用排名', '10', '', '22', 'boss', 'payApi:pay_log_sort', '1', '', 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where id='1010');
