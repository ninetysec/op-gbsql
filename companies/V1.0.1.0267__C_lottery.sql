-- auto gen by cherry 2017-04-21 21:16:37
CREATE TABLE IF not EXISTS "lottery" (

"id" serial4 NOT NULL PRIMARY KEY,

"type" varchar(32) ,

"code" varchar(32) ,

"status" varchar(16) ,

"order_num" int4,

"terminal" varchar(2)

)
WITH (OIDS=FALSE)

;

COMMENT ON TABLE "lottery" IS '彩种表';

COMMENT ON COLUMN "lottery"."id" IS '主键';

COMMENT ON COLUMN "lottery"."type" IS '彩种类型';

COMMENT ON COLUMN "lottery"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery"."status" IS '彩种状态:正常,维护';

COMMENT ON COLUMN "lottery"."order_num" IS '序号';

COMMENT ON COLUMN "lottery"."terminal" IS '支持终端：0-全部终端,1-PC,2-移动';

CREATE TABLE IF not EXISTS "lottery_betting" (

"id" serial4 NOT NULL PRIMARY KEY,

"type" varchar(32) ,

"code" varchar(32) ,

"name" varchar(32)

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_betting" IS '投注玩法表';

COMMENT ON COLUMN "lottery_betting"."id" IS '主键';

COMMENT ON COLUMN "lottery_betting"."type" IS '彩种类型';

COMMENT ON COLUMN "lottery_betting"."code" IS '投注玩法代号';

COMMENT ON COLUMN "lottery_betting"."name" IS '玩法名称';

CREATE TABLE IF NOT EXISTS "lottery_gather_conf" (

"id" serial4 NOT NULL PRIMARY KEY,

"abbr_name" varchar(32) ,

"name" varchar(32) ,

"code" varchar(32)  NOT NULL,

"type" varchar(32) ,

"url" varchar(200) ,

"method" varchar(200) ,

"request_content_type" varchar(20) ,

"response_content_type" varchar(20) ,

"json_param" varchar(500)

)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_gather_conf" IS '彩票采集接口配置表';

COMMENT ON COLUMN "lottery_gather_conf"."abbr_name" IS '彩票接口名称,参考LotteryGatherEnum';

COMMENT ON COLUMN "lottery_gather_conf"."name" IS '彩票接口名称';

COMMENT ON COLUMN "lottery_gather_conf"."code" IS '彩票code,参考LotteryEnum';

COMMENT ON COLUMN "lottery_gather_conf"."type" IS '彩票类型,参考LotteryTypeEnum';

COMMENT ON COLUMN "lottery_gather_conf"."url" IS '请求地址';

COMMENT ON COLUMN "lottery_gather_conf"."method" IS '请求方法';

COMMENT ON COLUMN "lottery_gather_conf"."request_content_type" IS '请求类型';

COMMENT ON COLUMN "lottery_gather_conf"."response_content_type" IS '响应类型';

COMMENT ON COLUMN "lottery_gather_conf"."json_param" IS 'json参数';

CREATE TABLE IF NOT EXISTS "lottery_handicap" (

"id" serial4 NOT NULL PRIMARY KEY,

"code" varchar(32)  NOT NULL,

"expect" varchar(32) ,

"open_time" time(6),

"close_time" time(6),

"lottery_time" time(6)

)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_handicap" IS '彩种盘口';

COMMENT ON COLUMN "lottery_handicap"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_handicap"."expect" IS '期数';

COMMENT ON COLUMN "lottery_handicap"."open_time" IS '开盘时间';

COMMENT ON COLUMN "lottery_handicap"."close_time" IS '封盘时间';

COMMENT ON COLUMN "lottery_handicap"."lottery_time" IS '开奖时间';

CREATE TABLE IF not EXISTS "lottery_handicap_lhc" (

"id" serial4 NOT NULL,

"code" varchar(32)  NOT NULL,

"expect" varchar(32) ,

"open_time" timestamp(6),

"close_time" timestamp(6),

"lottery_time" timestamp(6)

)

WITH (OIDS=FALSE)

;

COMMENT ON TABLE "lottery_handicap_lhc" IS '彩种盘口';

COMMENT ON COLUMN "lottery_handicap_lhc"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_handicap_lhc"."expect" IS '期数';

COMMENT ON COLUMN "lottery_handicap_lhc"."open_time" IS '开盘时间';

COMMENT ON COLUMN "lottery_handicap_lhc"."close_time" IS '封盘时间';

COMMENT ON COLUMN "lottery_handicap_lhc"."lottery_time" IS '开奖时间';

CREATE TABLE IF NOT EXISTS "lottery_odd" (

"id" serial4 NOT NULL PRIMARY key,

"code" varchar(32) ,

"bet_code" varchar(32) ,

"bet_num" varchar(32) ,

"odd" numeric(20,3)

)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_odd" IS '赔率设置表';

COMMENT ON COLUMN "lottery_odd"."id" IS '主键';

COMMENT ON COLUMN "lottery_odd"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_odd"."bet_code" IS '玩法代号';

COMMENT ON COLUMN "lottery_odd"."bet_num" IS '号码';

COMMENT ON COLUMN "lottery_odd"."odd" IS '赔率';

CREATE TABLE IF NOT EXISTS "lottery_play" (

"id" serial4 NOT NULL PRIMARY key,

"type" varchar(32) ,

"code" varchar(32) ,

"name" varchar(32)

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_play" IS '彩种玩法表';

COMMENT ON COLUMN "lottery_play"."id" IS '主键';

COMMENT ON COLUMN "lottery_play"."type" IS '彩种类型';

COMMENT ON COLUMN "lottery_play"."code" IS '彩种玩法代号';

COMMENT ON COLUMN "lottery_play"."name" IS '玩法名称';

CREATE TABLE IF NOT EXISTS "lottery_quota" (

"id" serial4 NOT NULL PRIMARY KEY,

"code" varchar(32)  NOT NULL,

"play_code" varchar(32) ,

"num_quota" numeric(20),

"bet_quota" numeric(20),

"play_quota" numeric(20)

)

WITH (OIDS=FALSE)



;

COMMENT ON TABLE "lottery_quota" IS '限额设置表';

COMMENT ON COLUMN "lottery_quota"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_quota"."play_code" IS '彩种玩法';

COMMENT ON COLUMN "lottery_quota"."num_quota" IS '单项限额';

COMMENT ON COLUMN "lottery_quota"."bet_quota" IS '单注限额';

COMMENT ON COLUMN "lottery_quota"."play_quota" IS '单类别单项限额';

CREATE TABLE IF not EXISTS "lottery_result" (

"id" serial4 NOT NULL PRIMARY KEY,

"expect" varchar(32) ,

"code" varchar(32) ,

"type" varchar(32) ,

"open_code" varchar(128) ,

"open_time" timestamp(6)

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_result" IS '开奖结果主表';

COMMENT ON COLUMN "lottery_result"."id" IS 'ID主键';

COMMENT ON COLUMN "lottery_result"."expect" IS '开奖期数';

COMMENT ON COLUMN "lottery_result"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_result"."type" IS '彩种类型';

COMMENT ON COLUMN "lottery_result"."open_code" IS '开奖结果,多个号码逗号隔开';

COMMENT ON COLUMN "lottery_result"."open_time" IS '开奖时间 ';

CREATE TABLE IF not EXISTS  "lottery_result_pk10" (

"id" serial4 NOT NULL PRIMARY KEY,

"expect" varchar(32) ,

"code" varchar(32) ,

"open_time" timestamp(6),

"bet_type" varchar(32) ,

"first" varchar(32) ,

"second" varchar(32) ,

"third" varchar(32) ,

"fourth" varchar(32) ,

"fifth" varchar(32) ,

"sixth" varchar(32) ,

"seventh" varchar(32) ,

"eighth" varchar(32) ,

"ninth" varchar(32) ,

"tenth" varchar(32) ,

"sum_crown_sub" varchar(32)

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_result_pk10" IS 'PK10开奖结果';

COMMENT ON COLUMN "lottery_result_pk10"."id" IS 'ID主键';

COMMENT ON COLUMN "lottery_result_pk10"."expect" IS '开奖期数';

COMMENT ON COLUMN "lottery_result_pk10"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_result_pk10"."open_time" IS '开奖时间 ';

COMMENT ON COLUMN "lottery_result_pk10"."bet_type" IS '投注类型，数字，单双，大小，单双，质合';

COMMENT ON COLUMN "lottery_result_pk10"."first" IS '第一个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."second" IS '第二个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."third" IS '第三个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."fourth" IS '第四个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."fifth" IS '第五个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."sixth" IS '第六个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."seventh" IS '第七个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."eighth" IS '第八个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."ninth" IS '第九个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."tenth" IS '第十个球 ';

COMMENT ON COLUMN "lottery_result_pk10"."sum_crown_sub" IS '冠亚和 ';

CREATE TABLE IF not EXISTS "lottery_result_ssc" (

"id" serial4 NOT NULL,

"expect" varchar(32) ,

"code" varchar(32) ,

"open_time" timestamp(6),

"first" varchar(32) ,

"second" varchar(32) ,

"third" varchar(32) ,

"fourth" varchar(32) ,

"fifth" varchar(32) ,

"first_big_small" varchar(32) ,

"second_big_small" varchar(32) ,

"third_big_small" varchar(32) ,

"fourth_big_small" varchar(32) ,

"fifth_big_small" varchar(32) ,

"first_single_double" varchar(32) ,

"second_single_double" varchar(32) ,

"third_single_double" varchar(32) ,

"fourth_single_double" varchar(32) ,

"fifth_single_double" varchar(32) ,

"total_sum" varchar(32) ,

"sum_big_small" varchar(32) ,

"sum_single_double" varchar(32) ,

"dragon_tiger_tie" varchar(32)

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_result_ssc" IS '时时彩开奖结果';

COMMENT ON COLUMN "lottery_result_ssc"."id" IS 'ID主键';

COMMENT ON COLUMN "lottery_result_ssc"."expect" IS '开奖期数';

COMMENT ON COLUMN "lottery_result_ssc"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_result_ssc"."open_time" IS '开奖时间 ';

COMMENT ON COLUMN "lottery_result_ssc"."first" IS '第一个球';

COMMENT ON COLUMN "lottery_result_ssc"."second" IS '第二个球';

COMMENT ON COLUMN "lottery_result_ssc"."third" IS '第三个球';

COMMENT ON COLUMN "lottery_result_ssc"."fourth" IS '第四个球';

COMMENT ON COLUMN "lottery_result_ssc"."fifth" IS '第五个球';

COMMENT ON COLUMN "lottery_result_ssc"."first_big_small" IS '第一个球大小';

COMMENT ON COLUMN "lottery_result_ssc"."second_big_small" IS '第二个球大小';

COMMENT ON COLUMN "lottery_result_ssc"."third_big_small" IS '第三个球大小';

COMMENT ON COLUMN "lottery_result_ssc"."fourth_big_small" IS '第四个球大小';

COMMENT ON COLUMN "lottery_result_ssc"."fifth_big_small" IS '第五个球大小';

COMMENT ON COLUMN "lottery_result_ssc"."first_single_double" IS '第一个球单双';

COMMENT ON COLUMN "lottery_result_ssc"."second_single_double" IS '第二个球单双';

COMMENT ON COLUMN "lottery_result_ssc"."third_single_double" IS '第三个球单双';

COMMENT ON COLUMN "lottery_result_ssc"."fourth_single_double" IS '第四个球单双';

COMMENT ON COLUMN "lottery_result_ssc"."fifth_single_double" IS '第五个球单双';

COMMENT ON COLUMN "lottery_result_ssc"."total_sum" IS '总和';

COMMENT ON COLUMN "lottery_result_ssc"."sum_big_small" IS '总和大小';

COMMENT ON COLUMN "lottery_result_ssc"."sum_single_double" IS '总和单双';

COMMENT ON COLUMN "lottery_result_ssc"."dragon_tiger_tie" IS '龙虎和 ';

CREATE TABLE IF not EXISTS "lottery_winning_record" (

"id" serial4 NOT NULL PRIMARY KEY,

"expect" varchar(32) ,

"code" varchar(32) ,

"play_code" varchar(32) ,

"bet_code" varchar(32) ,

"winning_num" varchar(32)

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "lottery_winning_record" IS '中奖记录表';

COMMENT ON COLUMN "lottery_winning_record"."id" IS '主键';

COMMENT ON COLUMN "lottery_winning_record"."expect" IS '开奖期数';

COMMENT ON COLUMN "lottery_winning_record"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_winning_record"."play_code" IS '彩种玩法';

COMMENT ON COLUMN "lottery_winning_record"."bet_code" IS '投注玩法';

COMMENT ON COLUMN "lottery_winning_record"."winning_num" IS '中奖号码';

CREATE TABLE IF not EXISTS "site_lottery_odd" (

"id" serial4 NOT NULL PRIMARY KEY,

"site_id" int4,

"code" varchar(32) ,

"bet_code" varchar(32) ,

"bet_num" varchar(32) ,

"odd" numeric(20,3)

)

WITH (OIDS=FALSE)



;

COMMENT ON TABLE "site_lottery_odd" IS '赔率设置表';

COMMENT ON COLUMN "site_lottery_odd"."id" IS '主键';

COMMENT ON COLUMN "site_lottery_odd"."code" IS '彩种代号';

COMMENT ON COLUMN "site_lottery_odd"."bet_code" IS '玩法代号';

COMMENT ON COLUMN "site_lottery_odd"."bet_num" IS '号码';

COMMENT ON COLUMN "site_lottery_odd"."odd" IS '赔率';

CREATE TABLE IF not EXISTS "site_lottery_quota" (

"id" serial4 NOT NULL PRIMARY KEY,

"code" varchar(32)  NOT NULL,

"site_id" int4,

"play_code" varchar(32) ,

"num_quota" numeric(20),

"bet_quota" numeric(20),

"play_quota" numeric(20)

)

WITH (OIDS=FALSE)
;

COMMENT ON TABLE "site_lottery_quota" IS '站点限额设置表';

COMMENT ON COLUMN "site_lottery_quota"."code" IS '彩种代号';

COMMENT ON COLUMN "site_lottery_quota"."site_id" IS '站点id';

COMMENT ON COLUMN "site_lottery_quota"."play_code" IS '彩种玩法';

COMMENT ON COLUMN "site_lottery_quota"."num_quota" IS '单项限额';

COMMENT ON COLUMN "site_lottery_quota"."bet_quota" IS '单注限额';

COMMENT ON COLUMN "site_lottery_quota"."play_quota" IS '单类别单项限额';

