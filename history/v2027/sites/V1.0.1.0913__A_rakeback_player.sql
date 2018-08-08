-- auto gen by linsen 2018-07-21 14:45:47
-- 修改rakeback_player表约束
ALTER TABLE rakeback_player DROP CONSTRAINT IF EXISTS rakeback_player_rp_uc;

SELECT redo_sqls($$
		ALTER TABLE rakeback_player ADD CONSTRAINT rakeback_player_rap_uc  UNIQUE(rakeback_bill_id, agent_id, player_id);
$$);