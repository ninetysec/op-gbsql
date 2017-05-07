-- auto gen by fei 2016-04-12 21:42:21

/**
 * 总代占成.入口
 * @author Lins
 * @date 2015.11.18
 * @param 	name 		占成周期名称.
 * @param 	start_time 	占成周期开始时间(yyyy-mm-dd HH:mm:ss), 周期一般以月为周期.
 * @param 	end_time 	占成周期结束时间(yyyy-mm-dd HH:mm:ss)
 * @param 	url 		dblink格式URL
 */
drop function if exists gamebox_occupy(text, text, text, text);
create or replace function gamebox_occupy(
	name 		text,
	start_time 	text,
	end_time 	text,
	url 		text
) returns void as $$

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

	-- vname 				text:='v_site_game';
	sid 				INT;--站点ID.
	bill_id 			INT;

	is_max 				BOOLEAN:=true;
	key_type 			int:=4;
	category 			TEXT:='AGENT';

	rakebackhash		hstore; -- 玩家返水
	rebatehash			hstore; -- 玩家返佣
BEGIN
	stTime = start_time::TIMESTAMP;
	edTime = end_time::TIMESTAMP;

	raise info '统计( % )的占成, 时间( %-% )', name, start_time, end_time;

	raise info '占成.玩家API返水';
	SELECT gamebox_rakeback_map(stTime, edTime, url, 'API') INTO rakeback_map;

	raise info '占成.取得当前站点ID';
	SELECT gamebox_current_site() INTO sid;

	raise info '返佣.梯度设置信息';
  	SELECT gamebox_rebate_api_grads() into rebate_grads_map;

	raise info '返佣.代理默认方案';
  	SELECT gamebox_rebate_agent_default_set() into agent_map;

  	raise info '返佣.代理满足的梯度';
	SELECT gamebox_rebate_agent_check(rebate_grads_map, agent_map, stTime, edTime) into agent_check_map;

	--取得各API的运营商占成.
	raise info '取得运营商各API占成';
	SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type) into operation_occupy_map;

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

  	raise info '占成.玩家贡献度.cost_map = %, sys_map = %, rakebackhash = %, rebatehash = %', cost_map, sys_map, rakebackhash, rebatehash;
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
COMMENT ON FUNCTION gamebox_occupy(name text, start_time text, end_time text, url text)
IS 'Lins-总代占成-入口';

/**
 * 总代占成数据更新.
 * @author Lins
 * @date 2015.12.2
 * @param 	name 		周期数.
 * @param 	start_time 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	end_time 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	bill_id 	返佣键值
 * @param 	op 			操作类型.I-新增, U-更新.
 */
DROP FUNCTION IF EXISTS gamebox_occupy_bill(TEXT, TIMESTAMP, TIMESTAMP, INOUT BIGINT, TEXT);
create or replace function gamebox_occupy_bill(
	name 			TEXT,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	INOUT bill_id 	BIGINT,
	op 				TEXT
) returns BIGINT as $$

DECLARE
	rec 		record;
	pending_pay text:='pending_pay';
BEGIN
	IF op='I' THEN
		INSERT INTO occupy_bill(
		 	period, start_time, end_time,
		 	top_agent_count, top_agent_lssuing_count, top_agent_reject_count, occupy_total, occupy_actual,
		 	last_operate_time, create_time, lssuing_state
		) VALUES (
		 name, start_time, end_time,
		 0, 0, 0, 0, 0,
		 now(), now(), pending_pay
		);
		SELECT currval(pg_get_serial_sequence('occupy_bill', 'id')) into bill_id;
		raise info 'occupy_bill.完成.键值:%', bill_id;
	ELSE
		FOR rec in
			SELECT occupy_bill_id,
				   count(top_agent_id)  		as top_agent_num,
				   SUM(effective_transaction) 	as effective_transaction ,
				   SUM(profit_loss) 			as profit_loss,
				   SUM(rakeback) 				as rakeback,
				   SUM(rebate) 					as rebate,
				   SUM(occupy_total) 			as occupy_total,
				   SUM(refund_fee) 				as refund_fee,
				   SUM(recommend) 				as recommend,
				   SUM(preferential_value) 		as preferential_value,
				   SUM(apportion) 				as apportion
			  FROM occupy_topagent
			 WHERE occupy_bill_id = bill_id
			  GROUP BY occupy_bill_id
		LOOP
			UPDATE occupy_bill SET
				   top_agent_count 			= rec.top_agent_num,
				   occupy_total 			= rec.occupy_total,
				   effective_transaction 	= rec.effective_transaction,
				   profit_loss 				= rec.profit_loss,
				   rakeback 				= rec.rakeback,
				   rebate 					= rec.rebate,
				   refund_fee 				= rec.refund_fee,
				   recommend 				= rec.recommend,
				   preferential_value 		= rec.preferential_value,
				   apportion 				= rec.apportion
			 WHERE id = rec.occupy_bill_id;
		END LOOP;
	END IF;

	RETURN;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, INOUT bill_id BIGINT, op TEXT)
IS 'Lins-总代占成-数据更新';

/**
 * 总代占成-玩家贡献度.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	bill_id 	占成键值
 * @param 	cost_map 	各种分摊费用
 * @param 	sys_map 	系统参数
 */
drop function if exists gamebox_occupy_player(INT, hstore, hstore, hstore, hstore);
create or replace function gamebox_occupy_player(
	bill_id 	INT,
	cost_map 	hstore,
	sys_map 	hstore,
	rakebackhash	hstore,
	rebatehash	hstore
) returns void as $$
DECLARE
  	keys 	text[];
	mhash 	hstore;
	param 	text:='';
	id 		int;
	money 	float:=0.00;

  	agent_num 		int:=0;
	profit_loss 	float:=0.00;
  	effective_transaction 	float:=0.00;

	keyname 	text:='';
	val 		text:='';
	vals 		text[];
	--返水
	rakeback 				FLOAT:=0.00;
	backwater_apportion 	float:=0.00;

	-- 优惠 (优惠 + 推荐 + 手动存入优惠)
	favourable 				float:=0.00;
  	recommend 				float:=0.00;
	artificial_depositfavorable 		float:=0.00;	-- 手动存入优惠
	favourable_apportion 	float:=0.00;

	--手续费
  	refund_fee 				float:=0.00;
	refund_fee_apportion 	float:=0.00;

	--返佣
  	rebate 					float:=0.00;
	rebate_apportion 		float:=0.00;

	--占成
	occupy_total float:=0.00;
	--分摊费用
	apportion 	FLOAT:=0.00;
	retio 		FLOAT:=0.00;	-- 总代分摊比例
	retio_2 	FLOAT:=0.00;	-- 代理分摊比例
	username 	text:='';
	tmp 		text:='';
	row_split 	text='^&^';
	col_split 	text:='^';

	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';

	deposit 		float:=0.00;	-- 存款
	company_deposit float:=0.00;	-- 存款:公司入款
	online_deposit	float:=0.00;	-- 存款:线上支付
	artificial_deposit float:=0.00;	-- 存款:手动存款

	withdraw 		float:=0.00;	-- 取款
	artificial_withdraw	float:=0.00;-- 取款:手动取款
	player_withdraw	float:=0.00;	-- 取款:玩家取款
BEGIN
 	IF cost_map is null THEN
		RETURN;
	END IF;

 	keys = akeys(cost_map);

	FOR i in 1..array_length(keys,  1)
	LOOP
		keyname = keys[i];

		val = cost_map->keyname;
		val = replace(val, row_split, ',');
		val = replace(val, col_split, '=>');

		SELECT val into mhash;

		-- 反水及反水分推.START
		rakeback = 0.00;
		IF exist(rakebackhash, keyname) THEN
			rakeback = (rakebackhash->keyname)::float;
		END IF;
		-- raise info '返水(rakeback) = %', rakeback;

		IF isexists(sys_map, 'agent.rakeback.percent') THEN
			retio_2 = (sys_map->'agent.rakeback.percent')::float;
		END IF;
		IF isexists(sys_map, 'topagent.rakeback.percent') THEN
			retio = (sys_map->'topagent.rakeback.percent')::float;
			backwater_apportion = rakeback * (1 - retio_2 / 100) * retio / 100;
		ELSE
			backwater_apportion = 0.00;
		END IF;
		-- raise info '返水分推(backwater_apportion) = %', backwater_apportion;
		-- 反水及反水分推.END

		-- 优惠推荐及优惠推荐分推.START
		favourable = 0.00;
		IF exist(mhash, 'favourable') THEN
			favourable = (mhash->'favourable')::float;
		END IF;
		-- raise info '优惠(favourable) = %', favourable;

		recommend = 0.00;
		IF exist(mhash, 'recommend') THEN
			recommend = (mhash->'recommend')::float;
		END IF;
		-- raise info '推荐(recommend) = %', recommend;

		artificial_depositfavorable = 0.00;	-- 手动存入优惠
		IF exist(mhash, 'artificial_depositfavorable') THEN
			artificial_depositfavorable = (mhash->'artificial_depositfavorable')::float;
		END IF;
		-- raise info '手动存入优惠(artificial_depositfavorable) = %', artificial_depositfavorable;
		favourable = favourable + artificial_depositfavorable;

		company_deposit = 0.00;
		IF exist(mhash, 'company_deposit') THEN
			company_deposit = (mhash->'company_deposit')::float;
		END IF;
		online_deposit = 0.00;
		IF exist(mhash, 'online_deposit') THEN
			online_deposit = (mhash->'online_deposit')::float;
		END IF;
		artificial_deposit = 0.00;
		IF exist(mhash, 'artificial_deposit') THEN
			artificial_deposit = (mhash->'artificial_deposit')::float;
		END IF;
		deposit = company_deposit + online_deposit + artificial_deposit;

		artificial_withdraw = 0.00;
		IF exist(mhash, 'artificial_withdraw') THEN
			artificial_withdraw = (mhash->'artificial_withdraw')::float;
		END IF;
		player_withdraw = 0.00;
		IF exist(mhash, 'player_withdraw') THEN
			player_withdraw = (mhash->'player_withdraw')::float;
		END IF;
		withdraw = artificial_withdraw + player_withdraw;

		IF isexists(sys_map,  'agent.preferential.percent') THEN
			retio_2 = (sys_map->'agent.preferential.percent')::float;
		END IF;
		IF isexists(sys_map,  'topagent.preferential.percent') THEN
			retio = (sys_map->'topagent.preferential.percent')::float;
			favourable_apportion = (favourable + recommend) * (1 - retio_2 / 100) * retio / 100;
		ELSE
			favourable_apportion = 0.00;
		END IF;
		-- raise info '优惠推荐分推(favourable_apportion) = %', favourable_apportion;
		-- 优惠推荐及优惠推荐分推.END

		-- 手续费及手续费分推.START
		refund_fee = 0.00;
		IF exist(mhash, 'refund_fee') THEN
			refund_fee = (mhash->'refund_fee')::float;
		END IF;
		-- raise info '手续费(refund_fee) = %', refund_fee;

		IF isexists(sys_map,  'agent.poundage.percent') THEN
			retio_2 = (sys_map->'agent.poundage.percent')::float;
		END IF;
		IF isexists(sys_map,  'topagent.poundage.percent') THEN
			retio = (sys_map->'topagent.poundage.percent')::float;
			refund_fee_apportion = refund_fee * (1 - retio_2 / 100) * retio / 100;
		ELSE
			refund_fee_apportion = 0.00;
		END IF;
		-- raise info '手续费分推(refund_fee_apportion) = %', refund_fee_apportion;
		-- 手续费及手续费分推.END

		-- 返佣及返佣分推.START
		rebate = 0.00;
		IF exist(rebatehash, keyname) THEN
			rebate = (rebatehash->keyname)::float;
		END IF;
		-- raise info '返佣(rebate) = %', rebate;

		IF isexists(sys_map,  'topagent.rebate.percent') THEN
			retio = (sys_map->'topagent.rebate.percent')::float;
			rebate_apportion = rebate * retio / 100;
		ELSE
			rebate_apportion = 0.00;
		END IF;
		-- raise info '返佣分推(rebate_apportion) = %', rebate_apportion;
		-- 返佣及返佣分推.END

		-- 总分摊 = 优惠分推 + 返水分推 + 返手续费分推 + 返佣分推
		apportion = favourable_apportion + backwater_apportion + refund_fee_apportion + rebate_apportion;

		-- 总代占成.START
		occupy_total = 0.00;
		IF exist(mhash, 'occupy_total') THEN
			occupy_total = (mhash->'occupy_total')::float;
		END IF;
		occupy_total = occupy_total - apportion;
		-- 总代占成.END

		profit_loss = 0.00;
		IF exist(mhash, 'profit_loss') THEN
			profit_loss = (mhash->'profit_loss')::float;--盈亏总额
		END IF;

		effective_transaction = 0.00;
		IF exist(mhash, 'effective_transaction') THEN
			effective_transaction = (mhash->'effective_transaction')::float;--有效交易量
		END IF;

		username = '';
		IF exist(mhash, 'username') THEN
			username = (mhash->'username');
		END IF;

		INSERT INTO occupy_player(
			occupy_bill_id, player_id, player_name,
			effective_transaction, profit_loss, preferential_value, rakeback,
			occupy_total, refund_fee, recommend, apportion, rebate, lssuing_state,
			deposit_amount, withdrawal_amount
		) VALUES (
			bill_id, keyname::int, username,
			effective_transaction, profit_loss, favourable, rakeback,
			occupy_total, refund_fee, recommend, apportion, rebate, pending_pay,
			deposit, withdraw
		);
		SELECT currval(pg_get_serial_sequence('occupy_player', 'id')) into tmp;
		raise info '占成玩家表.新增键值:%', tmp;

	END LOOP;

   raise info '总代占成之玩家贡献度.完成';
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_player(bill_id INT, cost_map hstore, sys_map hstore, rakebackhash hstore,rebatehash	hstore)
IS 'Lins-总代占成-玩家贡献度';

/**
 * 总代占成-代理贡献度.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	bill_id 	占成ID
 */
drop function if exists gamebox_occupy_agent(INT);
create or replace function gamebox_occupy_agent(
	bill_id INT
) returns void as $$

DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';

BEGIN
	INSERT INTO occupy_agent(
		occupy_bill_id, agent_id, agent_name,
		effective_player, effective_transaction, profit_loss,
		preferential_value, rakeback, occupy_total, refund_fee,
		recommend, apportion, rebate, lssuing_state
	)
	SELECT a1.*, pending_pay
	  	FROM (SELECT
	  			p.occupy_bill_id, a.id, a.username,
	  			COUNT(distinct p.player_id), sum(p.effective_transaction), SUM(p.profit_loss),
	  			SUM(preferential_value), SUM(rakeback), SUM(occupy_total), SUM(refund_fee),
	  			SUM(recommend), SUM(apportion), SUM(rebate)
	 		  FROM occupy_player p, sys_user u, sys_user a
	 		 WHERE p.player_id = u.id
     		   AND p.occupy_bill_id = bill_id
	   		   AND u.owner_id = a.id
	   		   AND u.user_type='24'
	   		   AND a.user_type='23'
	  		 GROUP BY p.occupy_bill_id, a.id, a.username
	 ) a1;
   raise info '总代占成-代理贡献度.完成';

END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_agent(INT)
IS 'Lins-总代占成-代理贡献';

/**
 * 总代占成-总代明细.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	占成键值
 */
drop function if exists gamebox_occupy_topagent(INT);
create or replace function gamebox_occupy_topagent(
	bill_id INT
) returns void as $$

DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
BEGIN
	INSERT INTO occupy_topagent(
		occupy_bill_id, top_agent_id, top_agent_name,
		effective_agent, effective_transaction, profit_loss,
		preferential_value, rakeback, occupy_total, rebate,
		refund_fee, recommend, apportion, lssuing_state
	)
	SELECT a1.*, pending_pay
	  FROM (SELECT
			  	p.occupy_bill_id, a.id, a.username,
			  	COUNT(distinct p.agent_id), sum(p.effective_transaction), SUM(p.profit_loss),
			  	SUM(preferential_value), SUM(rakeback), SUM(occupy_total), SUM(rebate),
			  	SUM(refund_fee), SUM(recommend), SUM(apportion)
			 FROM occupy_agent p, sys_user u, sys_user a
			WHERE p.agent_id = u.id
			  AND p.occupy_bill_id = bill_id
			  AND u.owner_id = a.id
			  AND u.user_type='23'
			  AND a.user_type='22'
			GROUP BY p.occupy_bill_id, a.id, a.username
		) a1;
   raise info '总代占成-总代明细.完成';

END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_topagent(INT)
IS 'Lins-总代占成-总代明细';

/**
 * 取得各总代API占成信息
 * @author 	Lins
 * @date 	2015.11.18
 */
DROP FUNCTION IF EXISTS gamebox_occupy_api_set();
create or replace function gamebox_occupy_api_set() returns hstore as $$
DECLARE
	hash 		hstore;
	mhash 		hstore;
	param 		text:='';
	rec 		record;
	row_split 	text:='^&^';
	col_split 	text:='_';
BEGIN
	FOR rec in
		SELECT DISTINCT user_id,
			   api_id,
			   game_type,
			   ratio
		  FROM user_agent_api
 		 WHERE ratio IS NOT NULL
		 ORDER BY user_id, api_id, game_type
	LOOP
		param = rec.user_id||col_split||rec.api_id||col_split||rec.game_type||'=>'||rec.ratio;
		IF hash is NULL THEN
			SELECT param into hash;
		ELSE
			SELECT param into mhash;
			hash = hash||mhash;
		END IF;
	END LOOP;
	return hash;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_api_set()
IS 'Lins-总代占成-梯度信息';

/**
 * 统计总代API占成.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	bill_id 	返佣KEY.
 * @param 	start_time 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	end_time 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	xxx_map 	各种费用(优惠、推荐、返手续费、返水)hash
 * @param 	各玩家返水hash
*/
DROP FUNCTION IF EXISTS gamebox_occupy_api(INT, TIMESTAMP, TIMESTAMP, hstore, hstore, hstore, hstore, hstore);
create or replace function gamebox_occupy_api(
	bill_id 				INT,
	start_time 				TIMESTAMP,
	end_time 				TIMESTAMP,
	occupy_grads_map 		hstore,
	operation_occupy_map 	hstore,
	rakeback_map 			hstore,
	rebate_grads_map 		hstore,
	agent_check_map 		hstore
) returns void as $$

DECLARE
	rec 				record;
	rakeback 			FLOAT:=0.00;--返水.
	rebate_value 		FLOAT:=0.00;--返佣.
	occupy_value 		FLOAT:=0.00;--占成.
	operation_occupy 	FLOAT:=0.00;--运营商API占成额

	tmp 				int:=0;
	keyname 			TEXT:='';
	col_split 			TEXT:='_';
	pending_lssuing 	text:='pending_lssuing';
	pending_pay 		text:='pending_pay';

BEGIN
  	raise info '计算各API各代理的盈亏总和';
	FOR rec IN
		SELECT rab.top_agent_id,
			   rab.agent_id,
			   rab.player_id,
			   rab.api_id,
			   rab.api_type_id,
			   rab.game_type,
			   SUM(-rab.profit_loss)			as profit_loss,
			   SUM(rab.effective_transaction)	as effective_transaction
		  FROM rakeback_api_base rab
 		 WHERE rab.rakeback_time >= start_time
	 	   AND rab.rakeback_time < end_time
 		 GROUP BY rab.top_agent_id, rab.agent_id, rab.player_id, rab.api_id, rab.api_type_id, rab.game_type
  	LOOP
		keyname = rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
		operation_occupy = (operation_occupy_map->keyname)::FLOAT;
		operation_occupy = coalesce(operation_occupy, 0);

		SELECT gamebox_rebate_calculator(
			rebate_grads_map,
			agent_check_map,
			rec.agent_id,
			rec.api_id,
			rec.game_type,
			rec.profit_loss,
			operation_occupy
		) INTO rebate_value;

		--取得各API占成
		SELECT gamebox_occupy_api_calculator(
			occupy_grads_map,
			operation_occupy_map,
			rec.top_agent_id,
			rec.player_id,
			rec.api_id,
			rec.game_type,
			rec.profit_loss
		) into occupy_value;

		rakeback = 0.00;
		--raise info 'rakeback_map=%',rakeback_map;
		IF isexists(rakeback_map, keyname) THEN
			rakeback = (rakeback_map->keyname)::FLOAT;
		END IF;
		INSERT INTO occupy_api (
			occupy_bill_id, player_id, api_id, game_type, api_type_id,
			occupy_total, effective_transaction, profit_loss, rakeback, rebate
		) VALUES(
			bill_id, rec.player_id, rec.api_id, rec.game_type, rec.api_type_id, occupy_value,
			rec.effective_transaction, rec.profit_loss, rakeback, rebate_value
		);
		SELECT currval(pg_get_serial_sequence('occupy_api', 'id')) into tmp;
		-- raise info '总代占成.API键值:%',tmp;
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, occupy_grads_map hstore, operation_occupy_map hstore, rakeback_map hstore, rebate_grads_map hstore, agent_check_map hstore)
IS 'Lins-返佣-统计各玩家API返佣';

/**
 * 总代各API占成.
 * @author 	Lins
 * @date 	2015.12.17
 * @param 	开始时间 TIMESTAMP
 * @param 	结束时间 TIMESTAMP
 * @param 	总代占成梯度map
 * @param 	运营商占成map
 */
DROP FUNCTION IF EXISTS gamebox_occupy_api_map(TIMESTAMP, TIMESTAMP, hstore, hstore);
create or replace function gamebox_occupy_api_map(
	start_time 				TIMESTAMP,
	end_time 				TIMESTAMP,
	occupy_grads_map 		hstore,
	operation_occupy_map 	hstore
) returns hstore as $$

DECLARE
	rec 					record;
	key_name 				TEXT:='';
	col_split 				TEXT:='_';

	operation_occupy_value 	FLOAT:=0.00;--运营商API占成金额
	occupy_value 			FLOAT:=0.00;--占成金额
	profit_amount 			FLOAT:=0.00;--盈亏总和

	api 		INT;
	game_type 	TEXT;
	owner_id 	TEXT;
	name 		TEXT:='';
	retio 		FLOAT:=0.00;--占成比例

	api_map 	hstore;
	param 		TEXT:='';

	sys_config 	hstore;
	sp 			TEXT:='@';
	rs 			TEXT:='\~';
	cs 			TEXT:='\^';

BEGIN
	--取得系统变量
	SELECT sys_config() INTO sys_config;
	sp = sys_config->'sp_split';
	rs = sys_config->'row_split';
	cs = sys_config->'col_split';
	-- raise info '------ operation_occupy_map = %', operation_occupy_map;

	FOR rec IN
		SELECT ut."id"											as topagent_id,
			   ut.username										as topagent_name,
			   rab.api_id,
			   rab.game_type,
			   COALESCE(SUM(-rab.profit_loss), 0.00)			as profit_amount
		  FROM rakeback_api_base rab
		  LEFT JOIN sys_user su ON rab.player_id = su."id"
		  LEFT JOIN sys_user ua ON su.owner_id = ua.id
		  LEFT JOIN sys_user ut ON ua.owner_id = ut.id
		 WHERE rab.rakeback_time >= start_time
		   AND rab.rakeback_time < end_time
		   AND su.user_type = '24'
		   AND ua.user_type = '23'
		   AND ut.user_type = '22'
		 GROUP BY ut."id", ut.username, rab.api_id, rab.game_type
  	LOOP
		raise info '------------------------ OFF LINE BEGIN ----------------------';
		api 			= rec.api_id;
		game_type 		= rec.game_type;
		owner_id 		= rec.topagent_id::TEXT;
		name 			= rec.topagent_name;
		profit_amount 	= rec.profit_amount;

		-- raise info '------ api_id = %, game_type = %, owner_id = %, name = %, profit_amount = %, ',
		-- 	api, game_type, owner_id, name, profit_amount;

		--取得运营商API占成.
		key_name = api||col_split||game_type;
		raise info '------ key_name1 = %', key_name;

		operation_occupy_value = 0.00;
		IF exist(operation_occupy_map, key_name) THEN
			operation_occupy_value = (operation_occupy_map->key_name)::FLOAT;
		END IF;

		raise info '------ operation_occupy_value = %', operation_occupy_value;

		--计算总代占成.
		key_name = owner_id||col_split||api||col_split||game_type;
		raise info '------ key_name2 = %', key_name;

		occupy_value 	= 0.00;
		retio 			= 0.00;

		-- raise info '------ occupy_grads_map = %', occupy_grads_map;
		IF exist(occupy_grads_map, key_name) THEN
			retio = (occupy_grads_map->key_name)::FLOAT;
			occupy_value = (profit_amount - operation_occupy_value) * retio / 100;
		ELSE
			raise info '总代ID = %, API = %, GAME_TYPE = % 未设置占成.', owner_id, api, game_type;
		END IF;

		raise info '------ retio = %, occupy_value = %', retio, occupy_value;

		--格式:id->'name@api^type^val~api^type^val^retio
		key_name = owner_id;
		raise info '------ key_name3 = %', key_name;
		raise info '------ api_map1 = %', api_map;
		IF api_map is null THEN
			param = name||sp||api||cs||game_type||cs||occupy_value||cs||retio||cs||profit_amount;
			SELECT key_name||'=>'||param INTO api_map;
		ELSEIF exist(api_map, key_name) THEN
			param = api_map->key_name;
			param = param||rs||api||cs||game_type||cs||occupy_value||cs||retio||cs||profit_amount;
			api_map = api_map||(SELECT (key_name||'=>'||param)::hstore);
		ELSE
			param = name||sp||api||cs||game_type||cs||occupy_value||cs||retio||cs||profit_amount;
			api_map = api_map||(SELECT (key_name||'=>'||param)::hstore);
		END IF;
		raise info '------ api_map2 = %', api_map;
		raise info '------------------------ OFF LINE END ------------------------';
	END LOOP;

	RETURN api_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_api_map(start_time TIMESTAMP, end_time TIMESTAMP, occupy_grads_map hstore, operation_occupy_map hstore)
IS 'Lins-总代占成-各API占成';


/**
 * 总代占成-当前周期的返佣
 * @author 	Lins
 * @date 	2015.12.17
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	expense_map 各种费用map
 * @return 	返回hstore类型
 */
drop function if EXISTS gamebox_occupy_value(TIMESTAMP, TIMESTAMP, hstore);
create or replace function gamebox_occupy_value(
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	expense_map hstore
) returns hstore as $$

DECLARE
	rec 		record;
	key_name 	TEXT:='';
	param 		TEXT:='';
	name 		TEXT:='';

	sys_config 	hstore;
	sp 			TEXT:='@';
	rs 			TEXT:='\~';
	cs 			TEXT:='\^';
BEGIN
	--取得系统变量
	SELECT sys_config() INTO sys_config;
	sp = sys_config->'sp_split';
	rs = sys_config->'row_split';
	cs = sys_config->'col_split';

	FOR rec IN EXECUTE
		'SELECT ut."id"					as topagent_id,
			   ut.username				as name,
			   SUM (rp.rebate_total) 	as rebate_total
		  FROM rebate_bill rb
		  LEFT JOIN rebate_agent ra ON rb."id" = ra.rebate_bill_id
		  LEFT JOIN rebate_player rp ON rb."id" = rp.rebate_bill_id
		  LEFT JOIN sys_user su ON rp.user_id = su."id"
		  LEFT JOIN sys_user ua ON su.owner_id = ua."id"
		  LEFT JOIN sys_user ut ON ua.owner_id = ut."id"
		 WHERE rb.start_time >= $1
		   AND rb.end_time <= $2
		   AND ra.settlement_state = ''lssuing''
		   AND su.user_type = ''24''
		   AND ua.user_type = ''23''
		   AND ut.user_type = ''22''
		 GROUP BY ut."id", ut.username'
	  	USING start_time, end_time
	LOOP
		key_name 	= rec.topagent_id::TEXT;
		name 		= rec.name;
		IF expense_map is null THEN
			param = 'user_name'||cs||name||rs||'rebate'||cs||rec.rebate_total::TEXT;
			SELECT key_name||'=>'||param INTO expense_map;
		ELSEIF exist(expense_map, key_name) THEN
			param = expense_map->key_name;
			param = param||rs||'rebate'||cs||rec.rebate_total::TEXT;
			expense_map = expense_map||(SELECT (key_name||'=>'||param)::hstore);
		ELSE
			param = 'user_name'||cs||name||rs||'rebate'||cs||rec.rebate_total;
			expense_map = expense_map||(SELECT (key_name||'=>'||param)::hstore);
		END IF;
	END LOOP;

	RETURN expense_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_value(start_time TIMESTAMP, end_time TIMESTAMP, expense_map hstore)
IS 'Lins-总代占成-当前周期的返佣';

/**
 * 分摊计算.
 * @author Lins
 * @date 2015.12.17
 * @param 	cost_map 	各种分摊费用
 * @param 	sys_map 	系统参数
 * @param 	category 	类别.REBATE.返佣,OCCUPY.占成
 */
drop function if exists gamebox_expense_calculate(hstore, hstore, TEXT);
create or replace function gamebox_expense_calculate(
	cost_map hstore,
	sys_map hstore,
	category TEXT
) returns hstore as $$

DECLARE
  	keys 		text[];
	mhash 		hstore;
	keyname 	text:='';
	val 		text:='';
	tmp 		TEXT:='';

	-- 返水
	backwater 				float:=0.00;
	backwater_apportion 	float:=0.00;

	-- 优惠 = (优惠 + 推荐 + 手动存入优惠)
	favourable 				float:=0.00;
  	recommend 				float:=0.00;
  	artificial_depositfavorable		float:=0.00;	-- 手动存入优惠
	favourable_apportion 	float:=0.00;

	-- 手续费
  	refund_fee 				float:=0.00;
	refund_fee_apportion 	float:=0.00;

	-- 返佣
  	rebate 					float:=0.00;
	rebate_apportion 		float:=0.00;

	-- 总分摊费用
	apportion 				FLOAT:=0.00;

	retio 					FLOAT:=0.00;
	retio2 					FLOAT:=0.00;

	sys_config 	hstore;
	sp 			TEXT:='@';
	rs 			TEXT:='\~';
	cs 			TEXT:='\^';

BEGIN
	--取得系统变量
	SELECT sys_config() INTO sys_config;
	sp = sys_config->'sp_split';
	rs = sys_config->'row_split';
	cs = sys_config->'col_split';

	 IF cost_map is null THEN
		RETURN cost_map;
	 END IF;
	 keys = akeys(cost_map);
	 FOR i in 1..array_length(keys, 1)
	 LOOP
		keyname = keys[i];
		val = cost_map->keyname;
		tmp = val;
		--转换成hstore数据格式:key1=>value1, key2=>value2
		tmp = replace(tmp, rs,',');
	    tmp = replace(tmp, cs,'=>');
		SELECT tmp into mhash;

		backwater = 0.00;--返水
		IF exist(mhash, 'backwater') THEN
			backwater = (mhash->'backwater')::float;
		END IF;

		favourable = 0.00;--优惠
		IF exist(mhash, 'favourable') THEN
			favourable = (mhash->'favourable')::float;
		END IF;

		refund_fee = 0.00;--返手续费
		IF exist(mhash, 'refund_fee') THEN
			refund_fee = (mhash->'refund_fee')::float;
		END IF;

		recommend = 0.00;--推荐
		IF exist(mhash, 'recommend') THEN
			recommend = (mhash->'recommend')::float;
		END IF;

		artificial_depositfavorable = 0.00; -- 手动存入优惠
		IF exist(mhash, 'artificial_depositfavorable') THEN
			artificial_depositfavorable = (mhash->'artificial_depositfavorable')::float;
		END IF;

		rebate = 0.00;
		IF exist(mhash, 'rebate') THEN
			rebate=(mhash->'rebate')::float;
		END IF;

		backwater 	= COALESCE(backwater, 0);
		favourable 	= COALESCE(favourable, 0);
		recommend 	= COALESCE(recommend, 0);
		artificial_depositfavorable = COALESCE(artificial_depositfavorable, 0);
		refund_fee 	= COALESCE(refund_fee, 0);
		rebate 		= COALESCE(rebate, 0);

		--计算各种优惠.
		/*
			计算各种优惠.
			1、返水承担费用=赠送给体系下玩家的返水 * 代理承担比例；
			2、优惠承担费用=赠送给体系下玩家的优惠 * 代理承担比例；
			3、返还手续费承担费用=返还给体系下玩家的手续费 * 代理承担比例；
		*/
		--优惠与推荐分摊
		retio2 = 0.00;
		retio = 0.00;

	  	IF isexists(sys_map, 'agent.preferential.percent') THEN
			retio2 = (sys_map->'agent.preferential.percent')::float;--代理分摊比例
		END IF;

		IF isexists(sys_map, 'topagent.preferential.percent') THEN
			retio = (sys_map->'topagent.preferential.percent')::float;
		END IF;

		IF category = 'OCCUPY' THEN
			retio = (1 - retio2 / 100) * retio / 100;
		ELSE
			retio = retio2 / 100;
		END IF;

		favourable_apportion = (favourable + recommend + artificial_depositfavorable) * retio;

		--返水分摊
		retio2 = 0.00;
		retio = 0.00;

		IF isexists(sys_map, 'agent.rakeback.percent') THEN
			retio2=(sys_map->'agent.rakeback.percent')::float;--代理分摊比例
		END IF;

		IF isexists(sys_map, 'topagent.rakeback.percent') THEN
		retio=(sys_map->'topagent.rakeback.percent')::float;
		END IF;

		IF category='OCCUPY' THEN
			retio=(1-retio2/100)*retio/100;
		ELSE
			retio = retio2/100;
		END IF;

		backwater_apportion = backwater*retio;

		--手续费优惠分摊
		retio2 = 0.00;
		retio = 0.00;

		IF isexists(sys_map, 'agent.poundage.percent') THEN
			retio2=(sys_map->'agent.poundage.percent')::float;--代理分摊比例
		END IF;

		IF isexists(sys_map, 'topagent.poundage.percent') THEN
			retio=(sys_map->'topagent.poundage.percent')::float;
		END IF;

		IF category='OCCUPY' THEN
			retio=(1-retio2/100)*retio/100;
		ELSE
			retio = retio2/100;
		END IF;

		refund_fee_apportion = refund_fee*retio;

		--返佣分摊
		rebate_apportion = 0;
		retio = 0.00;

		IF isexists(sys_map, 'topagent.rebate.percent') THEN
			retio=(sys_map->'topagent.rebate.percent')::float;
			rebate_apportion = rebate*retio/100;
		END IF;

		apportion = favourable_apportion + backwater_apportion + refund_fee_apportion;

		val = val||rs||'apportion'||cs||apportion;
		val = val||rs||'rebate_apportion'||cs||rebate_apportion;
		val = val||rs||'favourable_apportion'||cs||favourable_apportion;
		val = val||rs||'backwater_apportion'||cs||backwater_apportion;
		val = val||rs||'refund_fee_apportion'||cs||refund_fee_apportion;
		cost_map = cost_map||(SELECT (keyname||'=>'||val)::hstore);
	 END LOOP;

   	RETURN cost_map;
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_calculate(cost_map hstore, sys_map hstore, category TEXT)
IS 'Lins-费用分摊计算';

/**
 * 总代各种费用及分摊
 * @author Lins
 * @date 2015.11.13
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	sys_map
 * @param 	列分隔符
 * @return 	返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
 */
drop function if EXISTS gamebox_occupy_expense_map(TIMESTAMP, TIMESTAMP, hstore);
create or replace function gamebox_occupy_expense_map(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	sys_map 	hstore
) returns hstore as $$

DECLARE
	expense_map hstore;
BEGIN
	--取得各项费用
	SELECT gamebox_expense_gather(start_time, end_time, 'TOP') INTO expense_map;
	-- raise info '各项费用:%', expense_map;
	--取得返佣值
	SELECT gamebox_occupy_value(start_time, end_time, expense_map) INTO expense_map;
	-- raise info 'occupy fee:%', expense_map;
	--计算费用分摊
	SELECT gamebox_expense_calculate(expense_map, sys_map, 'OCCUPY') INTO expense_map;
	-- raise info '费用分摊%', expense_map;

	RETURN expense_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_expense_map(start_time TIMESTAMP,end_time TIMESTAMP,sys_map hstore)
IS 'Lins-总代占成-费用及分摊';

/**
 * 分摊费用
 * @author 	Lins
 * @date 	2015.11.13
 * @param 	start_time 	开始时间
 * @param 	end_time	结束时间
 * @param  	category 	统计类别.TOP,AGENT,PLAYER
 * @return 	返回hstore类型, 以玩家ID为KEY值.各种费用按一定格式组成VALUE。
 */
drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, text);
create or replace function gamebox_expense_gather(
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	category TEXT
) returns hstore as $$

DECLARE
	rec 	record;
	hash 	hstore;
	mhash 	hstore;
	param 	text:='';
	user_id text:='';
	money 	float:=0.00;
	name 	TEXT:='';
	cols 	TEXT;
  	tables 	TEXT;
	grups 	TEXT;

	sys_config hstore;
	sp TEXT:='@';
	rs TEXT:='\~';
	cs TEXT:='\^';
BEGIN
	--取得系统变量
	SELECT sys_config() INTO sys_config;
	sp = sys_config->'sp_split';
	rs = sys_config->'row_split';
	cs = sys_config->'col_split';

	IF category = 'TOP' THEN
		cols 	= 'u.topagent_id as id, u.topagent_name as name, ';
		tables	= ' player_transaction p, v_sys_user_tier u ';
		grups	= 'u.topagent_id, u.topagent_name ';
	ELSEIF category ='AGENT' THEN
		cols 	= 'u.agent_id as id, u.agent_name as name, ';
		tables 	= ' player_transaction p, v_sys_user_tier u ';
		grups 	= 'u.agent_id, u.agent_name ';
	ELSE
		cols 	= 'p.player_id as id, u.username as name, ';
		tables 	= ' player_transaction p, v_sys_user_tier u';
		grups 	= 'p.player_id, u.username ';
	END IF;
	FOR rec IN EXECUTE
		' SELECT '||cols||'
			 	 p.fund_type, SUM(p.transaction_money) as transaction_money
			FROM '||tables||'
		   WHERE p.fund_type IN (''backwater'', ''favourable'', ''recommend'', ''refund_fee'', ''artificial_deposit'',
		    	''company_deposit'', ''online_deposit'', ''artificial_withdraw'', ''player_withdraw'')
			 AND p.status = ''success''
		 	 AND p.create_time >= $1
		 	 AND p.create_time < $2
		   GROUP BY '||grups||', p.fund_type
		   UNION ALL
		  SELECT '||cols||'
				 p.fund_type||p.transaction_type,
				 SUM(transaction_money) 	as transaction_money
			FROM '||tables||'
		   WHERE fund_type = ''artificial_deposit''
		     AND transaction_type = ''favorable''
			 AND status = ''success''
		 	 AND create_time >= $1
		 	 AND create_time < $2
		   GROUP BY '||grups||', fund_type, transaction_type'
		USING start_time, end_time
	LOOP
		user_id = rec.id::text;
		money 	= rec.transaction_money;
		name 	= rec.name;

		IF isexists(hash,user_id) THEN
			param = hash->user_id;
			param = param||rs||rec.fund_type||cs||money::text;
		ELSE
			param = 'user_name'||cs||name||rs||rec.fund_type||cs||money::text;
		END IF;

		SELECT user_id||'=>'||param INTO mhash;

		IF hash is null THEN
			hash = mhash;
		ELSE
			hash = hash||mhash;
		END IF;
	END LOOP;
	return hash;
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT)
IS 'Lins-分摊费用';

/**
 * 总代占成.入口(wai bu yong)
 * @author 	Lins
 * @date 	2015.11.18
 * @param 	url 		dblink格式URL
 * @param 	start_time 	占成周期开始时间(yyyy-mm-dd HH:mm:ss),周期一般以月为周期.
 * @param 	end_time 	占成周期结束时间(yyyy-mm-dd HH:mm:ss)
 */
drop function if exists gamebox_occupy_map(text, text, text);
create or replace function gamebox_occupy_map(
	url 		text,
	start_time 	text,
	end_time 	text
) returns hstore[] as $$

DECLARE
	sys_map 				hstore;--系统设置各种承担比例.
  	occupy_grads_map 		hstore;--各API的占成设置
	operation_occupy_map 	hstore;--运营商各API占成比例.

	mhash 		hstore;--临时
	api_map 	hstore;--各API占成额
	cost_map 	hstore;--费用及分摊

	stTime 		TIMESTAMP;
	edTime 		TIMESTAMP;

	sid 		INT;--站点ID.

	is_max 		BOOLEAN:=true;
	-- key_type 	int:=4;
	-- category 	TEXT:='AGENT';
	key_type 	int:=5;
	category 	TEXT:='TOPAGENT';

BEGIN
	stTime = start_time::TIMESTAMP;
	edTime = end_time::TIMESTAMP;

	raise info '统计总代占成,时间( %-% )',start_time, end_time;

	raise info '占成.取得当前站点ID';
	SELECT gamebox_current_site() INTO sid;

	raise info '占成.系统各种分摊比例参数';
	SELECT gamebox_sys_param('apportionSetting') into sys_map;

	--取得各API的运营商占成.
	raise info '取得运营商各API占成';
	SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type) into operation_occupy_map;

	raise info '取得当前返佣梯度设置信息';
  	SELECT gamebox_occupy_api_set() into occupy_grads_map;

  	raise info '总代.API占成';
	SELECT gamebox_occupy_api_map(stTime, edTime, occupy_grads_map, operation_occupy_map) INTO api_map;

  	raise info '总代.费用及分摊';
	SELECT gamebox_occupy_expense_map(stTime, edTime, sys_map) INTO cost_map;
	-- raise info 'API占成:%',api_map;
	-- raise info '各项费用:%',cost_map;

	RETURN array[api_map, cost_map];
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_map(url text, start_time text, end_time text)
IS 'Lins-总代占成-入口-外调';

/**
 * 根据计算周期统计各总代的分摊费用(返佣, 返水、优惠、推荐、返手续费)
 * @author 	Lins
 * @date 	2015.11.13
 * @param 	bill_id 	占成表ID
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @return 	返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
 **/
drop function if EXISTS gamebox_occupy_expense_gather(INT, TIMESTAMP, TIMESTAMP);
create or replace function gamebox_occupy_expense_gather(
	bill_id 	INT,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP
) returns hstore as $$

DECLARE
	rec 			record;
	hash 			hstore;
	mhash 			hstore;
	param 			text:='';
	player_id 		text:='';
	money 			float:=0.00;--占成.
	--发放状态
	issue_state 	text:='lssuing';
	col_split 		text:='^';
	row_split 		text:='^&^';
	trans 			FLOAT:=0.00;--有效交易量
	loss 			FLOAT:=0.00;--盈亏总和
	backwater 		FLOAT:=0.00;--返水.
	rebate_value 	FLOAT:=0.00;--返佣
	result_hash 	hstore;

BEGIN
	-- raise info '分摊费用[返水、优惠、推荐、返手续费]';
	SELECT gamebox_expense_gather(start_time, end_time, 'PLAYER') INTO hash;
	SELECT '' INTO result_hash;
  	-- 统计各代理返佣.
	FOR rec IN
		/*
		SELECT op.player_id,
			   op.player_name	username,
			   op.effective_transaction,
			   op.profit_loss,
			   op.occupy_total,
			   op.rebate
		  FROM occupy_player op
		 WHERE op.occupy_bill_id = bill_id
		*/
		SELECT oa.player_id,
			   su.username,
			   SUM(oa.effective_transaction) 	as effective_transaction,
			   SUM(oa.profit_loss) 				as profit_loss,
			   SUM(occupy_total) 				as occupy_total,
			   SUM(rebate) 						as rebate
		  FROM occupy_api oa, sys_user su, user_agent ua
 		 WHERE oa.player_id = su.id
	 	   AND su.owner_id = ua."id"
	 	   AND oa.occupy_bill_id = bill_id
	 	   AND su.user_type = '24'
 	   	 GROUP BY oa.player_id, su.username

	LOOP
		player_id 	= rec.player_id::text;
		money 		= rec.occupy_total;
		trans 		= rec.effective_transaction;
		loss 		= rec.profit_loss;
		rebate_value = rec.rebate;

		IF isexists(hash, player_id) THEN
			param = hash->player_id;
			-- raise info 'param=%', param;
			param = param||row_split||'occupy_total'||col_split||money::text;
			param = param||row_split||'effective_transaction'||col_split||trans::TEXT;
			param = param||row_split||'profit_loss'||col_split||loss::TEXT;
			param = param||row_split||'rebate'||col_split||rebate_value::TEXT;
			param = param||row_split||'username'||col_split||rec.username;
		ELSE
			param = 'occupy_total'||col_split||money::text;
			param = param||row_split||'effective_transaction'||col_split||trans::TEXT;
			param = param||row_split||'profit_loss'||col_split||loss::TEXT;
			param = param||row_split||'rebate'||col_split||rebate_value::TEXT;
			param = param||row_split||'username'||col_split||rec.username;
		END IF;

		SELECT player_id||'=>'||param into mhash;

		result_hash = result_hash||mhash;

	END LOOP;
	RETURN result_hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_expense_gather(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Lins-总代占成-各分摊费用';


/**
 * 计算各API占成金额
 * @author 	Lins
 * @date 	2015.11.18
 * @param 	各个API的占成数据hash(KEY-VALUE)
 * @param 	运营商各个API的占成数据hash(KEY-VALUE)
 * @param 	当前代理统计数据JSON格式
 * @return 	返回float类型，返佣值.
 */
drop function if exists gamebox_occupy_api_calculator(hstore, hstore, INT, INT, INT, TEXT, FLOAT);
create or replace function gamebox_occupy_api_calculator(
	occupy_grads_map 		hstore,
	operation_occupy_map 	hstore,
	owner_id 				INT,
	player_id 				INT,
	api_id 					INT,
	game_type 				TEXT,
	profit_amount 			FLOAT
)returns FLOAT as $$

DECLARE
	ratio 		float:=0.00;--占成比例
	api 		TEXT;--API
	player 		TEXT;--玩家ID
	owners 		text;--代理ID
	operation_occupy_value 	float:=0.00;--运营商API占成.
	occupy_value 			float:=0.00;	--占成金额
	keyname 	text:='';--键值
	col_split 	text:='_';--列分隔符

BEGIN
	api 	= api_id::TEXT;
	owners 	= owner_id::TEXT;
	player 	= player_id::TEXT;
	keyname = player||col_split||api||col_split||game_type;
	--raise info 'Hash健值:%', keyname;
	operation_occupy_value = 0.00;
	--raise info 'keyname=%, operation_occupy_map:%', keyname, operation_occupy_map;
	IF isexists(operation_occupy_map,  keyname) THEN
		operation_occupy_value = (operation_occupy_map->keyname)::FLOAT;
	END IF;
	--raise info 'operation_occupy_value:%', operation_occupy_value;

	keyname = owners||col_split||api||col_split||game_type;

	IF isexists(occupy_grads_map,  keyname) THEN
		ratio = (occupy_grads_map->keyname)::float;
		occupy_value = (profit_amount - operation_occupy_value) * ratio / 100;
		--raise info 'profit_amount=%, operation_occupy_value=%, ratio=%, API占成总额:%', profit_amount, operation_occupy_value, ratio, occupy_value;
	ELSE
		-- raise info '总代:%, 未设置当前API:%, GAME_TYPE:% 的梯度, 未设置的占成金额置为:0.请检查!', owners, api, game_type;
	END IF;

	return occupy_value;
END

$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_api_calculator(occupy_grads_map hstore, operation_occupy_map hstore, owner_id INT, player_id INT, api_id INT, game_type TEXT, profit_amount FLOAT)
IS 'Lins-总代占成-各API占成计算';


/*
SELECT gamebox_generate_order_no('B','1','03');

SELECT gamebox_occupy(
	'1',
	'2016-01-01',
	'2016-01-15',
	'host = 192.168.0.88 dbname = gamebox-mainsite user = postgres password = postgres'
);

SELECT * from gamebox_occupy_map(
	'host = 192.168.0.88 dbname = gamebox-mainsite user = postgres password = postgres',
	'2016-01-01',
	'2016-01-15'
);
*/
