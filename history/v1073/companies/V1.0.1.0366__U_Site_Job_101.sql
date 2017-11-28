-- auto gen by longer 2017-07-21 10:19:25


--站点任务:在线支付超时(101)修改为2分钟一次
UPDATE site_job set fixed_minutes = 2,period_value = '2' where id = 101;