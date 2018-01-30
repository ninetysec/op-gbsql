-- auto gen by george 2018-01-16 20:50:41
INSERT INTO  "sys_resource" ( "id","name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select  '407','域名检测', 'operation/domainCheckData/getDomainCount.html', '运营-运营检测', '4', NULL, '8', 'mcenter', 'mcenter:domainCheck', '1', 'icon-huodongguanli', 't', 'f', 'f'
where not EXISTS (SELECT id FROM sys_resource where id='407' );