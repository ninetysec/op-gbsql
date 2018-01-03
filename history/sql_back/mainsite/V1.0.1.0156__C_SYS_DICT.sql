-- auto gen by mark 2015-12-14 20:53:08
INSERT INTO "sys_dict" (
	"module",
	"dict_type",
	"dict_code",
	"order_num",
	"remark",
	"parent_code",
	"active"
)
SELECT 'common',
		'export_status',
		'fail',
		'1',
		'导出失败',
		NULL,
		't'
WHERE not exists(select id from sys_dict where module='common' AND dict_type = 'export_status' AND dict_code='fail' );


