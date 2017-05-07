-- auto gen by longer 2015-12-27 14:31:34

--站长虚拟账号
DELETE  from sys_user where id = -8888;
INSERT into sys_user(id,username,password,user_type,subsys_code) SELECT -8888,'__admin__','','21','mcenter' where not exists( select id from sys_user where id = -8888) ;
