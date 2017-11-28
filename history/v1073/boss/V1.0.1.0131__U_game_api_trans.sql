-- auto gen by Alvin 2016-09-20 09:29:56
select redo_sqls($$
    alter table game_api_transaction add COLUMN request_code int4 DEFAULT 0;
    alter table game_api_transaction add COLUMN request_status VARCHAR(500) DEFAULT '';
    alter table game_api_transaction add COLUMN check_code int4 DEFAULT 0;
    alter table game_api_transaction add COLUMN check_num int4 DEFAULT 0;
    alter table game_api_transaction add COLUMN check_status VARCHAR(500) DEFAULT '';
$$);

COMMENT ON COLUMN game_api_transaction.request_code IS '首次请求代码';
COMMENT ON COLUMN game_api_transaction.request_status IS '首次请求状态';
COMMENT ON COLUMN game_api_transaction.check_code IS '检查请求代码';
COMMENT ON COLUMN game_api_transaction.check_num IS '检查次数';
COMMENT ON COLUMN game_api_transaction.check_status IS '检查请求状态';