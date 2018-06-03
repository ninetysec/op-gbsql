-- auto gen by steffan 2018-05-12 15:54:31

--增加权限:修改即时稽核　add by steffan
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select 2020806, '修改即时稽核', '', '玩家管理-玩家详细资料--修改即时稽核', '20208', '', NULL, 'mcenter', 'fund:playerwithdraw_editAudit', '2', '', 't', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=2020806);