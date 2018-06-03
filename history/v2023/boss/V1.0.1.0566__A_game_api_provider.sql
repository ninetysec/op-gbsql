-- auto gen by steffan 2018-05-16 17:58:26
-- alter by jimmy
select redo_sqls($$
     ALTER TABLE game_api_provider ADD COLUMN resend_intervals int4 DEFAULT 12 ;
  $$);
COMMENT ON COLUMN game_api_provider.resend_intervals IS '重发间隔时间,单位小时,默认为12小时';