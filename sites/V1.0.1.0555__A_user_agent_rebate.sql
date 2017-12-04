-- auto gen by george 2017-10-12 17:45:31
SELECT redo_sqls($$
ALTER TABLE user_agent_rebate ADD CONSTRAINT user_agent_rebate_user_id_uc UNIQUE ( user_id);
ALTER TABLE rebate_grads_api ADD CONSTRAINT rebate_grads_api_rrag_uc UNIQUE ( rebate_set_id, rebate_grads_id, api_id, game_type);
$$);

SELECT redo_sqls($$
ALTER TABLE rebate_bill ADD CONSTRAINT rebate_bill_period_uc UNIQUE ( period);
ALTER TABLE rebate_agent ADD CONSTRAINT rebate_agent_rbi_ai_uc UNIQUE ( rebate_bill_id, agent_id);
ALTER TABLE rebate_agent_api ADD CONSTRAINT rebate_agent_api_raag_uc UNIQUE ( rebate_bill_id, agent_id, api_id, game_type);
ALTER TABLE rebate_player_fee ADD CONSTRAINT rebate_player_fee_rbi_pi UNIQUE ( rebate_bill_id, player_id);
$$);