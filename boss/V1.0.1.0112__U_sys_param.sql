-- auto gen by jeff 2016-08-29 11:06:48
-- 清除缓存链接
-- auto gen by jeff 2016-08-29 11:06:48
INSERT INTO sys_param (
	MODULE,
	param_type,
	param_code,
	param_value,
	default_value,
	order_num,
	remark,
	parent_code,
	active,
	site_id
) SELECT
	'op',
	'purge_out_page_cache',
	'purge_out_page_cache',
	'http://nginx.c/purge_out_page_cache',
	'http://nginx.c/purge_out_page_cache',
	'1',
	'清理外围页面缓存',
	NULL,
	't',
	'0'
WHERE
	'purge_out_page_cache' NOT IN (
		SELECT
			param_type
		FROM
			sys_param
		WHERE
			MODULE = 'op'
	);


	INSERT INTO sys_param (
	MODULE,
	param_type,
	param_code,
	param_value,
	default_value,
	order_num,
	remark,
	parent_code,
	active,
	site_id
) SELECT
	'op',
	'purge_out_static_cache',
	'purge_out_static_cache',
	'http://nginx.c/purge_out_static_cache',
	'http://nginx.c/purge_out_static_cache',
	'1',
	'清理外围页面缓存',
	NULL,
	't',
	'0'
WHERE
	'purge_out_static_cache' NOT IN (
		SELECT
			param_type
		FROM
			sys_param
		WHERE
			MODULE = 'op'
	);


	INSERT INTO sys_param (
	MODULE,
	param_type,
	param_code,
	param_value,
	default_value,
	order_num,
	remark,
	parent_code,
	active,
	site_id
) SELECT
	'op',
	'purge_cf_cache',
	'purge_cf_cache',
	'http://nginx.c/purge_cf_cache',
	'http://nginx.c/purge_cf_cache',
	'1',
	'清理外围页面缓存',
	NULL,
	't',
	'0'
WHERE
	'purge_cf_cache' NOT IN (
		SELECT
			param_type
		FROM
			sys_param
		WHERE
			MODULE = 'op'
	);