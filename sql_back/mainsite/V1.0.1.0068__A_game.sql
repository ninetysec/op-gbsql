-- auto gen by cheery 2015-11-09 07:28:14
--游戏表添加链接和状态字段 by river
--游戏国际化表添加游戏介绍和游戏介绍状态 by river
select redo_sqls($$
   ALTER TABLE "game" ADD COLUMN "url" varchar(255), ADD COLUMN "status" varchar(16);
   ALTER TABLE "game_i18n" ADD COLUMN "introduce_status" varchar(16), ADD COLUMN "game_introduce" text;
$$);

COMMENT ON COLUMN "game"."url" IS 'URL';
COMMENT ON COLUMN "game"."status" IS '状态';
COMMENT ON COLUMN "game_i18n"."game_introduce" IS '游戏介绍';
COMMENT ON COLUMN "game_i18n"."introduce_status" IS '游戏介绍状态';