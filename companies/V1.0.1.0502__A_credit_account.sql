-- auto gen by george 2018-01-02 09:22:06
select redo_sqls($$
alter table credit_account add column use_sites VARCHAR(2048);
$$);
COMMENT ON COLUMN credit_account.use_sites IS '使用站点';