-- auto gen by bruce 2016-06-05 15:17:17
DROP VIEW IF EXISTS v_sys_role;
CREATE OR REPLACE VIEW v_sys_role AS
	SELECT sr."id",
	       sr."name",
		   sr.site_id,
	       sr.subsys_code,
	       sr.built_in,
	       COALESCE(user_count, 0) as user_count
	  FROM sys_role sr
	  LEFT JOIN (SELECT role_id,
	                    count(1) as user_count
	               FROM sys_user_role
	              GROUP BY role_id) user_role ON role_id = sr."id";

COMMENT ON VIEW v_sys_role IS '角色视图 - jeff';


DROP INDEX IF EXISTS idx_sys_audit_log_composite0;
DROP INDEX IF EXISTS idx_sys_audit_log_composite1;
DROP INDEX IF EXISTS idx_sys_audit_log_composite2;
select redo_sqls($$
	CREATE INDEX idx_sys_audit_log_composite0 ON sys_audit_log (module_type,operator,operator_user_type);
	CREATE INDEX idx_sys_audit_log_composite1 ON sys_audit_log (module_type,operator_user_type);
	CREATE INDEX idx_sys_audit_log_composite2 ON sys_audit_log (operate_ip,module_type,operator_user_type);
$$);