-- auto gen by cherry 2016-12-28 15:29:37
select redo_sqls($$
       ALTER TABLE pay_account ADD COLUMN terminal varchar(2);
$$);