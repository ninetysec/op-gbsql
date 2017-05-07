-- auto gen by cherry 2016-02-03 14:07:00
  select redo_sqls($$
       ALTER TABLE player_transfer ADD COLUMN additional_result text;
  $$);

COMMENT ON COLUMN player_transfer.additional_result is 'api返回其他结果';