-- auto gen by cherry 2016-11-22 11:31:13
DROP VIEW IF EXISTS  v_user_agent_manage;
CREATE OR REPLACE VIEW v_user_agent_manage AS
SELECT
       ua.id,
       su.username,
       su.nation,
       su.owner_id AS parent_id,
       tau.username AS parent_username,
       su.real_name,

       ( SELECT count(1) AS count
              FROM sys_user
             WHERE sys_user.owner_id = ua.id AND sys_user.user_type = '24') AS player_num,

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
       --ctct.mobile_phone,
       --ctct.mail,
       su.sex,
       su.birthday,
       ua.regist_code,
       ua.create_channel,
       su.create_time,
       su.register_ip,
       su.last_login_time,
       --ctct.qq,
       --ctct.msn,
       --ctct.skype,

       CASE
           WHEN su.freeze_end_time >= now() AND su.freeze_start_time <= now() THEN '3'
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
                     WHERE t.entity_user_id = su.id), '-'::text) AS array_to_string) AS remark_content,

       su.city,
       su.built_in,
       --ctct.weixin,

       ( SELECT count(1) AS count
           FROM user_player up, sys_user sur
          WHERE sur.owner_id = ua.id AND up.id = sur.id AND up.recharge_count > 0) AS recharge_player_count,

       ( SELECT sum(up.recharge_total) AS sum
           FROM user_player up, sys_user sur
          WHERE sur.owner_id = ua.id AND up.id = sur.id AND up.recharge_total > 0) AS recharge_player_total,

       ( SELECT sum(up.withdraw_total) AS sum
           FROM user_player up, sys_user sur
          WHERE sur.owner_id = ua.id AND up.id = sur.id AND up.withdraw_total > 0) AS withdraw_player_total,

       CASE ncw.contact_type WHEN '110' THEN ncw.contact_value END mobile_phone,
       CASE ncw.contact_type WHEN '201' THEN ncw.contact_value END mail,
       CASE ncw.contact_type WHEN '301' THEN ncw.contact_value END qq,
       CASE ncw.contact_type WHEN '302' THEN ncw.contact_value END msn,
       CASE ncw.contact_type WHEN '303' THEN ncw.contact_value END skype,
       CASE ncw.contact_type WHEN '304' THEN ncw.contact_value END weixin

  FROM user_agent ua
       JOIN sys_user su ON su.user_type = '23' AND su.status < '5' AND ua.id = su.id
       LEFT JOIN notice_contact_way ncw ON ua.id = ncw.user_id
       LEFT JOIN player_rank pr ON ua.player_rank_id = pr.id
       LEFT JOIN user_agent_rebate uar ON uar.user_id = su.id
       LEFT JOIN rebate_set rs ON uar.rebate_id = rs.id
       LEFT JOIN user_agent_rakeback uarb ON uarb.user_id = ua.id
       LEFT JOIN rakeback_set rsb ON uarb.rakeback_id = rsb.id
       LEFT JOIN user_bankcard ubc ON ubc.is_default = true AND ubc.user_id = ua.id
       LEFT JOIN sys_user tau ON tau.id = su.owner_id
;