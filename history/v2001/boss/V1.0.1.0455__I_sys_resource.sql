-- auto gen by george 2017-11-23 21:40:17

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060801', '站点信息', '/site/detail/viewSiteBasic.html', '站点信息', '30608', '', '1', 'boss', 'platform:view_siteInfo', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060801');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060802', '支付渠道', '/site/detail/viewPayChannel.html', '支付渠道', '30608', '', '2', 'boss', 'platform:view_payChannel', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060802');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060803', '备用网址', '/site/detail/viewDomain.html', '备用网址', '30608', '', '3', 'boss', 'platform:view_reserveWeb', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060803');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060804', '优惠活动', '/site/detail/viewActivity.html', '优惠活动', '30608', '', '4', 'boss', 'platform:view_favorableActivity', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060804');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060805', '访问限制', '/site/detail/viewWhiteList.html', '访问限制', '30608', '', '5', 'boss', 'platform:view_loginRestrict', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060805');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060806', '日志', '/site/detail/viewSiteLogs.html', '日志', '30608', '', '6', 'boss', 'platform:view_log', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060806');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060807', '子账号', '/siteSubAccount/accountList.html', '子账号', '30608', '', '7', 'boss', 'platform:view_subAccount', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060807');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060808', '额度上限', '/site/detail/viewMaxProfit.html', '额度上限', '30608', '', '8', 'boss', 'platform:view_maxProfit', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060808');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060809', '转账上限', '/site/detail/viewTransferProfit.html', '转账上限', '30608', '', '9', 'boss', 'platform:view_transferProfit', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060809');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '3060810', '站点首页', '/site/detail/viewSiteHomePage.html', '站点首页', '30608', '', '10', 'boss', 'platform:view_siteHomePage', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3060810');
