-- auto gen by admin 2016-06-17 20:04:51
drop function IF EXISTS gamebox_occupy_rebate_map(TIMESTAMP, TIMESTAMP);

create or replace function gamebox_occupy_rebate_map(

	startTime 	TIMESTAMP,

	endTime 	TIMESTAMP

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Fly      创建此函数：总返佣返佣-占成调用

--v1.01  2016/06/16  Leisure  目前返佣金额改成以审核时间统计

*/

DECLARE

	rec record;

	sql TEXT:= '';

	key TEXT:= '';

	val TEXT:= '';

	hash hstore;

BEGIN

	raise info '统计玩家返佣';

	hash = '-1=>-1';

	/*

	sql = ' SELECT rp.user_id						as player_id,

				   COALESCE(rp.rebate_total, 0.00)	as rebate

			  FROM rebate_bill rb

			  LEFT JOIN rebate_agent ra ON rb."id" = ra.rebate_bill_id

			  LEFT JOIN rebate_player rp ON rb."id" = rp.rebate_bill_id

			 WHERE rb.start_time >= $1

			   AND rb.end_time <= $2

			   AND ra.settlement_state = ''lssuing''';

	*/

	--v1.01  2016/06/16  Leisure

	sql =

		 'SELECT rp.user_id						as player_id,

			       COALESCE(rp.rebate_total, 0.00)	as rebate

			  FROM rebate_bill rb

			       LEFT JOIN rebate_agent ra ON rb."id" = ra.rebate_bill_id

			       LEFT JOIN rebate_player rp ON rb."id" = rp.rebate_bill_id

			 WHERE ra.agent_id = rp.agent_id

			   AND ra.settlement_time >= $1

			   AND ra.settlement_time <  $2

			   AND ra.settlement_state = ''lssuing''';



	FOR rec IN EXECUTE sql USING startTime, endTime

	LOOP

		key = rec.player_id;

		val = key||'=>'||rec.rebate;

		hash = hash||(SELECT val::hstore);

	END LOOP;

	raise info '统计玩家返佣.完成';



	RETURN hash;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_rebate_map(startTime TIMESTAMP, endTime TIMESTAMP)

IS 'Fly-返佣返佣-占成调用';



drop function if exists gamebox_occupy(text, text, text, text);

create or replace function gamebox_occupy(

	name 		text,

	p_start_time 	text,

	p_end_time 	text,

	url 		text

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：总代占成-入口

--v1.01  2016/06/01  Leisure  返水函数改用gamebox_rakeback_api_map获取

--v1.02  2016/06/17  Leisure  增加重跑标志，默认不允许重跑

*/

DECLARE

	rec 					record;

	sys_map 				hstore;	--系统设置各种承担比例.

	occupy_map 				hstore;	--各API的返佣设置

	operation_occupy_map 	hstore;	--运营商各API占成比例.

	rebate_grads_map 		hstore;	--返佣梯度设置.

	agent_map 				hstore;	--代理默认梯度.

	agent_check_map 		hstore;	--代理满足的梯度.

	cost_map 				hstore;	--费用分摊

	rakeback_map 			hstore;	--玩家API返水.

	numhash 				hstore;	--存储每个总代的玩家数.

	mhash 					hstore;	--临时

	occupy_value 			FLOAT;	--返佣值



	keyId 	int;

	tmp 	int;

	a1 		text;

	a2 		text;

	a3 		text;

	stTime 	TIMESTAMP;

	edTime 	TIMESTAMP;



	pending_lssuing 	text:='pending_lssuing';

	pending_pay 		text:='pending_pay';

	row_split_char 		text:='^&^';	--分隔符

	col_split_char 		text:='^';



	--vname 				text:='v_site_game';

	sid 				INT;--站点ID.

	bill_id 			INT;



	is_max 				BOOLEAN:=true;

	key_type 			int:=4;

	category 			TEXT:='AGENT';



	rakebackhash		hstore; -- 玩家返水

	rebatehash			hstore; -- 玩家返佣



	bill_count	INT :=0;

	redo_status BOOLEAN:=false; -- 重跑标识，默认允许重跑



BEGIN

	stTime = p_start_time::TIMESTAMP;

	edTime = p_end_time::TIMESTAMP;



	--v1.02  2016/06/17  Leisure begin

	SELECT COUNT("id")

	  INTO bill_count

		FROM occupy_bill cb

	 WHERE cb.period = name

		 AND cb."start_time" = stTime

		 AND cb."end_time" = edTime;



	IF bill_count > 0 THEN

		IF redo_status THEN

			DELETE FROM occupy_api WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);

			DELETE FROM occupy_player WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);

			DELETE FROM occupy_agent WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);

			DELETE FROM occupy_topagent WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);

			DELETE FROM occupy_bill WHERE "id" IN (SELECT "id" FROM occupy_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);

		ELSE

			raise info '已生成本期占成账单，无需重新生成。';

			RETURN;

		END IF;

	END IF;

	--v1.02  2016/06/17  Leisure end



	raise info '统计( % )的占成, 时间( %-% )', name, p_start_time, p_end_time;



	raise info '占成.玩家API返水';

	--v1.01  2016/06/01  Leisure

	--SELECT gamebox_rakeback_map(stTime, edTime, url, 'API') INTO rakeback_map;

	SELECT gamebox_rakeback_api_map(stTime, edTime, 'API') INTO rakeback_map;



	raise info '占成.取得当前站点ID';

	SELECT gamebox_current_site() INTO sid;



	raise info '返佣.梯度设置信息';

	SELECT gamebox_rebate_api_grads() into rebate_grads_map;



	raise info '返佣.代理默认方案';

	SELECT gamebox_rebate_agent_default_set() into agent_map;



	raise info '返佣.代理满足的梯度';

	SELECT gamebox_rebate_agent_check(rebate_grads_map, agent_map, stTime, edTime, 'Y') into agent_check_map;



	--取得各API的运营商占成.

	raise info '取得运营商各API占成';

	SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type, 'Y') into operation_occupy_map;



	raise info '取得当前返佣梯度设置信息';

	SELECT gamebox_occupy_api_set() into occupy_map;



	raise info '占成.总表新增';

	SELECT gamebox_occupy_bill(name, stTime, edTime, bill_id, 'I') into bill_id;

	raise info 'occupy_bill.键值:%', bill_id;



	raise info '总代.玩家API贡献度';

	perform gamebox_occupy_api(bill_id, stTime, edTime, occupy_map, operation_occupy_map, rakeback_map, rebate_grads_map, agent_check_map);



	raise info '占成.各种分摊费用';

	SELECT gamebox_occupy_expense_gather(bill_id, stTime, edTime) into cost_map;



	raise info '占成.系统各种分摊比例参数';

	SELECT gamebox_sys_param('apportionSetting') into sys_map;



	raise info '各个玩家返水,从返水账单取值';

	SELECT gamebox_rebate_rakeback_map(stTime, edTime) INTO rakebackhash;



	SELECT gamebox_occupy_rebate_map(stTime, edTime) INTO rebatehash;



	-- raise info '占成.玩家贡献度.cost_map = %, sys_map = %, rakebackhash = %, rebatehash = %', cost_map, sys_map, rakebackhash, rebatehash;

	perform gamebox_occupy_player(bill_id, cost_map, sys_map, rakebackhash, rebatehash);



	raise info '占成.代理贡献度.';

	perform gamebox_occupy_agent(bill_id);



	raise info '占成.总代明细';

	perform gamebox_occupy_topagent(bill_id);



	raise info '占成.总表更新';

	perform gamebox_occupy_bill(name, stTime, edTime, bill_id, 'U');



	--异常处理

	-- PG_EXCEPTION_DETAIL

	-- WHEN OTHERS THEN

	-- GET STACKED DIAGNOSTICS a1 = MESSAGE_TEXT, a2 = PG_EXCEPTION_DETAIL, a3 = PG_EXCEPTION_HINT;

	-- raise EXCEPTION '异常:%, %, %', a1, a2, a3;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy(name text, p_start_time text, p_end_time text, url text)

IS 'Lins-总代占成-入口';