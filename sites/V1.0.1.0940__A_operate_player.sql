-- auto gen by linsen 2018-08-04 14:30:53
-- 修改约束 by younger
ALTER TABLE operate_player  DROP CONSTRAINT if EXISTS operate_player_spag_uk;

select redo_sqls($$
      ALTER TABLE operate_player  ADD  CONSTRAINT operate_player_spag_uk UNIQUE ("static_date", "player_id", "api_id", "game_type", "agent_id");
$$);