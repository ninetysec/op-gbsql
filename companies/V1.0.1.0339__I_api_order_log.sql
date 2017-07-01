-- auto gen by cherry 2017-07-01 10:14:19
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT 	'23', '0', '2017-06-23 11:52:00.838', '1', '2017-06-23 11:52:00.046', 'f', '0', NULL, NULL, NULL
WHERE not EXISTS (SELECT id FROM api_order_log WHERE api_id=23 and type='1');