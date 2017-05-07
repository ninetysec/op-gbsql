-- auto gen by cherry 2016-01-19 09:09:23
drop view IF EXISTS v_ctt_float_pic;

drop table  IF EXISTS ctt_float_pic_temp;

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
  SELECT 50401,'返水统计导出','report/rakeback/detail/exportRecords.html','',504,'',1,'mcenter','test:view','2','',true,true,true
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 50401);
