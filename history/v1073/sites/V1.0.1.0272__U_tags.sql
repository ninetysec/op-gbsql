-- auto gen by bruce 2016-10-01 20:24:42
DELETE FROM tags WHERE built_in = 'TRUE' AND tag_name='VIP通道';

INSERT INTO "tags" ("id","tag_name", "tag_type", "tag_describe","built_in","quantity") SELECT 0,'VIP通道', '0', '有该标签的玩家,可使用VIP通道访问站点.VIP通道地址,请咨询客服获取.','t',100
  WHERE 'TRUE' NOT IN (SELECT built_in FROM tags WHERE built_in='TRUE ');