-- auto gen by younger 2018-10-03 12:27:23
--修改唯一约束
ALTER TABLE rebate_player_fee DROP CONSTRAINT IF EXISTS rebate_player_fee_rbi_pi;

SELECT redo_sqls($$
ALTER TABLE rebate_player_fee ADD CONSTRAINT rebate_player_fee_rbi_pi UNIQUE(rebate_bill_id,agent_id, player_id);
$$);