-- auto gen by longer 2016-02-21 17:05:36
-- from V1.0.1.0005__A_gamebox_api.sql.sql

select redo_sqls($$
alter table game_api_interface ALTER column ext_json TYPE varchar(1500);
alter table game_api_provider ALTER column ext_json TYPE varchar(1500);
$$);