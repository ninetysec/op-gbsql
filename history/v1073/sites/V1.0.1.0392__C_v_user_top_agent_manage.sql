-- auto gen by cherry 2017-02-28 09:04:09
DROP VIEW IF EXISTS v_user_top_agent_manage;

CREATE OR REPLACE VIEW v_user_top_agent_manage AS

 SELECT ua.id,

    su.username,

    su.nation,

    su.real_name,

    ( SELECT count(1) AS count

           FROM sys_user child

          WHERE ((child.owner_id = ua.id) AND ((child.user_type)::text = '23'::text) AND ((child.status)::text < '5'::text))) AS child_agent_num,

    ( SELECT count(1) AS count

           FROM (user_player players

             JOIN sys_user _user ON ((players.id = _user.id)))

          WHERE (players.user_agent_id IN ( SELECT child.id

                   FROM sys_user child

                  WHERE (child.owner_id = ua.id)))) AS player_num,

    ( SELECT count(1) AS count

           FROM (rebate_set rs

             JOIN user_agent_rebate uar ON ((uar.rebate_id = rs.id)))

          WHERE (uar.user_id = su.id)) AS rebatenum,

    ( SELECT count(1) AS count

           FROM (rakeback_set rs

             JOIN user_agent_rakeback uarb ON ((uarb.rakeback_id = rs.id)))

          WHERE (uarb.user_id = su.id)) AS rakebacknum,

    su.default_locale,

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

    su.region,

    su.constellation,

    ( SELECT array_to_string(ARRAY( SELECT t.remark_content

                   FROM remark t

                  WHERE (t.entity_user_id = su.id)), '-'::text) AS array_to_string) AS remark_content,

    su.built_in

   FROM ((user_agent ua

     JOIN ( SELECT sys_user.id,

            sys_user.username,

            sys_user.password,

            sys_user.dept_id,

            sys_user.status,

            sys_user.create_user,

            sys_user.create_time,

            sys_user.update_user,

            sys_user.update_time,

            sys_user.default_locale,

            sys_user.default_timezone,

            sys_user.subsys_code,

            sys_user.user_type,

            sys_user.built_in,

            sys_user.site_id,

            sys_user.owner_id,

            sys_user.freeze_type,

            sys_user.freeze_start_time,

            sys_user.freeze_end_time,

            sys_user.freeze_code,

            sys_user.login_time,

            sys_user.login_ip,

            sys_user.last_active_time,

            sys_user.use_line,

            sys_user.last_login_time,

            sys_user.last_login_ip,

            sys_user.total_online_time,

            sys_user.nickname,

            sys_user.real_name,

            sys_user.birthday,

            sys_user.sex,

            sys_user.constellation,

            sys_user.country,

            sys_user.nation,

            sys_user.register_ip,

            sys_user.avatar_url,

            sys_user.permission_pwd,

            sys_user.idcard,

            sys_user.default_currency,

            sys_user.register_site,

            sys_user.region,

            sys_user.city,

            sys_user.memo

           FROM sys_user

          WHERE (((sys_user.user_type)::text = '22'::text) AND ((sys_user.status)::text < '5'::text))) su ON ((ua.id = su.id)))

     LEFT JOIN ( SELECT ct.user_id,

            ct.mobile_phone,

            ct.mail,

            ct.qq,

            ct.msn,

            ct.skype

           FROM crosstab('SELECT user_id, contact_type,contact_value
                 FROM   notice_contact_way
                 ORDER  BY user_id,contact_type'::text, 'VALUES (''110''::text),  (''201''::text),  (''301''::text), (''302''::text), (''303''::text)'::text) ct(user_id integer, mobile_phone character varying, mail character varying, qq character varying, msn character varying, skype character varying)) ctct ON ((ua.id = ctct.user_id)));


COMMENT ON VIEW v_user_top_agent_manage IS '总代视图--edit by younger';

UPDATE ctt_document SET parent_id=null,order_num=1 WHERE id=-1;

UPDATE ctt_document SET parent_id=null,order_num=2 WHERE id=-2;

UPDATE ctt_document SET parent_id=null,order_num=3 WHERE id=-3;


UPDATE sys_resource SET url='home/Index.html' WHERE id=31;