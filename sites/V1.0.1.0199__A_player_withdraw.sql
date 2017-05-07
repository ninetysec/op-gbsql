-- auto gen by cherry 2016-07-14 20:13:49
drop INDEX IF EXISTS idx_player_withdraw_composite0;
CREATE INDEX IF NOT EXISTS idx_player_withdraw_composite0 ON player_withdraw USING btree (withdraw_status, id DESC);

DROP INDEX IF EXISTS idx_sys_audit_log_composite0;
CREATE INDEX IF NOT EXISTS idx_sys_audit_log_composite0 ON sys_audit_log USING btree (operator, operator_user_type, module_type);

DROP INDEX IF EXISTS idx_sys_audit_log_operate_time;
CREATE INDEX IF NOT EXISTS idx_sys_audit_log_operate_time ON sys_audit_log USING btree (operate_time);

DROP INDEX IF EXISTS idx_sys_audit_log_operator_user_type;
CREATE INDEX IF NOT EXISTS idx_sys_audit_log_operator_user_type ON sys_audit_log USING btree (operator_user_type);

 select redo_sqls($$
      ALTER TABLE player_recharge ADD COLUMN status_code  VARCHAR(32);
 $$);

comment on COLUMN player_recharge.status_code is '第三方支付返回的的状态码';