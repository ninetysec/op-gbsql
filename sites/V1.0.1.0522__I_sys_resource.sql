-- auto gen by cherry 2017-09-11 14:37:11
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '716', '额度充值', 'credit/pay/pay.html', '充值记录', '7', '', '16', 'mcenter', 'system:credit_pay', '1', 'icon-wenanguanli', 't', 'f', 't'
where not EXISTS (SELECT id from sys_resource where id=716);
