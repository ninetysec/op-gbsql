-- auto gen by longer 2016-02-03 10:02:25
SELECT redo_sqls($$
  alter TABLE defense_record add COLUMN reset_columns CHARACTER VARYING(20);
$$);

COMMENT ON COLUMN defense_record.reset_columns is '需要重置的字段,当处置过期后';