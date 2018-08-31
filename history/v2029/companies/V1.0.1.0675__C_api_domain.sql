-- auto gen by linsen 2018-08-20 14:16:14
-- API备用域名表 by linsen
CREATE TABLE IF NOT EXISTS "api_domain" (
"id" SERIAL4 NOT NULL,
"api_id"  int4,
"domain" varchar(128) COLLATE "default" NOT NULL,
"terminal" varchar(2) COLLATE "default" NOT NULL,
"remark" varchar(500) COLLATE "default",

CONSTRAINT "api_domain_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE "api_domain" IS 'API备用域名表--linsen';

COMMENT ON COLUMN "api_domain"."api_id" IS 'API的id';

COMMENT ON COLUMN "api_domain"."domain" IS '域名';

COMMENT ON COLUMN "api_domain"."terminal" IS '终端类型(1-PC;2-手机)';

COMMENT ON COLUMN "api_domain"."remark" IS '备注';

