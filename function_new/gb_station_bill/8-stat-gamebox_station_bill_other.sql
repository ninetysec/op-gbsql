drop function if exists gamebox_station_bill_other(hstore);
create or replace function gamebox_station_bill_other(
    map hstore
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点账务.其它费用
--v1.01  2016/05/28  Laser    新增游戏盈亏总额字段total_profit_loss
*/
DECLARE
	bill_id 	INT;
	payable 	FLOAT;
	code 		TEXT;
	actual 		FLOAT;
	grads 		FLOAT;
	way 		TEXT;
	value 		FLOAT;
	limit_value FLOAT;
	name 		TEXT;
	fee 		FLOAT;
	apportion 	FLOAT;
  total_profit_loss 	FLOAT; --v1.01  2016/05/28  Laser
BEGIN
	bill_id = (map->'bill_id')::INT;
	payable = (map->'payable')::FLOAT;
	code = (map->'code')::TEXT;
	actual = (map->'actual')::FLOAT;
	grads = (map->'grads')::FLOAT;
	way = (map->'way')::TEXT;
	value = (map->'value')::FLOAT;
	limit_value = (map->'limit')::FLOAT;
	name = (map->'name')::TEXT;
	fee = (map->'fee')::FLOAT;
	apportion = (map->'apportion')::FLOAT;
	total_profit_loss = (map->'occupy_tatol')::FLOAT; --v1.01  2016/05/28  Laser

	payable = COALESCE(payable, 0);
	code = COALESCE(code, '');
	actual = COALESCE(actual, 0);
	grads = COALESCE(grads, 0);
	way = COALESCE(way, '');
	value = COALESCE(value, 0);
	limit_value = COALESCE(limit_value, 0);
	name = COALESCE(name, '');
	fee = COALESCE(fee, 0);
	apportion = COALESCE(apportion, 0);
	total_profit_loss = COALESCE(total_profit_loss, 0); --v1.01  2016/05/28  Laser

	raise info '------station_bill_other（actual）= %', actual;

	IF name = '~' THEN
		name = '';
	END IF;

	--TODO station_bill_other 新增 游戏盈亏总额字段total_profit_loss
	--TODO 该值为站长中心-结算账单-站长账单的游戏盈利小计
	--v1.01  2016/05/28  Laser
	INSERT INTO station_bill_other(
		station_bill_id, amount_payable, project_code, amount_actual,
		favourable_grads, favourable_way, favourable_value, favourable_limit,
		operate_user_name, fee, apportion_proportion, total_profit_loss
	) VALUES(
		bill_id, payable, code, actual,
		grads, way, value, limit_value,
		name, fee, apportion, total_profit_loss
	);
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_other(map hstore)
IS 'Lins-站点账务.其它费用';
