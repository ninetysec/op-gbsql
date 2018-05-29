-- auto gen by cherry 2018-05-25 20:26:33
DROP VIEW if EXISTS v_player_online;
DROP VIEW IF EXISTS v_user_player_fund;
DROP VIEW IF EXISTS vv_sys_user;
ALTER TABLE sys_user ALTER COLUMN terminal type varchar(2);

CREATE OR REPLACE VIEW "v_player_online" AS
 SELECT s.id,
    s.username,
    s.real_name,
    s.login_time,
    s.login_ip,
    s.login_ip_dict_code,
    s.last_active_time,
    s.use_line,
    s.last_login_time,
    s.last_login_ip,
    s.last_login_ip_dict_code,
    s.total_online_time,
    string_agg(((pgl.game_id)::character varying)::text, ','::text) AS gameids,
    string_agg(((pgl.api_id)::character varying)::text, ','::text) AS apiids,
    s.session_key,
    u.wallet_balance,
    u.freezing_funds_balance,
    u.rank_id,
    u.create_channel AS channel_terminal,
    s.terminal,
    u.user_agent_id,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = s.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = s.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone_way_status
   FROM ((user_player u
     JOIN sys_user s ON ((s.id = u.id)))
     LEFT JOIN player_game_log pgl ON (((pgl.user_id = s.id) AND ((pgl.session_key)::text = (s.session_key)::text))))
  WHERE ((s.session_key IS NOT NULL) AND ((s.login_time > s.last_logout_time) OR (s.last_logout_time IS NULL)) AND (s.last_active_time > (now() - '00:30:00'::interval)))
  GROUP BY s.id, s.username, s.real_name, s.login_time, s.login_ip, s.login_ip_dict_code, s.last_active_time, s.use_line, s.last_login_time, s.last_login_ip, s.last_login_ip_dict_code, s.total_online_time, s.session_key, u.wallet_balance, u.freezing_funds_balance, u.rank_id, u.create_channel, s.terminal, u.user_agent_id;


COMMENT ON VIEW "v_player_online" IS '在线玩家视图 edit by linsen -younger-steffan';

CREATE OR REPLACE VIEW "v_user_player_fund" AS
 WITH op AS (
         SELECT operate_player.player_id,
            (sum(operate_player.transaction_order))::integer AS transaction_order,
            sum(operate_player.effective_transaction) AS effective_transaction,
            sum(operate_player.profit_loss) AS profit_loss
           FROM operate_player
          WHERE ((operate_player.static_time >= '2018-01-01 00:00:00'::timestamp without time zone) AND (operate_player.static_time < '2018-01-08 00:00:00'::timestamp without time zone))
          GROUP BY operate_player.player_id
        ), pt AS (
         SELECT player_transaction.id,
            player_transaction.transaction_no,
            player_transaction.create_time,
            player_transaction.transaction_type,
            player_transaction.remark,
            player_transaction.transaction_money,
            player_transaction.balance,
            player_transaction.status,
            player_transaction.player_id,
            player_transaction.failure_reason,
            player_transaction.source_id,
            player_transaction.effective_transaction,
            player_transaction.recharge_audit_points,
            player_transaction.relaxing_quota,
            player_transaction.administrative_fee,
            player_transaction.favorable_total_amount,
            player_transaction.favorable_audit_points,
            player_transaction.deduct_favorable,
            player_transaction.is_satisfy_audit,
            player_transaction.is_clear_audit,
            player_transaction.api_money,
            player_transaction.completion_time,
            player_transaction.fund_type,
            player_transaction.transaction_way,
            player_transaction.transaction_data,
            player_transaction.remainder_effective_transaction,
            player_transaction.origin,
            player_transaction.rank_id,
            player_transaction.favorable_remainder_effective_transaction,
            player_transaction.check_result,
            player_transaction.check_time,
            player_transaction.agent_id,
            player_transaction.agent_username,
            player_transaction.topagent_id,
            player_transaction.topagent_username,
            player_transaction.user_name
           FROM player_transaction
          WHERE (((player_transaction.status)::text = 'success'::text) AND (player_transaction.completion_time >= '2018-01-01 00:00:00'::timestamp without time zone) AND (player_transaction.completion_time < '2018-01-08 00:00:00'::timestamp without time zone))
        ), pti AS (
         SELECT pt.player_id,
            'deposit'::text AS transaction_type,
            pt.transaction_money
           FROM pt
          WHERE ((pt.transaction_type)::text = 'deposit'::text)
        UNION ALL
         SELECT pt.player_id,
            'withdrawal'::text AS transaction_type,
            (- pt.transaction_money) AS transaction_money
           FROM pt
          WHERE ((pt.transaction_type)::text = 'withdrawals'::text)
        UNION ALL
         SELECT pt.player_id,
            'backwater'::text AS transaction_type,
            pt.transaction_money
           FROM pt
          WHERE ((pt.transaction_type)::text = 'backwater'::text)
        UNION ALL
         SELECT pt.player_id,
            'favorable'::text AS transaction_type,
            pt.transaction_money
           FROM pt
          WHERE (((pt.transaction_type)::text = 'favorable'::text) OR ((pt.transaction_type)::text = 'recommend'::text))
        ), pto AS (
         SELECT pti.player_id,
            count(
                CASE pti.transaction_type
                    WHEN 'deposit'::text THEN pti.transaction_money
                    ELSE (0)::numeric
                END) AS deposit_count,
            sum(
                CASE pti.transaction_type
                    WHEN 'deposit'::text THEN pti.transaction_money
                    ELSE (0)::numeric
                END) AS deposit_amount,
            count(
                CASE pti.transaction_type
                    WHEN 'withdrawal'::text THEN pti.transaction_money
                    ELSE (0)::numeric
                END) AS withdraw_count,
            sum(
                CASE pti.transaction_type
                    WHEN 'withdrawal'::text THEN pti.transaction_money
                    ELSE (0)::numeric
                END) AS withdraw_amount,
            sum(
                CASE pti.transaction_type
                    WHEN 'backwater'::text THEN pti.transaction_money
                    ELSE (0)::numeric
                END) AS rakeback_amount,
            sum(
                CASE pti.transaction_type
                    WHEN 'favorable'::text THEN pti.transaction_money
                    ELSE (0)::numeric
                END) AS favorable_amount,
            0 AS other_amount
           FROM pti
          GROUP BY pti.player_id
        ), ptu AS (
         SELECT su.id,
            su.username AS player_name,
            su.create_time,
            pto.deposit_count,
            pto.deposit_amount,
            pto.withdraw_count,
            pto.withdraw_amount,
            pto.rakeback_amount,
            pto.favorable_amount,
            op.transaction_order,
            op.effective_transaction,
            op.profit_loss,
            pt.agent_id,
            pt.agent_username AS agent_name,
            pt.topagent_id,
            pt.topagent_username AS topagent_name
           FROM (((( SELECT sys_user.id,
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
                    sys_user.memo,
                    sys_user.password_level,
                    sys_user.login_ip_dict_code,
                    sys_user.last_login_ip_dict_code,
                    sys_user.register_ip_dict_code,
                    sys_user.login_error_times,
                    sys_user.freeze_title,
                    sys_user.freeze_content,
                    sys_user.last_logout_time,
                    sys_user.freeze_user,
                    sys_user.disabled_user,
                    sys_user.disabled_time,
                    sys_user.freeze_time,
                    sys_user.__clean__,
                    sys_user.account_freeze_remark,
                    sys_user.secpwd_freeze_start_time,
                    sys_user.secpwd_freeze_end_time,
                    sys_user.secpwd_error_times,
                    sys_user.session_key,
                    sys_user.terminal,
                    sys_user.authentication_key
                   FROM sys_user
                  WHERE ((sys_user.user_type)::text = '24'::text)) su
             LEFT JOIN pt ON ((pt.player_id = su.id)))
             LEFT JOIN pto ON ((pto.player_id = su.id)))
             LEFT JOIN op ON ((op.player_id = su.id)))
          WHERE ((pto.player_id IS NOT NULL) OR (op.player_id IS NOT NULL))
        )
 SELECT ptu.id,
    ptu.player_name,
    ptu.create_time,
    ptu.deposit_count,
    ptu.deposit_amount,
    ptu.withdraw_count,
    ptu.withdraw_amount,
    ptu.rakeback_amount,
    ptu.favorable_amount,
    ptu.transaction_order,
    ptu.effective_transaction,
    ptu.profit_loss,
    ptu.agent_id,
    ptu.agent_name,
    ptu.topagent_id,
    ptu.topagent_name
   FROM ptu
 LIMIT 100;

CREATE OR REPLACE VIEW vv_sys_user AS
 SELECT sys_user.id,
    sys_user.username,
    md5(sys_user.password::text) AS password,
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
    sys_user.login_time,
    sys_user.login_ip,
    sys_user.last_active_time,
    sys_user.use_line,
    sys_user.last_login_time,
    sys_user.last_login_ip,
    sys_user.total_online_time,
    sys_user.register_ip,
    sys_user.nickname,
    sys_user.real_name,
    sys_user.birthday,
    sys_user.sex,
    sys_user.constellation,
    sys_user.country,
    sys_user.nation,
    sys_user.avatar_url,
    md5(sys_user.permission_pwd::text) AS permission_pwd,
    sys_user.idcard,
    sys_user.default_currency,
    sys_user.register_site,
    sys_user.region,
    sys_user.city,
    sys_user.memo,
    sys_user.password_level,
    sys_user.login_ip_dict_code,
    sys_user.last_login_ip_dict_code,
    sys_user.register_ip_dict_code,
    sys_user.login_error_times,
    sys_user.freeze_title,
    sys_user.freeze_content,
    sys_user.freeze_code,
    sys_user.last_logout_time,
    sys_user.freeze_user,
    sys_user.disabled_user,
    sys_user.disabled_time,
    sys_user.freeze_time,
    sys_user.account_freeze_remark,
    sys_user.secpwd_freeze_start_time,
    sys_user.secpwd_freeze_end_time,
    sys_user.secpwd_error_times,
    sys_user.session_key,
    sys_user.terminal,
    md5(sys_user.authentication_key::text) AS authentication_key
   FROM sys_user;