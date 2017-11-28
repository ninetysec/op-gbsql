-- auto gen by cherry 2016-11-12 10:15:41
alter table sys_audit_log alter column request_form_data TYPE text;

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '508', '转账记录', 'report/fundsTrans/apiTrans.html', '转入转出', '5', '', '8', 'mcenter', 'report:fundrecord', '1', 'icon-zijinjilu', 't', 'f', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource where id=508);
