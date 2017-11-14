-- auto gen by tony 2017-11-12 11:00:51
UPDATE "sys_resource" SET
  "name"='DevTool', "url"='devTool.html', "remark"='DevTool', "permission"='maintenance:devtool'
  WHERE ("id"='507');
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num",
      "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  select '519', '组件监控', 'Monitor/list.html', '组件监控', '5', '', '7', 'boss', 'maintenance:monitor', '1', '', 'f', 't', 't'
  from sys_resource where 'maintenance:monitor' not in (select permission from sys_resource);
