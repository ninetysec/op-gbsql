-- auto gen by cherry 2016-12-12 21:56:02
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '902', '推广链接新进', 'vAnalyzePlayer/analyzeLink.html', '', '9', '', '2', 'mcenter', 'mcenter:analyze', '1', '', 't', 'f', 't'
WHERE 902 not in(select id from sys_resource where id=902);
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '901', '代理新进', '/vAnalyzePlayer/analyze.html', '', '9', '', '1', 'mcenter', 'mcenter:analyze-link', '1', '', 't', 'f', 't'
WHERE 901 not in(select id from sys_resource where id=901);

INSERT INTO sys_param ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") SELECT 'analyze', 'analyze_player', 'deposit_today', '1', '0', NULL, '注册当日存款金额大于或等于设定的值', NULL, 't', NULL
WHERE  NOT EXISTS (select id from sys_param where module='analyze' and param_type = 'analyze_player' and param_code = 'deposit_today');
INSERT INTO sys_param ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") SELECT 'analyze', 'analyze_player', 'effective_today', '1', '0', NULL, '注册当日有效投注额大于或等于设定的值', '', 't', NULL
WHERE  NOT EXISTS (select id from sys_param where module='analyze' and param_type = 'analyze_player' and param_code = 'effective_today');

UPDATE sys_resource SET url='report/vPlayerFundsRecord/fundsLog.html' WHERE id=503;

CREATE TABLE IF NOT EXISTS  analyze_player (
"id" serial4 NOT NULL,
"player_id" int4,
"agent_id" int4,
"topagent_id" int4,
"promote_link" varchar(256) COLLATE "default",
"is_new_player" bool,
"deposit_amount" numeric(20,2),
"withdraw_amount" numeric(20,2),
"effective_amount" numeric(20,2),
"payout_amount" numeric(20,2),
"static_date" date,
"static_time" timestamp(6),
"static_time_end" timestamp(6),
CONSTRAINT "analyze_player_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE analyze_player IS '玩家分析';

COMMENT ON COLUMN analyze_player."id" IS '主键';

COMMENT ON COLUMN analyze_player."player_id" IS '玩家ID';

COMMENT ON COLUMN analyze_player."agent_id" IS '代理ID';

COMMENT ON COLUMN analyze_player."topagent_id" IS '总代ID';

COMMENT ON COLUMN analyze_player."promote_link" IS '推广链接';

COMMENT ON COLUMN analyze_player."is_new_player" IS '是否是新玩家';

COMMENT ON COLUMN analyze_player."deposit_amount" IS '当日存款';

COMMENT ON COLUMN analyze_player."withdraw_amount" IS '当日取款';

COMMENT ON COLUMN analyze_player."effective_amount" IS '当日有效交易量';

COMMENT ON COLUMN analyze_player."payout_amount" IS '当日损益（派彩）';

COMMENT ON COLUMN analyze_player."static_date" IS '统计日期';

COMMENT ON COLUMN analyze_player."static_time" IS '统计起始时间';

CREATE INDEX IF not EXISTS "idx_analyze_player_agent_id" ON analyze_player USING btree (agent_id);

CREATE INDEX IF not EXISTS "idx_analyze_player_player_id" ON analyze_player USING btree (player_id);