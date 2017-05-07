-- auto gen by longer 2016-01-27 16:12:13

SELECT redo_sqls($$
  alter TABLE defense_record add COLUMN sys_user_id INTEGER;
$$);

COMMENT ON COLUMN defense_record.sys_user_id IS '系统用户ID';


