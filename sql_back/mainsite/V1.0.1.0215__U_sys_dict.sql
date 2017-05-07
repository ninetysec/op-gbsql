-- auto gen by orange 2016-01-06 15:41:35
--修改字典表是否稽核
update sys_dict set dict_code = true where  id = (
	select id from sys_dict where  dict_type = 'is_audit' and dict_code = '1'
);

update sys_dict set dict_code = false where  id = (
	select id from sys_dict where  dict_type = 'is_audit' and dict_code = '2'
);