-- auto gen by george 2017-12-31 21:30:16
SELECT redo_sqls($$
alter table game_api_log alter api_transaction_id type VARCHAR(64);
alter table game_api_log alter api_account type VARCHAR(16);
alter table game_api_log alter user_name type VARCHAR(16);
alter table game_api_log alter api_name type VARCHAR(10);
alter table game_api_log alter transaction_no type VARCHAR(32);
alter table game_api_log alter status_desc type VARCHAR(100);
alter table game_api_log alter api_status_code type VARCHAR(30);
alter table game_api_log alter api_status_desc type VARCHAR(400);
alter table game_api_log alter context type VARCHAR(500);
$$);