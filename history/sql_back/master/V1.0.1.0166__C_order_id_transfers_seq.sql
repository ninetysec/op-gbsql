-- auto gen by mark 2015-11-04 14:28:00
--转账订单序列
select redo_sqls($$
CREATE SEQUENCE order_id_transfers_seq INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999 START 1 CACHE 100;
$$);
