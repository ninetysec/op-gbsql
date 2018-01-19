-- auto gen by george 2018-01-19 15:40:04
--添加APP下载域名层级关联表 by younger
CREATE TABLE IF NOT EXISTS "player_rank_app_domain" (
"id" serial4 NOT NULL PRIMARY KEY,
"rank_id" int4 NOT NULL,
"domain" VARCHAR(256) NOT NULL
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "player_rank_app_domain" IS 'APP下载域名层级关联表';
COMMENT ON COLUMN "player_rank_app_domain"."id" IS '主键';
COMMENT ON COLUMN "player_rank_app_domain"."rank_id" IS '层级ID';
COMMENT ON COLUMN "player_rank_app_domain"."domain" IS '域名';