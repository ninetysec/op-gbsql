-- auto gen by cherry 2016-01-06 20:50:49
  select redo_sqls($$
					ALTER TABLE user_player ADD COLUMN is_first_recharge bool NOT NULL DEFAULT true;
					ALTER TABLE player_recharge ADD COLUMN is_first_favorable bool DEFAULT true;
  $$);

COMMENT ON COLUMN user_player.is_first_recharge IS '是否首存';

COMMENT ON COLUMN player_recharge.is_first_favorable IS '是否首存优惠';


DROP VIEW  if EXISTS v_user_player;
create OR REPLACE VIEW v_user_player AS
SELECT a.id,
    a.rank_id,
  a.total_assets,
    a.phone_code,
    a.wallet_balance,
    a.synchronization_time,
    a.special_focus,
   a.balance_type,
    a.balance_freeze_start_time,
    a.balance_freeze_end_time,
    a.freeze_code,
    a.balance_freeze_remark,
    a.account_freeze_remark,
 a.rakeback_id,
    a.level,
    a.ohter_contact_information,
  a.rakeback,
    a.backwash_total_amount,
    a.backwash_balance_amount,
    a.backwash_recharge_warn,
    a.transaction_syn_time,
   a.recharge_count,
    a.recharge_total,
    a.recharge_max_amount,
    a.withdraw_count AS tx_count,
    a.withdraw_total AS tx_total,
    a.level_lock,
    a.total_profit_loss,
    a.total_trade_volume,
    a.total_effective_volume,
    a.create_channel,
    a.mail_status,
    a.mobile_phone_status,
		a.is_first_recharge,
    b.nickname,
    b.sex,
    b.constellation,
    b.birthday,
    b.country,
    b.region,
    b.city,
    b.nation,
    b.create_user,
    b.create_time,
    b.owner_id AS user_agent_id,
    b.default_currency,
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
    ( SELECT count(1) AS remarkcount
           FROM remark player_remark
          WHERE (player_remark.entity_user_id = a.id)) AS remarkcount,
    ( SELECT count(1) AS tagcount
           FROM player_tag
          WHERE (player_tag.player_id = a.id)) AS tagcount,
    b.default_timezone,
    r.rank_name,
    r.risk_marker,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '201'::text))
         LIMIT 1) AS mail,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '301'::text))
         LIMIT 1) AS qq,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '302'::text))
         LIMIT 1) AS msn,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '303'::text))
         LIMIT 1) AS skype,
    rs.name AS rakeback_name
   FROM user_player a
     JOIN sys_user b ON a.id = b.id
     LEFT JOIN sys_user d ON b.owner_id = d.id
     LEFT JOIN sys_user f ON d.owner_id = f.id
     LEFT JOIN player_rank r ON a.rank_id = r.id
     LEFT JOIN sys_on_line_session g ON a.id = g.sys_user_id
     LEFT JOIN rakeback_set rs ON a.rakeback_id = rs.id;

     comment ON  VIEW v_user_player is '玩家视图';