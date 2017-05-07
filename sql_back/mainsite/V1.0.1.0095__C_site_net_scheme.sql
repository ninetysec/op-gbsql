CREATE TABLE IF NOT EXISTS "site_net_scheme" (
"id" int4 NOT NULL,
"name" varchar(32) COLLATE "default" NOT NULL,
"center_id" int4 NOT NULL,
CONSTRAINT "site_net_scheme_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_net_scheme" OWNER TO "postgres";

COMMENT ON TABLE "site_net_scheme" IS '站点包网方案--tom';

COMMENT ON COLUMN "site_net_scheme"."id" IS '主键';

COMMENT ON COLUMN "site_net_scheme"."name" IS '包网方案名称';

COMMENT ON COLUMN "site_net_scheme"."center_id" IS '运营商ID';