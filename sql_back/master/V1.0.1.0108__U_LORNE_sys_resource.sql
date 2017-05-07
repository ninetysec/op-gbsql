-- auto gen by loong 2015-10-10 10:35:22
select redo_sqls($$
    ALTER TABLE "site_i18n" ADD COLUMN "built_in" bool;
    DROP VIEW v_user_player;
    ALTER TABLE "site_confine_ip" ALTER COLUMN "remark" TYPE varchar(200) COLLATE "default";
    ALTER TABLE "site_confine_area" ALTER COLUMN "remark" TYPE varchar(200) COLLATE "default";
    ALTER TABLE "site_customer_service" ALTER COLUMN "parameter" TYPE varchar(500) COLLATE "default";


  $$);

COMMENT ON COLUMN "site_i18n"."built_in" IS '是否系统内置(是否可删除)';
update sys_resource set url='vPayAccount/delpayrank.html' where name='线上支付账户删除层级';
update sys_resource set url='vPayAccount/delpayrank.html' where name='公司入款账户删除层级';
update sys_resource set url='report/backwater/reindex.html' where name='返水报表' and parent_id=5;



-- View: v_user_player

-- DROP VIEW v_user_player;

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
    a.user_agent_id,
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
    e.id AS agent_id,
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
     LEFT JOIN user_agent e ON a.user_agent_id = e.id
     LEFT JOIN sys_user d ON e.id = d.id
     LEFT JOIN sys_user f ON e.parent_id = f.id
     LEFT JOIN player_rank r ON a.rank_id = r.id
     LEFT JOIN sys_on_line_session g ON a.id = g.sys_user_id
     LEFT JOIN rakeback_set rs ON a.rakeback_id = rs.id;

ALTER TABLE v_user_player
  OWNER TO postgres;
