-- auto gen by Water 2017-06-29 20:41:04

--cause exception: too long 2048.so update all 2048 size's column
ALTER TABLE sys_audit_log ALTER COLUMN description TYPE text;
ALTER TABLE sys_audit_log ALTER COLUMN string_params TYPE text;
ALTER TABLE sys_audit_log ALTER COLUMN object_params TYPE text;
ALTER TABLE sys_audit_log ALTER COLUMN request_referer TYPE text;