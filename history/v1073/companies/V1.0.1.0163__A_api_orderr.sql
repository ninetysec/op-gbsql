-- auto gen by cherry 2016-08-31 21:05:44
 select redo_sqls($$
       ALTER TABLE api_order add COLUMN terminal varchar(9);
$$);

COMMENT on COLUMN api_order.terminal is '注单终端:1-PC 2-MOBILE';