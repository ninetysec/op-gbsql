-- auto gen by cheery 2015-09-08 20:11:09
--字典表 - 添加备注类型
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','remark_type','artificial_draw',9,'备注类型：手动取款',true
WHERE 'artificial_draw' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'remark_type');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','remark_type','artificial_deposit',8,'备注类型：手动存款',true
WHERE 'artificial_deposit' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'remark_type');


--字典表 - 添加备注标题
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','remark_title','despoit_fee',5,'备注标题：存款手续费',true
WHERE 'despoit_fee' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'remark_title');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','remark_title','despoit_sale',4,'备注标题：存款优惠',true
WHERE 'despoit_sale' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'remark_title');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','remark_title','artificial',3,'备注标题：手动存取款备注',true
WHERE 'artificial' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'remark_title');
