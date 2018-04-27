-- auto gen by linsen 2018-04-25 19:19:53
-- by carl
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '90401', '注单ID重发', 'gameOrderTransaction/resendGameOrderId.html', '注单ID重发', '904', '', '2', 'boss', 'api:resendGameOrderId', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=90401);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '90402', '时间区间重发', 'gameOrderTransaction/timeInterval.html', '时间区间重发', '904', '', '2', 'boss', 'api:timeInterval', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=90402);