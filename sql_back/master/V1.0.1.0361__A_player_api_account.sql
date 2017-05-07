-- auto gen by cherry 2016-01-27 15:17:51
 select redo_sqls($$
			ALTER TABLE player_api_account ADD COLUMN last_login_ip int8;
 $$);
COMMENT ON COLUMN player_api_account.last_login_ip is '上次登录IP';


INSERT INTO "user_task_reminder" (
        "dict_code",
        "update_time",
        "task_num",
        "task_url",
        "parent_code",
        "remark",
        "param_value",
        "tone_type"
)select  'agentReg',  '2016-01-26 02:09:49.615195', NULL,  NULL,'examine', '代理注册', NULL, 'audit' WHERE 'agentReg' not in(SELECT dict_code FROM user_task_reminder);