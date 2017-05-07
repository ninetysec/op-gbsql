-- auto gen by tom 2015-11-23 13:43:36
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','site_status','1',1,'正常',true
WHERE '1' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'site_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','site_status','2',2,'停用',true
WHERE '2' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'site_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','site_status','3',3,'维护中',true
WHERE '3' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'site_status');