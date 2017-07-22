-- auto gen by cherry 2017-07-12 14:10:47
INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '211', '站点API管理', 'vSiteApiType/list.html', '站点API管理', '2', '', '11', 'boss', 'api:apiType', '1', '', 'f', 't', 't'
WHERE 211 NOT IN(SELECT id FROM sys_resource WHERE id=211);


