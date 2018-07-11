DROP FUNCTION IF EXISTS gamebox_station_profit_loss(hstore);
CREATE OR REPLACE FUNCTION gamebox_station_profit_loss(
    map hstore
) RETURNS void AS $$
/*版本更新说明
  版本   时间        作者   内容
--v1.00  2015/01/01  Lins   创建此函数: 站点账务-API
--v1.01  2017/03/22  Laser  增加api_type_id
--v1.02  2018/01/25  Laser  增加api_type_id=5
*/
DECLARE
  api_id     INT;
  game_type   TEXT;
  profit_loss FLOAT;
  occupy_proportion FLOAT;
  amount_payable FLOAT;
  bill_id   INT;
  api_type_id INT;
BEGIN
  api_id = (map->'api_id')::INT;
  game_type = (map->'game_type')::TEXT;
  profit_loss = (map->'profit_loss')::FLOAT;
  occupy_proportion = (map->'occupy_proportion')::FLOAT;
  amount_payable = (map->'amount_payable')::FLOAT;
  bill_id = (map->'bill_id')::INT;
  api_type_id = CASE game_type WHEN 'LiveDealer' THEN 1 WHEN 'Casino' THEN 2 WHEN 'Sportsbook' THEN 3
                               WHEN 'Lottery' THEN 4 WHEN 'SixLottery' THEN 4 WHEN 'Fish' THEN 2
                               WHEN 'Chess' THEN 5 END;

  INSERT INTO station_profit_loss(
    station_bill_id, api_id, profit_loss,
    amount_payable, game_type, occupy_proportion, api_type_id
  ) VALUES (
    bill_id, api_id, profit_loss,
    amount_payable, game_type, occupy_proportion, api_type_id
  );
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_profit_loss( map hstore) IS 'Lins-站点账务-API';
