-- auto gen by longer 2015-11-24 15:47:44

CREATE TABLE IF NOT EXISTS system_announcement (
  id SERIAL4 PRIMARY KEY NOT NULL ,
  release_mode CHARACTER VARYING(64), -- 发布方式
  publish_time TIMESTAMP(6) WITHOUT TIME ZONE, -- 发布时间
  publish_user_id INTEGER -- 发布人id
);
COMMENT ON TABLE system_announcement IS '系统公告表--orange';
COMMENT ON COLUMN system_announcement.id IS '主键';
COMMENT ON COLUMN system_announcement.release_mode IS '发布方式';
COMMENT ON COLUMN system_announcement.publish_time IS '发布时间';
COMMENT ON COLUMN system_announcement.publish_user_id IS '发布人id';

CREATE TABLE IF NOT EXISTS system_announcement_i18n (
  id SERIAL4 PRIMARY KEY NOT NULL ,
  system_announcement_id INTEGER, -- 系统公告表ID
  local CHARACTER(5), -- 语言版本(site_language)
  title CHARACTER VARYING(100), -- 标题
  content CHARACTER VARYING(2000) -- 内容
);
COMMENT ON TABLE system_announcement_i18n IS '系统公告国际化表--orange';
COMMENT ON COLUMN system_announcement_i18n.id IS '主键';
COMMENT ON COLUMN system_announcement_i18n.system_announcement_id IS '系统公告表ID';
COMMENT ON COLUMN system_announcement_i18n.local IS '语言版本(site_language)';
COMMENT ON COLUMN system_announcement_i18n.title IS '标题';
COMMENT ON COLUMN system_announcement_i18n.content IS '内容';

-- Orange 遗漏的脚本
CREATE OR REPLACE VIEW "v_system_announcement" AS
  SELECT s.id,
    s.release_mode,
    s.publish_time,
    s.publish_user_id,
    a.local,
    a.title,
    a.content,
    u.username
  FROM system_announcement s
    LEFT JOIN system_announcement_i18n a ON a.system_announcement_id = s.id
    LEFT JOIN sys_user u ON u.id = s.publish_user_id;

ALTER TABLE "v_system_announcement" OWNER TO "postgres";

COMMENT ON VIEW v_system_announcement  IS '系统公告视图 --orange';

