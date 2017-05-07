-- auto gen by cheery 2015-12-23 17:41:02
--添加一个菜单
INSERT INTO sys_resource("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege","status")
  SELECT '712', '导出任务列表', 'share/exports/exportHistoryList.html', '导出任务列表-by River', 7, null, '12', 'mcenter', 'test:view', '1', 'icon-fangwenshezhi', 't', 'f','t'
  WHERE '导出任务列表' not in (SELECT name from sys_resource where name = '导出任务列表' and subsys_code = 'mcenter');

--玩家视图新增字段 -玩家表中的邮箱激活状态 手机激活状态
CREATE OR REPLACE VIEW "v_user_player" AS
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
    a.create_channel,
    a.mail_status ,
    a.mobile_phone_status
   FROM ((((((user_player a
     JOIN sys_user b ON ((a.id = b.id)))
     LEFT JOIN sys_user d ON ((b.owner_id = d.id)))
     LEFT JOIN sys_user f ON ((d.owner_id = f.id)))
     LEFT JOIN player_rank r ON ((a.rank_id = r.id)))
     LEFT JOIN sys_on_line_session g ON ((a.id = g.sys_user_id)))
     LEFT JOIN rakeback_set rs ON ((a.rakeback_id = rs.id)));

ALTER TABLE "v_user_player" OWNER TO "postgres";

COMMENT ON VIEW "v_user_player" IS '玩家视图-Jeff';




select redo_sqls($$
  ALTER TABLE sys_user ADD COLUMN freeze_user int4;
$$);
 select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN disabled_user int4;
$$);
 select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN disabled_time timestamp;
$$);
 select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN freeze_time timestamp;
$$);

COMMENT ON COLUMN "sys_user"."freeze_time" IS '冻结操作时间';
COMMENT ON COLUMN "sys_user"."freeze_user" IS '冻结操作人id';

COMMENT ON COLUMN "sys_user"."disabled_user" IS '停用操作人id';

COMMENT ON COLUMN "sys_user"."disabled_time" IS '停用时间';

INSERT INTO "sys_resource" ("id","name", "url", "remark","parent_id","structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in","privilege","status")
  select '20207', '取消冻结余额',  'share/account/cancelBalanceFreeze.html', NULL,  '202', NULL, NULL,  'mcenter', 'test:view', '2',NULL, 't', 't','t'
  where '取消冻结余额' not in (SELECT name FROM sys_resource);

update sys_resource set url = 'share/account/freezeAccount.html' where name = '账号冻结';
update sys_resource set url = 'share/account/disabledAccount.html' where name = '账号停用';
update sys_resource set url = 'share/account/cancelAccountFreeze.html' where name = '取消冻结账号';
update sys_resource set url = 'share/account/freezeBalance.html' where name = '余额冻结';