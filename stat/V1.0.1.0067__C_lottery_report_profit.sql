-- auto gen by marz 2017-10-09 16:21:20
﻿CREATE TABLE IF NOT EXISTS  "lottery_report_profit" (
"id" SERIAL4 NOT NULL,
"center_id" int4 NOT NULL,
"site_id" int4 NOT NULL,
"code" varchar(32) NOT NULL,
"play_code" varchar(32) NOT NULL ,
"bet_code" varchar(32) NOT NULL ,
"bet_amount" numeric(20,2) NOT NULL,
"bet_volume" int4 NOT NULL,
"payout" numeric(20,2) NOT NULL,
"static_date" date NOT NULL,
"static_start" timestamp(6) NOT NULL,
"static_end" timestamp(6) NOT NULL,
CONSTRAINT "lottery_report_profit_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE "lottery_report_profit" IS '彩票报表统计';

COMMENT ON COLUMN "lottery_report_profit"."id" IS '主键';

COMMENT ON COLUMN "lottery_report_profit"."center_id" IS '运营商ID';

COMMENT ON COLUMN "lottery_report_profit"."site_id" IS '站点ID';

COMMENT ON COLUMN "lottery_report_profit"."code" IS '彩种';

COMMENT ON COLUMN "lottery_report_profit"."play_code" IS '彩种玩法';

COMMENT ON COLUMN "lottery_report_profit"."bet_code" IS '投注玩法';

COMMENT ON COLUMN "lottery_report_profit"."bet_amount" IS '投注金额';

COMMENT ON COLUMN "lottery_report_profit"."bet_volume" IS '投注单量';

COMMENT ON COLUMN "lottery_report_profit"."payout" IS '派彩金额';

COMMENT ON COLUMN "lottery_report_profit"."static_date" IS '统计日期';

COMMENT ON COLUMN "lottery_report_profit"."static_start" IS '统计起始日期';

COMMENT ON COLUMN "lottery_report_profit"."static_end" IS '统计截止日期';



CREATE INDEX "fk_lottery_report_profit_code" ON "lottery_report_profit" USING btree (code);

CREATE INDEX "fk_lottery_report_profit_static_date" ON "lottery_report_profit" USING btree (static_date);
