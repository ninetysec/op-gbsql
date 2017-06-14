-- auto gen by cherry 2017-06-14 14:18:38
select redo_sqls($$
  ALTER TABLE activity_money_play_record ADD COLUMN is_accept BOOLEAN;
$$);

COMMENT ON COLUMN activity_money_play_record.is_accept IS '是否领取';