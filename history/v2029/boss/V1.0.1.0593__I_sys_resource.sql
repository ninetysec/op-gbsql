-- auto gen by steffan 2018-08-07 17:57:33
-- 同步单个站点参数
insert into sys_resource(id,name,url,remark,parent_id,structure,sort_num,subsys_code,permission,resource_type,icon,built_in,privilege,status)
select 30624 ,'同步单个站点参数','sysSite/syncSitesParam.html','平台-站点管理-查看站点信息-同步单个站点参数',30608,null,24,'boss','platform:sync_sites_param','2',null,false,false,TRUE
where not exists  (select url from sys_resource where id=30624);

-- 同步所有站点参数
insert into sys_resource(id,name,url,remark,parent_id,structure,sort_num,subsys_code,permission,resource_type,icon,built_in,privilege,status)
select 309, '同步所有站点参数','sysSite/syncAllSitesParam.html','平台-站点管理-同步所有站点参数',306,null,24,'boss','platform:sync_all_sites_param','2',null,false,false,TRUE
where not exists  (select url from sys_resource where id=309);