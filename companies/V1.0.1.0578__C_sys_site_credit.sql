-- auto gen by linsen 2018-03-25 17:19:53
-- 买分表 by linsen
CREATE TABLE IF not EXISTS sys_site_credit (
"id" int4 not null PRIMARY KEY,
"max_profit" numeric,
"default_profit" numeric(20,2),
"profit_time" timestamp(6),
"default_transfer_limit" numeric(20,2),
"current_transfer_limit" numeric(20,2),
"transfer_limit_time" timestamp(6),
"transfer_out_sum" numeric(20,2),
"transfer_into_sum" numeric(20,2),
"has_use_profit" numeric(20,2),
"credit_line" numeric(20,2),
"transfer_line" numeric(20,2),
"authorize_end_time" timestamp(6),
"profit_ratio" numeric(20,2),
"transfer_ratio" numeric(20,2),
"remark" text COLLATE "default"
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "sys_site_credit" IS '买分表--linsen';

COMMENT ON COLUMN "sys_site_credit"."id" IS '站点ID';

COMMENT ON COLUMN "sys_site_credit"."max_profit" IS '盈利上限';

COMMENT ON COLUMN "sys_site_credit"."default_profit" IS '默认额度';

COMMENT ON COLUMN "sys_site_credit"."profit_time" IS '额度超出时间';

COMMENT ON COLUMN "sys_site_credit"."default_transfer_limit" IS '默认转账上限';

COMMENT ON COLUMN "sys_site_credit"."current_transfer_limit" IS '当前转账上限';

COMMENT ON COLUMN "sys_site_credit"."transfer_limit_time" IS '转账超出倒计时时间';

COMMENT ON COLUMN "sys_site_credit"."transfer_out_sum" IS '当前转出统计';

COMMENT ON COLUMN "sys_site_credit"."transfer_into_sum" IS '当前转入统计';

COMMENT ON COLUMN "sys_site_credit"."has_use_profit" IS '已使用额度';

COMMENT ON COLUMN "sys_site_credit"."credit_line" IS '买分授信额度';

COMMENT ON COLUMN "sys_site_credit"."transfer_line" IS '转账授信额度';

COMMENT ON COLUMN "sys_site_credit"."authorize_end_time" IS '授权截止时间';

COMMENT ON COLUMN "sys_site_credit"."profit_ratio" IS '买分兑换比例';

COMMENT ON COLUMN "sys_site_credit"."transfer_ratio" IS '转账兑换比例';

COMMENT ON COLUMN "sys_site_credit"."remark" IS '备注';


-- 同步sys_site表买分相关数据到sys_site_credit表
INSERT INTO sys_site_credit (id,max_profit,default_profit,profit_time,default_transfer_limit,current_transfer_limit,transfer_limit_time,transfer_out_sum,transfer_into_sum,has_use_profit,credit_line,authorize_end_time)
 SELECT id,max_profit,default_profit,profit_time,default_transfer_limit,current_transfer_limit,transfer_limit_time,transfer_out_sum,transfer_into_sum,has_use_profit,credit_line,authorize_end_time from sys_site ss where ss.id>0
AND NOT EXISTS(SELECT "id" FROM sys_site_credit WHERE "id"=ss.id);