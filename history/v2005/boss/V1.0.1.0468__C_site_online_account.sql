-- auto gen by george 2017-12-17 20:05:44
CREATE TABLE IF NOT EXISTS site_online_account(
	id serial4 PRIMARY KEY,
	site_id int4 NOT NULL,
	player_online_num int4 default 0,
	visitor_num int4 default 0,
	agent_online_num int4 default 0,
	agent_sub_online_num int4 default 0,
	top_agent_online_num int4 default 0,
	top_agent_sub_online_num int4 default 0,
	create_time timestamp(6),
	is_last_record bool
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "site_online_account" IS '站点在线用户统计 -- kobe';

COMMENT ON COLUMN "site_online_account"."id" IS '主键';

COMMENT ON COLUMN "site_online_account"."site_id" IS '站点ID';

COMMENT ON COLUMN "site_online_account"."player_online_num" IS '在线玩家人数';

COMMENT ON COLUMN "site_online_account"."visitor_num" IS '游客人数';

COMMENT ON COLUMN "site_online_account"."agent_online_num" IS '代理在线人数';

COMMENT ON COLUMN "site_online_account"."agent_sub_online_num" IS '代理子账号在线人数';

COMMENT ON COLUMN "site_online_account"."top_agent_online_num" IS '总代在线人数';

COMMENT ON COLUMN "site_online_account"."top_agent_sub_online_num" IS '总代子账号在线人数';

COMMENT ON COLUMN "site_online_account"."create_time" IS '创建时间';

COMMENT ON COLUMN "site_online_account"."is_last_record" IS '是否最新记录';
