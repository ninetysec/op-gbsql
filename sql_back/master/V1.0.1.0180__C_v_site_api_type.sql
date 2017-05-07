-- auto gen by cheery 2015-11-09 07:18:41
--修改站点API类型视图 by river
DROP VIEW IF EXISTS v_site_api_type;

CREATE OR REPLACE VIEW v_site_api_type AS
  SELECT t.id,
    ( SELECT count(1) AS apicount
      FROM site_api_type_relation a
      WHERE a.type = t.id) AS api_count,
    0 AS player_count,
    t.order_num,
    t.status
  FROM site_api_type t
  ORDER BY t.status DESC, t.order_num;

COMMENT ON VIEW v_site_api_type IS '站点API类型视图--river';

--添加状态字段/站点游戏表添加链接和状态字段/站点游戏国际化表添加游戏介绍和游戏介绍的状态 by river
select redo_sqls($$
    ALTER TABLE site_api_type ADD COLUMN "status" varchar(16);
    ALTER TABLE "site_game" ADD COLUMN "url" varchar(255), ADD COLUMN "status" varchar(16);
    ALTER TABLE "site_game_i18n" ADD COLUMN "introduce_status" varchar(16),ADD COLUMN "game_introduce" text;
$$);

COMMENT ON COLUMN "site_api_type"."status" IS '状态';
COMMENT ON COLUMN "site_game"."url" IS 'URL';
COMMENT ON COLUMN "site_game"."status" IS '状态';
COMMENT ON COLUMN "site_game_i18n"."game_introduce" IS '游戏介绍';
COMMENT ON COLUMN "site_game_i18n"."introduce_status" IS '游戏介绍状态';

