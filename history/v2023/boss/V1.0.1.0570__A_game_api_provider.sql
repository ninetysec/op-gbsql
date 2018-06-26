-- auto gen by steffan 2018-05-22 14:19:47 add by mical
select redo_sqls($$
  ALTER table game_api_provider add column proxy bool;
$$);
COMMENT ON COLUMN "game_api_provider"."proxy" IS '是否支持代理';


select redo_sqls($$
    ALTER TABLE game_api_provider ADD COLUMN api_origin_url VARCHAR(128);
  $$);

COMMENT ON COLUMN "game_api_provider"."api_origin_url" IS 'API请求原地址';