-- auto gen by longer 2015-09-07 14:26:01

--审计日志菜单
insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege)
  SELECT 704,'审计日志','sysAuditLog/fromMongo.html','',7,'',4,'boss','sysAuditLog:view','1','',FALSE,FALSE
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 704);

insert into sys_role_resource(role_id, resource_id) select 1,704 where not exists(
  select id from sys_role_resource where role_id = 1 and resource_id = 704
);