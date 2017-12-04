-- auto gen by george 2017-10-11 20:47:35
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
 SELECT '27', '玩家管理', 'vUserPlayer/list.html', '总代中心-玩家管理', NULL, '', '7', 'mcenterTopAgent', 'topAgent:player', '1', 'icon-wanjiaguanli', 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='27');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '28', '经营分析', NULL, '', NULL, '', '8', 'mcenterTopAgent', 'topAgent:analyze', '1', 'icon-fenxi', 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='28');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '2801', '代理新进', '/vAnalyzePlayer/analyze.html', '', '28', '', '1', 'mcenterTopAgent', 'topAgent:analyze-agent', '1', 'icon-dailixinjin', 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='2801');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '2802', '推广链接新进', 'vAnalyzePlayer/analyzeLink.html', '', '28', '', '2', 'mcenterTopAgent', 'topAgent:analyze-link', '1', 'icon-lianjiexinjin', 't', 'f', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE ID='2802');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '29', '资金记录', 'report/vPlayerFundsRecord/fundsLog.html', '资金记录', NULL, '', '9', 'mcenterTopAgent', 'topAgent:fundrecord', '1', 'icon-zijinjilu', 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='29');