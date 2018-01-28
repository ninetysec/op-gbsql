-- auto gen by george 2018-01-25 19:21:09
CREATE TABLE IF NOT EXISTS "api_game_log" (
"id" SERIAL4  NOT NULL PRIMARY KEY,
"site_id" int4 NOT NULL,
"start_time" timestamp(6),
"update_time" timestamp(6),
"type" varchar(1) COLLATE "default"
);

COMMENT ON TABLE api_game_log is '同步游戏数据进度表';

COMMENT ON COLUMN api_game_log.id is '主键';

COMMENT ON COLUMN api_game_log.site_id is '站点id';

COMMENT ON COLUMN api_game_log.start_time is '开始时间';

COMMENT ON COLUMN api_game_log.update_time is '更新时间';

COMMENT ON COLUMN api_game_log.type is '类型：0-收藏,1-评分';