-- auto gen by cheery 2015-11-19 15:04:40
--修改备注表字段
DROP VIEW IF EXISTS v_remark;
DROP VIEW IF EXISTS v_user_player;

ALTER TABLE remark DROP COLUMN IF EXISTS player_id;
ALTER TABLE remark DROP COLUMN IF EXISTS user_id;
ALTER TABLE remark DROP COLUMN IF EXISTS model_id;

select redo_sqls($$
  ALTER TABLE remark ADD COLUMN entity_user_id INT4;
  ALTER TABLE remark ADD COLUMN operator_id INT4;
  ALTER TABLE remark ADD COLUMN entity_id INT4;
$$);

COMMENT ON COLUMN remark.entity_user_id IS '被操作实体的所属用户ID';
COMMENT ON COLUMN remark.operator_id IS '操作员id';
COMMENT ON COLUMN remark.entity_id IS '业务实体id';
COMMENT ON COLUMN remark.model IS '模块名';

CREATE OR REPLACE VIEW v_remark AS
  SELECT t1.*,
    t2.username entity_username,
    t3.username "operator"
  FROM remark t1
    LEFT JOIN sys_user t2 ON t1.entity_id = t2.id
    LEFT JOIN sys_user t3 ON t1.operator_id = t3.id;

COMMENT ON VIEW "v_remark" IS '玩家备注视图 --orange';

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
    b.owner_id AS user_agent_id,
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
      WHERE (player_remark.entity_user_id = a.id)) AS remarkcount,
    ( SELECT count(1) AS tagcount
      FROM player_tag
      WHERE (player_tag.player_id = a.id)) AS tagcount,
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
    rs.name AS rakeback_name,
    a.total_profit_loss,
    a.total_trade_volume,
    a.total_effective_volume,
    a.create_channel
  FROM user_player a
    JOIN sys_user b ON a.id = b.id
    LEFT JOIN sys_user d ON b.owner_id = d.id
    LEFT JOIN sys_user f ON d.owner_id = f.id
    LEFT JOIN player_rank r ON a.rank_id = r.id
    LEFT JOIN sys_on_line_session g ON a.id = g.sys_user_id
    LEFT JOIN rakeback_set rs ON a.rakeback_id = rs.id;