-- auto gen by cherry 2016-08-15 14:57:28
INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '15', '0', now(), '0', now(), 'f'
where not EXISTS (SELECT id from api_order_log where api_id=15 and type='0');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '15', '0', now(), '1', now(), 'f'
where not EXISTS (SELECT id from api_order_log where api_id=15 and type='1');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '15', '0', now(), '2', now(), 'f'
where not EXISTS (SELECT id from api_order_log where api_id=15 and type='2');

