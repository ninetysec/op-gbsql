-- auto gen by admin 2016-11-22 20:37:21delete from sys_dict where module = 'fund' and dict_type = 'check_result';INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)SELECT 'fund','check_result','1',1,'正常',trueWHERE '1' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'check_result');INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)SELECT 'fund','check_result','2',2,'异常',trueWHERE '2' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'check_result');INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)SELECT 'fund','check_result','3',3,'待确认',trueWHERE '3' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'check_result');