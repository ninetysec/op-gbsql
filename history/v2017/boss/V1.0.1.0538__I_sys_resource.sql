-- auto gen by linsen 2018-03-29 20:21:15
-- 站点电销服务管理　by pack

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT  '308', '站点电销服务管理', 'siteTelemarketing/list.html', '站点电销服务管理', '3', '', '8', 'boss', 'site:telemarketing', '1', '', 'f', 'f', 't'
WHERE NOT EXISTS (SELECT id  FROM sys_resource where id=308 ) ;



INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT'30801', '新增', 'site:telemarketing/createMoreView.html', '站点电销服务管理-新增', '308', '', NULL, 'boss', 'site:telemarketing_add', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT id  FROM sys_resource where id=30801 ) ;

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT'30802', '删除', 'site:telemarketing/delete.html', '站点电销服务管理-删除', '308', '', NULL, 'boss', 'site:telemarketing_delete', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT id  FROM sys_resource where id=30802 ) ;

INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT'30803', '编辑', 'site:telemarketing/edit.html', '站点电销服务管理-编辑', '308', NULL, NULL, 'boss', 'site:telemarketing_edit', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT id  FROM sys_resource where id=30803 ) ;
