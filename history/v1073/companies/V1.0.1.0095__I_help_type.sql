-- auto gen by admin 2016-05-10 16:29:31
INSERT INTO "help_type" ("id", "is_delete", "parent_id", "order_num") SELECT 61, false, 3, 9 where 61 not in (SELECT "id" from help_type where "id" = 61);

INSERT INTO "help_type_i18n" ("id", "help_type_id", "name", "local") SELECT '181', '61', '优惠活动', 'zh_CN' where 181 not in (SELECT id from help_type_i18n where id=181);

INSERT INTO "help_type_i18n" ("id", "help_type_id", "name", "local") SELECT '182', '61', '优惠活动', 'zh_TW' where 182 not in (SELECT id from help_type_i18n where id=182);

INSERT INTO "help_type_i18n" ("id", "help_type_id", "name", "local") SELECT '183', '61', '优惠活动', 'en_US' where 183 not in (SELECT id from help_type_i18n where id=183);

INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
SELECT 'yongli', '2', '1200', '1', '1200 px  澳门永利模板', NULL, 'images/yongli.png'
where 'yongli' not in (SELECT code FROM site_template where code='yongli');