  --体育推荐添加菜单
  INSERT INTO "sys_resource" (
	"id",
	"name",
	"url",
	"remark",
	"parent_id",
	"structure",
	"sort_num",
	"subsys_code",
	"permission",
	"resource_type",
	"icon",
	"privilege",
	"built_in",
	"status"
)
SELECT
		'206',
		'体育推荐',
		'vSportRecommended/list.html',
		'',
		'2',
		'',
		'6',
		'boss',
		'game:view',
		'1',
		'',
		'f',
		'f',
		't'
	where '体育推荐' not in (SELECT NAME FROM sys_resource where parent_id = 2)

