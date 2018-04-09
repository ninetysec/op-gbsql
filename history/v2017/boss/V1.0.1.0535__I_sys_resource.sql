-- auto gen by linsen 2018-03-25 11:25:59
-- 设置站长座席号-站长详细 by younger
INSERT INTO "sys_resource"("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '30703', '设置站长座席号', 'vSiteMasterManage/editExtNo.html', '设置站长座席号-站长详细', '307', NULL, '3', 'boss', 'site:mastermanage_extno', '2', NULL, 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30703);