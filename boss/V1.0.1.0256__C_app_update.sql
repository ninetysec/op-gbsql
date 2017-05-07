CREATE TABLE if not EXISTS app_update (
	id serial4 NOT NULL,
	app_name VARCHAR(20) NOT NULL,
	app_type VARCHAR(20) NULL,
	version_code int4 NOT NULL,
	version_name varchar(10) NOT NULL,
	app_url varchar(255) NOT NULL,
	memo VARCHAR(500) NULL,
	update_time TIMESTAMP(6),
	md5 VARCHAR(32),
	CONSTRAINT "app_update_pkey" PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE app_update IS '应用更新表 -- Fei';

COMMENT ON COLUMN app_update.id IS '主键';

COMMENT ON COLUMN app_update.app_name IS '应用名称';

COMMENT ON COLUMN app_update.app_type IS '应用类别：ios, android';

COMMENT ON COLUMN app_update.version_code IS '版本代号';

COMMENT ON COLUMN app_update.version_name IS '版本号';

COMMENT ON COLUMN app_update.app_url IS '下载地址';

COMMENT ON COLUMN app_update.memo IS '更新描述';

COMMENT ON COLUMN app_update.update_time IS '更新时间';

COMMENT ON COLUMN app_update.md5 IS 'MD5校验码：上个版本version_code加密，秘钥app_type';

INSERT INTO "app_update" ("id", "app_name", "app_type", "version_code", "version_name", "app_url", "memo", "update_time", "md5")
SELECT '1', 'Gamebox-1.0.0.apk', 'android', '1', '1.0.0', 'app/download.html', 'This is start...', '2016-10-01 14:45:51', ''
WHERE not EXISTS(SELECT id FROM app_update WHERE id=1);

INSERT INTO "app_update" ("id", "app_name", "app_type", "version_code", "version_name", "app_url", "memo", "update_time", "md5")
SELECT '2', 'Gamebox-1.2.0.apk', 'android', '2', '1.2.0', 'app/download.html', 'This is 1.2.0', '2016-11-01 14:46:08', 'c254fb40712588d8229211c979fc8d54'
WHERE not EXISTS(SELECT id FROM app_update WHERE id=2);

INSERT INTO "app_update" ("id", "app_name", "app_type", "version_code", "version_name", "app_url", "memo", "update_time", "md5")
SELECT '3', 'Gamebox-2.0.0.apk', 'android', '3', '2.0.0', 'app/download.html', 'This is 2.0.0', '2016-12-07 14:46:47', '9a1dd17fdab667c0af2ffd737c97c936'
WHERE not EXISTS(SELECT id FROM app_update WHERE id=3);
