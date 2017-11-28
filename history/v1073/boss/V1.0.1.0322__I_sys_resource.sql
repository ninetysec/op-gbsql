-- auto gen by cherry 2017-04-21 20:38:08
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '702', ' 开奖结果', 'lotteryResult/list.html', ' 开奖结果', '7', '', '2', 'boss', 'lottery:lottery_result', '1', '', 'f', 't', 'f'
WHERE not EXISTS (SELECT id FROM sys_resource where id=702);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '701', '彩种管理', 'lottery/manage/list.html', '彩种管理', '7', NULL, '1', 'boss', 'lottery:lottery_typ', '1', NULL, 'f', 't', 't'
WHERE not EXISTS (SELECT id FROM sys_resource where id=701);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '7', '彩票', NULL, '彩票管理', NULL, '', '6', 'boss', 'boss:lottery', '1', '', 't', 't', 't'
WHERE not EXISTS (SELECT id FROM sys_resource where id=7);
