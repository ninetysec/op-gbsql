DROP FUNCTION if exists gamebox_station_bill_prev(INT, INT, INT, TEXT);
create or replace function gamebox_station_bill_prev(
    site_id 	INT,
    bill_year 	INT,
    bill_month 	INT,
    bill_type 	TEXT
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fei      创建此函数: 站点账务-上期信息
--v1.01  2016/05/25  Laser  	上期未结需要计算应付和实付
--v1.02  2016/06/08  Laser  	修正一处bug，字段缺少逗号
--v1.03  2016/06/10  Laser    修改查询条件，上期未结以应付金额判断
*/
DECLARE
	map hstore:='';
	rec record;
BEGIN
	IF bill_month = 1 THEN
		bill_month = 12;
		bill_year = bill_year - 1;
	ELSE
		bill_month = bill_month - 1;
	END IF;

	--V1.02  2016/06/08  Laser
	FOR rec IN EXECUTE
		' SELECT amount_actual, amount_payable, operate_user_name
			FROM station_bill
		   WHERE site_id = $1
		     AND bill_year = $2
		     AND bill_month = $3
		     AND bill_type = $4
		     --AND amount_actual < 0
		     AND amount_payable < 0
		   LIMIT 1' USING site_id, bill_year, bill_month, bill_type
	LOOP
		--v1.01  2016/05/25  Laser   begin
		SELECT put(map, 'no_bill_payable', COALESCE(rec.amount_payable, 0.00)::TEXT) INTO map;
		SELECT put(map, 'no_bill_actual', COALESCE(rec.amount_actual, 0.00)::TEXT) INTO map;
		--v1.01  2016/05/25  Laser   end
 		SELECT put(map, 'operator', COALESCE(rec.operate_user_name, '~')) INTO map;
	END LOOP;
	RETURN map;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_prev(site_id INT, bill_year INT, bill_month INT, bill_type TEXT)
IS 'Fly-站点账务-上期信息（未结金额，经办人）';
