-- auto gen by cherry 2017-03-31 21:49:19
drop view if exists v_game_type;

CREATE OR REPLACE VIEW "v_game_type" AS

 SELECT DISTINCT site_game.game_type,

    site_game.api_type_id,

    site_game.api_id,

    site_game.site_id,

    site_game.api_id AS id

   FROM site_game

  ORDER BY site_game.api_id;