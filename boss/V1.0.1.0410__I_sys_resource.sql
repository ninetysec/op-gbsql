-- auto gen by cherry 2017-09-05 19:21:58
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '709', '报表', 'LotteryBetOrderReport/reportlist.html', '彩票管理-报表', '7', NULL, '4', 'boss', 'lottery:report', '1', 'icon-xiane', 't', 'f', 't' WHERE NOT EXISTS(SELECT id  FROM  sys_resource where  id=709);

