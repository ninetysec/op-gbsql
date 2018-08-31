-- auto gen by linsen 2018-08-20 19:04:38
--添加字段, 为app_version_log表增加version_no，用于手动设置app版本号 by hanson
select redo_sqls($$

  ALTER TABLE app_version_log ADD COLUMN version_no  varchar(6);

$$);

COMMENT ON COLUMN app_version_log.version_no IS 'app版本号';