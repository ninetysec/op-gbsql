-- auto gen by linsen 2018-08-23 17:29:55
-- game_api_provider添加API备用域名字段
SELECT redo_sqls($$
	ALTER TABLE "game_api_provider" ADD COLUMN "pc_domain" varchar(128);
	ALTER TABLE "game_api_provider" ADD COLUMN "mobile_domain" varchar(128);
$$);

COMMENT ON COLUMN "game_api_provider"."pc_domain" IS 'PC端备用域名';
COMMENT ON COLUMN "game_api_provider"."mobile_domain" IS '手机端备用域名';
