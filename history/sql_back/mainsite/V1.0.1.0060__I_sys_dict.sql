-- auto gen by cheery 2015-11-02 19:23:28
--添加交易类型-推荐
INSERT INTO sys_dict ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'transaction_type', 'recommend', '6', '交易类型：推荐', NULL, 't'
  WHERE 'recommend' not in (SELECT dict_code from sys_dict where module = 'common' and dict_type = 'transaction_type');
