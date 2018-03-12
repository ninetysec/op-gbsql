-- auto gen by linsen 2018-02-27 11:29:05
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
 select '30305', '易收付出款账户编辑', 'fund/withdraw/withdrawAccount.html', '易收付出款-账户编辑', '303', '', NULL, 'mcenter', 'fund:withdraw_account', '2', '', 't', 'f', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where id='30305');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
 select '30306', '易收付出款', 'fund/withdraw/payment.html', '易收付出款-出款', '303', '', NULL, 'mcenter', 'fund:withdraw_payment', '2', '', 't', 'f', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where id='30306');