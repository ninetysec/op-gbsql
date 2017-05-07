-- auto gen by bruce 2016-08-20 16:47:56
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
  SELECT 'content', 'carousel_type', 'carousel_type_ad_dialog', '4', '广告类别-前端首页弹窗广告', NULL, 't'
  WHERE 'carousel_type_ad_dialog' NOT IN (SELECT dict_code FROM sys_dict WHERE module='content' AND dict_type='carousel_type');