-- auto gen by cheery 2015-10-19 05:33:23
UPDATE "sys_dict"
SET "parent_code"='company_deposit' WHERE
"module"='fund' AND "dict_type"='recharge_status' AND "dict_code"='1';

UPDATE "sys_dict" SET "parent_code"='company_deposit' WHERE
"module"='fund' AND "dict_type"='recharge_status' AND "dict_code"='2';

UPDATE "sys_dict" SET  "parent_code"='company_deposit' WHERE
"module"='fund' AND "dict_type"='recharge_status' AND "dict_code"='3';

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,parent_code,active)
  SELECT 'fund', 'recharge_status', '4', '4', '线上支付状态：待支付', 'online_deposit', true
  WHERE '4' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,parent_code,active)
  SELECT 'fund', 'recharge_status', '5', '5', '线上支付状态：成功', 'online_deposit', true
  WHERE '5' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,parent_code,active)
  SELECT 'fund', 'recharge_status', '6', '6', '线上支付状态：失败', 'online_deposit', true
  WHERE '6' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_status');

INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,parent_code,active)
  SELECT 'fund', 'recharge_status', '7', '7', '线上支付状态：超时', 'online_deposit', true
  WHERE '7' not in (SELECT dict_code from sys_dict where module = 'fund' and dict_type = 'recharge_status');
