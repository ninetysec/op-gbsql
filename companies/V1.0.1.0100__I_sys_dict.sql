-- auto gen by admin 2016-05-20 15:16:53
insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)

  SELECT 'content', 'carousel_type', 'carousel_type_player_index', 3, '广告类别-玩家中心首页', NULL, 't'

  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = 'carousel_type_player_index');