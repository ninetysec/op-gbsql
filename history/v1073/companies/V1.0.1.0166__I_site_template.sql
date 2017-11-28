-- auto gen by cherry 2016-09-04 19:42:06
UPDATE site_template SET pic_path='images/venetian.png' WHERE code ='venetian';

INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
SELECT 'betweide', '2', '1200', '1', '1200 px 韦德模板', NULL, 'images/betweide.png'
WHERE not EXISTS(SELECT id FROM site_template where code='betweide');

INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
SELECT 'casino777', '2', '1200', '1', '1200 px 电子777模板', NULL, 'images/casino777.png'
WHERE not EXISTS(SELECT id FROM site_template where code='casino777');

INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
SELECT 'casinoPt', '2', '1200', '1', '1200 px 电子PT模板', NULL, 'images/casinoPt.png'
WHERE not EXISTS(SELECT id FROM site_template where code='casinoPt');

INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
SELECT 'lol', '2', '1200', '1', '1200 px 英雄联盟模板', NULL, 'images/lol.png'
WHERE not EXISTS(SELECT id FROM site_template where code='lol');

INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
SELECT 'parisian', '2', '1200', '1', '1200 px 巴黎人模板', NULL, 'images/parisian.png'
WHERE not EXISTS(SELECT id FROM site_template where code='parisian');

INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
SELECT 'yongli01', '2', '1200', '1', '1200 px 新永利模板', NULL, 'images/yongli01.png'
WHERE not EXISTS(SELECT id FROM site_template where code='yongli01');

