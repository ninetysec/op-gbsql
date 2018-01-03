-- auto gen by loong 2015-09-15 12:02:26


select redo_sqls($$
    ALTER TABLE "rakeback_set" ADD COLUMN "audit_num" int4 DEFAULT 0;
    ALTER TABLE "rakeback_set" ADD COLUMN "remark" varchar(200);
    ALTER TABLE "rakeback_set" ADD COLUMN "create_time" timestamp(6);
    ALTER TABLE "rakeback_set" ADD COLUMN "create_user_id" int4;
    ALTER TABLE "rebate_set" ADD COLUMN "valid_value" int4 DEFAULT 0;
    ALTER TABLE "rebate_set" ADD COLUMN "remark" varchar(200);
    ALTER TABLE "rebate_set" ADD COLUMN "create_time" timestamp(6);
    ALTER TABLE "rebate_set" ADD COLUMN "create_user_id" int4;
    DROP VIEW IF EXISTS v_pay_rank111;
    DROP VIEW IF EXISTS v_player_rank_statistics111111;
    DROP VIEW IF EXISTS v_pay_account111;
    DROP VIEW IF EXISTS v_player_withdraw;
    DROP VIEW IF EXISTS v_user_player;
    DROP VIEW IF EXISTS v_user_agent;
    DROP TABLE IF EXISTS pay_account111111;
    DROP TABLE IF EXISTS player_rank111111;
    DROP TABLE IF EXISTS user_agent111111111;

  $$);

COMMENT ON COLUMN "rakeback_set"."audit_num" IS '优惠稽核';

COMMENT ON COLUMN "rakeback_set"."remark" IS '备注';

COMMENT ON COLUMN "rebate_set"."valid_value" IS '有效玩家交易量';

COMMENT ON COLUMN "rebate_set"."remark" IS '备注';

COMMENT ON COLUMN "rakeback_set"."create_time" IS '创建人ID';

COMMENT ON COLUMN "rakeback_set"."create_user_id" IS '创建人ID';

COMMENT ON COLUMN "rebate_set"."create_time" IS '创建人ID';

COMMENT ON COLUMN "rebate_set"."create_user_id" IS '创建人ID';

ALTER SEQUENCE "pay_account_id_seq"
 OWNED BY "pay_account"."id";

ALTER SEQUENCE "player_rank_id_seq"
 OWNED BY "player_rank"."id";

-- View: v_player_withdraw

-- DROP VIEW v_player_withdraw;

-- View: v_user_player

-- DROP VIEW v_user_player;

CREATE OR REPLACE VIEW v_user_player AS
 SELECT a.id, a.rank_id, a.phone_code, a.mobile_phone, a.mail, a.nick_name,
    a.sex, a.constellation, a.birthday, a.nation, a.province, a.total_assets,
    a.wallet_balance, a.synchronization_time, a.special_focus, b.create_user,
    b.create_time, a.balance_type, a.balance_freeze_start_time,
    a.balance_freeze_end_time, a.freeze_code, a.balance_freeze_remark,
    a.account_freeze_remark, a.user_agent_id, a.level, a.main_currency,
    a.ohter_contact_information, a.payment_password, a.mobile_phone_status,
    a.mail_status, b.username, b.password, b.dept_id, b.status, b.freeze_type,
    b.freeze_start_time, b.freeze_end_time, b.freeze_code AS user_freeze_code,
    b.register_ip, e.id AS agent_id, d.username AS agent_name,
    f.username AS general_agent_name, f.id AS general_agent_id,
    g.id AS on_line_id, a.real_name, b.default_locale, a.rakeback,
    a.backwash_total_amount, a.backwash_balance_amount,
    a.backwash_recharge_warn,
    ( SELECT count(1) AS remarkcount
           FROM remark player_remark
          WHERE player_remark.player_id = a.id
          GROUP BY player_remark.player_id) AS remarkcount,
    ( SELECT count(1) AS tagcount
           FROM player_tag
          WHERE player_tag.player_id = a.id
          GROUP BY player_tag.player_id) AS tagcount,
    b.default_timezone, r.rank_name, a.recharge_count, a.recharge_total,
    a.recharge_max_amount, a.withdraw_count AS tx_count,
    a.withdraw_total AS tx_total, a.level_lock, r.risk_marker
   FROM user_player a
   LEFT JOIN sys_user b ON a.id = b.id
   LEFT JOIN user_agent e ON a.user_agent_id = e.id
   LEFT JOIN sys_user d ON e.id = d.id
   LEFT JOIN sys_user f ON e.parent_id = f.id
   LEFT JOIN player_rank r ON a.rank_id = r.id
   LEFT JOIN sys_on_line_session g ON a.id = g.sys_user_id;

ALTER TABLE v_user_player
  OWNER TO postgres;
COMMENT ON VIEW v_user_player
  IS '玩家视图--lorne';

SELECT redo_sqls($$
  alter table user_agent add column rebate_count INTEGER DEFAULT 0;
  alter table user_agent add column withdraw_count INTEGER DEFAULT 0;
  alter table user_agent add column freezing_funds_balance NUMERIC(20,2) DEFAULT 0;
  COMMENT ON COLUMN user_agent.rebate_count IS '累计充值次数';
  COMMENT ON COLUMN user_agent.withdraw_count IS '累计提现次数';
  COMMENT ON COLUMN user_agent.freezing_funds_balance IS '冻结资金余额';
$$);

CREATE OR REPLACE VIEW "v_user_agent" AS SELECT
"a"."id",
u.real_name,
u.username,
u.nickname,
"a".sites_id,
"a".parent_id,
"a".regist_code,
"a".built_in,
"a".player_rank_id,
"a".promotion_resources,
"a".create_channel,
"a".account_balance,
"a".total_rebate,
"a".check_time,
"a".check_user_id,
"a".rebate_count,
"a".withdraw_count,
"a".freezing_funds_balance,
(select w.contact_value from notice_contact_way w where a."id"=w.user_id and w.contact_type='110' LIMIT 1) as mobil_phone,
(select w.contact_value from notice_contact_way w where a."id"=w.user_id and w.contact_type='201' LIMIT 1) as mail
FROM user_agent  a , sys_user  u where a."id" = u."id";

-- Table: rakeback_grads

-- DROP TABLE rakeback_grads;

CREATE TABLE IF NOT EXISTS rakeback_grads
(
  id serial4 NOT NULL,
  rakeback_id integer NOT NULL, -- 返水设置表id
  valid_value integer, -- 有效交易量
  max_rakeback integer, -- 每期返水上限
  CONSTRAINT rakeback_grads_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE rakeback_grads
  OWNER TO postgres;
COMMENT ON TABLE rakeback_grads
  IS '返水设置梯度表--lorne';
COMMENT ON COLUMN rakeback_grads.rakeback_id IS '返水设置表id';
COMMENT ON COLUMN rakeback_grads.valid_value IS '有效交易量';
COMMENT ON COLUMN rakeback_grads.max_rakeback IS '每期返水上限';

-- Table: rakeback_grads_api

-- DROP TABLE rakeback_grads_api;

CREATE TABLE IF NOT EXISTS rakeback_grads_api
(
  id serial4 NOT NULL,
  api_id integer NOT NULL, -- api外键
  ratio numeric(20,2) DEFAULT 0, -- 占成
  game_type character varying(32) NOT NULL, -- 游戏类别:Dicts:     Module:common   Dict_Type:gameType
  rakeback_grads_id integer NOT NULL, -- 返水设置梯度表ID
  CONSTRAINT rakeback_grads_api_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE rakeback_grads_api
  OWNER TO postgres;
COMMENT ON TABLE rakeback_grads_api
  IS '返水设置梯度API比例表--lorne';
COMMENT ON COLUMN rakeback_grads_api.api_id IS 'api外键';
COMMENT ON COLUMN rakeback_grads_api.ratio IS '占成';
COMMENT ON COLUMN rakeback_grads_api.game_type IS '游戏类别:Dicts:     Module:common   Dict_Type:gameType';
COMMENT ON COLUMN rakeback_grads_api.rakeback_grads_id IS '返水设置梯度表ID';


-- Table: rebate_grads

-- DROP TABLE rebate_grads;

CREATE TABLE IF NOT EXISTS rebate_grads
(
  id serial4 NOT NULL,
  rebate_id integer NOT NULL, -- 返水设置表id
  total_profit integer DEFAULT 0, -- 盈利总额
  valid_player_num integer DEFAULT 0, -- 有效玩家数
  max_rebate integer DEFAULT 0, -- 每期返水上限
  CONSTRAINT rebate_grads_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE rebate_grads
  OWNER TO postgres;
COMMENT ON TABLE rebate_grads
  IS '返佣设置梯度表--lorne';
COMMENT ON COLUMN rebate_grads.rebate_id IS '返水设置表id';
COMMENT ON COLUMN rebate_grads.total_profit IS '盈利总额';
COMMENT ON COLUMN rebate_grads.valid_player_num IS '有效玩家数 ';
COMMENT ON COLUMN rebate_grads.max_rebate IS '每期返水上限';

-- Table: rebate_grads_api

-- DROP TABLE rebate_grads_api;

CREATE TABLE IF NOT EXISTS rebate_grads_api
(
  id serial4 NOT NULL,
  api_id integer NOT NULL, -- api外键
  ratio numeric(20,2) DEFAULT 0, -- 占成
  game_type character varying(32) NOT NULL, -- 游戏类别:Dicts:     Module:common   Dict_Type:gameType
  rebate_grads_id integer NOT NULL, -- 返水设置梯度表ID
  CONSTRAINT rebate_grads_api_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE rebate_grads_api
  OWNER TO postgres;
COMMENT ON TABLE rebate_grads_api
  IS '返佣设置梯度API比例表--lorne';
COMMENT ON COLUMN rebate_grads_api.api_id IS 'api外键';
COMMENT ON COLUMN rebate_grads_api.ratio IS '占成';
COMMENT ON COLUMN rebate_grads_api.game_type IS '游戏类别:Dicts:     Module:common   Dict_Type:gameType';
COMMENT ON COLUMN rebate_grads_api.rebate_grads_id IS '返水设置梯度表ID';

