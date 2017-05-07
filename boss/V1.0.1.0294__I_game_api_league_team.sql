-- auto gen by admin 2017-02-18 08:54:38
-- auto gen by root 2016-10-11 20:09:49

CREATE TABLE IF not EXISTS "game_api_league" (
"id" SERIAL4 NOT NULL,
"api_id" int4,
"league_id" varchar(64) COLLATE "default" NOT NULL,
"lang" varchar(10) COLLATE "default" ,
"league_name" varchar(200) COLLATE "default",
"result_json" text COLLATE "default",
"version_key" int4,
"create_time" timestamp(6),
"update_time" timestamp(6),
CONSTRAINT "league_pkey" PRIMARY KEY ("id"),
CONSTRAINT "u_league" UNIQUE ("api_id", "league_id")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "game_api_league" IS 'api游戏赛事表 ';

COMMENT ON COLUMN "game_api_league"."id" IS '主键';

COMMENT ON COLUMN "game_api_league"."api_id" IS 'api表id';

COMMENT ON COLUMN "game_api_league"."league_id" IS '联赛id';

COMMENT ON COLUMN "game_api_league"."lang" IS '语言';

COMMENT ON COLUMN "game_api_league"."league_name" IS '联赛名称';

COMMENT ON COLUMN "game_api_league"."result_json" IS 'result_json';

COMMENT ON COLUMN "game_api_league"."version_key" IS '版本号';

COMMENT ON COLUMN "game_api_league"."create_time" IS '入库时间';

COMMENT ON COLUMN "game_api_league"."update_time" IS '更新时间';



CREATE INDEX IF not EXISTS "fk_league_api_id" ON "game_api_league" USING btree (api_id);

CREATE INDEX IF not EXISTS "fk_league_league_id" ON "game_api_league" USING btree (league_id);


-- auto gen by root 2016-10-11 20:09:49
CREATE TABLE IF not EXISTS "game_api_team" (
"id" SERIAL4 NOT NULL,
"api_id" int4,
"team_id" varchar(64) COLLATE "default" NOT NULL,
"lang" varchar(10) COLLATE "default" ,
"team_name" varchar(200) COLLATE "default",
"result_json" text COLLATE "default",
"version_key" int4,
"create_time" timestamp(6),
"update_time" timestamp(6),
CONSTRAINT "team_pkey" PRIMARY KEY ("id"),
CONSTRAINT "u_team" UNIQUE ("api_id", "team_id")
)
WITH (OIDS=FALSE)
;


COMMENT ON TABLE "game_api_team" IS 'api游戏赛事表 ';

COMMENT ON COLUMN "game_api_team"."id" IS '主键';

COMMENT ON COLUMN "game_api_team"."api_id" IS 'api表id';

COMMENT ON COLUMN "game_api_team"."team_id" IS '联赛id';

COMMENT ON COLUMN "game_api_team"."lang" IS '语言';

COMMENT ON COLUMN "game_api_team"."team_name" IS '联赛名称';

COMMENT ON COLUMN "game_api_team"."result_json" IS 'result_json';

COMMENT ON COLUMN "game_api_team"."version_key" IS '版本号';

COMMENT ON COLUMN "game_api_team"."create_time" IS '入库时间';

COMMENT ON COLUMN "game_api_team"."update_time" IS '更新时间';



CREATE INDEX IF not EXISTS "fk_team_api_id" ON "game_api_team" USING btree (api_id);

CREATE INDEX IF not EXISTS "fk_team_team_id" ON "game_api_team" USING btree (team_id);