-- auto gen by cherry 2017-05-16 10:35:32
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '703', '即时注单', 'lotteryBetOrder/list.html', '彩票管理-即时注单', '7', NULL, '3', 'boss', 'lottery:record', '1', 'icon-gongsirukuanshenhe', 'f', 't', 't'
	WHERE not exists(SELECT id FROM sys_resource WHERE id=703);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '704', '开奖结果', 'lotteryResult/list.html', '彩票管理-开奖结果', '7', NULL, '4', 'boss', 'lottery:opencode', '1', 'icon-xianshangzhifujilu', 'f', 't', 't'
	WHERE not exists(SELECT id FROM sys_resource WHERE id=704);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '705', ' 资金记录', 'lotteryTransaction/list.html', ' 资金记录', '7', NULL, '5', 'boss', 'lottery:fundrecord', '1', 'icon-gongsirukuanshenhe', 'f', 't', 't'
	WHERE not exists(SELECT id FROM sys_resource WHERE id=705);