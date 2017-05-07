-- auto gen by cheery 2015-09-10 11:51:42
--新增词典：交易类型-返佣
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'common','transaction_type','rebate',4,'交易类型:返佣',true
WHERE 'rebate' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_type');

