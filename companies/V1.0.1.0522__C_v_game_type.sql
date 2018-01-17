-- auto gen by george 2018-01-17 11:49:42
DROP VIEW IF EXISTS v_game_type;
CREATE OR REPLACE VIEW "v_game_type" AS
 select  g.*,sd.order_num from (SELECT DISTINCT site_game.game_type,
    site_game.api_type_id,
    site_game.api_id,
    site_game.site_id,
    site_game.api_id AS id
   FROM site_game
  ORDER BY site_game.api_id) g left join (select * from sys_dict where "module"='game' and dict_type='game_type') sd on g.game_type = sd.dict_code;

COMMENT ON VIEW "v_game_type" IS '站点游戏类型，可以排序 edit by younger';
