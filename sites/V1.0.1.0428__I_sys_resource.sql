-- auto gen by cherry 2017-04-21 20:38:58
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1001', '即时注单', 'lotteryBetOrder/list.html', '彩票管理-即时注单', '10', NULL, '1', 'mcenter', 'lottery:record', '1', 'icon-gongsirukuanshenhe', 't', 'f', 't'
WHERE not EXISTS (SELECT id FROM sys_resource where id=1001);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1002', '开奖结果', 'lotteryResult/list.html', '彩票管理-开奖结果', '10', NULL, '2', 'mcenter', 'lottery:opencode', '1', 'icon-xianshangzhifujilu', 't', 'f', 't'
WHERE not EXISTS (SELECT id FROM sys_resource where id=1002);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1003', '赔率设置', 'lottery/odds/index.html', '彩票管理-赔率设置', '10', '', '3', 'mcenter', 'lottery:odd', '1', 'icon-dailiqukuanshenhe', 't', 'f', 't'
WHERE not EXISTS (SELECT id FROM sys_resource where id=1003);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1004', '限额设置', 'lottery/quotas/index.html', '彩票管理-限额设置', '10', NULL, '4', 'mcenter', 'lottery:quota', '1', 'icon-shoudongcunti', 't', 'f', 't'
WHERE not EXISTS (SELECT id FROM sys_resource where id=1004);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '10', '彩票', '', '', NULL, '', '9', 'mcenter', 'mcenter:lottery', '1', '', 't', 't', 't'
WHERE not EXISTS (SELECT id FROM sys_resource where id=10);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '1005', ' 资金记录', 'lotteryTransaction/list.html', ' 资金记录', '10', NULL, '5', 'mcenter', 'lottery:fundrecord', '1', 'icon-gongsirukuanshenhe', 't', 'f', 't'
WHERE not EXISTS (SELECT id FROM sys_resource where id=1005);
