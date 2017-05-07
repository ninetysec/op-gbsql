-- auto gen by mark 2015-10-08 08:43:30
--取款订单序列
select redo_sqls($$
  CREATE SEQUENCE order_id_withdraw_seq INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999 START 1 CACHE 100;
$$);


