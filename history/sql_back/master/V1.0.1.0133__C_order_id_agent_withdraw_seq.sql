-- auto gen by mark 2015-10-21 14:22:19
--代理提现订单序列
select redo_sqls($$
CREATE SEQUENCE order_id_agent_withdraw_seq INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999 START 1 CACHE 100;
$$);
