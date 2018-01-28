-- auto gen by cherry 2018-01-14 11:26:34
select redo_sqls($$
     ALTER TABLE player_favorable ADD COLUMN player_apply_id int4;
$$);

COMMENT ON COLUMN player_favorable.player_apply_id is '申请活动记录activity_player_apply.id';