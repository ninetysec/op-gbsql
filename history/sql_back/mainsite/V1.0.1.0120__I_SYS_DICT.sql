-- auto gen by tom 2015-11-26 14:13:29
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','remark_type','buildsite_netscheme',8,'备注类型：新增站点-包网方案备注',true
WHERE 'buildsite_netscheme' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'remark_type');