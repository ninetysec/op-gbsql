-- auto gen by cherry 2016-02-25 15:49:20
DELETE FROM sys_param WHERE module='setting' AND param_code='visit.management.center.prompt' AND param_type='visit';

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
  SELECT 20401,'API管理保存','api/saveManage.html','',204,'',1,'boss','game:api:manage','2','',true,true,true
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 20401);

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
  SELECT 207,'新手引导','vHelpDocument/list.html','',2,'',1,'boss','serv:newbie-guide','1','',true,true,true
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 207);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '60001', '系统设置-安全密码', 'index/content.html?parentId=6', '货币管理-设置汇率', '6', NULL, '1', 'boss', 'test:view', '2', NULL, 't', 't', 't'
WHERE '60001' not in(SELECT id FROM sys_resource WHERE id='60001');