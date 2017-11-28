-- auto gen by cherry 2017-07-26 14:18:51
  select redo_sqls($$
       ALTER TABLE digiccy_transaction ADD CONSTRAINT uk_digiccy_transaction_no UNIQUE(transaction_no);
$$);