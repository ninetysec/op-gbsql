-- auto gen by bruce 2016-09-17 14:08:17
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'common', 'remark_type', 'activity', 12, '备注类型：优惠申请审核', '', 't'
  WHERE 'activity' NOT IN (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='remark_type');