-- auto gen by Administrator 2017-05-04 09:49:17
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  select '307', '站长管理', 'vSiteMasterManage/list.html', '站长管理', '3', '', '7', 'boss', 'site:mastermanage', '1', '', 'f', 'f', 't'
  where not EXISTS(SELECT id FROM sys_resource WHERE id='307');
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  select '30701', '新增站长', 'vSiteMasterManage/create.html', '站长管理-新增站长', '307', '', NULL, 'boss', 'site:mastermanage_addmaster', '2', '', 'f', 'f', 't'
  where not EXISTS(SELECT id FROM sys_resource WHERE id='30701');
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  select '30702', '新增站点', 'vSysSiteManage/siteBasic.html', '站长管理-新增站点', '307', '', NULL, 'boss', 'site:mastermanage_addsite', '2', '', 'f', 'f', 't'
  where not EXISTS(SELECT id FROM sys_resource WHERE id='30702');
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  select '30612', '查看站点备注', '', '查看站点备注', '306', '', '9', 'boss', 'platform:site_db_detail', '2', '', 'f', 't', 't'
  where not EXISTS(SELECT id FROM sys_resource WHERE id='30612');
