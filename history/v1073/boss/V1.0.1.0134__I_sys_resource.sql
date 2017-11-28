-- auto gen by cherry 2016-09-21 20:35:37
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '50801', '转账通过', 'operate/transferBySite/success.html', '转账通过', '508', NULL, '1', 'boss', 'maintenance:transfer_success', '2', NULL, 'f', 't', 't'
where not EXISTS(SELECT id FROM sys_resource WHERE id=50801);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '50802', '转账失败', 'operate/transferBySite/failure.html', '转账失败', '508', NULL, '2', 'boss', 'maintenance:transfer_failure', '2', NULL, 'f', 't', 't'
where not EXISTS(SELECT id FROM sys_resource WHERE id=50802);