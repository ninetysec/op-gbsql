-- auto gen by tony 2015-10-26 06:51:26
--开启一些表的操作函数
DROP EXTENSION IF EXISTS dblink;

 CREATE EXTENSION dblink
  SCHEMA public
  VERSION '1.1';

--DROP EXTENSION IF EXISTS tablefunc;

-- CREATE EXTENSION tablefunc SCHEMA public VERSION '1.0';
-- --代理提款视图修改
DROP VIEW v_agent_withdraw_order;

CREATE OR REPLACE VIEW v_agent_withdraw_order AS
 SELECT agent.username,
    audi.username AS auditname,
    topagent.username AS topagentname,
    agent.region,
    agent.nation,
    agent.country,
    agent.city,
    agent.real_name,
    agent.create_time AS register_time,
    agent.status,
    t1.id,
    t1.audit_user_id,
    t1.agent_id,
    t1.transaction_no,
    t1.currency,
    t1.withdraw_amount,
    t1.actual_amount,
    t1.agent_bank,
    t1.agent_realname,
    t1.agent_bankcard,
    t1.create_time,
    t1.audit_time,
    t1.check_status,
    t1.audit_remark,
    t1.transaction_status,
    t1.reason_title,
    t1.reason_content,
    t1.remark,
    useragent.withdraw_count,
    t1.is_lock,
    t1.lock_person_id,
    lock.username AS lock_person_name
   FROM agent_withdraw_order t1
     LEFT JOIN sys_user agent ON agent.id = t1.agent_id
     LEFT JOIN user_agent useragent ON useragent.id = t1.agent_id
     LEFT JOIN sys_user audi ON audi.id = t1.audit_user_id
     LEFT JOIN sys_user topagent ON topagent.id = agent.owner_id
     LEFT JOIN sys_user lock ON lock.id = t1.lock_person_id;

ALTER TABLE v_agent_withdraw_order
  OWNER TO postgres;
COMMENT ON VIEW v_agent_withdraw_order
  IS '代理取款审核视图 -- orange';

  DROP VIEW v_player_withdraw;

CREATE OR REPLACE VIEW v_player_withdraw AS
 SELECT t1.id,
    t1.player_id,
    t1.player_transaction_id,
    t1.transaction_no,
    t1.current_account_amount,
    t1.current_return_zero_amount,
    t1.current_backflush_amount,
    t1.withdraw_monetary,
    t1.withdraw_amount,
    t1.withdraw_remark,
    t1.deduct_favorable,
    t1.counter_fee,
    t1.administrative_fee,
    t1.is_deduct_audit,
    t1.deduct_audit_recharge_amount,
    t1.deduct_audit_recharge_index,
    t1.deduct_audit_favorable_amount,
    t1.deduct_audit_favorable_index,
    t1.withdraw_type,
    t1.create_time,
    t1.payee_bank,
    t1.payee_bankcard,
    t1.payee_name,
    t1.withdraw_status,
    t1.check_status,
    t1.check_time,
    t1.check_user_id,
    t1.check_remark,
    t1.is_clear_audit,
    t1.is_warn,
    t1.check_closing_time,
    t1.withdraw_type_parent,
    t1.withdraw_actual_amount,
    t1.play_money_time,
    t1.play_money_user,
    t1.reason_content,
    t1.artificial_reason_content,
    t1.is_lock,
    t1.lock_person_id,
    t1.is_satisfy_audit,
    t1.artificial_reason_title,
    t1.reason_title,
    t4.withdraw_count AS success_count,
    date_part('epoch'::text, t1.check_closing_time::timestamp with time zone - now()) / 60::double precision AS closing_time,
    p.remark,
    t2.username,
    t3.username AS check_user_name,
    t4.rank_id,
    t2.region,
    t2.nation,
    t2.country,
    t2.city,
    t2.real_name,
    t2.create_time AS register_time,
    t2.status,
    t5.risk_marker,
    t5.rank_name,
    t6.username AS agent_name,
    t9.username AS general_agent_name,
    t10.username AS lock_person_name
   FROM player_withdraw t1
     LEFT JOIN user_player t4 ON t4.id = t1.player_id
     LEFT JOIN sys_user t2 ON t4.id = t2.id
     LEFT JOIN player_transaction p ON t1.player_transaction_id = p.id
     LEFT JOIN sys_user t3 ON t1.check_user_id = t3.id
     LEFT JOIN player_rank t5 ON t5.id = t4.rank_id
     LEFT JOIN sys_user t6 ON t6.id = t2.owner_id
     LEFT JOIN sys_user t10 ON t10.id = t1.lock_person_id
     LEFT JOIN sys_user t9 ON t9.id = t6.owner_id;

ALTER TABLE v_player_withdraw
  OWNER TO postgres;
COMMENT ON VIEW v_player_withdraw
  IS '玩家取款审核视图 -- cheery';

  -- View: v_user_top_agent_manage

DROP VIEW v_user_top_agent_manage;

CREATE OR REPLACE VIEW v_user_top_agent_manage AS
 SELECT ua.id,
    su.username,
    su.nation,
    su.real_name,
    ( SELECT count(1) AS count
           FROM sys_user child
          WHERE child.owner_id = ua.id) AS child_agent_num,
    ( SELECT count(1) AS count
           FROM user_player players
           where players.id in(SELECT id
		FROM sys_user child
		WHERE child.owner_id = ua.id)) AS player_num,
    rs.name AS rebate_name,
    rsb.name AS rakeback_name,
    qs.name AS quota_name,
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
    (CASE
            WHEN su.freeze_end_time >= now() AND su.freeze_start_time <= now() THEN '3'::character varying(5)
            ELSE su.status
    END) AS status,
    su.freeze_end_time,
    su.freeze_start_time,
    su.region
   FROM user_agent ua
   left join sys_user su on  su.user_type::text = '22'::text AND  su.status::text < '5'::text and ua.id = su.id
   left join user_agent_rebate uar on uar.user_id = su.id
   left JOIN rebate_set rs ON uar.rebate_id = rs.id
   left join user_agent_quota uaq on uaq.user_id = su.id
   left JOIN quota_set qs ON uaq.quota_id = qs.id
   left join user_agent_rakeback uarb on uarb.user_id = ua.id
   left JOIN rebate_set rsb ON uarb.user_id = rsb.id
   left join (SELECT * FROM   crosstab(
	      'SELECT user_id, contact_type,contact_value
	       FROM   notice_contact_way
	       ORDER  BY user_id,contact_type',$$VALUES ('110'::text),  ('201'::text),  ('301'::text), ('302'::text), ('303'::text)$$) AS ct
	       ("user_id" integer, "mobile_phone" varchar, "mail" varchar, "qq" varchar, "msn" varchar, "skype" varchar))
	     as ctct on ua.id=ctct.user_id;

ALTER TABLE v_user_top_agent_manage  OWNER TO postgres;
COMMENT ON VIEW v_user_top_agent_manage
  IS '总代管理实体 -- Tom';


-- View: v_user_agent_manage

DROP VIEW v_user_agent_manage;

CREATE OR REPLACE VIEW v_user_agent_manage AS
 SELECT ua.id,
    su.username,
    su.nation,
    su.owner_id as parent_id,
    tau.username AS parent_username,
    su.real_name,
    ( SELECT count(1) AS count
           FROM sys_user
          WHERE sys_user.owner_id = ua.id) AS player_num,
    pr.rank_name AS rank_name,
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
    (CASE
            WHEN su.freeze_end_time >= now() AND su.freeze_start_time <= now() THEN '3'::character varying(5)
            ELSE su.status
    END) AS status,
    su.freeze_end_time,
    su.freeze_start_time,
    ua.player_rank_id,
    su.region,
    uarb.rakeback_id AS rakeback_id,
    uar.rebate_id AS rebate_id,
    ubc.bankcard_number AS bankcard_number
   FROM user_agent ua
   left join sys_user su on  su.user_type::text = '23'::text AND  su.status::text < '5'::text and ua.id = su.id
   left join player_rank pr on ua.player_rank_id = pr.id
   left join user_agent_rebate uar on uar.user_id = su.id
   left JOIN rebate_set rs ON uar.rebate_id = rs.id
   left join user_agent_quota uaq on uaq.user_id = su.id
   left JOIN quota_set qs ON uaq.quota_id = qs.id
   left join user_agent_rakeback uarb on uarb.user_id = ua.id
   left JOIN rebate_set rsb ON uarb.user_id = rsb.id
   left join user_bankcard ubc on ubc.is_default = true AND ubc.user_id = ua.id
   left join sys_user tau on tau.id = su.owner_id
   left join (SELECT * FROM   crosstab(
	      'SELECT user_id, contact_type,contact_value
	       FROM   notice_contact_way
	       ORDER  BY user_id,contact_type',$$VALUES ('110'::text),  ('201'::text),  ('301'::text), ('302'::text), ('303'::text)$$) AS ct
	       ("user_id" integer, "mobile_phone" varchar, "mail" varchar, "qq" varchar, "msn" varchar, "skype" varchar))
	     as ctct on ua.id=ctct.user_id;

ALTER TABLE v_user_agent_manage  OWNER TO postgres;
COMMENT ON VIEW v_user_agent_manage
  IS '代理管理实体 -- Tom';


-- View: v_user_player

DROP VIEW v_user_player;

CREATE OR REPLACE VIEW v_user_player AS
 SELECT a.id,
    a.rank_id,
    b.nickname,
    b.sex,
    b.constellation,
    b.birthday,
    b.country,
    b.region,
    b.city,
    b.nation,
    a.total_assets,
    a.phone_code,
    a.wallet_balance,
    a.synchronization_time,
    a.special_focus,
    b.create_user,
    b.create_time,
    a.balance_type,
    a.balance_freeze_start_time,
    a.balance_freeze_end_time,
    a.freeze_code,
    a.balance_freeze_remark,
    a.account_freeze_remark,
    b.owner_id as user_agent_id,
    a.rakeback_id,
    a.level,
    b.default_currency,
    a.ohter_contact_information,
    b.username,
    b.password,
    b.dept_id,
    b.status,
    b.freeze_type,
    b.freeze_start_time,
    b.freeze_end_time,
    b.freeze_code AS user_freeze_code,
    b.register_ip,
    b.owner_id AS agent_id,
    d.username AS agent_name,
    f.username AS general_agent_name,
    f.id AS general_agent_id,
    g.id AS on_line_id,
    b.real_name,
    b.default_locale,
    a.rakeback,
    a.backwash_total_amount,
    a.backwash_balance_amount,
    a.backwash_recharge_warn,
    a.transaction_syn_time,
    ( SELECT count(1) AS remarkcount
           FROM remark player_remark
          WHERE player_remark.player_id = a.id) AS remarkcount,
    ( SELECT count(1) AS tagcount
           FROM player_tag
          WHERE player_tag.player_id = a.id) AS tagcount,
    b.default_timezone,
    r.rank_name,
    a.recharge_count,
    a.recharge_total,
    a.recharge_max_amount,
    a.withdraw_count AS tx_count,
    a.withdraw_total AS tx_total,
    a.level_lock,
    r.risk_marker,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '110'::text
         LIMIT 1) AS mobile_phone,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '201'::text
         LIMIT 1) AS mail,
    rs.name AS rakeback_name,
    a.total_profit_loss,
    a.total_trade_volume,
    a.total_effective_volume
   FROM user_player a
     JOIN sys_user b ON a.id = b.id
     LEFT JOIN sys_user d ON b.owner_id = d.id
     LEFT JOIN sys_user f ON d.id = f.id
     LEFT JOIN player_rank r ON a.rank_id = r.id
     LEFT JOIN sys_on_line_session g ON a.id = g.sys_user_id
     LEFT JOIN rakeback_set rs ON a.rakeback_id = rs.id;

ALTER TABLE v_user_player
  OWNER TO postgres;
COMMENT ON VIEW v_user_player
  IS '代理管理实体 -- cheery';


DROP VIEW v_rakeback_set;

CREATE OR REPLACE VIEW v_rakeback_set AS
 SELECT rs.id,
    rs.name,
    rs.create_time,
    rs.status,
    rs.audit_num,
    rs.remark,
    ( SELECT count(1) AS count
           FROM user_player
          WHERE user_player.rakeback_id = rs.id) AS player_count,
    COALESCE(uar.count, 0::bigint) AS agent_count
   FROM rakeback_set rs
     LEFT JOIN ( SELECT count(1) AS count,
            user_agent_rakeback.rakeback_id
           FROM user_agent_rakeback
          WHERE (user_agent_rakeback.user_id IN ( SELECT s_u.id
                   FROM sys_user s_u
                  WHERE  s_u.owner_id IS NOT NULL AND s_u.user_type::text = '23'::text))
          GROUP BY user_agent_rakeback.rakeback_id) uar ON uar.rakeback_id = rs.id
  WHERE rs.status::text <> '2'::text;

ALTER TABLE v_rakeback_set
  OWNER TO postgres;
COMMENT ON VIEW v_rakeback_set
  IS '返水方案视图－Jeff';


DROP VIEW v_user_agent;

CREATE OR REPLACE VIEW v_user_agent AS
 SELECT a.id,
    u.real_name,
    u.username,
    u.nickname,
    a.sites_id,
    u.owner_id as parent_id,
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
          WHERE a.id = w.user_id AND w.contact_type::text = '110'::text
         LIMIT 1) AS mobil_phone,
    ( SELECT w.contact_value
           FROM notice_contact_way w
          WHERE a.id = w.user_id AND w.contact_type::text = '201'::text
         LIMIT 1) AS mail
   FROM user_agent a,
    sys_user u
  WHERE a.id = u.id;

ALTER TABLE v_user_agent
  OWNER TO postgres;

  COMMENT ON VIEW v_rakeback_set
  IS '代理信息视图－cheery';


  -- View: v_report_settlement_rebate_detail

DROP VIEW v_report_settlement_rebate_detail;

CREATE OR REPLACE VIEW v_report_settlement_rebate_detail AS
 SELECT sra.id,
    sr.id AS rebate_id,
    sra.agent_name,
    su.username,
    sra.effective_transaction,
    sra.profit_loss,
    sra.deposit_amount,
    sra.withdrawal_amount,
    sra.backwater,
    sra.preferential_value,
    sra.deduct_expenses,
    sra.rebate_total,
    sr.lssuing_state,
    sr.start_time,
    sr.end_time,
    sr.settlement_name
   FROM settlement_rebate sr
     LEFT JOIN settlement_rebate_agent sra ON sr.id = sra.settlement_rabate_id
     LEFT JOIN sys_user ua ON sra.agent_id = ua.id
     LEFT JOIN sys_user su ON ua.owner_id = su.id
  WHERE sra.id IS NOT NULL AND sr.end_time >= (now() - '90 days'::interval);

ALTER TABLE v_report_settlement_rebate_detail
  OWNER TO postgres;
COMMENT ON VIEW v_report_settlement_rebate_detail
  IS '返佣统计详细视图';
