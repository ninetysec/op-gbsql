-- auto gen by cheery 2015-10-09 09:57:03
--删除充值父类型：手动删除，再重新新增，因为前面写sql写错单词了
DELETE from sys_dict WHERE dict_code='artificial_deposit' AND "module"='fund' AND dict_type='recharge_type_parent';

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'fund','recharge_type_parent','artificial_deposit',3,'充值父类型：手动存款',true
WHERE 'artificial_deposit' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_type_parent');
