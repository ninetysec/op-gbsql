-- auto gen by cherry 2017-09-23 11:21:06
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '20103', '域名审核操作', '', '域名审核-可否操作', '201', '', NULL, 'boss', 'domainReview.operate', '2', '', 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE permission='domainReview.operate');


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '50803', '转账异常处理', '', '转账异常处理-可否操作', '508', '', NULL, 'boss', 'transferException.operate', '2', '', 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE permission='transferException.operate');