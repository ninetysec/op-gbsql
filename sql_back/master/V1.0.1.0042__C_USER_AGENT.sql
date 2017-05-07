-- auto gen by lorne 2015-09-01
-- 新增代理相关表和字段


select redo_sqls($$

    ALTER TABLE "user_agent" ADD COLUMN "player_rank_id" int4;
    ALTER TABLE "user_agent" ADD COLUMN "promotion_resources" varchar(300);
    ALTER TABLE "user_agent" ADD COLUMN "create_channel" varchar(1);
    ALTER TABLE "user_agent" ADD COLUMN "account_balance" numeric(20,2) DEFAULT 0;
    ALTER TABLE "user_agent" ADD COLUMN "total_rebate" numeric(20,2) DEFAULT 0;
    ALTER TABLE "user_agent" ADD COLUMN "status" varchar(1) DEFAULT 0;
    ALTER TABLE "user_agent" ADD COLUMN "check_time" timestamp;
    ALTER TABLE "user_agent" ADD COLUMN "check_user_id" int4;
    ALTER TABLE "user_agent" DROP COLUMN "status";
  $$);
COMMENT ON COLUMN "user_agent"."player_rank_id" IS '预设玩家层级';

COMMENT ON COLUMN "user_agent"."promotion_resources" IS '推广资源';

COMMENT ON COLUMN "user_agent"."create_channel" IS '创建渠道';

COMMENT ON COLUMN "user_agent"."account_balance" IS '账户余额';

COMMENT ON COLUMN "user_agent"."total_rebate" IS '返佣总额';

COMMENT ON COLUMN "user_agent"."status" IS '状态（0未审核；1已审核；2审核失败）字典类型agent_status';

COMMENT ON COLUMN "user_agent"."check_time" IS '审核时间';

COMMENT ON COLUMN "user_agent"."check_user_id" IS '审核人';

-- Table: quota_set

-- DROP TABLE quota_set;

CREATE TABLE IF NOT EXISTS quota_set
(
  id serial4 NOT NULL,
  name character varying(50) NOT NULL, -- 名称
  status character varying(1) NOT NULL DEFAULT 1, -- 状态（0停用，1正常，2删除）
  CONSTRAINT quota_set_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE quota_set
  OWNER TO postgres;
COMMENT ON TABLE quota_set
  IS '限额设置--lorne';
COMMENT ON COLUMN quota_set.name IS '名称';
COMMENT ON COLUMN quota_set.status IS '状态（0停用，1正常，2删除）字典类型program_settings';


CREATE TABLE IF NOT EXISTS rakeback_set
(
  id serial4 NOT NULL,
  name character varying(50) NOT NULL, -- 名称
  status character varying(1) DEFAULT 1, -- 状态（0停用，1正常，2删除）
  CONSTRAINT rakeback_set_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE rakeback_set
  OWNER TO postgres;
COMMENT ON TABLE rakeback_set
  IS '返水设置表--lorne';
COMMENT ON COLUMN rakeback_set.name IS '名称';
COMMENT ON COLUMN rakeback_set.status IS '状态（0停用，1正常，2删除）字典类型program_settings';

-- Table: rebate_set

-- DROP TABLE rebate_set;

CREATE TABLE IF NOT EXISTS rebate_set
(
  id serial4 NOT NULL,
  name character varying(50) NOT NULL, -- 名称
  status character varying(1) NOT NULL DEFAULT 1, -- 状态（0停用，1正常，2删除）
  CONSTRAINT rebate_set_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE rebate_set
  OWNER TO postgres;
COMMENT ON TABLE rebate_set
  IS '返佣设置表--lorne';
COMMENT ON COLUMN rebate_set.name IS '名称';
COMMENT ON COLUMN rebate_set.status IS '状态（0停用，1正常，2删除）字典类型program_settings';

-- Table: user_agent_quota

-- DROP TABLE user_agent_quota;

CREATE TABLE IF NOT EXISTS user_agent_quota
(
  id serial4 NOT NULL,
  user_id integer NOT NULL, -- 代理/总代 ID
  quota_id integer NOT NULL, -- 限额表主键（quota_set）
  CONSTRAINT user_agent_quota_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE user_agent_quota
  OWNER TO postgres;
COMMENT ON TABLE user_agent_quota
  IS '代理/总代 限额关联表--lorne';
COMMENT ON COLUMN user_agent_quota.user_id IS '代理/总代 ID';
COMMENT ON COLUMN user_agent_quota.quota_id IS '限额表主键（quota_set）';



CREATE TABLE IF NOT EXISTS user_agent_rakeback
(
  id serial4 NOT NULL,
  user_id integer NOT NULL, -- 代理/总代 ID
  rakeback_id integer NOT NULL, -- 返水表主键（rakeback_set）
  CONSTRAINT user_agent_rakeback_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE user_agent_rakeback
  OWNER TO postgres;
COMMENT ON TABLE user_agent_rakeback
  IS '代理/总代 返水关联表--lorne';
COMMENT ON COLUMN user_agent_rakeback.user_id IS '代理/总代 ID';
COMMENT ON COLUMN user_agent_rakeback.rakeback_id IS '返水表主键（rakeback_set）';

-- Table: user_agent_rebate

-- DROP TABLE user_agent_rebate;

CREATE TABLE IF NOT EXISTS user_agent_rebate
(
  id serial4 NOT NULL,
  user_id integer NOT NULL, -- 代理/总代 ID
  rebate_id integer NOT NULL, -- 返佣表主键（rebate_set）
  CONSTRAINT user_agent_rebate_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE user_agent_rebate
  OWNER TO postgres;
COMMENT ON TABLE user_agent_rebate
  IS '代理/总代 返佣关联表--lorne';
COMMENT ON COLUMN user_agent_rebate.user_id IS '代理/总代 ID';
COMMENT ON COLUMN user_agent_rebate.rebate_id IS '返佣表主键（rebate_set）';




-- Table: user_agent_api

-- DROP TABLE user_agent_api;

CREATE TABLE user_agent_api
(
  id serial4 NOT NULL,
  user_id integer NOT NULL, -- 总代ID
  api_id integer NOT NULL, -- api外键
  ratio numeric(20,2) DEFAULT 0, -- 占成
  game_type character varying(32), -- 游戏类别:Dicts:     Module:common   Dict_Type:gameType
  CONSTRAINT user_agent_api_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE user_agent_api
  OWNER TO postgres;
COMMENT ON TABLE user_agent_api
  IS '总代API占成表--lorne';
COMMENT ON COLUMN user_agent_api.user_id IS '总代ID';
COMMENT ON COLUMN user_agent_api.api_id IS 'api外键';
COMMENT ON COLUMN user_agent_api.ratio IS '占成';
COMMENT ON COLUMN user_agent_api.game_type IS '游戏类别:Dicts:     Module:common   Dict_Type:gameType';

