-- auto gen by cherry 2017-03-17 09:18:17
select redo_sqls($$
ALTER TABLE station_profit_loss ADD COLUMN api_type_id INT4;
$$);

COMMENT ON COLUMN station_profit_loss.api_type_id is 'API类型ID';

update station_profit_loss set api_type_id = 1 where game_type = 'LiveDealer';

update station_profit_loss set api_type_id = 2 where game_type = 'Casino';

update station_profit_loss set api_type_id = 3 where game_type = 'Sportsbook';

update station_profit_loss set api_type_id = 4 where game_type = 'Lottery';