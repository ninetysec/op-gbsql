-- auto gen by tony 2017-11-21 16:02:55
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num",
      "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  select '520', '服务版本切换', 'Monitor/Version.html', '服务版本切换', '5', '', '7', 'boss', 'maintenance:monitor:vresion', '1', '', 'f', 't', 't'
   where 'maintenance:monitor:vresion' not in (select permission from sys_resource);