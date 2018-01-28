-- auto gen by cherry 2018-01-04 09:07:05
CREATE TABLE IF not EXISTS recharge_monitor_param(
id serial4 not NULL PRIMARY key,
recharge_minute int4,
recharge_hour int4,
recharge_day int4,
level_1 int4,
level_2 int4,
level_3 int4
);
COMMENT ON TABLE recharge_monitor_param is '存款监控点参数';
COMMENT ON COLUMN recharge_monitor_param.id is '主键';
COMMENT ON COLUMN recharge_monitor_param.recharge_minute is '分钟数';
COMMENT ON COLUMN recharge_monitor_param.recharge_hour is '小时数';
COMMENT ON COLUMN recharge_monitor_param.recharge_day is '天数';
COMMENT ON COLUMN recharge_monitor_param.level_1 is '最近笔数第一级';
COMMENT ON COLUMN recharge_monitor_param.level_2 is '最近笔数第二级';
COMMENT ON COLUMN recharge_monitor_param.level_3 is '最近笔数第三级';

INSERT INTO "recharge_monitor_param" ("recharge_minute", "recharge_hour", "recharge_day", "level_1", "level_2", "level_3")
SELECT '5', '2', '1', '50', '100', '200'
WHERE NOT EXISTS (SELECT id FROM recharge_monitor_param);