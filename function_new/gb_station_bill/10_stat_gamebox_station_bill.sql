DROP FUNCTION IF EXISTS gamebox_station_bill(hstore);
create or replace function gamebox_station_bill(
  	dict_map hstore
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 总代占成-当前周期的返佣
--v1.01  2016/05/16  Leisure  bill_id改为returning获取，防止并发
*/
DECLARE
	rec 		record;
	bill_id 	INT;
	s_id 		INT;
	s_name 		TEXT;
	c_id 		INT;
	c_name 		TEXT;
	m_id 		INT;
	m_name 		TEXT;
	c_year 		INT;
	c_month 	INT;
	bill_type 	TEXT;
	bill_no 	TEXT;
	topagent_id INT:=0;
	topagent_name TEXT:='';
	amount 		FLOAT:=0.00;--应付金额
	op 			TEXT;
BEGIN
	s_id = (dict_map->'site_id')::INT;
	c_id = (dict_map->'center_id')::INT;
	m_id = (dict_map->'master_id')::INT;
	s_name = COALESCE((dict_map->'site_name')::TEXT, '');
	c_name = COALESCE((dict_map->'center_name')::TEXT, '');
	m_name = COALESCE((dict_map->'master_name')::TEXT, '');
	c_year = (dict_map->'year')::INT;
	c_month = (dict_map->'month')::INT;
	bill_no = (dict_map->'bill_no')::TEXT;
	bill_type = (dict_map->'bill_type')::TEXT;

	IF bill_type = '2' THEN
		topagent_id = (dict_map->'topagent_id')::INT;
		topagent_name = COALESCE((dict_map->'topagent_name')::TEXT, '');
	END IF;

	op = (dict_map->'op')::TEXT;
	IF op = 'I' THEN
		INSERT INTO station_bill (
		 	center_id, master_id, site_id,
		 	bill_num, amount_payable, bill_year, bill_month,
		 	amount_actual, create_time, topagent_id, topagent_name,
		 	bill_type, site_name, master_name, center_name
		) VALUES (
			c_id, m_id, s_id,
			bill_no, 0, c_year, c_month,
			0, now(), topagent_id, topagent_name,
			bill_type, s_name, m_name, c_name
		) RETURNING "id" into bill_id;
		--v1.01 bill_id改为returning获取，防止并发
		--SELECT currval(pg_get_serial_sequence('station_bill',  'id')) into bill_id;
		raise info 'station_bill.完成.键值:%', bill_id;
	ELSEIF op = 'U' THEN
		bill_id = (dict_map->'bill_id')::INT;
		amount = (dict_map->'amount')::FLOAT;
		UPDATE station_bill SET amount_payable = amount, amount_actual = amount WHERE id = bill_id;
	END IF;

	RETURN bill_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill(dict_map hstore)
IS 'Lins-站点账务-账务汇总';
