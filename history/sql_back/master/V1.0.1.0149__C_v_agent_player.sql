-- auto gen by fly 2015-10-28 17:18:54
/* -------- 代理下玩家视图 -------- */

select redo_sqls($$
        ALTER TABLE "user_player" ADD COLUMN "create_channel" varchar(1);
$$);

COMMENT ON COLUMN "user_player"."create_channel" IS '''创建渠道 字典create_channel'';';
DROP VIEW IF EXISTS v_agent_player;


CREATE OR REPLACE VIEW v_agent_player AS
	SELECT su."id",
				 su.owner_id,
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
	 WHERE su.status NOT in ('4', '5')
	 	 AND su.user_type = '24'
	 ORDER BY su.create_time DESC NULLS LAST;

ALTER TABLE v_agent_player OWNER TO postgres;
COMMENT ON VIEW v_agent_player IS '代理下玩家视图';
