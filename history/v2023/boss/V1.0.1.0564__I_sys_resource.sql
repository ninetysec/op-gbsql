-- auto gen by steffan 2018-05-15 20:07:10
--添加缓存管理  add by younger
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '527', '缓存管理', 'cacheItem/list.html', '缓存管理', '5', '', '27', 'boss', 'maintenance:cachemanage', '1', '', 'f', 't', 't' where NOT EXISTS (select id from sys_resource where id=527) ;
