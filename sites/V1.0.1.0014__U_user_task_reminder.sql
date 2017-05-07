-- auto gen by orange 2016-02-22 11:02:03
--修改任务表
update user_task_reminder set remark = '账户冻结'   where dict_code = 'freeze';

INSERT INTO user_task_reminder("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
select 'agentReg', '2016-02-21 06:23:11.703774', '0', NULL, 'examine', '代理注册', NULL, 'audit'
where 'agentReg' not in (select dict_code from user_task_reminder where dict_code = 'agentReg');

delete from user_task_reminder where parent_code = 'profit';