-- auto gen by cherry 2017-03-18 16:56:19
INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30608', '查看站点信息', '/site/detail/viewSiteBasic.html', '查看站点信息', '306', '', '8', 'boss', 'platform:site_detail', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30608);


INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30609', '查看站点备注', '', '查看站点备注', '306', '', '9', 'boss', 'platform:site_remark', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30609);



INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30610', '查看站点域名', '', '查看站点域名', '306', '', '10', 'boss', 'platform:site_domain', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30610);


INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30611', '编辑站点信息', '', '编辑站点信息', '306', '', '11', 'boss', 'platform:site_eidt', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30611);

INSERT INTO "sys_resource"
("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '30608', '查看站点信息', '/site/detail/viewSiteBasic.html', '查看站点信息', '306', '', '8', 'boss', 'platform:site_detail', '2', NULL, 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30608);


INSERT INTO "sys_resource"
("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30609', '查看站点备注', '', '查看站点备注', '306', '', '9', 'boss', 'platform:site_remark', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30609);

INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30610', '查看站点域名', '', '查看站点域名', '306', '', '10', 'boss', 'platform:site_domain', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30610);


INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30611', '编辑站点信息', '', '编辑站点信息', '306', '', '11', 'boss', 'platform:site_eidt', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30611);