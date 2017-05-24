-- auto gen by cherry 2017-05-13 17:07:32
--autovacuum
alter table player_game_order set (
  FILLFACTOR=80,
  autovacuum_enabled=true,
  autovacuum_vacuum_scale_factor=0.01, -- 触发回收的比率
  autovacuum_analyze_scale_factor=0.005 ) -- 触发分析的比率
;
