-- auto gen by cherry 2016-08-01 16:31:38
select redo_sqls($$
       ALTER TABLE exception_transfer add COLUMN api_trans_id varchar(64);
				ALTER TABLE exception_transfer add COLUMN account varchar(64);
 $$);

COMMENT on COLUMN exception_transfer.api_trans_id is 'api交易号';

COMMENT on COLUMN exception_transfer.account is '玩家游戏账户';


DROP VIEW IF EXISTS v_exception_transfer;
CREATE OR REPLACE VIEW "v_exception_transfer" AS
 SELECT t1.*,
    t2.username AS comanyname,
    t3.username AS mastername,
    t5.value AS sitename,
    t5.locale
   FROM (((exception_transfer t1
     LEFT JOIN  sys_user t2 ON ((t1.company_id = t2.id)))
     LEFT JOIN  sys_user t3 ON ((t1.master_id = t3.id)))
     LEFT JOIN ( SELECT t4.id,
            t4.module,
            t4.type,
            t4.key,
            t4.locale,
            t4.value,
            t4.site_id,
            t4.default_value
           FROM site_i18n t4
          WHERE ((t4.type)::text = 'site_name'::text)) t5 ON ((t1.site_id = t5.site_id)));

COMMENT on view v_exception_transfer is '异常转账视图';