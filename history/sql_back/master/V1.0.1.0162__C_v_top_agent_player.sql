-- auto gen by fly 2015-11-02 13:56:09
/* -------- 总代下玩家视图 -------- */
DROP VIEW IF EXISTS v_top_agent_player;

CREATE OR REPLACE VIEW v_top_agent_player AS
	SELECT su."id",
			 su.owner_id,
			 ua.parent_id,
			 up.create_channel,
			 su.username,
			 su.create_time,
			 su.last_login_time,
			 su.status,
			 su.freeze_start_time,
			 su.freeze_end_time,
			 up.balance_freeze_start_time,
			 up.balance_freeze_end_time
		FROM sys_user su
	 INNER JOIN user_player up ON su."id" = up."id"
	 INNER JOIN user_agent ua ON su.owner_id = ua."id"
	 WHERE su.status NOT in ('4', '5')
	 	 AND su.user_type = '24'
	 ORDER BY su.create_time DESC;

ALTER TABLE v_top_agent_player OWNER TO postgres;
COMMENT ON VIEW v_top_agent_player IS '总代下玩家视图';
