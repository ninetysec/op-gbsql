select redo_sqls($$
alter table game_api_interface ALTER column ext_json TYPE varchar(500);
alter table game_api_provider ALTER column ext_json TYPE varchar(500);
alter table game_api_interface ALTER column api_action TYPE varchar(200);

alter table game_api_interface_request ALTER column reg_exp TYPE varchar(300);
alter table game_api_interface_request ALTER column comment TYPE varchar(300);
$$);