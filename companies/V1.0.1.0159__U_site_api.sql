-- auto gen by bruce 2016-08-24 10:00:49
select redo_sqls($$
    ALTER TABLE site_api ADD COLUMN transferable BOOL;
  $$);
COMMENT ON COLUMN site_api.transferable IS '开启关闭转账';