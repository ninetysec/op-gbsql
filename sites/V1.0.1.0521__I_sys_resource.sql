-- auto gen by cherry 2017-09-06 21:07:48
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '715', '充值记录', 'creditRecord/list.html', '充值记录', '7', '', '15', 'mcenter', 'system:credit_record', '1', 'icon-wenanguanli', 't', 'f', 't'
where not EXISTS (SELECT id from sys_resource where id=715);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '1006', '报表', 'LotteryBetOrderReport/reportlist.html', '彩票管理-报表', '10', NULL, '4', 'mcenter', 'lottery:report', '1', 'icon-xiane', 't', 'f', 't' WHERE NOT EXISTS(SELECT id  FROM  sys_resource where  id=1006);


