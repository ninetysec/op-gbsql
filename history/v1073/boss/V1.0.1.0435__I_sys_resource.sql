-- auto gen by george 2017-11-01 17:41:04
INSERT INTO "sys_resource"("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT
'213', '站点账单模板', 'siteBillTemplate/list.html', '站点账单模板', '2', NULL, '13', 'boss', 'serve:siteBillTemplate', '1', NULL, 'f', 't', 't'
  WHERE NOT EXISTS (select id from sys_resource where id = '213');

INSERT INTO "sys_resource"("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT
 '21301', '站点账单模板新增', 'siteBillTemplate/create.html', '站点账单模板新增', '213', NULL, '1', 'boss', 'serve:siteBillTemplateAdd', '2', NULL, 'f', 't', 't'
  WHERE NOT EXISTS (select id from sys_resource where id = '21301');

INSERT INTO "sys_resource"("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT
 '21302', '站点账单模板批量新增', 'siteBillTemplate/createMoreView.html', '站点账单模板批量新增', '213', NULL, '2', 'boss', 'serve:siteBillTemplateAddMore', '2', NULL, 'f', 't', 't'
  WHERE NOT EXISTS (select id from sys_resource where id = '21302');

INSERT INTO "sys_resource"("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT
 '21303', '站点账单模板修改', 'siteBillTemplate/edit.html', '站点账单模板修改', '213', NULL, '3', 'boss', 'serve:siteBillTemplateEdit', '3', NULL, 'f', 't', 't'
  WHERE NOT EXISTS (select id from sys_resource where id = '21303');

INSERT INTO "sys_resource"("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT
 '21304', '站点账单模板删除', 'siteBillTemplate/delete.html', '站点账单模板删除', '213', NULL, '4', 'boss', 'serve:siteBillTemplateDelete', '4', NULL, 'f', 't', 't'
  WHERE NOT EXISTS (select id from sys_resource where id = '21304');