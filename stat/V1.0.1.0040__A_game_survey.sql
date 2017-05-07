-- auto gen by fei 2016-09-19 20:11:35
select redo_sqls($$
  ALTER TABLE game_survey ADD COLUMN static_date date;
  ALTER TABLE game_survey ADD COLUMN static_time timestamp(6);
  ALTER TABLE game_survey ADD COLUMN static_time_end timestamp(6);
$$);

COMMENT ON COLUMN game_survey.static_date IS '统计日期';
COMMENT ON COLUMN game_survey.static_time IS '统计起始时间';
COMMENT ON COLUMN game_survey.static_time_end IS '统计截止时间';
COMMENT ON COLUMN game_survey.statistics_time IS '统计时间——停用';
