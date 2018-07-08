-- auto gen by steffan 2018-05-30 08:06:03

UPDATE player_transaction SET origin = CASE origin WHEN 'PC' THEN '1' WHEN 'MOBILE' THEN '2' END WHERE origin IN ( 'PC', 'MOBILE')
and create_time <= '2018-06-01 00:00:00' and create_time >= '2018-05-29 22:30:00';