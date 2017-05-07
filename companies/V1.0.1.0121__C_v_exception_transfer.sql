-- auto gen by admin 2016-06-30 15:44:15
DROP VIEW IF EXISTS v_exception_transfer;
CREATE OR REPLACE VIEW "v_exception_transfer" AS
  SELECT  t1.id,
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
          t4."name" AS sitename
FROM exception_transfer t1
        LEFT JOIN sys_user t2 ON t1.company_id = t2.id
        LEFT JOIN sys_user t3 ON t1.master_id = t3.id
        LEFT JOIN sys_site t4 ON t1.site_id = t4.id;

INSERT INTO site_contacts_position (site_id, name, create_user, create_time, built_in)
select -2, name, create_user, create_time, false from  site_contacts_position
where site_id=0 and built_in=true and name not in(select name from site_contacts_position where site_id= -2);