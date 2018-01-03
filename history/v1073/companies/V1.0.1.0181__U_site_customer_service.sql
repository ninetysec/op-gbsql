-- auto gen by bruce 2016-09-18 10:30:44
UPDATE site_customer_service SET type=1 WHERE type is NULL;
UPDATE site_customer_service SET name='站点客服' WHERE name='默认客服' AND site_id > 0;
INSERT INTO "site_customer_service" ("id", "site_id", "code", "name", "parameter", "status", "create_time", "create_user", "built_in", "type")
  SELECT '-9999', '0', 'K000', '手机端客服', '', 't', '2016-01-18 07:19:04.719', '0', 't', 2 WHERE '-9999' NOT IN(SELECT id FROM site_customer_service WHERE id='-9999' AND site_id=0);