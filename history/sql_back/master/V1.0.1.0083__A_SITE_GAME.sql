-- auto gen by cheery 2015-09-21 03:46:55
--新增字段category类别
COMMENT ON COLUMN site_game.game_type IS '二级游戏类别:Dicts:Module:game Dict_Type:game_type';

COMMENT ON COLUMN site_game.game_type_parent IS '一级游戏分类:Dicts:Module:game Dict_Type:game_type_parent';

ALTER TABLE site_game DROP COLUMN IF EXISTS key;

select redo_sqls($$
  ALTER TABLE site_game ADD COLUMN category varchar(64);
$$);

COMMENT ON COLUMN site_game.category IS '类别：site_i18n表的key';
