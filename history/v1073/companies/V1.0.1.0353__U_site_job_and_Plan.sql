-- auto gen by longer 2017-07-06 16:22:26

--站点任务:禁用总代占成
update site_job set status = '0' where id = 10;
update site_job_plan set enable_status = '0' where job_id = 10;
