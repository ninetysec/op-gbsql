-- auto gen by linsen 2018-02-27 17:38:41

--添加站点返水功能
INSERT INTO "sys_resource" ("id","name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select  '414','站点返水', 'report/siteBackWater/init.html', '统计报表-站点返水', '4', '', '6', 'boss', 'report:rakeback', '1', '', 'f', 't', 't'
where 'report/siteBackWater/init.html' not in (select url from sys_resource where url = 'report/siteBackWater/init.html');

--添加站点返水权限设置
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '41401', '补差', 'report/siteBackWater/reSettleRakeback.html', '补差', '414', NULL, '1', 'boss', 'report:reSettleRakeback', '2', NULL, 'f', 't', 't'
where '41401' not in (select id from sys_resource where id = '41401');

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '41402', '还原', 'report/siteBackWater/recoveryBackWater.html', '站点返水状态还原', '414', NULL, '2', 'boss', 'report:recoveryBackWater', '2', NULL, 'f', 't', 't'
where '41402' not in (select id from sys_resource where id = '41402');

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '41403', '批量还原', 'report/siteBackWater/batchRecoveryBackWater.html', '站点返水状态批量还原', '414', NULL, '3', 'boss', 'report:batchRecoveryBackWater', '2', NULL, 'f', 't', 't'
where '41403' not in (select id from sys_resource where id = '41403');


--添加站点API转账限额功能
INSERT INTO "sys_resource" ("id","name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select  '216','API转账限额', 'api/apiTransferLimitIndex.html', '服务-API转账限额', '2', '', '16', 'boss', 'serve:apiTransferLimitIndex', '1', '', 'f', 't', 't'
where 'api/apiTransferLimitIndex.html' not in (select url from sys_resource where url = 'api/apiTransferLimitIndex.html');
