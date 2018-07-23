-- auto gen by cherry 2018-07-14 14:01:30
SELECT redo_sqls($$
ALTER TABLE site_operate ADD CONSTRAINT site_operate_ssag_uk UNIQUE (static_date, site_id, api_id, game_type);
$$);