-- auto gen by bruce 2016-10-08 11:05:43
drop view if EXISTS v_sys_user_tier;
create or REPLACE view v_sys_user_tier as
	SELECT p.id,
		   p.username,
		   p.status,
		   r.id rank_id,
		   r.rank_name,
		   r.rank_code,
		   r.risk_marker,
		   a.id agent_id,
		   a.username agent_name,
		   t.id topagent_id,
		   t.username topagent_name
	  FROM sys_user a, sys_user p, sys_user t, user_player up, player_rank r
	 WHERE a.id = p.owner_id
	   AND a.owner_id = t.id
	   AND a.user_type = '23'
	   AND p.user_type = '24'
	   AND t.user_type = '22'
	   AND p.id = up.id
	   --AND p.status = '1'
	   AND up.rank_id = r.id
	 ORDER BY p.id;
COMMENT ON VIEW "v_sys_user_tier"
IS '玩家层级信息-Lins';