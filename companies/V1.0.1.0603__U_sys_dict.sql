-- auto gen by linsen 2018-04-26 16:22:20
--更新game_type对应的api_type_id by younger
update sys_dict set parent_code='1' where dict_type='game_type' and dict_code='LiveDealer' and module='game';
update sys_dict set parent_code='2' where dict_type='game_type' and dict_code='Casino' and module='game';
update sys_dict set parent_code='2' where dict_type='game_type' and dict_code='Fish' and module='game';
update sys_dict set parent_code='3' where dict_type='game_type' and dict_code='Sportsbook' and module='game';
update sys_dict set parent_code='4' where dict_type='game_type' and dict_code='Lottery' and module='game';
update sys_dict set parent_code='4' where dict_type='game_type' and dict_code='SixLottery' and module='game';
update sys_dict set parent_code='5' where dict_type='game_type' and dict_code='Chess' and module='game';