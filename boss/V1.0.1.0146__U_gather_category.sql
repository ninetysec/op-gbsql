-- auto gen by jerry 2016-09-26 16:04:03
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '010', 'DS', '1', '2016-09-26 16:03:01'where not EXISTS(SELECT id FROM gather_category WHERE id='010');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '020', 'KG', '1', '2016-06-23 19:35:44' where not EXISTS(SELECT id FROM gather_category WHERE id='020');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '030', 'MG', '1', '2016-07-16 16:24:19' where not EXISTS(SELECT id FROM gather_category WHERE id='030');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '040', 'IM', '1', '2016-06-23 19:35:42' where not EXISTS(SELECT id FROM gather_category WHERE id='040');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '050', 'GD', '1', '2016-08-10 15:43:00' where not EXISTS(SELECT id FROM gather_category WHERE id='050');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '060', 'PT', '1', '2016-08-10 15:42:41' where not EXISTS(SELECT id FROM gather_category WHERE id='060');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '070', 'OG', '1', '2016-08-10 15:43:11' where not EXISTS(SELECT id FROM gather_category WHERE id='070');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '080', 'SLC', '1', '2016-06-23 19:35:42' where not EXISTS(SELECT id FROM gather_category WHERE id='080');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '090', 'AG', '1', '2016-06-23 19:35:42' where not EXISTS(SELECT id FROM gather_category WHERE id='090');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '100', 'HG', '1', '2016-06-23 19:35:42' where not EXISTS(SELECT id FROM gather_category WHERE id='010');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '110', 'PG', '1', '2016-09-06 15:22:42' where not EXISTS(SELECT id FROM gather_category WHERE id='110');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '120', 'SS', '1', '2016-09-26 16:00:40' where not EXISTS(SELECT id FROM gather_category WHERE id='120');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '140', 'NYX', '1', '2016-09-26 16:01:43' where not EXISTS(SELECT id FROM gather_category WHERE id='140');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '150', 'HB', '1', '2016-09-26 16:02:00' where not EXISTS(SELECT id FROM gather_category WHERE id='150');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '160', 'EBET', '1', '2016-09-26 16:02:18' where not EXISTS(SELECT id FROM gather_category WHERE id='160');
INSERT INTO gather_category ("id", "name", "status", "create_time") SELECT '170', 'SA', '1', '2016-09-26 16:02:29' where not EXISTS(SELECT id FROM gather_category WHERE id='170');


DELETE FROM gather_user where username='marking';
INSERT INTO gather_user ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") SELECT '301', 'MG001', 'fa8034h6', 'MG用户', '01', '1', '2016-06-23 19:26:49', '030', 't' where not EXISTS(SELECT id FROM gather_user WHERE id='301');
INSERT INTO gather_user ("id", "username", "password", "nickname", "type", "status", "create_time", "category_id", "duplicateused") SELECT '302', 'MG002', 'fa8034h6', 'MG用户', '01', '1', '2016-06-23 19:26:49', '030', 't' where not EXISTS(SELECT id FROM gather_user WHERE id='302');


