-- auto gen by cheery 2015-09-21 03:45:21
select redo_sqls($$
  ALTER TABLE game add COLUMN game_type_parent varchar(32);
$$);

COMMENT ON COLUMN game.game_type_parent  IS '一级游戏分类:Dicts:Module:game Dict_Type:game_type_parent';
