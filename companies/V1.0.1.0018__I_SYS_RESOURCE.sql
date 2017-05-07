-- auto gen by tom 2016-02-21 11:31:30
insert into sys_resource(name,url,remark,parent_id,structure,sort_num,subsys_code,permission,resource_type,icon,built_in,privilege,status)
select '运营商站长重置密码','vMasterManage/resetPwdByHand.html','站点-站长管理-重置密码',301,null,5,'ccenter','site:mastermanage:resetPwdByHand','2',null,false,true,TRUE
where 'vMasterManage/resetPwdByHand.html' not in (select url from sys_resource where parent_id=301)