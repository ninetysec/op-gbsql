-- auto gen by tony 2016-09-03 15:52:11
 select redo_sqls($$
    ALTER TABLE sys_audit_log
      ADD COLUMN site_id integer;
  $$);
COMMENT ON COLUMN sys_audit_log.site_id IS '站点ID';