-- auto gen by cherry 2016-03-30 20:42:37
CREATE TABLE if not EXISTS "game_tag" (

"id" SERIAL4 NOT NULL,

"game_id" int4,

"tag_id" varchar(64) COLLATE "default",

CONSTRAINT "game_tag_pkey" PRIMARY KEY ("id")

);

COMMENT ON TABLE "game_tag" IS '游戏标签表 by River';

COMMENT ON COLUMN "game_tag"."id" IS '主键';

COMMENT ON COLUMN "game_tag"."game_id" IS '游戏ID';

COMMENT ON COLUMN "game_tag"."tag_id" IS '标签ID，site_i18n中setting.game_tag的key值';

DROP INDEX if  EXISTS fk_game_tag_game_id;
DROP INDEX if EXISTS fk_game_tag_tag_id;

CREATE INDEX "fk_game_tag_game_id" ON "game_tag" USING btree (game_id);

CREATE INDEX "fk_game_tag_tag_id" ON "game_tag" USING btree (tag_id);