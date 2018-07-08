-- auto gen by steffan 2018-05-30 08:06:08
UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-01-01' and create_time >= '2017-11-28';