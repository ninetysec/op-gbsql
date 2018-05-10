-- auto gen by linsen 2018-04-25 19:22:57
-- 玩家管理-重置前三存送添加权限 by linsen
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '40807', '重置前三存送', 'player/resetStorage.html', '玩家管理-重置前三存送', '408', '', NULL, 'mcenter', 'operate:reset_storage', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=40807);