-- auto gen by tony 2015-10-15 21:45:23

update sys_resource set name=substring(name, 0 ,3)
--select * from sys_resource
where subsys_code='mcenter' and resource_type=1 and parent_id is NULL
