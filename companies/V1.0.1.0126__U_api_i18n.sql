-- auto gen by admin 2016-07-11 15:33:10
update api_i18n set name='BBIN游戏大厅' where api_id=10;

update site_api_i18n set name='BBIN游戏大厅' where api_id=10;

DROP VIEW IF EXISTS v_exception_transfer;
CREATE OR REPLACE VIEW v_exception_transfer AS
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
    t2.username AS comanyname,
    t3.username AS mastername,
    t5."value" AS sitename,
    t5.locale
  FROM exception_transfer t1
    LEFT JOIN sys_user t2 ON t1.company_id = t2.id
    LEFT JOIN sys_user t3 ON t1.master_id = t3.id
    LEFT JOIN
    (SELECT * from site_i18n t4 WHERE t4."type"='site_name') t5  ON t1.site_id = t5.site_id;