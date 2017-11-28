-- auto gen by cherry 2016-01-06 15:13:38
DROP TABLE IF EXISTS site_backwater_api;
DROP TABLE IF EXISTS site_backwater_gametype;
DROP TABLE IF EXISTS site_backwater_player;

-- 站点返水玩家 --
CREATE TABLE IF NOT EXISTS site_rakeback_player
(
  id            serial4  NOT NULL, -- 主键
  center_id     int4 NOT null, -- 运营商ID
  master_id     int4 NOT NULL, -- 站长ID
  site_id       int4 NOT NULL, -- 站点ID
  player_count  int4 NULL,     -- 返水玩家数
  rakeback_total   numeric(20,2) NULL,   -- 应付返水
  rakeback_actual  numeric(20,2) NULL,  -- 实付返水
  rakeback_year    int4  NULL, -- 返水年份
  rakeback_month   int4 NULL, -- 返水月份
  static_time       timestamp NULL, -- 统计时间
  CONSTRAINT pk_site_rakeback_player_id PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE site_rakeback_player
  OWNER TO postgres;
COMMENT ON TABLE site_rakeback_player IS '站点返水玩家 -- Fly';
COMMENT ON COLUMN site_rakeback_player.id IS '主键';
COMMENT ON COLUMN site_rakeback_player.center_id IS '运营商ID';
COMMENT ON COLUMN site_rakeback_player.master_id IS '站长ID';
COMMENT ON COLUMN site_rakeback_player.site_id IS '站点ID';
COMMENT ON COLUMN site_rakeback_player.player_count IS '返水玩家数';
COMMENT ON COLUMN site_rakeback_player.rakeback_total IS '应付返水';
COMMENT ON COLUMN site_rakeback_player.rakeback_actual IS '实付返水';
COMMENT ON COLUMN site_rakeback_player.rakeback_year IS '返水年份';
COMMENT ON COLUMN site_rakeback_player.rakeback_month IS '返水月份';
COMMENT ON COLUMN site_rakeback_player.static_time IS '统计时间';

-- 站点API返水 --
CREATE TABLE IF NOT EXISTS site_rakeback_api
(
  id            serial4  NOT NULL, -- 主键
  center_id     int4 NOT null, -- 运营商ID
  master_id     int4 NOT NULL, -- 站长ID
  site_id       int4 NOT NULL, -- 站点ID
  api_id        int4 NOT NULL,     -- API主键
  rakeback     numeric(20,2) NULL,   -- 总返水
  rakeback_year  int4  NULL,  -- 返水年份
  rakeback_month int4 NULL,   -- 返水月份
  static_time     timestamp NULL, -- 统计时间
  CONSTRAINT pk_site_rakeback_api_id PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE site_rakeback_api
  OWNER TO postgres;
COMMENT ON TABLE site_rakeback_api  IS '站点API返水 -- Fly';
COMMENT ON COLUMN site_rakeback_api.id IS '主键';
COMMENT ON COLUMN site_rakeback_api.center_id IS '运营商ID';
COMMENT ON COLUMN site_rakeback_api.master_id IS '站长ID';
COMMENT ON COLUMN site_rakeback_api.site_id IS '站点ID';
COMMENT ON COLUMN site_rakeback_api.api_id IS 'API主键';
COMMENT ON COLUMN site_rakeback_api.rakeback IS '总返水';
COMMENT ON COLUMN site_rakeback_api.rakeback_year IS '返水年份';
COMMENT ON COLUMN site_rakeback_api.rakeback_month IS '返水月份';
COMMENT ON COLUMN site_rakeback_api.static_time IS '统计时间';

-- 站点游戏分类返水 --
CREATE TABLE IF NOT EXISTS site_rakeback_gametype
(
  id            serial4  NOT NULL, -- 主键
  center_id     int4 NOT null, -- 运营商ID
  master_id     int4 NOT NULL, -- 站长ID
  site_id       int4 NOT NULL, -- 站点ID
  api_id        int4 NOT NULL,     -- API主键
  game_type     varchar(2) NULL,  -- 游戏类别(API二级分类)
  rakeback numeric(20,2) NULL,   -- 总返水
  rakeback_year  int4  NULL,  -- 返水年份
  rakeback_month int4 NULL,   -- 返水月份
  static_time     timestamp NULL, -- 统计时间
  CONSTRAINT pk_site_rakeback_gametype_id PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE site_rakeback_gametype
  OWNER TO postgres;
COMMENT ON TABLE site_rakeback_gametype IS '站点游戏分类返水 -- Fly';
COMMENT ON COLUMN site_rakeback_gametype.id IS '主键';
COMMENT ON COLUMN site_rakeback_gametype.center_id IS '运营商ID';
COMMENT ON COLUMN site_rakeback_gametype.master_id IS '站长ID';
COMMENT ON COLUMN site_rakeback_gametype.site_id IS '站点ID';
COMMENT ON COLUMN site_rakeback_gametype.api_id IS 'API主键';
COMMENT ON COLUMN site_rakeback_gametype.game_type IS '游戏分类';
COMMENT ON COLUMN site_rakeback_gametype.rakeback IS '总返水';
COMMENT ON COLUMN site_rakeback_gametype.rakeback_year IS '返水年份';
COMMENT ON COLUMN site_rakeback_gametype.rakeback_month IS '返水月份';
COMMENT ON COLUMN site_rakeback_gametype.static_time IS '统计时间';

DROP INDEX IF EXISTS fk_site_rakeback_api_api_id;
DROP INDEX IF EXISTS fk_site_rakeback_api_center_id;
DROP INDEX IF EXISTS fk_site_rakeback_api_master_id;
DROP INDEX IF EXISTS fk_site_rakeback_api_site_id;
CREATE INDEX "fk_site_rakeback_api_api_id" ON "site_rakeback_api" USING btree (api_id);
CREATE INDEX "fk_site_rakeback_api_center_id" ON "site_rakeback_api" USING btree (center_id);
CREATE INDEX "fk_site_rakeback_api_master_id" ON "site_rakeback_api" USING btree (master_id);
CREATE INDEX "fk_site_rakeback_api_site_id" ON "site_rakeback_api" USING btree (site_id);