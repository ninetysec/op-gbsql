-- auto gen by cherry 2017-07-14 16:41:02
select redo_sqls($$
     ALTER TABLE lottery_result ADD COLUMN close_time TIMESTAMP;
     ALTER TABLE lottery_result ADD COLUMN opening_time TIMESTAMP;
     ALTER TABLE lottery_result ADD COLUMN acquisition_time TIMESTAMP;
$$);

COMMENT on COLUMN lottery_result.close_time is '封盘时间';
COMMENT on COLUMN lottery_result.opening_time is '开盘时间';
COMMENT on COLUMN lottery_result.acquisition_time is '采集时间';
