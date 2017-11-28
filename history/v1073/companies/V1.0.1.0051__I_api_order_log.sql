-- auto gen by cherry 2016-03-14 16:05:09
INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '1', NULL, now(), '0', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=1 and type='0')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '1', NULL, now(), '1', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=1 and type='1')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '2', NULL, now(), '0', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=2 and type='0')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '2', NULL, now(), '1', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=2 and type='1')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '3', NULL, now(), '0', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=3 and type='0')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '3', NULL, now(), '1', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=3 and type='1')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '4', NULL, now(), '0', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=4 and type='0')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '4', NULL, now(), '1', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=4 and type='1')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '5', NULL, now(), '0', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=5 and type='0')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '5', NULL, now(), '1', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=5 and type='1')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '6', NULL, now(), '0', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=6 and type='0')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '6', NULL, now(), '1', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=6 and type='1')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '7', NULL, now(), '0', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=7 and type='0')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '7', NULL, now(), '1', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=7 and type='1')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '8', NULL, now(), '0', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=8 and type='0')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '8', NULL, now(), '1', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=8 and type='1')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '9', NULL, now(), '0', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=9 and type='0')=0;

INSERT INTO "api_order_log" ( "api_id", "start_id", "update_time", "type", "start_time", "is_need_account")
SELECT '9', NULL, now(), '1', now(), 'f'
WHERE (SELECT "count"(*) FROM api_order_log where api_id=9 and type='1')=0;



