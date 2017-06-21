-- auto gen by Water 2017-06-19 15:40:03

SELECT redo_sqls($$
  ALTER TABLE task_schedule ADD COLUMN SCHEDULER VARCHAR(32);
$$);
COMMENT ON COLUMN task_schedule.scheduler is 'Quartz调度器';
