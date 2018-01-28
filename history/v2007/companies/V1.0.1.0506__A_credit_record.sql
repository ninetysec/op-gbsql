-- auto gen by george 2018-01-04 15:22:44
SELECT redo_sqls($$
  ALTER TABLE credit_record ADD COLUMN exchange_rate numeric(20,4);
$$);
COMMENT ON COLUMN credit_record.exchange_rate is '汇率';