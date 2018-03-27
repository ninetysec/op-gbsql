-- auto gen by linsen 2018-01-28 18:00:13
CREATE TABLE IF NOT EXISTS app_domain_error(
        id serial4 PRIMARY KEY,
	site_id int4 NOT NULL,
	username varchar(32),
	last_login_time timestamp(6),
	domain text NOT NULL,
	ip int8,
	error_message text,
	code varchar(8),
	create_time timestamp(6)
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "app_domain_error" IS '收集app错误域名 -- kobe';

COMMENT ON COLUMN "app_domain_error"."id" IS '主键';

COMMENT ON COLUMN "app_domain_error"."site_id" IS '站点ID';

COMMENT ON COLUMN "app_domain_error"."username" IS '用户名';

COMMENT ON COLUMN "app_domain_error"."last_login_time" IS '最后登录时间';

COMMENT ON COLUMN "app_domain_error"."domain" IS '域名';

COMMENT ON COLUMN "app_domain_error"."ip" IS 'IP';

COMMENT ON COLUMN "app_domain_error"."error_message" IS '错误信息';

COMMENT ON COLUMN "app_domain_error"."code" IS '错误代码';

COMMENT ON COLUMN "app_domain_error"."create_time" IS '创建时间';