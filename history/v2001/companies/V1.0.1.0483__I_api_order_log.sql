-- auto gen by george 2017-11-29 15:46:08
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '12', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=12 and type='9');