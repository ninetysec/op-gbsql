-- auto gen by cherry 2017-11-03 20:02:57
select redo_sqls($$
    ALTER TABLE player_rank ADD COLUMN display_company_account BOOLEAN;
  $$);

COMMENT ON COLUMN player_rank.display_company_account is '该层级公司入款是否展示多个账号';