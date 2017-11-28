-- auto gen by bruce 2016-08-29 17:01:44
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  select 'content', 'float_pic_display_in', '5', '2', '注册页', NULL, 't'
  where '5' not in (select dict_code from sys_dict where module='content' and dict_type='float_pic_display_in');