-- auto gen by cherry 2016-02-23 20:10:13
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '1', '0', '2016-02-15 06:00:01.163', '1', NULL, 'f'
WHERE '1' not in(SELECT api_id FROM api_order_log WHERE type='1');

INSERT INTO "api_order_log"  ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '1', '0', '2016-02-15 06:00:01.176', '0', NULL, 'f'
WHERE '1' not in(SELECT api_id FROM api_order_log WHERE type='0');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '5', '0', NULL, '1', '2016-02-21 20:01:29', 'f'
WHERE '5' not in(SELECT api_id FROM api_order_log WHERE type='1');

INSERT INTO  "api_order_log"  ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '5', '0', '2016-02-22 20:00:48', '0', '2016-02-22 20:00:58', 'f'
WHERE '5' not in(SELECT api_id FROM api_order_log WHERE type='0');

INSERT INTO "api_order_log"  ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT  '3', '0', '2016-02-05 02:24:06.157', '0', '2014-08-26 09:37:10.022', 'f'
WHERE '3' not in(SELECT api_id FROM api_order_log WHERE type='0');

INSERT INTO  "api_order_log"  ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '3', '0', '2016-02-03 17:52:50', '1', '2016-02-03 17:53:14', 'f'
WHERE '3' not in(SELECT api_id FROM api_order_log WHERE type='1');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '2', '0', '2016-02-15 06:00:01.163', '1', NULL, 'f'
WHERE '2' not in(SELECT api_id FROM api_order_log WHERE type='1');

INSERT INTO "api_order_log"  ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '2', '0', '2016-02-15 06:00:01.176', '0', NULL, 'f'
WHERE '2' not in(SELECT api_id FROM api_order_log WHERE type='0');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '4', '0', NULL, '1', '2016-02-21 20:01:29', 'f'
WHERE '4' not in(SELECT api_id FROM api_order_log WHERE type='1');

INSERT INTO "api_order_log"  ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '4', '0', '2016-02-22 20:00:48', '0', '2016-02-22 20:00:58', 'f'
WHERE '4' not in(SELECT api_id FROM api_order_log WHERE type='0');
