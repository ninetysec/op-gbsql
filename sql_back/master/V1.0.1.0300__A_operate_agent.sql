-- auto gen by cheery 2015-12-30 11:28:42
ALTER TABLE operate_agent DROP COLUMN IF EXISTS agent_num;
ALTER TABLE operate_topagent DROP COLUMN IF EXISTS top_agent_num;
ALTER TABLE operate_topagent DROP COLUMN IF EXISTS agent_num;

UPDATE sys_resource  SET url = 'myAccount/myAccount.html' WHERE NAME = '我的账号' AND subsys_code = 'mcenter' AND url != 'myAccount/myAccount.html' ;