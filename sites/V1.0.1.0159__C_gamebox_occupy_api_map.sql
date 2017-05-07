-- auto gen by admin 2016-05-27 14:35:17
DROP FUNCTION IF EXISTS gamebox_occupy_api_map(TIMESTAMP, TIMESTAMP, hstore, hstore[]);

create or replace function gamebox_occupy_api_map(

	start_time 				TIMESTAMP,

	end_time 				TIMESTAMP,

	occupy_grads_map 		hstore,

	--operation_occupy_map 	hstore

	net_maps 	hstore[]

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：总代占成-各API占成

--v1.01  2016/05/17  Leisure  API盈利信息改由原始表获取

--v1.02  2016/05/23  Leisure  代理占成=(盈亏-盈亏*运营商占成比例)*代理占成比例

														  计算方式改为：=盈亏*(1-运营商占成比例)*代理占成比例

*/

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

	occupy_map 	hstore;		-- API占成梯度map --v1.02  2016/05/23  Leisure

	assume_map 	hstore;		-- 盈亏共担map. --v1.02  2016/05/23  Leisure

	operation_retio FLOAT:=0.00;--运营商占成比例 --v1.02  2016/05/23  Leisure

BEGIN

	--取得系统变量

	SELECT sys_config() INTO sys_config;

	sp = sys_config->'sp_split';

	rs = sys_config->'row_split';

	cs = sys_config->'col_split';



	--取得运营商占成、盈亏共担map

	--raise info '------ net_maps = %', net_maps;

	occupy_map = net_maps[2];

	assume_map = net_maps[3];



	-- raise info '------ operation_occupy_map = %', operation_occupy_map;



	--v1.01  2016/05/17  Leisure  API盈利信息改由原始表获取

	/*

	FOR rec IN

		SELECT ut."id"									as topagent_id,

			   ut.username								as topagent_name,

			   rab.api_id,

			   rab.game_type,

			   COALESCE(SUM(-rab.profit_loss), 0.00)	as profit_amount

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

		*/

	FOR rec IN

		SELECT ut."id"									as topagent_id,

		       ut.username							as topagent_name,

		       pgo.api_id,

		       pgo.game_type,

		       COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount

		    FROM player_game_order pgo

		    LEFT JOIN sys_user su ON pgo.player_id = su."id"

		    LEFT JOIN sys_user ua ON su.owner_id = ua.id

		    LEFT JOIN sys_user ut ON ua.owner_id = ut.id

		 WHERE pgo.order_state = 'settle'

		   AND pgo.is_profit_loss = TRUE

		   AND pgo.bet_time >= start_time

		   AND pgo.bet_time < end_time

		   AND su.user_type = '24'

		   AND ua.user_type = '23'

		   AND ut.user_type = '22'

		 GROUP BY ut."id", ut.username, pgo.api_id, pgo.game_type

	LOOP

		api 			= rec.api_id;

		game_type 		= rec.game_type;

		owner_id 		= rec.topagent_id::TEXT;

		name 			= rec.topagent_name;

		profit_amount 	= rec.profit_amount;





		--取得运营商API占成.--比例

		key_name = api||col_split||game_type;

		/*

		operation_occupy_value = 0.00;

		IF exist(operation_occupy_map, key_name) THEN

			operation_occupy_value = (operation_occupy_map->key_name)::FLOAT;

		END IF;

		*/

		--v1.02  2016/05/23  Leisure

		IF isexists(occupy_map, key_name) THEN

			operation_retio = (occupy_map->key_name)::float;

		ELSE

			operation_retio = 0.00;

		END IF;



		--计算总代占成.

		key_name = owner_id||col_split||api||col_split||game_type;



		occupy_value = 0.00;

		retio 		 = 0.00;



		IF exist(occupy_grads_map, key_name) THEN

			retio = (occupy_grads_map->key_name)::FLOAT;

			--v1.02  2016/05/23  Leisure

			--occupy_value = (profit_amount - operation_occupy_value) * retio / 100;

			occupy_value = profit_amount * (1 - operation_retio/100) * retio / 100;

		ELSE

			raise info '总代ID = %, API = %, GAME_TYPE = % 未设置占成.', owner_id, api, game_type;

		END IF;



		--格式:id->'name@api^type^val~api^type^val^retio

		key_name = owner_id;



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



	END LOOP;



	RETURN api_map;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_api_map(start_time TIMESTAMP, end_time TIMESTAMP, occupy_grads_map hstore, operation_occupy_map hstore)

IS 'Lins-总代占成-各API占成';



drop function if exists gamebox_occupy_map(text, text, text);

create or replace function gamebox_occupy_map(

	url 		text,

	start_time 	text,

	end_time 	text

) returns hstore[] as $$

/*版本更新说明

--版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：总代占成-入口-外调

--v1.01  2016/05/23  Leisure  代理占成=(盈亏-盈亏*运营商占成比例)*代理占成比例

                              计算方式改为：=盈亏*(1-运营商占成比例)*代理占成比例

*/

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

	key_type 	int:=5;

	category 	TEXT:='TOPAGENT';

	net_map 	hstore[];-- 包网方案map --v1.01  2016/05/23  Leisure



BEGIN

	stTime = start_time::TIMESTAMP;

	edTime = end_time::TIMESTAMP;



	raise info '统计总代占成,时间( %-% )',start_time, end_time;



	raise info '占成.取得当前站点ID';

	SELECT gamebox_current_site() INTO sid;



	raise info '占成.系统各种分摊比例参数';

	SELECT gamebox_sys_param('apportionSetting') into sys_map;

	--v1.01  2016/05/23  Leisure

	/*

	--取得各API的运营商占成.

	raise info '取得运营商各API占成';

	SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type, 'Y') into operation_occupy_map;

	*/--v1.01  2016/05/23  Leisure

	raise info '取得当前返佣梯度设置信息';

	SELECT gamebox_occupy_api_set() into occupy_grads_map;



	--raise info 'operation_occupy_map: %', operation_occupy_map;

	--raise info 'occupy_grads_map: %', occupy_grads_map;



	--v1.01  2016/05/23  Leisure

	raise info '取得包网方案';

	SELECT * FROM dblink(url, 'SELECT gamebox_contract('||sid||', '||is_max||')') as a(hash hstore[]) INTO net_map;



	--v1.01  2016/05/23  Leisure

	raise info '总代.API占成';

	SELECT gamebox_occupy_api_map(stTime, edTime, occupy_grads_map, net_map) INTO api_map;



	raise info '总代.费用及分摊';

	SELECT gamebox_occupy_expense_map(stTime, edTime, sys_map) INTO cost_map;

	-- raise info 'API占成:%',api_map;

	-- raise info '各项费用:%',cost_map;



	RETURN array[api_map, cost_map];

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_map(url text, start_time text, end_time text)

IS 'Lins-总代占成-入口-外调';



drop function if exists gamebox_occupy_player(INT, hstore, hstore, hstore, hstore);

create or replace function gamebox_occupy_player(

	bill_id 	INT,

	cost_map 	hstore,

	sys_map 	hstore,

	rakebackhash	hstore,

	rebatehash	hstore

) returns void as $$

/*版本更新说明

--版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：总代占成-玩家贡献度

--v1.01  2016/05/25  Leisure  增加roop上限长度判断，空值或0不roop

*/

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



	rakeback 				FLOAT:=0.00;	--返水

	backwater_apportion 	float:=0.00;



	favourable 				float:=0.00;	-- 优惠 (优惠 + 推荐 + 手动存入优惠)

	recommend 				float:=0.00;

	artificial_depositfavorable 	float:=0.00;	-- 手动存入优惠

	favourable_apportion 	float:=0.00;



	refund_fee 				float:=0.00;	--手续费

	refund_fee_apportion 	float:=0.00;



	rebate 					float:=0.00;	--返佣

	rebate_apportion 		float:=0.00;



	occupy_total float:=0.00;	--占成



	apportion 	FLOAT:=0.00;	--分摊费用

	retio 		FLOAT:=0.00;	-- 总代分摊比例

	retio_2 	FLOAT:=0.00;	-- 代理分摊比例

	username 	text:='';

	tmp 		text:='';

	row_split 	text='^&^';

	col_split 	text:='^';



	pending_lssuing text:='pending_lssuing';

	pending_pay 	text:='pending_pay';



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



	IF COALESCE(array_length(keys,  1), 0) = 0 THEN --v1.01

		return;

	END IF;



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

COMMENT ON FUNCTION gamebox_occupy_player(bill_id INT, cost_map hstore, sys_map hstore, rakebackhash hstore, rebatehash	hstore)

IS 'Lins-总代占成-玩家贡献度';



drop function IF EXISTS gamebox_rakeback_map(TIMESTAMP, TIMESTAMP, text, text);

create or replace function gamebox_rakeback_map(

	startTime 	TIMESTAMP,

	endTime 	TIMESTAMP,

	url 		TEXT,

	category 	TEXT

) returns hstore as $$

/*版本更新说明

--版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：返水-玩家入口-返佣调用

--v1.01  2016/05/25  Leisure  返回值类型由hstore[]改为hstore

*/

DECLARE

  gradshash 	hstore;

	agenthash 	hstore;

	hash 		hstore;

	sid 		INT:=-1;

	maps 		hstore[];

	rhash 		hstore;		-- 玩家返水



BEGIN

	SELECT gamebox_current_site() INTO sid;

	--取得当前返水梯度设置信息.

	SELECT gamebox_rakeback_api_grads() into gradshash;

	SELECT gamebox_agent_rakeback() into agenthash;



	raise info '统计玩家API返水';

	SELECT gamebox_rakeback_api_map(startTime, endTime, gradshash, agenthash, category) INTO hash;



	SELECT gamebox_rakeback_act(startTime, endTime) INTO rhash;



	hash = hash || rhash;



	RETURN hash;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rakeback_map(startTime TIMESTAMP, endTime TIMESTAMP, url TEXT, category TEXT)

IS 'Lins-返水-玩家入口-返佣调用';