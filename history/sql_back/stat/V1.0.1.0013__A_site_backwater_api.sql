-- auto gen by cheery 2015-11-27 09:01:58

CREATE TABLE IF NOT EXISTS site_backwater_api (
    id SERIAL4 PRIMARY KEY NOT NULL ,
    center_id INTEGER NOT NULL, -- 运营商ID
    master_id INTEGER NOT NULL, -- 站长ID
    site_id INTEGER NOT NULL, -- 站点ID
    api_id INTEGER NOT NULL, -- API主键
    backwater_year INTEGER, -- 返水年份
    backwater_month INTEGER, -- 返水月份
    static_time TIMESTAMP WITHOUT TIME ZONE, -- 统计时间
    rakeback NUMERIC(20,2) -- 总返水
);
COMMENT ON TABLE site_backwater_api IS '站点API返水 -- Fly';
COMMENT ON COLUMN site_backwater_api.id IS '主键';
COMMENT ON COLUMN site_backwater_api.center_id IS '运营商ID';
COMMENT ON COLUMN site_backwater_api.master_id IS '站长ID';
COMMENT ON COLUMN site_backwater_api.site_id IS '站点ID';
COMMENT ON COLUMN site_backwater_api.api_id IS 'API主键';
COMMENT ON COLUMN site_backwater_api.backwater_year IS '返水年份';
COMMENT ON COLUMN site_backwater_api.backwater_month IS '返水月份';
COMMENT ON COLUMN site_backwater_api.static_time IS '统计时间';
COMMENT ON COLUMN site_backwater_api.rakeback IS '总返水';

CREATE TABLE site_backwater_player (
    id SERIAL4 PRIMARY KEY NOT NULL,
    center_id INTEGER NOT NULL, -- 运营商ID
    master_id INTEGER NOT NULL, -- 站长ID
    site_id INTEGER NOT NULL, -- 站点ID
    player_count INTEGER, -- 返水玩家数
    backwater_year INTEGER, -- 返水年份
    backwater_month INTEGER, -- 返水月份
    static_time TIMESTAMP WITHOUT TIME ZONE, -- 统计时间
    rakeback_total NUMERIC(20,2), -- 应付返水
    rakeback_actual NUMERIC(20,2) -- 实付返水
);
COMMENT ON TABLE site_backwater_player IS '站点返水玩家 -- Fly';
COMMENT ON COLUMN site_backwater_player.id IS '主键';
COMMENT ON COLUMN site_backwater_player.center_id IS '运营商ID';
COMMENT ON COLUMN site_backwater_player.master_id IS '站长ID';
COMMENT ON COLUMN site_backwater_player.site_id IS '站点ID';
COMMENT ON COLUMN site_backwater_player.player_count IS '返水玩家数';
COMMENT ON COLUMN site_backwater_player.backwater_year IS '返水年份';
COMMENT ON COLUMN site_backwater_player.backwater_month IS '返水月份';
COMMENT ON COLUMN site_backwater_player.static_time IS '统计时间';
COMMENT ON COLUMN site_backwater_player.rakeback_total IS '应付返水';
COMMENT ON COLUMN site_backwater_player.rakeback_actual IS '实付返水';


CREATE TABLE site_backwater_gametype (
    id SERIAL4 PRIMARY KEY NOT NULL,
    center_id INTEGER NOT NULL, -- 运营商ID
    master_id INTEGER NOT NULL, -- 站长ID
    site_id INTEGER NOT NULL, -- 站点ID
    api_id INTEGER NOT NULL, -- API主键
    game_type CHARACTER VARYING(2), -- 游戏二级分类(字典:game.game_type)
    backwater_year INTEGER, -- 返水年份
    backwater_month INTEGER, -- 返水月份
    static_time TIMESTAMP WITHOUT TIME ZONE, -- 统计时间
    rakeback_total NUMERIC(20,2) -- 总返水
);
COMMENT ON TABLE site_backwater_gametype IS '站点游戏分类返水 -- Fly';
COMMENT ON COLUMN site_backwater_gametype.id IS '主键';
COMMENT ON COLUMN site_backwater_gametype.center_id IS '运营商ID';
COMMENT ON COLUMN site_backwater_gametype.master_id IS '站长ID';
COMMENT ON COLUMN site_backwater_gametype.site_id IS '站点ID';
COMMENT ON COLUMN site_backwater_gametype.api_id IS 'API主键';
COMMENT ON COLUMN site_backwater_gametype.game_type IS '游戏二级分类(字典:game.game_type)';
COMMENT ON COLUMN site_backwater_gametype.backwater_year IS '返水年份';
COMMENT ON COLUMN site_backwater_gametype.backwater_month IS '返水月份';
COMMENT ON COLUMN site_backwater_gametype.static_time IS '统计时间';
COMMENT ON COLUMN site_backwater_gametype.rakeback_total IS '总返水';


ALTER TABLE site_backwater_api DROP COLUMN IF EXISTS backwater;

ALTER TABLE site_backwater_player DROP COLUMN IF EXISTS backwater_total;

ALTER TABLE site_backwater_player DROP COLUMN IF EXISTS  backwater_actual;

ALTER TABLE site_backwater_gametype DROP COLUMN IF EXISTS backwater_total;


select redo_sqls($$
    ALTER TABLE site_backwater_api ADD COLUMN rakeback NUMERIC(20,2);

    ALTER TABLE site_backwater_player ADD COLUMN rakeback_total NUMERIC(20,2);

    ALTER TABLE site_backwater_player ADD COLUMN rakeback_actual NUMERIC(20,2);

    ALTER TABLE site_backwater_gametype ADD COLUMN rakeback_total NUMERIC(20,2);

$$);

COMMENT ON COLUMN site_backwater_api.rakeback IS '总返水';

COMMENT ON COLUMN site_backwater_player.rakeback_total IS '应付返水';

COMMENT ON COLUMN site_backwater_player.rakeback_actual IS '实付返水';


COMMENT ON COLUMN site_backwater_gametype.rakeback_total IS '总返水';
