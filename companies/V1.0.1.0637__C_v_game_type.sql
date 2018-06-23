-- auto gen by linsen 2018-06-23 10:20:30
-- 修改视图v_game_type by zain

DROP VIEW IF EXISTS v_game_type;
CREATE OR REPLACE VIEW  "v_game_type" AS
 SELECT g.game_type,
    g.api_type_id,
    g.api_id,
    g.site_id,
    g.id,
    sd.order_num
   FROM (( SELECT DISTINCT site_game.game_type,
            site_game.api_type_id,
            site_game.api_id,
            site_game.site_id,
            site_game.api_id AS id
           FROM site_game
					WHERE site_game.status!='disable'
          ORDER BY site_game.api_id) g
     LEFT JOIN ( SELECT sys_dict.id,
            sys_dict.module,
            sys_dict.dict_type,
            sys_dict.dict_code,
            sys_dict.order_num,
            sys_dict.remark,
            sys_dict.parent_code,
            sys_dict.active
           FROM sys_dict
          WHERE (((sys_dict.module)::text = 'game'::text) AND ((sys_dict.dict_type)::text = 'game_type'::text))) sd ON (((g.game_type)::text = (sd.dict_code)::text)));


COMMENT ON VIEW  "v_game_type" IS '站点游戏类型，可以排序 edit by younger';