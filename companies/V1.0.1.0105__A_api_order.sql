-- auto gen by bruce 2016-05-31 15:16:37
select redo_sqls($$
       ALTER TABLE api_order ALTER COLUMN game_code DROP NOT NULL;
$$);
COMMENT ON COLUMN api_order.game_code IS '游戏code';

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'MANUAL_RECHARGE_SUCCESS', NULL, '手动存款', NULL, 't'
where 'MANUAL_RECHARGE_SUCCESS' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');

DROP VIEW if EXISTS v_site_master_manage;
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
    su.password,
    su.default_timezone
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

COMMENT ON VIEW "v_site_master_manage" IS '站长管理 --tom edit by younger';