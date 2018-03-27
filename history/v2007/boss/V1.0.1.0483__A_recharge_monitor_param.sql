-- auto gen by cherry 2018-01-04 17:19:21
select redo_sqls($$
     ALTER TABLE recharge_monitor_param ADD COLUMN weight_params varchar(256);
$$);

COMMENT ON COLUMN recharge_monitor_param.weight_params is '各个指标对应权重比';
