-- auto gen by cheery 2015-12-10 09:12:38
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'setting', 'close_site_time_type', '1', '1', '立即生效', NULL, 't'
   WHERE '1' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'close_site_time_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'setting', 'close_site_time_type', '2', '2', '定时生效', NULL, 't'
   WHERE '2' not in (SELECT dict_code from sys_dict where module = 'setting' and dict_type = 'close_site_time_type');

		ALTER TABLE "game" DROP COLUMN IF EXISTS "game_type_parent";
  select redo_sqls($$
			ALTER TABLE "api" ADD COLUMN "code" varchar(32);
			ALTER TABLE "api" ADD COLUMN "maintain_start_time" timestamp;
			ALTER TABLE "api" ADD COLUMN "maintain_end_time" timestamp;
			ALTER TABLE "api" ADD COLUMN "domain" varchar(255);
			ALTER TABLE "api" ADD COLUMN "announment_id" int4;

			ALTER TABLE "site_api" ADD COLUMN "code" varchar(32);
			ALTER TABLE "site_api" ADD COLUMN "maintain_start_time" date;
			ALTER TABLE "site_api" ADD COLUMN "maintain_end_time" date;

			ALTER TABLE "api_i18n" ADD COLUMN "introduce_status" varchar(32);
			ALTER TABLE "api_i18n" ADD COLUMN "introduce_content" text;

		ALTER TABLE "game" ADD COLUMN "code" varchar(32);
		ALTER TABLE "game" ADD COLUMN "api_type_id" int4;
		ALTER TABLE "game" ADD COLUMN "maintain_start_time" date;
		ALTER TABLE "game" ADD COLUMN "maintain_end_time" date;
  $$);

COMMENT ON COLUMN "api"."code" IS '代号';
COMMENT ON COLUMN "api"."maintain_start_time" IS '维护开始时间';
COMMENT ON COLUMN "api"."maintain_end_time" IS '维护结束时间';
COMMENT ON COLUMN "api"."domain" IS 'api的默认域名';
COMMENT ON COLUMN "api"."announment_id" IS '公告表ID';

COMMENT ON COLUMN "site_api"."code" IS '代号';
COMMENT ON COLUMN "site_api"."maintain_start_time" IS '维护开始时间';
COMMENT ON COLUMN "site_api"."maintain_end_time" IS '维护结束时间';

COMMENT ON COLUMN "api_i18n"."introduce_status" IS 'API介绍状态';
COMMENT ON COLUMN "api_i18n"."introduce_content" IS 'API介绍内容';

ALTER TABLE "game" DROP COLUMN IF EXISTS "game_type_parent";

COMMENT ON COLUMN "game"."code" IS '代号';
COMMENT ON COLUMN "game"."api_type_id" IS 'API类型ID';
COMMENT ON COLUMN "game"."maintain_start_time" IS '维护开始时间';
COMMENT ON COLUMN "game"."maintain_end_time" IS '维护结束时间';

CREATE TABLE IF NOT EXISTS "api_gametype_relation" (
"id" serial4 NOT NULL,
"api_id" int4,
"game_type" varchar(32),
"url" varchar(128),
"parameter" varchar(1024),
PRIMARY KEY ("id")
);

COMMENT ON TABLE "api_gametype_relation" IS 'API和游戏类型（API二级分类）关系表 by River';
COMMENT ON COLUMN "api_gametype_relation"."id" IS '主键';
COMMENT ON COLUMN "api_gametype_relation"."api_id" IS 'api主键';
COMMENT ON COLUMN "api_gametype_relation"."game_type" IS '游戏分类,即api二级分类';
COMMENT ON COLUMN "api_gametype_relation"."url" IS 'url地址';
COMMENT ON COLUMN "api_gametype_relation"."parameter" IS '参数';
COMMENT ON TABLE "api_gametype_relation" IS 'API和游戏类型关系表 add by river';

DROP VIEW IF EXISTS v_api;
CREATE OR REPLACE VIEW "v_api" AS
 SELECT api.id,
    api.status,
    api.order_num,
    api.maintain_start_time,
    api.maintain_end_time,
    api.code,
    api.domain,
    ( SELECT string_agg((a.type)::text, ','::text) AS type1
           FROM api_type_relation a
          WHERE (a.api_id = api.id)) AS first_category,
    ( SELECT string_agg((api_gametype_relation.game_type)::text, ','::text) AS type2
           FROM api_gametype_relation
          WHERE (api_gametype_relation.api_id = api.id)) AS second_category,
    (( SELECT count(1) AS count
           FROM game gm
          WHERE (gm.api_id = api.id)))::integer AS game_count,
    (( SELECT count(1) AS count
           FROM site_api sa
          WHERE (sa.api_id = api.id)))::integer AS site_count,
        CASE
            WHEN ((api.status)::text <> 'maintain'::text) THEN (api.status)::text
            ELSE
            CASE
                WHEN ((now() < api.maintain_end_time) AND (now() > api.maintain_start_time)) THEN 'maintain'::text
                ELSE 'normal'::text
            END
        END AS real_status,
    api.announment_id
   FROM api api;
COMMENT ON VIEW "v_api" IS 'API视图 add by river';

DROP VIEW if EXISTS v_game;
create or replace view v_game as
 SELECT gm.id,
    gm.api_id,
    gm.game_type,
    gm.order_num,
    gm.url,
    gm.status,
    gm.code,
    gm.api_type_id,
    gm.maintain_start_time,
    gm.maintain_end_time,
        CASE
            WHEN ((gm.status)::text <> 'maintain'::text) THEN (gm.status)::text
            ELSE
            CASE
                WHEN ((now() < gm.maintain_end_time) AND (now() > gm.maintain_start_time)) THEN 'maintain'::text
                ELSE 'normal'::text
            END
        END AS real_status
   FROM game gm;
COMMENT ON VIEW "v_game" IS '游戏列表视图 add by river';


