-- auto gen by linsen 2018-03-09 16:23:51
-- APP应用更新表 by carl
CREATE TABLE if not EXISTS site_app_update (
	id serial4 NOT NULL,
	app_name VARCHAR(50) NOT NULL,
	app_type VARCHAR(50) NULL,
	version_code int4 NOT NULL,
	site_id int4 NOT NULL,
	version_name varchar(50) NOT NULL,
	app_url varchar(255) NOT NULL,
	memo VARCHAR(500) NULL,
	update_time TIMESTAMP(6),
	md5 VARCHAR(32),
	CONSTRAINT "site_app_update_pkey" PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE site_app_update IS 'APP应用更新表 -- mical';

COMMENT ON COLUMN site_app_update.id IS '主键';

COMMENT ON COLUMN site_app_update.app_name IS '应用名称';

COMMENT ON COLUMN site_app_update.app_type IS '应用类别：ios, android';

COMMENT ON COLUMN site_app_update.version_code IS '版本代号';

COMMENT ON COLUMN site_app_update.site_id IS '站点id';

COMMENT ON COLUMN site_app_update.version_name IS '版本号';

COMMENT ON COLUMN site_app_update.app_url IS '下载地址';

COMMENT ON COLUMN site_app_update.memo IS '更新描述';

COMMENT ON COLUMN site_app_update.update_time IS '更新时间';

COMMENT ON COLUMN site_app_update.md5 IS 'MD5校验码：上个版本version_code加密，秘钥app_type';