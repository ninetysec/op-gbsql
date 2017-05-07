-- auto gen by lenovo 2016-06-28 05:50:51
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '208', '短信接口', 'smsInterface/list.html', '短信接口', '2', '', '8', 'boss', 'serve:smsinterface', '1', '', 'f', 't', 't'
WHERE NOT EXISTS (select id from sys_resource WHERE id=208);
