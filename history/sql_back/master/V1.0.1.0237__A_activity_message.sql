-- auto gen by cheery 2015-11-27 15:20:22
select redo_sqls($$
    ALTER TABLE activity_message ADD COLUMN settlement_time_next timestamp(6);
    ALTER TABLE activity_message ADD COLUMN settlement_time_latest timestamp(6);
    ALTER TABLE activity_player_apply ADD COLUMN start_time timestamp(6);
    ALTER TABLE activity_player_apply ADD COLUMN end_time timestamp(6);
  $$);

COMMENT ON COLUMN activity_message.settlement_time_next IS '下一次结算时间';
COMMENT ON COLUMN activity_message.settlement_time_latest IS '最新结算时间';
COMMENT ON COLUMN activity_player_apply.start_time IS '活动结算起始时间';
COMMENT ON COLUMN activity_player_apply.end_time IS '活动结算起始时间';