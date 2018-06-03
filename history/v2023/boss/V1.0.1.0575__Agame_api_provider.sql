-- auto gen by steffan 2018-05-28 15:17:25 alter by mical
select redo_sqls($$
alter table game_api_provider ALTER column api_origin_url TYPE varchar(1500);
$$);