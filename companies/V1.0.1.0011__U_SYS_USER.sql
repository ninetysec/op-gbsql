-- auto gen by tom 2016-02-16 15:14:35
DROP VIEW if EXISTS v_sys_user_operators;
DROP VIEW if EXISTS v_site_master_manage;
select redo_sqls($$
    ALTER TABLE "sys_user" ALTER COLUMN "memo" TYPE varchar(20000) COLLATE "default";
  $$);

CREATE OR REPLACE VIEW "v_sys_user_operators" AS
 SELECT t2.name,
    t3.referrals,
    t1.id,
    t1.username,
    t1.birthday,
    t1.sex,
    t1.create_time,
    t1.last_login_ip,
    t1.last_login_time,
    t1.last_login_ip_dict_code,
    t1.constellation,
    t1.memo,
    t1.nickname,
    t1.status,
    t1.freeze_end_time,
    t2.id AS site_id,
    t4.contract_scheme_ids
   FROM (((sys_user t1
     LEFT JOIN sys_site t2 ON ((t1.id = t2.sys_user_id)))
     LEFT JOIN user_extend t3 ON ((t1.id = t3.id)))
     LEFT JOIN ( SELECT site_contract_scheme.center_id,
            string_agg((site_contract_scheme.contract_scheme_id || ''::text), ','::text) AS contract_scheme_ids
           FROM site_contract_scheme
          GROUP BY site_contract_scheme.center_id) t4 ON ((t4.center_id = t2.id)))
  WHERE ((t1.user_type)::text = '1'::text);

ALTER TABLE "v_sys_user_operators" OWNER TO "postgres";

COMMENT ON VIEW "v_sys_user_operators" IS '运营商视图实体 -- cherry';

CREATE OR REPLACE VIEW "v_site_master_manage" AS
 SELECT su.id,
    su.username,
    su.nickname,
    su.sex,
    ( SELECT count(1) AS count
           FROM sys_site
          WHERE (sys_site.sys_user_id = su.id)) AS site_num,
    su.status,
    su.last_login_time,
    su.create_time,
    ctct.user_id,
    ctct.mobile_phone,
    ctct.mail,
    ctct.qq,
    ctct.msn,
    ctct.skype,
    ue.referrals,
    su.memo,
    su.last_login_ip,
    su.birthday,
    su.constellation,
    su.user_type,
    su.site_id,
    su.owner_id,
    su.freeze_type,
    su.freeze_start_time,
    su.freeze_end_time,
    ss.name,
    su.last_login_ip_dict_code,
    su.password
   FROM (((sys_user su
     LEFT JOIN user_extend ue ON ((su.id = ue.id)))
     LEFT JOIN sys_site ss ON ((su.site_id = ss.id)))
     LEFT JOIN ( SELECT ct.user_id,
            ct.mobile_phone,
            ct.mail,
            ct.qq,
            ct.msn,
            ct.skype
           FROM crosstab('SELECT user_id, contact_type,contact_value
	       FROM   notice_contact_way
	       ORDER  BY user_id,contact_type'::text, 'VALUES (''110''::text),  (''201''::text),  (''301''::text), (''302''::text), (''303''::text)'::text) ct(user_id integer, mobile_phone character varying, mail character varying, qq character varying, msn character varying, skype character varying)) ctct ON ((su.id = ctct.user_id)));

ALTER TABLE "v_site_master_manage" OWNER TO "postgres";

COMMENT ON VIEW "v_site_master_manage" IS '站长管理 --tom';
