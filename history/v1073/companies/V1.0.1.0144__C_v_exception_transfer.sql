-- auto gen by cherry 2016-08-10 14:26:50
 select redo_sqls($$
     ALTER TABLE exception_transfer ADD COLUMN handle_name VARCHAR(32);
$$);
COMMENT on COLUMN exception_transfer.handle_name is '操作人';

DROP VIEW if EXISTS v_exception_transfer;
CREATE OR REPLACE VIEW  "v_exception_transfer" AS
 SELECT t1.id,
    t1.company_id,
    t1.master_id,
    t1.site_id,
    t1.player_id,
    t1.player_name,
    t1.order_no,
    t1.order_type,
    t1.order_status,
    t1.api_id,
    t1.currency_code,
    t1.money,
    t1.transfer_time,
    t1.create_time,
    t1.handler_id,
    t1.handl_time,
    t1.api_trans_id,
    t1.account,
		t1.handle_name,
    t2.username AS comanyname,
    t3.username AS mastername,
    t5.value AS sitename,
    t5.locale
   FROM exception_transfer t1
     LEFT JOIN sys_user t2 ON t1.company_id = t2.id
     LEFT JOIN sys_user t3 ON t1.master_id = t3.id
     LEFT JOIN ( SELECT t4.id,
            t4.module,
            t4.type,
            t4.key,
            t4.locale,
            t4.value,
            t4.site_id,
            t4.default_value
           FROM site_i18n t4
          WHERE t4.type = 'site_name') t5 ON t1.site_id = t5.site_id;

COMMENT ON VIEW "v_exception_transfer" IS '异常转账视图';