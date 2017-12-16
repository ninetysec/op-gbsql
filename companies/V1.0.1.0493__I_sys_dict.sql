-- auto gen by george 2017-12-16 13:49:58
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'content', 'carousel_type', 'carousel_type_phone_dialog', '6', '广告类别-手机弹窗广告', '', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_type='carousel_type' AND dict_code='carousel_type_phone_dialog');
