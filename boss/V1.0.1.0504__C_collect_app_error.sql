-- auto gen by george 2018-01-28 10:41:21

CREATE TABLE IF NOT EXISTS collect_app_error(
        id serial4 PRIMARY KEY,
				site_id int4 NOT NULL,
				username char(32),
				last_login_time timestamp(6),
				domain char(64) NOT NULL,
				ip char(64),
				error_message char(1024),
				code char(16),
				create_time timestamp(6)
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "collect_app_error" IS '收集app错误域名 -- kobe';

COMMENT ON COLUMN "collect_app_error"."id" IS '主键';

COMMENT ON COLUMN "collect_app_error"."site_id" IS '站点ID';

COMMENT ON COLUMN "collect_app_error"."username" IS '用户名';

COMMENT ON COLUMN "collect_app_error"."last_login_time" IS '最后登录时间';

COMMENT ON COLUMN "collect_app_error"."domain" IS '域名';

COMMENT ON COLUMN "collect_app_error"."ip" IS 'IP';

COMMENT ON COLUMN "collect_app_error"."error_message" IS '错误信息';

COMMENT ON COLUMN "collect_app_error"."code" IS '错误代码';

COMMENT ON COLUMN "collect_app_error"."create_time" IS '创建时间';