/**
 * Lins-站点账务-API.
 * @author 	Lins
 * @date 	2015-12-14
 * @param 	map 各项值map
**/
drop function if exists gamebox_station_profit_loss(hstore);
create or replace function gamebox_station_profit_loss(
	map hstore
) returns void as $$
DECLARE
	api_id 		INT;
	game_type 	TEXT;
	profit_loss FLOAT;
	occupy_proportion FLOAT;
	amount_payable FLOAT;
	bill_id 	INT;
BEGIN
	api_id = (map->'api_id')::INT;
	game_type = (map->'game_type')::TEXT;
	profit_loss = (map->'profit_loss')::FLOAT;
	occupy_proportion = (map->'occupy_proportion')::FLOAT;
	amount_payable = (map->'amount_payable')::FLOAT;
	bill_id = (map->'bill_id')::INT;

	INSERT INTO station_profit_loss(
		station_bill_id, api_id, profit_loss,
		amount_payable, game_type, occupy_proportion
	) VALUES (
		bill_id, api_id, profit_loss,
		amount_payable, game_type, occupy_proportion
	);
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_profit_loss(
map hstore
) IS 'Lins-站点账务-API';