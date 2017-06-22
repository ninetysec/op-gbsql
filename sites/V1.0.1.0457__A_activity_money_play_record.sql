-- auto gen by cherry 2017-06-22 16:58:19
select redo_sqls($$
  ALTER TABLE activity_money_play_record ADD COLUMN entity_id int4;
$$);

COMMENT ON COLUMN activity_money_play_record.entity_id IS '内置ID或者奖项ID';
