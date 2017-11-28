-- auto gen by Cherry 2015-09-08
--修改game表，改为site_game表
select redo_sqls($$
  alter table IF EXISTS game rename to site_game;

  ALTER TABLE site_game ALTER COLUMN id DROP DEFAULT;

  DROP SEQUENCE IF EXISTS  site_game_id_seq ;

  ALTER TABLE site_game DROP COLUMN IF EXISTS game_id;

  ALTER TABLE site_game ADD COLUMN game_type_parent varchar(32);

  COMMENT ON COLUMN site_game.game_type_parent IS '一级游戏分类:Dicts:Module:common Dict_Type:gameType';

  ALTER TABLE site_game ADD COLUMN key varchar(64);

  COMMENT ON COLUMN site_game.key IS 'site_i18n表的key';

$$);


