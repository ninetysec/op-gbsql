-- auto gen by cheery 2015-09-09 08:06:28
--修改字典游戏类型game_type修改为game_type_parent
UPDATE sys_dict set dict_type = 'game_type_parent',remark=replace(remark,'游戏类别','游戏一级分类')  WHERE dict_type = 'game_type'AND "module"='game';

