-- auto gen by jerry 2016-11-06 11:19:46
INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT '1', 'KG后台计划', 'daemon', NULL, NULL, '1', 'N', NULL, '2016-06-24 09:29:29', '2016-06-24 09:29:32', NULL, NULL, '2016', '020' WHERE NOT EXISTS(SELECT id from gather_schedule where id='1');
INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT '2', 'IM后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-06-24 09:28:38', '2016-06-24 09:28:47', NULL, NULL, '2016', '040' WHERE NOT EXISTS(SELECT id from gather_schedule where id='2');
INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT '3', 'SLC后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-06-24 09:28:38', '2016-06-24 09:28:47', NULL, NULL, '2016', '080' WHERE NOT EXISTS(SELECT id from gather_schedule where id='3');
INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT '4', 'HG后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-06-24 09:28:38', '2016-06-24 09:28:47', NULL, NULL, '2016', '100' WHERE NOT EXISTS(SELECT id from gather_schedule where id='4');
INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT '5', 'MG后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-06-24 09:28:38', '2016-06-24 09:28:47', NULL, NULL, '2016', '030' WHERE NOT EXISTS(SELECT id from gather_schedule where id='5');
INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT '6', 'PT后台计划', 'daemon', NULL, NULL, '1', 'N', NULL, '2016-08-10 21:24:22', '2016-08-10 21:24:26', NULL, NULL, '2016', '060' WHERE NOT EXISTS(SELECT id from gather_schedule where id='6');
INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT '9', 'AG后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-08-10 21:24:22', '2016-08-10 21:24:26', NULL, NULL, '2016', '090' WHERE NOT EXISTS(SELECT id from gather_schedule where id='9');
INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") SELECT '10', 'PG后台计划', 'daemon', '', '', '1', 'N', NULL, '2016-09-06 20:24:22', '2016-09-06 20:24:22', NULL, NULL, '2016', '110' WHERE NOT EXISTS(SELECT id from gather_schedule where id='10');



DELETE FROM gather_type;
INSERT INTO gather_type (ID, NAME, category_id, status) SELECT
	type_id,
	config_name,
	category_id,
	1
FROM
	gather_flow;


DELETE FROM gather_category where id='060';
INSERT INTO gather_category ("id", "name", "status", "create_time") VALUES ('060', 'PT', '1', '2016-08-10 15:42:41');

DELETE FROM gather_schedule where id='6';
INSERT INTO gather_schedule ("id", "name", "type", "init_user_info", "cron_expressions", "status", "auto_start", "result_channel_id", "create_time", "update_time", "create_user_id", "update_user_id", "version", "category_id") VALUES ('6', 'PT后台计划', 'daemon', NULL, NULL, '1', 'N', NULL, '2016-08-10 21:24:22', '2016-08-10 21:24:26', NULL, NULL, '2016', '060');


DELETE FROM gather_type where category_id='060';
INSERT INTO gather_type ("id", "name", "category_id", "status", "create_time") VALUES ('060001', 'PT初始化', '060', '1', NULL);
INSERT INTO gather_type ("id", "name", "category_id", "status", "create_time") VALUES ('060002', 'PT帐务查询', '060', '1', NULL);
INSERT INTO gather_type ("id", "name", "category_id", "status", "create_time") VALUES ('060003', 'PT会话保持', '060', '1', NULL);