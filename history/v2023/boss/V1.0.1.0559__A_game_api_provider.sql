-- auto gen by cherry 2018-05-10 09:54:05
select redo_sqls($$
  ALTER table game_api_provider add column proxy bool;
$$);
COMMENT ON COLUMN "game_api_provider"."proxy" IS '是否支持代理';