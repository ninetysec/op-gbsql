-- auto gen by cheery 2015-09-21 03:18:39
--修改优惠稽核倍数类型
 select redo_sqls($$
  ALTER TABLE player_favorable ALTER COLUMN audit_favorable_multiple TYPE NUMERIC(20,2);
$$);
