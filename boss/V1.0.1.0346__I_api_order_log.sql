-- auto gen by cherry 2017-06-13 15:48:34
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '23', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=23 and type='0');


INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '24', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=24 and type='0');