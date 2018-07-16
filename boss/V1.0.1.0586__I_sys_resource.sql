-- auto gen by linsen 2018-07-16 19:55:24
--站点Game批量启用/停用权限 by martin
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
  select '21103', '站点Game批量启用/停用', '', '站点Game批量启用/停用', '211', NULL, NULL, 'boss', 'siteApi:siteGameManage', '1', NULL, 'f', 't', 't'
  where not exists(select id from sys_resource where id=21103);