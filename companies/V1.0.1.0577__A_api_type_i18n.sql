-- auto gen by linsen 2018-03-23 17:47:43
-- api_type_i18n site_api_type_i18n 添加手机端名称字段 by carl

SELECT redo_sqls($$
	ALTER TABLE api_type_i18n ADD COLUMN mobile_name character varying(100);
	ALTER TABLE site_api_type_i18n ADD COLUMN mobile_name character varying(100);
$$);
COMMENT ON COLUMN "api_type_i18n"."name" IS 'PC端名称';
COMMENT ON COLUMN "api_type_i18n"."mobile_name" IS '手机端名称';
COMMENT ON COLUMN "site_api_type_i18n"."name" IS 'PC端名称';
COMMENT ON COLUMN "site_api_type_i18n"."mobile_name" IS '手机端名称';

-- 复制PC端名称到手机端
update api_type_i18n set mobile_name = name;
update site_api_type_i18n set mobile_name = name;

