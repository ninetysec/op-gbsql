-- auto gen by cherry 2016-01-06 14:14:10
--导入用户信息表添加主表ID
 select redo_sqls($$
    ALTER TABLE "user_player_transfer" ADD COLUMN "import_id" int4;
  $$);

COMMENT ON COLUMN "user_player_transfer"."import_id" IS '导入记录ID';

--添加导出权限
insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
  SELECT 50301,'资金记录导出','report/fundsLog/exportRecords.html','',503,'',1,'mcenter','test:view','2','',true,true,true
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 50301);

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
  SELECT 50201,'交易记录导出','report/gameTransaction/exportRecords.html','',502,'',1,'mcenter','test:view','2','',true,true,true
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 50201);

insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
  SELECT 50501,'返佣统计导出','report/rebate/detail/exportRecords.html','',505,'',1,'mcenter','test:view','2','',true,true,true
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 50501);