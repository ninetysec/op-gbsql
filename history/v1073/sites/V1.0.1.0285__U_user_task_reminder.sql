-- auto gen by bruce 2016-10-12 15:49:27
INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
  SELECT 'agentReg', '2016-10-12 07:15:58.038718', '0', '/vUserAgentManage/list.html', 'examine', '代理注册', NULL, 'audit' WHERE 'agentReg' not in (SELECT dict_code FROM user_task_reminder);
