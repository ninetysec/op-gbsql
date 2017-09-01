-- auto gen by cherry 2017-09-01 20:46:40
	CREATE TABLE  IF NOT EXISTS "lottery_killrate" (
	"id" SERIAL4  NOT NULL PRIMARY KEY,
	"code" varchar(32) ,
	"status" varchar(32) ,
	"killrate" numeric(5,2),
	"update_time"  timestamp,
	"modify" varchar(32) ,
	"calculate_times" int4
	)
	WITH (OIDS=FALSE)
	;

	COMMENT ON TABLE  "lottery_killrate" IS '彩票杀率设置';

	COMMENT ON COLUMN  "lottery_killrate"."id" IS '主键';

	COMMENT ON COLUMN  "lottery_killrate"."code" IS '彩种代号';

	COMMENT ON COLUMN  "lottery_killrate"."status" IS '杀率状态';

	COMMENT ON COLUMN  "lottery_killrate"."killrate" IS '杀率百分比';

	COMMENT ON COLUMN  "lottery_killrate"."update_time" IS '更新时间';

	COMMENT ON COLUMN  "lottery_killrate"."modify" IS '修改人';

	COMMENT ON COLUMN  "lottery_killrate"."calculate_times" IS '最大计算次数';


	INSERT INTO lottery_killrate (code, status, killrate, update_time, modify, calculate_times) SELECT  'efssc', 'disabled', '1', NULL, NULL, 100  WHERE NOT EXISTS (SELECT code  FROM lottery_killrate WHERE code='efssc');

	INSERT INTO lottery_killrate (code, status, killrate, update_time, modify, calculate_times) SELECT  'sfssc', 'disabled', '1', NULL, NULL, 100  WHERE NOT EXISTS (SELECT code  FROM lottery_killrate WHERE code='sfssc');

	INSERT INTO lottery_killrate (code, status, killrate, update_time, modify, calculate_times) SELECT  'wfssc', 'disabled', '1', NULL, NULL, 100  WHERE NOT EXISTS (SELECT code  FROM lottery_killrate WHERE code='wfssc');

	INSERT INTO lottery_killrate (code, status, killrate, update_time, modify, calculate_times) SELECT  'ffssc', 'disabled', '1', NULL, NULL, 100  WHERE NOT EXISTS (SELECT code  FROM lottery_killrate WHERE code='ffssc');

