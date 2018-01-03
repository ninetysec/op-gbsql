-- auto gen by cherry 2017-07-20 10:07:00
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '20402', '同步游戏标签', 'vApi/syncGameTag.html', '同步游戏标签', '204', '', 2, 'boss', 'serve:apimanage_synctag', '2', '', 'f', 't', 't' where 20402 not in (SELECT id from sys_resource where id=20402);

update sys_resource set sort_num=1 where id=20401;