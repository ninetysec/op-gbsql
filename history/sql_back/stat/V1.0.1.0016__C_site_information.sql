-- auto gen by cheery 2015-12-07 08:00:01
--创建站点信息表
CREATE TABLE IF NOT EXISTS site_information (
  id           SERIAL4 NOT NULL PRIMARY KEY,
  center_id    INT4,
  center_name  VARCHAR(100),
  master_id    INT4,
  master_name  VARCHAR(100),
  site_id      INT4,
  site_name    VARCHAR(100),
  topagent_num INT4,
  agent_num    INT4,
  player_num   INT4
)
WITH (OIDS =FALSE
);
COMMENT ON TABLE site_information IS '站点信息表-susu';

COMMENT ON COLUMN site_information.id IS '主键';

COMMENT ON COLUMN site_information.center_id IS '运营商ID';

COMMENT ON COLUMN site_information.center_name IS '运营商名称';

COMMENT ON COLUMN site_information.master_id IS '站长ID';

COMMENT ON COLUMN site_information.master_name IS '站长名称';

COMMENT ON COLUMN site_information.site_id IS '站点ID';

COMMENT ON COLUMN site_information.site_name IS '站点名称';

COMMENT ON COLUMN site_information.topagent_num IS '总代数量';

COMMENT ON COLUMN site_information.agent_num IS '代理数量';

COMMENT ON COLUMN site_information.player_num IS '玩家数量';