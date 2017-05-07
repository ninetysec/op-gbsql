-- auto gen by cherry 2016-01-06 14:54:10
-- 添加注册渠道字典
INSERT INTO "sys_dict" (
	"module",
	"dict_type",
	"dict_code",
	"order_num",
	"remark",
	"parent_code",
	"active"
)
select
		'player',
		'create_channel',
		'3',
		'3',
		'导入玩家',
		NULL,
		't'
where '3' not in (SELECT dict_code from sys_dict where module = 	'player' and dict_type = 'create_channel');

UPDATE sys_resource SET url = 'report/rakeback/rakebackIndex.html' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '返水统计' AND parent_id = 5 AND subsys_code = 'ccenter');