
-- auto gen by cheery 2015-10-23 15:37:47
--添加site_api表
CREATE TABLE  IF NOT EXISTS "site_api" (
  "id" INT4 NOT NULL,
  "status" varchar(16) COLLATE "default",
  "api_name" varchar(64) COLLATE "default",
  CONSTRAINT "site_api_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "site_api" OWNER TO "postgres";

COMMENT ON TABLE "site_api" IS 'site_api表-- cherry';

COMMENT ON COLUMN "site_api"."id" IS '主键';

COMMENT ON COLUMN "site_api"."status" IS 'api状态(关联字典game.status):正常、游戏维护中';

COMMENT ON COLUMN "site_api"."api_name" IS 'api名称:site_i18n表api_name的key';


--修改site_game表
ALTER TABLE "site_game" DROP COLUMN IF EXISTS "game_aliases";

select redo_sqls($$
  ALTER TABLE "site_game" ADD COLUMN "game_name" varchar(64);
  ALTER TABLE "site_game" ADD COLUMN "cover" varchar(128);
$$);

COMMENT ON COLUMN "site_game"."game_name" IS '游戏名称:取site_i18n表game_name的key';

COMMENT ON COLUMN "site_game"."cover" IS '游戏封面';

--删除系统公告表
DROP TABLE IF EXISTS announcement_message;


