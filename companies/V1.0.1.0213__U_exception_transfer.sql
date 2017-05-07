-- auto gen by admin 2016-11-13 14:28:51--gb-companies select redo_sqls($$       ALTER TABLE exception_transfer add COLUMN check_result varchar(10);       ALTER TABLE exception_transfer add COLUMN check_time TIMESTAMP(6);$$);COMMENT on COLUMN exception_transfer.check_result is '检测结果';COMMENT on COLUMN exception_transfer.check_time is '检测时间';CREATE OR REPLACE VIEW "gb-companies"."v_exception_transfer" AS SELECT t1.id,    t1.company_id,    t1.master_id,    t1.site_id,    t1.player_id,    t1.player_name,    t1.order_no,    t1.order_type,    t1.order_status,    t1.api_id,    t1.currency_code,    t1.money,    t1.transfer_time,    t1.create_time,    t1.handler_id,    t1.handl_time,    t1.api_trans_id,    t1.account,    t1.handle_name,    t2.username AS comanyname,    t3.username AS mastername,    t5.value AS sitename,    t5.locale,	  t1.check_result,    t1.check_time   FROM ((("gb-companies".exception_transfer t1     LEFT JOIN "gb-companies".sys_user t2 ON ((t1.company_id = t2.id)))     LEFT JOIN "gb-companies".sys_user t3 ON ((t1.master_id = t3.id)))     LEFT JOIN ( SELECT t4.id,            t4.module,            t4.type,            t4.key,            t4.locale,            t4.value,            t4.site_id,            t4.default_value           FROM "gb-companies".site_i18n t4          WHERE ((t4.type)::text = 'site_name'::text)) t5 ON ((t1.site_id = t5.site_id)));ALTER TABLE "gb-companies"."v_exception_transfer" OWNER TO "gb-companies";COMMENT ON VIEW "gb-companies"."v_exception_transfer" IS '异常转账视图';