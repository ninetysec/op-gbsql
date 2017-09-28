-- auto gen by cherry 2017-09-28 10:45:50
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '715', '充值记录', 'creditRecord/list.html', '充值记录', '7', '', '15', 'mcenter', 'system:credit_record', '1', 'icon-wenanguanli', 't', 'f', 't'
where not EXISTS (SELECT id from sys_resource where id=715);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '716', '额度充值', 'credit/pay/pay.html', '额度充值', '7', '', '16', 'mcenter', 'system:credit_pay', '1', 'icon-wenanguanli', 't', 'f', 't'
where not EXISTS (SELECT id from sys_resource where id=716);