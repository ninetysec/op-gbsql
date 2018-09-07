-- auto gen by linsen 2018-08-10 11:39:06
-- 创建站点开关表 by martin
CREATE TABLE IF NOT EXISTS sys_site_switch
(
  id           SERIAL4 PRIMARY KEY,
  switch_code  VARCHAR(32)          NOT NULL,
  switch_value BOOLEAN DEFAULT FALSE NOT NULL,
  remark       VARCHAR(128),
  site_id      INTEGER,
  create_user  VARCHAR(32),
  create_time  TIMESTAMP,
  update_user  VARCHAR(32),
  update_time  TIMESTAMP
);

COMMENT ON TABLE sys_site_switch IS '站点开关表 - martin';

COMMENT ON COLUMN sys_site_switch.id IS '开关ID,主键';

COMMENT ON COLUMN sys_site_switch.switch_code IS '开关代码 - SiteSwitchCodeEnum';

COMMENT ON COLUMN sys_site_switch.switch_value IS '开关值(true:打开/false:关闭)';

COMMENT ON COLUMN sys_site_switch.remark IS '备注';

COMMENT ON COLUMN sys_site_switch.site_id IS '站点id';

COMMENT ON COLUMN sys_site_switch.create_user IS '创建人';

COMMENT ON COLUMN sys_site_switch.create_time IS '创建时间';

COMMENT ON COLUMN sys_site_switch.update_user IS '修改人';

COMMENT ON COLUMN sys_site_switch.update_time IS '修改时间';


SELECT redo_sqls($$

CREATE INDEX fk_sys_site_switch_site_id ON sys_site_switch (site_id);

CREATE INDEX index_sys_site_switch_code ON sys_site_switch (switch_code);

ALTER TABLE sys_site_switch ADD CONSTRAINT unique_sys_site_switch_code UNIQUE (site_id, switch_code);

$$);

