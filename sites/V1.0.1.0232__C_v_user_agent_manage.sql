-- auto gen by cherry 2016-08-24 16:31:24
drop view if EXISTS v_user_agent_manage;

CREATE OR REPLACE VIEW "v_user_agent_manage" AS

 SELECT DISTINCT ua.id,

    su.username,

    su.nation,

    su.owner_id AS parent_id,

    tau.username AS parent_username,

    su.real_name,

    ( SELECT count(1) AS count

           FROM sys_user

          WHERE ((sys_user.owner_id = ua.id) AND ((sys_user.user_type)::text = '24'::text))) AS player_num,

    pr.rank_name,

    rs.name AS rebate_name,

    rsb.name AS rakeback_name,

    ''::text AS quota_name,

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

    ubc.bankcard_number,

    ( SELECT array_to_string(ARRAY( SELECT t.remark_content

                   FROM remark t

                  WHERE (t.entity_user_id = su.id)), '-'::text) AS array_to_string) AS remark_content,

    su.city,

    su.built_in,

    ctct.weixin,

    ( SELECT count(1) AS count

           FROM (user_player up

             LEFT JOIN sys_user sur ON ((up.id = sur.id)))

          WHERE ((sur.owner_id = ua.id) AND ((up.recharge_count IS NOT NULL) AND (up.recharge_count > 0)))) AS recharge_player_count,

    ( SELECT sum(up.recharge_total) AS sum

           FROM (user_player up

             LEFT JOIN sys_user sur ON ((up.id = sur.id)))

          WHERE ((sur.owner_id = ua.id) AND (up.recharge_total > (0)::numeric))) AS recharge_player_total,

    ( SELECT sum(up.withdraw_total) AS sum

           FROM (user_player up

             LEFT JOIN sys_user sur ON ((up.id = sur.id)))

          WHERE ((sur.owner_id = ua.id) AND (up.withdraw_total > (0)::numeric))) AS withdraw_player_total

   FROM (((((((((user_agent ua

     JOIN sys_user su ON ((((su.user_type)::text = '23'::text) AND ((su.status)::text < '5'::text) AND (ua.id = su.id))))

     LEFT JOIN player_rank pr ON ((ua.player_rank_id = pr.id)))

     LEFT JOIN user_agent_rebate uar ON ((uar.user_id = su.id)))

     LEFT JOIN rebate_set rs ON ((uar.rebate_id = rs.id)))

     LEFT JOIN user_agent_rakeback uarb ON ((uarb.user_id = ua.id)))

     LEFT JOIN rakeback_set rsb ON ((uarb.rakeback_id = rsb.id)))

     LEFT JOIN user_bankcard ubc ON (((ubc.is_default = true) AND (ubc.user_id = ua.id))))

     LEFT JOIN sys_user tau ON ((tau.id = su.owner_id)))

     LEFT JOIN ( SELECT ct.user_id,

            ct.mobile_phone,

            ct.mail,

            ct.qq,

            ct.msn,

            ct.skype,

            ct.weixin

           FROM crosstab('SELECT user_id, contact_type,contact_value
	       FROM   notice_contact_way
	       ORDER  BY user_id,contact_type'::text, 'VALUES (''110''::text),  (''201''::text),  (''301''::text), (''302''::text), (''303''::text), (''304''::text)'::text) ct(user_id integer, mobile_phone character varying, mail character varying, qq character varying, msn character varying, skype character varying, weixin character varying)) ctct ON ((ua.id = ctct.user_id)));

COMMENT ON VIEW "v_user_agent_manage" IS '代理视图--edit by younger';