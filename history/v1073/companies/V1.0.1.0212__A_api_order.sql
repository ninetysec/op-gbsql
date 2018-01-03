-- auto gen by cherry 2016-11-12 10:45:00
CREATE TABLE IF not EXISTS api_tip_order(
	id  SERIAL4 NOT NULL PRIMARY KEY,
	api_id int4 NOT NULL,
	account varchar(32) NOT NULL,
	sands_name varchar(64),
	site_id int4,
	game_code varchar(64),
	game_id int4,
	game_type varchar(32),
	api_type_id int4,
	tip_amount numeric(20,2),
	bill_no varchar(64) not NULL,
	bet_id varchar(64),
	tip_time timestamp(6) NOT NULL,
	terminal varchar(8) COLLATE "default",
	additional_result text,
	create_time timestamp(6),
	status varchar(16),
	distribute_state varchar(32),
	anchor VARCHAR(64),
	CONSTRAINT "u_api_tip_order" UNIQUE ("api_id", "bill_no")
);

COMMENT ON TABLE api_tip_order is 'api小费记录';

COMMENT on COLUMN api_tip_order.id is '主键';

COMMENT ON COLUMN api_tip_order.api_id is 'api';

COMMENT ON COLUMN api_tip_order.account is '玩家游戏账号';

COMMENT ON COLUMN api_tip_order.sands_name is '荷官名称';

COMMENT ON COLUMN api_tip_order.site_id is '站点id';

COMMENT ON COLUMN api_tip_order.game_code is '游戏code';

COMMENT ON COLUMN api_tip_order.game_id is '游戏id';

COMMENT ON COLUMN api_tip_order.game_type is '游戏类型';

COMMENT ON COLUMN api_tip_order.api_type_id is 'api类型';

COMMENT ON COLUMN api_tip_order.tip_amount is '小费金额';

COMMENT ON COLUMN api_tip_order.bill_no is '小费在api的交易号';

COMMENT ON COLUMN api_tip_order.bet_id is '小费相关联的注单号';

COMMENT on COLUMN api_tip_order.tip_time is '小费消费时间';

COMMENT ON COLUMN api_tip_order.terminal is '终端:1-PC 2-MOBILE';

COMMENT ON COLUMN api_tip_order.additional_result IS '附加结果';

COMMENT ON COLUMN api_tip_order.create_time is '创建时间';

COMMENT ON COLUMN api_tip_order.status is '小费状态：settle-已结算 cancel-取消';

COMMENT ON COLUMN api_tip_order.distribute_state is '小费分发状态：0-未分发，1-已分发，2-待重新分发，3-已消费';

COMMENT ON COLUMN api_tip_order.anchor is '主播名字';


CREATE TABLE IF NOT EXISTS "api_tip_log" (
"id" SERIAL4  NOT NULL PRIMARY KEY,
"api_id" int4 NOT NULL,
"start_id" int8,
"start_time" timestamp(6),
"update_time" timestamp(6),
"type" varchar(1) COLLATE "default",
"ext_json" varchar(1000) COLLATE "default"
);

COMMENT ON TABLE api_tip_log is '小费记录日志';

COMMENT ON COLUMN api_tip_log.id is '主键';

COMMENT ON COLUMN api_tip_log.api_id is 'api';

COMMENT ON COLUMN api_tip_log.start_id is '开始id';

COMMENT ON COLUMN api_tip_log.start_time is '开始时间';

COMMENT ON COLUMN api_tip_log.update_time is '更新时间';

COMMENT ON COLUMN api_tip_log.type is '类型：0-新增小费';

COMMENT ON COLUMN api_tip_log.ext_json is '自主扩展字段';

ALTER TABLE api_order DROP COLUMN IF EXISTS bet_type;