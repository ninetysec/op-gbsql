-- auto gen by steffan 2018-06-27 16:59:32

--关闭活动管理的站点任务  002 PreferentialProcedureJob
update site_job set  status ='0'  where  sub_job_code='site_job_002';
--开启活动大厅的站点任务  021 PreferentialSettleJob
update site_job set  status='1'   where sub_job_code='site_job_021';