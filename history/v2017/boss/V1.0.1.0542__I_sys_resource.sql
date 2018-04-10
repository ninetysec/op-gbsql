-- auto gen by marz 2018-04-06 08:58:20
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '70104', '杀率管理', 'lotteryKillrate/list.html', '彩票杀率管理', '701', '', '4', 'boss', 'lottery:list_killrate', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (select id from sys_resource where id = '70104');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '7010401', '杀率添加', 'lotteryKillrate/create.html', '彩票杀率添加', '70104', '', '1', 'boss', 'lottery:list_killrate_create', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (select id from sys_resource where id = '7010401');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '7010402', '杀率编辑', 'lotteryKillrate/edit.html', '彩票杀率编辑', '70104', '', '2', 'boss', 'lottery:list_killrate_edit', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (select id from sys_resource where id = '7010402');