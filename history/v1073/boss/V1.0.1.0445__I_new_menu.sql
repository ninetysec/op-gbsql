-- auto gen by water 2017-11-19 17:52:30

INSERT INTO "sys_resource"("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  SELECT
    '212', '站点API设置', 'siteApi/list.html', '站点API设置', '2', NULL, '12', 'boss', 'api:api', '1', NULL, 'f', 't', 't'
  WHERE NOT EXISTS (select id from sys_resource where id = '212');

INSERT INTO "sys_resource"("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  SELECT
    '21202', '站点API设置修改', 'siteApi/edit.html', '站点API设置修改', '212', NULL, '2', 'boss', 'api:api_update', '2', NULL, 'f', 't', 't'
  WHERE NOT EXISTS (select id from sys_resource where id = '21202');