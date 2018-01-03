-- auto gen by longer 2015-09-10 20:32:28

--系统日志表-用户类型
select redo_sqls($$
  alter table sys_audit_log add COLUMN user_type CHARACTER VARYING(5);
$$);
COMMENT ON COLUMN sys_audit_log.user_type IS '用户类型(参观:sys_user)';

