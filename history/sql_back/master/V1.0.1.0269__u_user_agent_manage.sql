-- auto gen by tom 2015-12-18 14:11:23
DROP view if EXISTS v_user_agent_manage;

CREATE OR REPLACE VIEW "v_user_agent_manage" AS
 SELECT DISTINCT ua.id,
    su.username,
    su.nation,
    su.owner_id AS parent_id,
    tau.username AS parent_username,
    su.real_name,
    ( SELECT count(1) AS count
           FROM sys_user
          WHERE (sys_user.owner_id = ua.id)) AS player_num,
    pr.rank_name,
    rs.name AS rebate_name,
    rs.name AS rakeback_name,
    qs.name AS quota_name,
    ua.account_balance,
    ua.total_rebate,
    su.default_locale,
    su.default_currency,
    su.country,
    su.default_timezone,
    ctct.mobile_phone,
    ctct.mail,
    su.sex,
    su.birthday,
    ua.regist_code,
    ua.create_channel,
    su.create_time,
    su.register_ip,
    su.last_login_time,
    ctct.qq,
    ctct.msn,
    ctct.skype,
        CASE
            WHEN ((su.freeze_end_time >= now()) AND (su.freeze_start_time <= now())) THEN '3'::character varying(5)
            ELSE su.status
        END AS status,
    su.freeze_end_time,
    su.freeze_start_time,
    ua.player_rank_id,
    su.region,
    uarb.rakeback_id,
    uar.rebate_id,
    ubc.bankcard_number
   FROM (((((((((((user_agent ua
     JOIN sys_user su ON (((((su.user_type)::text = '23'::text) AND ((su.status)::text < '5'::text)) AND (ua.id = su.id))))
     LEFT JOIN player_rank pr ON ((ua.player_rank_id = pr.id)))
     LEFT JOIN user_agent_rebate uar ON ((uar.user_id = su.id)))
     LEFT JOIN rebate_set rs ON ((uar.rebate_id = rs.id)))
     LEFT JOIN user_agent_quota uaq ON ((uaq.user_id = su.id)))
     LEFT JOIN quota_set qs ON ((uaq.quota_id = qs.id)))
     LEFT JOIN user_agent_rakeback uarb ON ((uarb.user_id = ua.id)))
     LEFT JOIN rebate_set rsb ON ((uarb.user_id = rsb.id)))
     LEFT JOIN user_bankcard ubc ON (((ubc.is_default = true) AND (ubc.user_id = ua.id))))
     LEFT JOIN sys_user tau ON ((tau.id = su.owner_id)))
     LEFT JOIN ( SELECT ct.user_id,
            ct.mobile_phone,
            ct.mail,
            ct.qq,
            ct.msn,
            ct.skype
           FROM crosstab('SELECT user_id, contact_type,contact_value
	       FROM   notice_contact_way
	       ORDER  BY user_id,contact_type'::text, 'VALUES (''110''::text),  (''201''::text),  (''301''::text), (''302''::text), (''303''::text)'::text) ct(user_id integer, mobile_phone character varying, mail character varying, qq character varying, msn character varying, skype character varying)) ctct ON ((ua.id = ctct.user_id)));

ALTER TABLE "v_user_agent_manage" OWNER TO "postgres";

COMMENT ON VIEW "v_user_agent_manage" IS '玩家视图 -- Jeff';