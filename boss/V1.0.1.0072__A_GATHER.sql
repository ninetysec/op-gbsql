-- auto gen by lenovo 2016-06-24 07:36:50

DROP TABLE IF EXISTS gather_category;
DROP TABLE IF EXISTS gather_flow;
DROP TABLE IF EXISTS gather_schedule;
DROP TABLE IF EXISTS gather_user;
DROP TABLE IF EXISTS gather_type;

CREATE TABLE gather_category
(
  id character varying(20) NOT NULL, -- 主键
  name character varying(64) NOT NULL, -- 名称
  status integer DEFAULT 0, -- 状态: 启用(1),停用(2),删除(3)
  create_time timestamp without time zone, -- 创建时间
  CONSTRAINT category_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE gather_category
  OWNER TO postgres;
COMMENT ON TABLE gather_category
  IS '流程类别-Lins';
COMMENT ON COLUMN gather_category.id IS '主键';
COMMENT ON COLUMN gather_category.name IS '名称';
COMMENT ON COLUMN gather_category.status IS '状态: 启用(1),停用(2),删除(3)';
COMMENT ON COLUMN gather_category.create_time IS '创建时间';




CREATE TABLE gather_flow
(
  id bigserial NOT NULL, -- 主键
  abbr_name character varying(16) NOT NULL, -- 简称
  config_name character varying(64), -- 全称
  category_id character varying(16) NOT NULL, -- 类别，关联category表-复合唯一性
  type_id character varying(16) NOT NULL, -- 类型,关于type表--复合唯一性
  remarks character varying(128), -- 备注
  flow text NOT NULL, -- 流程信息
  version character varying(20) NOT NULL, -- 流程版本--复合唯一性
  ext_json character varying(300) DEFAULT ''::character varying, -- 扩展信息
  init_param character varying(300) DEFAULT ''::character varying, -- 初始化参数
  status integer DEFAULT 1, -- 状态: 启用(1),停用(2),删除(3)
  create_time timestamp without time zone, -- 创建时间
  flow_type character varying(10) NOT NULL, -- 流程类型
  CONSTRAINT gather_flow_pkey PRIMARY KEY (id),
  CONSTRAINT flow_uniq_key UNIQUE (category_id, type_id, version)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE gather_flow
  OWNER TO postgres;
COMMENT ON TABLE gather_flow
  IS '采集流程-Lins';
COMMENT ON COLUMN gather_flow.id IS '主键';
COMMENT ON COLUMN gather_flow.abbr_name IS '简称';
COMMENT ON COLUMN gather_flow.config_name IS '全称';
COMMENT ON COLUMN gather_flow.category_id IS '类别，关联category表-复合唯一性';
COMMENT ON COLUMN gather_flow.type_id IS '类型,关于type表--复合唯一性';
COMMENT ON COLUMN gather_flow.remarks IS '备注';
COMMENT ON COLUMN gather_flow.flow IS '流程信息';
COMMENT ON COLUMN gather_flow.version IS '流程版本--复合唯一性';
COMMENT ON COLUMN gather_flow.ext_json IS '扩展信息';
COMMENT ON COLUMN gather_flow.init_param IS '初始化参数';
COMMENT ON COLUMN gather_flow.status IS '状态: 启用(1),停用(2),删除(3)';
COMMENT ON COLUMN gather_flow.create_time IS '创建时间';
COMMENT ON COLUMN gather_flow.flow_type IS '流程类型';

CREATE TABLE gather_schedule
(
  id bigserial NOT NULL, -- 主键
  name character varying(64) NOT NULL, -- 名称
  type character varying(20), -- 计划类型: 后台驻留(daemon),定时计划(schedule),连续(straight),单次(once)
  init_user_info character varying(300), -- 多用户信息-按一定规则轮换(防止被封号)
  cron_expressions character varying(50), -- quartz 表达式,定时计划(schedule)使用
  status integer DEFAULT 0, -- 状态: 启用(1),停用(2),删除(3)
  auto_start character varying(1) DEFAULT 'N'::character varying, -- 是否自动: 自动(Y),手动(N)
  result_channel_id bigint, -- 结果推送通道,关联result_channel表
  create_time timestamp without time zone, -- 创建时间
  update_time timestamp without time zone, -- 更新时间
  create_user_id bigint, -- 创建用户
  update_user_id bigint, -- 更新用户
  version character varying(16), -- 版本
  category_id character varying(20), -- 类别,关联category表
  CONSTRAINT schedule_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE gather_schedule
  OWNER TO postgres;
COMMENT ON TABLE gather_schedule
  IS '采集计划-Lins';
COMMENT ON COLUMN gather_schedule.id IS '主键';
COMMENT ON COLUMN gather_schedule.name IS '名称';
COMMENT ON COLUMN gather_schedule.type IS '计划类型: 后台驻留(daemon),定时计划(schedule),连续(straight),单次(once)';
COMMENT ON COLUMN gather_schedule.init_user_info IS '多用户信息-按一定规则轮换(防止被封号)';
COMMENT ON COLUMN gather_schedule.cron_expressions IS 'quartz 表达式,定时计划(schedule)使用';
COMMENT ON COLUMN gather_schedule.status IS '状态: 启用(1),停用(2),删除(3)';
COMMENT ON COLUMN gather_schedule.auto_start IS '是否自动: 自动(Y),手动(N)';
COMMENT ON COLUMN gather_schedule.result_channel_id IS '结果推送通道,关联result_channel表';
COMMENT ON COLUMN gather_schedule.create_time IS '创建时间';
COMMENT ON COLUMN gather_schedule.update_time IS '更新时间';
COMMENT ON COLUMN gather_schedule.create_user_id IS '创建用户';
COMMENT ON COLUMN gather_schedule.update_user_id IS '更新用户';
COMMENT ON COLUMN gather_schedule.version IS '版本';
COMMENT ON COLUMN gather_schedule.category_id IS '类别,关联category表';


CREATE TABLE gather_type
(
  id character varying(20) NOT NULL, -- 主键
  name character varying(100) NOT NULL, -- 名称
  category_id character varying(20) NOT NULL, -- 类别，关联category表-复合唯一性
  status integer DEFAULT 0, -- 状态: 启用(1),停用(2),删除(3)
  create_time timestamp without time zone, -- 创建时间
  CONSTRAINT type_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE gather_type
  OWNER TO postgres;
COMMENT ON TABLE gather_type
  IS '流程类型-Lins';
COMMENT ON COLUMN gather_type.id IS '主键';
COMMENT ON COLUMN gather_type.name IS '名称';
COMMENT ON COLUMN gather_type.category_id IS '类别，关联category表-复合唯一性';
COMMENT ON COLUMN gather_type.status IS '状态: 启用(1),停用(2),删除(3)';
COMMENT ON COLUMN gather_type.create_time IS '创建时间';




CREATE TABLE gather_user
(
  id bigint NOT NULL, -- 主键
  username character varying(20) NOT NULL, -- 名称
  password character varying(30) NOT NULL, -- 密码
  nickname character varying(30) DEFAULT ''::character varying, -- 昵称
  type character varying(2), -- 用户类型:01:采集端,02:验证端,03:计划管理端,04:客户端
  status integer DEFAULT 0, -- 状态: 启用(1),停用(2),删除(3)
  create_time timestamp without time zone, -- 创建时间
  category_id character varying(10) NOT NULL, -- 采集类别
  duplicateused boolean NOT NULL, -- 是否重复使用
  CONSTRAINT user_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE gather_user
  OWNER TO postgres;
COMMENT ON TABLE gather_user
  IS '采集流程-Lins';
COMMENT ON COLUMN gather_user.id IS '主键';
COMMENT ON COLUMN gather_user.username IS '名称';
COMMENT ON COLUMN gather_user.password IS '密码';
COMMENT ON COLUMN gather_user.nickname IS '昵称';
COMMENT ON COLUMN gather_user.type IS '用户类型:01:采集端,02:验证端,03:计划管理端,04:客户端';
COMMENT ON COLUMN gather_user.status IS '状态: 启用(1),停用(2),删除(3)';
COMMENT ON COLUMN gather_user.create_time IS '创建时间';
COMMENT ON COLUMN gather_user.category_id IS '采集类别';
COMMENT ON COLUMN gather_user.duplicateused IS '是否重复使用';

