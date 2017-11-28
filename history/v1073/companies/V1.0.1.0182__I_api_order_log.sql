-- auto gen by cherry 2016-09-20 14:49:24
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json")
SELECT '16', '0', now(), '2', now(), 'f', '0', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=16 AND type='2');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json")
SELECT '16', '0', now(), '1', now(), 'f', '0', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=16 AND type='1');


INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json")
SELECT '16', '0', now(), '0', now(), 'f', '0', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=16 AND type='0');
