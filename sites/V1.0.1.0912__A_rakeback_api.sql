-- auto gen by linsen 2018-07-21 14:45:26
--修改rakeback_api表约束
ALTER TABLE rakeback_api DROP CONSTRAINT IF EXISTS rakeback_api_rpag_uc;

SELECT redo_sqls($$
		ALTER TABLE rakeback_api ADD CONSTRAINT rakeback_api_rapag_uc  UNIQUE(rakeback_bill_id, agent_id, player_id, api_id, game_type);
$$);