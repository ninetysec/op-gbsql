-- auto gen by steffan 2018-05-28 19:52:14   update by steffan -- 修改终端为1,2
UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-06-01' and create_time > '2018-05-01';
UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-05-01' and create_time > '2018-04-01';
UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-04-01' and create_time > '2018-03-01';
UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-03-01' and create_time > '2018-02-01';

UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-02-01' and create_time > '2018-01-01';

UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2017-01-01' and create_time > '2017-12-01';