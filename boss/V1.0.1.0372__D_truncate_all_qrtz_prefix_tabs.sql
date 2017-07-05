-- auto gen by Water 2017-07-05 17:12:07

--调度器: 删除调度器临时表,删除后需要boss重新初始化之
--TRUNCATE table qrtz_locks;
--TRUNCATE table qrtz_scheduler_state;
--TRUNCATE table qrtz_paused_trigger_grps;
--TRUNCATE table qrtz_calendars;
--TRUNCATE table qrtz_job_details CASCADE ;
--TRUNCATE table qrtz_fired_triggers;