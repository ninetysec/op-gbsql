-- auto gen by george 2017-12-31 21:30:16
SELECT redo_sqls($$
 alter table game_api_log alter api_transaction_id type VARCHAR(64);
$$);