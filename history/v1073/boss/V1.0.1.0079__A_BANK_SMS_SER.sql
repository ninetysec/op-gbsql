-- auto gen by lenovo 2016-06-29 13:53:03

 select redo_sqls($$
    CREATE SEQUENCE "sms_interface_id_seq"
       INCREMENT 1
       MINVALUE 1
       MAXVALUE 9223372036854775807
       START 10
       CACHE 10;
  $$);
  
   select redo_sqls($$
    CREATE SEQUENCE "bankhome_db_id_seq"
       INCREMENT 1
       MINVALUE 1
       MAXVALUE 9223372036854775807
       START 10
       CACHE 10;
  $$);