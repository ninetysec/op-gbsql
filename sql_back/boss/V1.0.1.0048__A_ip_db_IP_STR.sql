-- auto gen by longer 2016-01-08 13:40:17

SELECT redo_sqls($$
  ALTER TABLE ip_db add COLUMN ip_start_str CHARACTER VARYING(17);
  ALTER TABLE ip_db add COLUMN ip_end_str CHARACTER VARYING(17);
$$);

COMMENT ON COLUMN ip_db.ip_start_str is 'ip段起(字符)';
COMMENT ON COLUMN ip_db.ip_end_str is 'ip段止(字符)';
