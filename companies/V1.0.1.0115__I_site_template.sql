-- auto gen by bruce 2016-06-21 15:05:00
INSERT INTO "site_template" ("code", "fee_type", "pixels", "terminal", "description", "price", "pic_path")
  SELECT 'xpj', '2', '1200', '1', '1200 px  新葡京模板', NULL, 'images/xpj.png'
  WHERE 'xpj' not in (SELECT code FROM site_template where code='xpj');