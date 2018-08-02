-- auto gen by linsen 2018-07-12 15:44:45
-- 修复导入玩家user_player总代数据
UPDATE user_player up
SET general_agent_id = ut. ID,
 general_agent_name = ut.username
FROM
	sys_user su,
	sys_user ua,
	sys_user ut
WHERE
	up. ID = su. ID
AND su.owner_id = ua. ID
AND ua.owner_id = ut. ID
AND su.user_type = '24'
AND ua.user_type = '23'
AND ut.user_type = '22';
