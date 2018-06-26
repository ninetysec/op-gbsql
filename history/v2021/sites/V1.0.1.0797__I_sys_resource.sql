-- auto gen by linsen 2018-05-04 19:32:49
-- 玩家中心-修改密码 by carl
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '50', '修改密码', 'personInfo/password/index.html', '玩家中心-修改密码', '4002', NULL, '10', 'pcenter', 'pcenter:updatePassword', '1', 'recommend', 't', 'f', 't'
where not EXISTS (select id from sys_resource where id=50);