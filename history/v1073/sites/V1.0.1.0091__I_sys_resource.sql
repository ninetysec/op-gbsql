-- auto gen by admin 2016-04-10 20:35:39
insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)

  SELECT 60801,'API资金回收','vSiteGame/withdrawBalance.html','API资金回收',608,'',1,'mcenter','content:game:withdrawBalance','2','',true,true,true

  WHERE NOT EXISTS (select id from sys_resource t where t.id = 60801);