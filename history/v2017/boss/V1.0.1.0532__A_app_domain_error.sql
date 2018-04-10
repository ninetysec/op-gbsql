-- auto gen by linsen 2018-03-14 09:15:47
-- 修改app_domain_error表code长度为255 by kobe

select redo_sqls($$
  ALTER table app_domain_error alter column code type varchar(255);
$$);