-- auto gen by steffan 2018-05-18 11:50:38
-- 按月刷新交易表的终端字段，业务需要 update by steffan
UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-06-01' and create_time > '2018-05-01';
UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-05-01' and create_time > '2018-04-01';
UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-04-01' and create_time > '2018-03-01';
UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-03-01' and create_time > '2018-02-01';