-- auto gen by bruce 2017-03-13 09:32:57
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
	SELECT 'fund','rebate_status','0',1,'未处理',true
	WHERE '1' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'rebate_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
	SELECT 'fund','rebate_status','1',2,'未达到门坎',true
	WHERE '2' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'rebate_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
	SELECT 'fund','rebate_status','2',3,'清除',true
	WHERE '3' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'rebate_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
	SELECT 'fund','rebate_status','3',4,'已结算',true
	WHERE '4' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'rebate_status');