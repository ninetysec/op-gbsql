-- auto gen by cherry 2016-01-15 18:09:31
------修改视图v_user_agent 开始2016-01-15 10：05 cogo--------
DROP VIEW IF EXISTS v_user_agent;
CREATE OR REPLACE VIEW v_user_agent AS
 SELECT a.id,
    u.real_name,
    u.username,
    u.nickname,
    a.sites_id,
    u.owner_id AS parent_id,
    a.regist_code,
    a.built_in,
    a.player_rank_id,
    a.promotion_resources,
    a.create_channel,
    a.account_balance,
    a.total_rebate,
    a.check_time,
    a.check_user_id,
    a.rebate_count,
    a.withdraw_count,
    a.freezing_funds_balance,
    ( SELECT w.contact_value
           FROM notice_contact_way w
          WHERE ((a.id = w.user_id) AND ((w.contact_type)::text = '110'::text))
         LIMIT 1) AS mobil_phone,
    ( SELECT w.contact_value
           FROM notice_contact_way w
          WHERE ((a.id = w.user_id) AND ((w.contact_type)::text = '201'::text))
         LIMIT 1) AS mail,
    ( SELECT w.status
           FROM notice_contact_way w
          WHERE ((a.id = w.user_id) AND ((w.contact_type)::text = '110'::text))
         LIMIT 1) AS mobil_phone_status,
    ( SELECT w.status
           FROM notice_contact_way w
          WHERE ((a.id = w.user_id) AND ((w.contact_type)::text = '201'::text))
         LIMIT 1) AS mail_status,
    u.status,
    u.user_type
   FROM user_agent a,
    sys_user u
  WHERE (a.id = u.id);
ALTER TABLE v_user_agent OWNER TO "postgres";
-----------------修改视图v_user_player 结束----------------

-- 修改总代代理视图
DROP VIEW IF EXISTS v_top_agent_agent;

CREATE OR REPLACE VIEW v_top_agent_agent AS
  SELECT * FROM (
    SELECT su."id",
         ua.parent_id,
         ua.create_channel,
         su.username,
         su.create_time,
         su.last_login_time,
         su.status,
         su.freeze_start_time,
         su.freeze_end_time
      FROM sys_user su
     INNER JOIN user_agent ua ON su."id" = ua."id"
     WHERE su.user_type = '23'
         ) ag
      LEFT JOIN (SELECT user_agent_id, COUNT(1) player_num
               FROM user_player
              GROUP BY user_agent_id) up
        ON ag."id" = up.user_agent_id
  ORDER BY ag.create_time DESC NULLS LAST;

ALTER TABLE v_top_agent_agent OWNER TO postgres;

COMMENT ON VIEW v_top_agent_agent IS '总代下代理列表视图';
