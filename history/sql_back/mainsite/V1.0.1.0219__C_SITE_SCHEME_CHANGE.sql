-- auto gen by tom 2016-01-07 20:25:18

CREATE TABLE IF NOT EXISTS "site_scheme_change" (
"id" SERIAL4 NOT NULL PRIMARY KEY,
"site_id" int4 NOT NULL,
"contract_scheme_id" int4 NOT NULL,
"effective_time" timestamp(6) NOT NULL,
"operate_user" int4 NOT NULL,
"operate_time" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_scheme_change" OWNER TO "postgres";

COMMENT ON TABLE "site_scheme_change" IS '站点包网方案变更表';

COMMENT ON COLUMN "site_scheme_change"."id" IS '主键';

COMMENT ON COLUMN "site_scheme_change"."site_id" IS '站点Id';

COMMENT ON COLUMN "site_scheme_change"."contract_scheme_id" IS '变更包网方案id';

COMMENT ON COLUMN "site_scheme_change"."effective_time" IS '生效时间（变更年月，日不用考虑）';

COMMENT ON COLUMN "site_scheme_change"."operate_user" IS '操作用户';

COMMENT ON COLUMN "site_scheme_change"."operate_time" IS '操作时间';