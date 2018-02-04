-- auto gen by cherry 2018-01-23 17:03:28
CREATE TABLE IF not EXISTS pay_account_rate_history(
	id serial4 PRIMARY key,
	site_id int4,
	pay_account_id int4,
	account varchar(200),
	bank_code varchar(50),
	account_type varchar(50),
	minute_weight int4,
	hour_weight int4,
	day_weight int4,
	level1_weight int4,
	level2_weight int4,
	level3_weight int4,
	minute_success int4,
	minute_total int4,
	hour_success int4,
	hour_total int4,
	day_success int4,
	day_total int4,
	level1_success int4,
	level1_total int4,
	level2_success int4,
	level2_total int4,
	level3_success int4,
	level3_total int4,
	syn_time TIMESTAMP(6),
	time_weight int4,
	level_weight int4,
	recharge_minute int4,
	recharge_hour int4,
	recharge_day int4,
	level1 int4,
	level2 int4,
	level3 int4
);

COMMENT ON TABLE pay_account_rate_history is '站点收款账号成功率';
COMMENT on COLUMN pay_account_rate_history.id is '主键';
COMMENT on COLUMN pay_account_rate_history.site_id is '站点id';
COMMENT on COLUMN pay_account_rate_history.pay_account_id is '收款账号id';
COMMENT on COLUMN pay_account_rate_history.account is '商户号';
COMMENT on COLUMN pay_account_rate_history.bank_code is '渠道';
COMMENT on COLUMN pay_account_rate_history.account_type is '账户类型';
COMMENT on COLUMN pay_account_rate_history.minute_weight is '分钟权重';
COMMENT on COLUMN pay_account_rate_history.hour_weight is '小时权重';
COMMENT on COLUMN pay_account_rate_history.day_weight is '天数权重';
COMMENT on COLUMN pay_account_rate_history.level1_weight is '等级1权重';
COMMENT on COLUMN pay_account_rate_history.level2_weight is '等级2权重';
COMMENT on COLUMN pay_account_rate_history.level3_weight is '等级3权重';
COMMENT on COLUMN pay_account_rate_history.minute_success is '分钟成功存款数';
COMMENT on COLUMN pay_account_rate_history.minute_total is '分钟存款总数';
COMMENT on COLUMN pay_account_rate_history.hour_success is '小时成功存款数';
COMMENT on COLUMN pay_account_rate_history.hour_total is '小时存款总数';
COMMENT on COLUMN pay_account_rate_history.day_success is '天数成功存款数';
COMMENT on COLUMN pay_account_rate_history.day_total is '天数存款总数';
COMMENT on COLUMN pay_account_rate_history.level1_success is '等级1成功数';
COMMENT on COLUMN pay_account_rate_history.level1_total is '等级1存款总数';
COMMENT on COLUMN pay_account_rate_history.level2_success is '等级2成功数';
COMMENT on COLUMN pay_account_rate_history.level2_total is '等级2存款总数';
COMMENT on COLUMN pay_account_rate_history.level3_success is '等级3成功数';
COMMENT on COLUMN pay_account_rate_history.level3_total is '等级3存款总数';
COMMENT on COLUMN pay_account_rate_history.syn_time is '同步时间';
COMMENT on COLUMN pay_account_rate_history.time_weight is '单位时间权重';
COMMENT on COLUMN pay_account_rate_history.level_weight is '单位笔数权重';
COMMENT on COLUMN pay_account_rate_history.recharge_minute is '近x分钟';
COMMENT on COLUMN pay_account_rate_history.recharge_hour is '近x小时';
COMMENT on COLUMN pay_account_rate_history.recharge_day is '近x天';
COMMENT on COLUMN pay_account_rate_history.level1 is '等级1近x笔';
COMMENT on COLUMN pay_account_rate_history.level2 is '等级2近x笔';
COMMENT on COLUMN pay_account_rate_history.level3 is '等级3近x笔';
