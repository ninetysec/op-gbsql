-- auto gen by fly 2015-11-02 13:55:44
/* -------- 总代下代理列表视图 -------- */
DROP VIEW IF EXISTS v_top_agent_agent;

CREATE OR REPLACE VIEW v_top_agent_agent AS
	SELECT * FROM (
		SELECT su."id",
			   ua.parent_id,
			   ua.create_channel,
			   su.username,
			   su.create_time,
			   su.last_login_time,
			   su.status,
			   su.freeze_start_time,
			   su.freeze_end_time
		  FROM sys_user su
 		 INNER JOIN user_agent ua ON su."id" = ua."id"
 		 WHERE su.user_type = '23'
   		   AND su.status NOT IN ('4','5')) ag
		  LEFT JOIN (SELECT user_agent_id, COUNT(1) player_num
		  			   FROM user_player
		  			  GROUP BY user_agent_id) up
		  	ON ag."id" = up.user_agent_id
	ORDER BY ag.create_time DESC NULLS LAST;

ALTER TABLE v_top_agent_agent OWNER TO postgres;

COMMENT ON VIEW v_top_agent_agent IS '总代下代理列表视图';
