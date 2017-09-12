-- auto gen by cherry 2017-09-12 11:22:06
--添加功能权限菜单
insert into sys_resource(id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
  SELECT 20406,'无限级代理','userAgent/changeAddSubAgent.html','控制代理的是否能新建子代理',204,'',6,'mcenter','role:agent_canaddsubagent','2','',true,false,true
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 20406);

--添加无限级代理功能
SELECT redo_sqls($$
  ALTER TABLE "user_agent" ADD COLUMN "add_sub_agent" bool;
  COMMENT ON COLUMN "user_agent"."add_sub_agent" IS '无限级代理';
  ALTER TABLE "user_agent" ADD COLUMN "add_new_player" bool;
  COMMENT ON COLUMN "user_agent"."add_new_player" IS '开启添加玩家功能';
$$);

DROP VIEW IF EXISTS v_user_agent_manage;
CREATE OR REPLACE VIEW "v_user_agent_manage" AS
 WITH ncw AS (
         SELECT notice_contact_way.user_id,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '110'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS mobile_phone,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '201'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS mail,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '301'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS qq,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '302'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS msn,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '303'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS skype,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '304'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS weixin
           FROM notice_contact_way
          GROUP BY notice_contact_way.user_id
        )
 SELECT ua.id,
    su.username,
    su.nation,
    su.owner_id AS topagent_id,
    tau.username AS topagent_username,
    ua.parent_id,
    psu.username AS parent_username,
    su.real_name,
    ( SELECT count(1) AS count
           FROM sys_user
          WHERE ((sys_user.owner_id = ua.id) AND ((sys_user.user_type)::text = '24'::text))) AS player_num,
    ( SELECT count(1) AS count
           FROM user_agent
          WHERE (user_agent.parent_id = ua.id)) AS agent_num,
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
    su.sex,
    su.birthday,
    ua.regist_code,
    ua.create_channel,
    su.create_time,
    su.register_ip,
    su.last_login_time,
        CASE
            WHEN ((su.freeze_end_time >= now()) AND (su.freeze_start_time <= now())) THEN '3'::character varying
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
    ( SELECT count(1) AS count
           FROM user_player up,
            sys_user sur
          WHERE ((sur.owner_id = ua.id) AND (up.id = sur.id) AND (up.recharge_count > 0))) AS recharge_player_count,
    ( SELECT sum(up.recharge_total) AS sum
           FROM user_player up,
            sys_user sur
          WHERE ((sur.owner_id = ua.id) AND (up.id = sur.id) AND (up.recharge_total > (0)::numeric))) AS recharge_player_total,
    ( SELECT sum(up.withdraw_total) AS sum
           FROM user_player up,
            sys_user sur
          WHERE ((sur.owner_id = ua.id) AND (up.id = sur.id) AND (up.withdraw_total > (0)::numeric))) AS withdraw_player_total,
    ncw.mobile_phone,
    ncw.mail,
    ncw.qq,
    ncw.msn,
    ncw.skype,
    ncw.weixin,
    ua.agent_rank,
    ua.parent_array,
    ua.add_sub_agent,
    ua.add_new_player
   FROM ((((((((((user_agent ua
     JOIN sys_user su ON ((((su.user_type)::text = '23'::text) AND ((su.status)::text < '5'::text) AND (ua.id = su.id))))
     LEFT JOIN ncw ON ((ua.id = ncw.user_id)))
     LEFT JOIN player_rank pr ON ((ua.player_rank_id = pr.id)))
     LEFT JOIN user_agent_rebate uar ON ((uar.user_id = su.id)))
     LEFT JOIN rebate_set rs ON ((uar.rebate_id = rs.id)))
     LEFT JOIN user_agent_rakeback uarb ON ((uarb.user_id = ua.id)))
     LEFT JOIN rakeback_set rsb ON ((uarb.rakeback_id = rsb.id)))
     LEFT JOIN user_bankcard ubc ON (((ubc.is_default = true) AND (ubc.user_id = ua.id))))
     LEFT JOIN sys_user psu ON ((ua.parent_id = psu.id)))
     LEFT JOIN sys_user tau ON ((tau.id = su.owner_id)));