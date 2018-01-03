-- auto gen by bruce 2016-09-17 14:57:57
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'content', 'carousel_type', 'carousel_type_phone', 5, '广告类别-手机轮播图', '', 't'
  WHERE 'carousel_type_phone' NOT IN (SELECT dict_code FROM sys_dict WHERE module='content' and dict_type='carousel_type');