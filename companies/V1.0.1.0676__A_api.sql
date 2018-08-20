-- auto gen by linsen 2018-08-20 14:17:32
-- 添加pc和手机端备用域名字段 by linsen
SELECT redo_sqls($$
	ALTER TABLE "api" ADD COLUMN "pc_domain" varchar(128);
	ALTER TABLE "api" ADD COLUMN "mobile_domain" varchar(128);
$$);

COMMENT ON COLUMN "api"."pc_domain" IS 'PC端备用域名';
COMMENT ON COLUMN "api"."mobile_domain" IS '手机端备用域名';
