-- auto gen by cherry 2017-08-03 16:37:59
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '30302', '兑币', 'fund/withdraw/exchange.html', '玩家取款审核-兑币', '303', '', NULL, 'mcenter', 'fund:playerwithdraw_exchange', '2', '', 't', 'f', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where id=30302);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '30303', '自动打款', 'fund/withdraw/automaticPay.html', '玩家取款审核-自动打款', '303', '', NULL, 'mcenter', 'fund:playerwithdraw_automaticPay', '2', '', 't', 'f', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where id=30303);
