-- auto gen by jerry 2016-12-28 10:52:08
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '9', '分析', NULL, '', NULL, '', '5', 'mcenter', 'mcenter:analyze', '1', '', 't', 't', 't'
WHERE 9 not in(select id from sys_resource where id=9);
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '901', '代理新进', '/vAnalyzePlayer/analyze.html', '', '9', '', '1', 'mcenter', 'mcenter:analyze-link', '1', '', 't', 'f', 't'
WHERE 901 not in(select id from sys_resource where id=901);
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '902', '推广链接新进', 'vAnalyzePlayer/analyzeLink.html', '', '9', '', '2', 'mcenter', 'mcenter:analyze', '1', '', 't', 'f', 't'
WHERE 902 not in(select id from sys_resource where id=902);
