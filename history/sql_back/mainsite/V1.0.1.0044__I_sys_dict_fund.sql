-- auto gen by longer 2015-10-22 20:35:40

--Longer 从V1.0.1.0131__U_sys_resource_lorne.sql 转移过来
INSERT INTO "sys_dict" ("id", "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT '766', 'agent', 'fund_record_type', '1', '1', '返佣', NULL, 't'
  WHERE 766  not in (SELECT id from sys_dict where id = 766 );

INSERT INTO "sys_dict" ("id", "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT '768','agent', 'fund_record_type', '2', '2', '取款', NULL, 't'
  WHERE 768 not in (SELECT id from sys_dict where id = 768 );
