-- auto gen by george 2018-01-23 10:12:39
--修复数据 默认改为结算账单
update site_bill_template set template_type='1' where file_type is null and template_type is null;
--更新GG捕鱼的游戏类型为捕鱼
update api_gametype_relation set game_type = 'Fish' where api_id=28 and game_type='Casino';