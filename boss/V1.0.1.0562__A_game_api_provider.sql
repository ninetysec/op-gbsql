-- auto gen by steffan 2018-05-11 17:30:21
-- add by leo
select redo_sqls($$
    ALTER TABLE game_api_provider ADD COLUMN is_resend boolean DEFAULT FALSE ;
  $$);
COMMENT ON COLUMN game_api_provider.is_resend IS '是否支持重发';