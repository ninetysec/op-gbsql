-- auto gen by george 2017-11-17 15:32:59
INSERT INTO "api_order_log"  ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account","gametype")
SELECT '10', '0', now(), '8', now(), 'f','8'
WHERE '10' not in(SELECT api_id FROM api_order_log WHERE type='8' and gametype='8');