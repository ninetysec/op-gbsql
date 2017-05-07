-- auto gen by cherry 2017-02-28 09:04:09
UPDATE user_player set agent_name = (SELECT username FROM sys_user WHERE id=user_agent_id),
  general_agent_name = (SELECT username FROM sys_user t1 where t1.id=(SELECT owner_id FROM sys_user WHERE id=user_agent_id)),
  general_agent_id = (SELECT owner_id FROM sys_user where id=user_agent_id)
WHERE agent_name is NULL;