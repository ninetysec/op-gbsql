-- auto gen by cherry 2017-08-30 09:43:29
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

	SELECT '20405', '添加子代理', 'userAgent/editAgent.html', '添加子代理', '204', '', '5', 'mcenter', 'role:agent_addsubagent', '2', '', 't', 'f', 't' where 20405 not in(SELECT id from sys_resource where id=20405);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '37', '代理管理', 'vUserAgentManage/list.html', '代理管理', NULL, '', '2', 'mcenterAgent', 'agent:agent', '1', 'icon-dailiguanli', 't', 'f', 't' where 37 not in(SELECT id from sys_resource where id=37);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '38', '返佣设置', 'rebateSet/list.html', '返佣设置', NULL, '', '2', 'mcenterAgent', 'agent:rebate', '1', 'icon-fanyongshezhi', 't', 'f', 't' where 38 not in(SELECT id from sys_resource where id=38);





INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3701', '查看代理详情的联系方式', 'userAgent/veiwDetail.html', '查看代理详情的联系方式', '37', '', '1', 'mcenterAgent', 'agent:veiwdetail', '2', '', 't', 't', 't' WHERE 3701 not in (SELECT id FROM sys_resource WHERE id = 3701);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3702', '审核', 'userAgent/toCheck.html', '代理管理-审核代理', '37', '', 2, 'mcenterAgent', 'agent:agent_check', '2', '', 't', 'f', 't' WHERE 3702 not in(SELECT id from sys_resource where id=3702);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3703', '新增', 'userAgent/editAgent.html', '代理管理-新增代理', '37', '', 3, 'mcenterAgent', 'agent:agent_add', '2', '', 't', 'f', 't' WHERE 3703 not in(SELECT id from sys_resource where id=3703);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3704', '编辑', 'userAgent/edit.html', '代理管理-编辑代理', '37', '', 4, 'mcenterAgent', 'agent:agent_edit', '2', '', 't', 'f', 't' WHERE 3704 not in(SELECT id from sys_resource where id=3704);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3705', '账号冻结', 'share/account/freezeAccount.html', '代理管理-账号冻结', '37', NULL, 5, 'mcenterAgent', 'agent:freezeaccout', '2', NULL, 't', 't', 't' WHERE 3705 not in(SELECT id from sys_resource where id=3705);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3706', '账号停用', 'share/account/disabledAccount.html', '代理管理-账号停用', '37', NULL, 6, 'mcenterAgent', 'agent:disabledaccount', '2', NULL, 't', 't', 't' WHERE 3706 not in(SELECT id from sys_resource where id=3706);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3707', '取消冻结账号', 'share/account/cancelAccountFreeze.html', '代理管理-取消冻结账号', '37', NULL, 7, 'mcenterAgent', 'agent:cancelfreezeaccount', '2', NULL, 't', 't', 't' WHERE 3707 not in(SELECT id from sys_resource where id=3707);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3708', '重置登录密码', 'player/resetPwd/goRestUserPwd.html', '代理管理-重置登录密码', '37', NULL, 8, 'mcenterAgent', 'agent:resetloginpwd', '2', NULL, 't', 't', 't' WHERE 3708 not in(SELECT id from sys_resource where id=3708);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3709', '重置安全密码', 'player/resetPwd/goRestUserPwd.html', '代理管理-重置安全密码', '37', NULL, 9, 'mcenterAgent', 'agent:resetpowerpwd', '2', NULL, 't', 't', 't' WHERE 3709 not in(SELECT id from sys_resource where id=3709);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3710', '查看列表', 'player/resetPwd/goRestUserPwd.html', '代理管理-查看列表', '37', NULL, 10, 'mcenterAgent', 'agent:agentlist', '2', NULL, 't', 't', 't' WHERE 3710 not in(SELECT id from sys_resource where id=3710);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3801', '查看列表', 'rebateSet/list.html', '返佣设置-查看列表', '38', '', 1, 'mcenterAgent', 'rebate:rebate_list', '2', '', 't', 'f', 't' WHERE 3801 not in(SELECT id from sys_resource where id=3801);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3802', '新增', 'rebateSet/create.html', '返佣设置-新增', '38', '', 2, 'mcenterAgent', 'rebate:rebate_add', '2', '', 't', 'f', 't' WHERE 3802 not in(SELECT id from sys_resource where id=3802);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3803', '编辑', 'rebateSet/edit.html', '返佣设置-编辑', '38', '', 3, 'mcenterAgent', 'rebate:rebate_edit', '2', '', 't', 'f', 't' WHERE 3803 not in(SELECT id from sys_resource where id=3803);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")

SELECT '3804', '删除', 'rebateSet/deleterebate.html', '返佣设置-删除', '38', '', 4, 'mcenterAgent', 'rebate:rebate_delete', '2', '', 't', 'f', 't' WHERE 3804 not in(SELECT id from sys_resource where id=3804);


update sys_resource set sort_num=1 where id=31;

update sys_resource set sort_num=2 where id=38;

update sys_resource set sort_num=3 where id=37;

update sys_resource set sort_num=4 where id=32;

update sys_resource set sort_num=5 where id=33;

update sys_resource set sort_num=6 where id=34;

update sys_resource set sort_num=7 where id=35;

update sys_resource set sort_num=8 where id=36;

