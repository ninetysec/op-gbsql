-- auto gen by linsen 2018-08-20 14:09:52
-- 代付出款账户 by linsen
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '409', '代付账户', 'withdrawAccount/list.html', '代付账户', '4', null, '10', 'mcenter', 'content:withdraw_account', '1', 'icon-xianshangzhifuzhanghu', 't', 'f', 'f'
WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE ID='409');


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '40901', '代付账户-删除', 'withdrawAccount/delete.html', '代付账户-删除', '409', NULL, NULL, 'mcenter', 'content:withdraw_account_delete', '2', NULL, 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE id=40901);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '40902', '代付账户-编辑', 'withdrawAccount/edit.html', '代付账户-编辑', '409', NULL, NULL, 'mcenter', 'content:withdraw_account_edit', '2', NULL, 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE id=40902);
