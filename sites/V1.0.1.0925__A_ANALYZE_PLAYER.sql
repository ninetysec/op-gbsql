-- auto gen by younger 2018-07-25 18:40:29
SELECT redo_sqls($$
	ALTER TABLE analyze_player DROP CONSTRAINT analyze_player_sp_uk;
	ALTER TABLE analyze_player ADD CONSTRAINT analyze_player_sp_uk UNIQUE ("player_id", "static_date", "agent_id");
$$);
