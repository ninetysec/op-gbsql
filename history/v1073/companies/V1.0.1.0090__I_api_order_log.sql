-- auto gen by admin 2016-05-04 20:25:53
INSERT INTO  "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT'10', NULL, '2016-05-04 08:36:17.706', '0', '2016-05-04 08:36:05', 'f'
WHERE '10' not in(SELECT api_id FROM api_order_log where type='0');

INSERT INTO  "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '10', NULL, '2016-05-04 08:30:30.892', '1', '2016-05-04 08:24:33', 'f'
WHERE'10' not in(SELECT api_id FROM api_order_log where type='1');
