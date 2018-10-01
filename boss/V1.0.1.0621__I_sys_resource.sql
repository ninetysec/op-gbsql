-- auto gen by steffan 2018-10-01 14:04:29
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
) SELECT
	'415',
	'经营报表投注记录比对',
	'report/gameTransaction/reportBeting.html',
	'经营报表投注记录比对',
	'4',
	'',
	'15',
	'boss',
	'payApi:reportbeting',
	'1',
	'',
	'f',
	't',
	't'
WHERE
	NOT EXISTS (
		SELECT
			ID
		FROM
			sys_resource
		WHERE
			ID = '415'
	);