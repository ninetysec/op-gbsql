-- auto gen by cherry 2017-03-07 14:56:48
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '30604', '站点管理-站长账号详情', '', '', '306', '', '4', 'boss', 'platform:site_account_detail', '2', '', 'f', 't', 't'
where NOT EXISTS (select id from sys_resource where id=30604);
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '30605', '站点管理-站点详情-访问限制-新增编辑', '', '', '306', '', '5', 'boss', 'platform:site_confine_edit', '2', '', 'f', 't', 't'
where NOT EXISTS (select id from sys_resource where id=30605);