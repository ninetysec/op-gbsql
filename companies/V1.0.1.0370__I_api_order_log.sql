-- auto gen by cherry 2017-07-24 11:36:44
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '25', '0', now(), '2', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=25 and type='2');