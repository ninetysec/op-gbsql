-- auto gen by brave 2016-12-30 07:40:33
INSERT INTO "sys_resource"
("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '409', '彩金对账', 'siteJackpot/jackpotApi.html', '彩池贡献金对账', '4', '', '9', 'boss', 'operate:jszd', '1', NULL, 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 409);
