-- auto gen by loong 2015-10-09 16:27:11
UPDATE sys_dict SET parent_code='athletic' WHERE id=586;
---字典 交易类型 添加优惠
INSERT INTO sys_dict (
  "module",
  "dict_type",
  "dict_code",
  "order_num",
  "remark",
  "parent_code",
  "active"
)
  SELECT
    'common',
    'transaction_type',
    'favorable',
    '5',
    '交易类型:优惠',
    NULL,
    't'
  WHERE 'favorable' NOT IN (
    SELECT dict_code from sys_dict WHERE dict_type = 'transaction_type' AND module = 'common'
  );