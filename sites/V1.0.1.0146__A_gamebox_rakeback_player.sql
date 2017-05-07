-- auto gen by admin 2016-05-16 21:58:57
drop function if exists gamebox_rebate(text, text, text, text, text);
create or replace function gamebox_rebate(
		name 		text,
		startTime 	text,
		endTime 	text,
		url 		text,
		flag 		text
) returns void as $$
/*版本更新说明
版本   时间        作者     内容
v1.00  2015/01/01  Lins     创建此函数：返佣-代理返佣计算入口
v1.01  2016/05/12  Leisure  未达返佣梯度，依然需要计算代理承担费用
*/
DECLARE
		rec 		record;   --系统设置各种承担比例.
		syshash 	hstore;   --各API的返佣设置
		gradshash 	hstore;   --各个代理的返佣设置
		agenthash 	hstore;   --运营商各API占成比例.
		mainhash 	hstore;   --存储每个代理是否满足梯度.
		checkhash 	hstore;   --各玩家返水.
		rakebackhash hstore;  --临时
		hash 		hstore;
		mhash 		hstore;   --返佣值
		rebate_value FLOAT;

		sid 	int;
		keyId 	int;
		tmp 	int;
		stTime 	TIMESTAMP;
		edTime 	TIMESTAMP;

		pending_lssuing text:='pending_lssuing';
		pending_pay 	text:='pending_pay';
		--分隔符
		row_split 	text:='^&^';
		col_split 	text:='^';

		--运营商占成参数.
		is_max 		BOOLEAN:=true;
		key_type 	int:=4;
		category 	TEXT:='AGENT';

		rebate_bill_id INT:=-1; --返佣主表键值.
		bill_count	INT :=0;
		redo_status BOOLEAN:=false;

BEGIN
		stTime = startTime::TIMESTAMP;
		edTime = endTime::TIMESTAMP;

		IF flag = 'Y' THEN
			SELECT COUNT("id")
			 INTO bill_count
				FROM rebate_bill rb
			 WHERE rb.period = name
				 AND rb."start_time" = stTime
				 AND rb."end_time" = edTime;

			IF bill_count > 0 THEN
				IF redo_status THEN
					DELETE FROM rebate_api ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
					DELETE FROM rebate_player rp WHERE rp.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
					DELETE FROM rebate_agent ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
					DELETE FROM rebate_bill rb WHERE "id" IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
				ELSE
					raise info '已生成本期返佣账单，无需重新生成。';
					RETURN;
				END IF;
			END IF;
		END IF;
		raise info '开始统计第( % )期的返佣,周期( %-% )', name, startTime, endTime;
		raise info '取得玩家返水';
		SELECT gamebox_rebate_rakeback_map(stTime, edTime) INTO rakebackhash;
		--取得当前站点.
		SELECT gamebox_current_site() INTO sid;
		--取得系统关于各种承担比例参数.
		SELECT gamebox_sys_param('apportionSetting') INTO syshash;
		--取得当前返佣梯度设置信息.
		SELECT gamebox_rebate_api_grads() INTO gradshash;
		--取得代理默认返佣方案
		SELECT gamebox_rebate_agent_default_set() INTO agenthash;
		--判断各个代理满足的返佣梯度.
		SELECT gamebox_rebate_agent_check(gradshash, agenthash, stTime, edTime, flag) INTO checkhash;

		--IF checkhash IS NOT NULL THEN
		--EDIT BY Leisure 2016-05-06 对于当期返佣为0的，需要计算承担费用

		--取得各API的运营商占成.
		raise info '取得运营商各API占成';
		SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type, flag) INTO mainhash;

		--先插入返佣总记录并取得键值.
		raise info '返佣rebate_bill新增记录';
		SELECT gamebox_rebate_bill(name, stTime, edTime, rebate_bill_id, 'I', flag) INTO rebate_bill_id;

		raise info '计算各玩家API返佣';
		perform gamebox_rebate_api(rebate_bill_id, stTime, edTime, gradshash, checkhash, mainhash, flag);

		raise info '收集各玩家的分摊费用';
		SELECT gamebox_rebate_expense_gather(rebate_bill_id, stTime, edTime, row_split, col_split, flag) INTO hash;

		raise info '统计各玩家返佣';
		perform gamebox_rebate_player(syshash, hash, rakebackhash, rebate_bill_id, row_split, col_split, flag);

		raise info '开始统计代理返佣';
		perform gamebox_rebate_agent(rebate_bill_id,flag, checkhash);

		raise info '更新返佣总表';
		perform gamebox_rebate_bill(name, stTime, edTime, rebate_bill_id, 'U', flag);

		--END IF;
		--EDIT BY Leisure 2016-05-06 对于当期返佣为0的，需要计算承担费用
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate(name text, startTime text, endTime text, url text, flag text)
IS 'Lins-返佣-代理返佣计算入口';

DROP FUNCTION IF EXISTS gamebox_station_bill(hstore);
create or replace function gamebox_station_bill(
  	dict_map hstore
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：总代占成-当前周期的返佣
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