-- auto gen by tom 2015-11-04 15:20:40
INSERT INTO "sys_resource" ("name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
 SELECT '推广素材', 'cttMaterialText/list.html', '站长中心-内容-推广素材', '6', NULL, 13, 'mcenter', 'test:view', '1', NULL, 't', 'f'
WHERE 'cttMaterial/list.html' not in (SELECT url from sys_resource where url = 'cttMaterialText/list.html' and subsys_code='mcenter' );
