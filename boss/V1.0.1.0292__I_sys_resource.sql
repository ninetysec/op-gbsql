-- auto gen by cherry 2017-02-08 16:43:59
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '30304', '详细', 'vContractScheme/view.html', '包网方案-详细', '303', '', NULL,
'boss', 'platform:contractscheme_view', '2', '', 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource WHERE id=30304);
