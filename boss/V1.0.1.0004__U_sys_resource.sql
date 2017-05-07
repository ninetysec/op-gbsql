-- auto gen by cherry 2016-02-05 11:58:01
update sys_resource set name = '子账号',url = 'subAccount/list.html' where name = '系统账号' AND subsys_code = 'boss';