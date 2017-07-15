-- auto gen by cherry 2017-07-15 17:56:46
 select redo_sqls($$
	ALTER TABLE lottery_result ADD COLUMN origin varchar(2);
  $$);

COMMENT on COLUMN lottery_result.origin is '区分手动自动采集 0-手动 1-自动';