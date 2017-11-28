-- auto gen by jerry 2016-12-16 09:55:13
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '9', '分析', NULL, '', NULL, '', '5', 'mcenter', 'mcenter:analyze', '1', '', 't', 't', 't'
WHERE 9 not in(select id from sys_resource where id=9);

DELETE FROM  sys_param WHERE param_type='domain_type';



DELETE FROM  user_task_reminder WHERE parent_code='pay';