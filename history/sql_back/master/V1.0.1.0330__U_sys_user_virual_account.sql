-- auto gen by longer 2016-01-15 16:53:05

--更新站长虚拟账号ID
update sys_user set id = 0 where id = -8888;

--清理非正常用户
DELETE from sys_user where site_id is null and id >= 1;
DELETE from sys_user where length(password) < 32 and id >= 1;