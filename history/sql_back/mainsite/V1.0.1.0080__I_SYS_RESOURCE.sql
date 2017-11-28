-- auto gen by tom 2015-11-18 09:10:16
UPDATE sys_resource SET url = 'vSysSiteManage/list.html', remark = '站点管理' WHERE parent_id = ( SELECT ID FROM sys_resource WHERE NAME = '站点' AND parent_id is null   ) and name='站点管理';

UPDATE sys_resource SET url = 'vSiteMasterManage/list.html', remark = '站长管理' WHERE parent_id = ( SELECT ID FROM sys_resource WHERE NAME = '站点' AND parent_id is null   ) and name='站长管理';