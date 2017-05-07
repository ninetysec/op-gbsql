-- auto gen by cherry 2016-11-14 15:10:49
update sys_resource set url='param/siteParam.html' where id=701;

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 70101,'基础设置','param/basicSettingIndex.html','基础设置',701,NULL,1,'mcenter','system:basicsetting_setting','2',NULL,true,false,true
WHERE NOT EXISTS (select id from sys_resource t where t.id = 70101);

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 70102,'偏好设置','setting/preference/index.html','偏好设置',701,NULL,2,'mcenter','system:basicsetting_preference','2',NULL,true,false,true
WHERE NOT EXISTS (select id from sys_resource t where t.id = 70102);

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 70103,'玩家导入','vUserPlayerImport/list.html','玩家导入',701,NULL,3,'mcenter','system:basicsetting_playerimport','2',NULL,true,false,true
WHERE NOT EXISTS (select id from sys_resource t where t.id = 70103);