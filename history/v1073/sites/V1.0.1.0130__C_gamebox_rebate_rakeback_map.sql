-- auto gen by admin 2016-04-27 21:11:15
----------------------------------------------------------------

---------------------------- common ----------------------------

----------------------------------------------------------------

/**

 * 玩家[API]返水-返佣调用.

 * @author 	Lins

 * @date 	2015.12.3

 * @param 	startTime 	返水结算开始时间(yyyy-mm-dd)

 * @param 	endTime 	返水结算结束时间(yyyy-mm-dd)

 */

drop function IF EXISTS gamebox_rebate_rakeback_map(TIMESTAMP, TIMESTAMP);

create or replace function gamebox_rebate_rakeback_map(

	startTime 	TIMESTAMP,

	endTime 	TIMESTAMP

) returns hstore as $$



DECLARE

	rec 	record;

	sql 	TEXT:= '';

	key 	TEXT:= '';

	val 	TEXT:= '';

	hash 	hstore;

BEGIN

	raise info '统计玩家API返水';

	hash = '-1=>-1';

	sql = 'SELECT rp.player_id,

			 	  SUM(rp.rakeback_actual)	rakeback

			 FROM rakeback_bill rb

			 LEFT JOIN rakeback_player rp ON rb."id" = rp.rakeback_bill_id

			WHERE rp.settlement_time >= $1

			  AND rp.settlement_time < $2

			  AND rp.settlement_state = ''lssuing''

			  AND rp.player_id IS NOT NULL

			GROUP BY rp.player_id';

	FOR rec IN EXECUTE sql USING startTime, endTime

	LOOP

		key 	= rec.player_id;

		val 	= key||'=>'||rec.rakeback;

		hash 	= hash||(SELECT val::hstore);

	END LOOP;

	-- raise info '玩家API返水 = %', hash;

	raise info '统计玩家API返水.完成';



	RETURN hash;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_rakeback_map(startTime TIMESTAMP, endTime TIMESTAMP)

IS 'Lins-返佣返水-返佣调用';



----------------------------------------------------------------

--------------------------- rakeback ---------------------------

----------------------------------------------------------------

/**

 * 玩家[API]返水.

 * @author 	Lins

 * @date 	2015.12.2

 * @param 	start_time 	开始时间

 * @param 	end_time 	结束时间

 * @param 	gradshash 	返水梯度

 * @param 	agenthash 	各代理设置的梯度ID.

 * @param 	category 	类型.API或PLAYER,  区别在于KEY值不同. 另外GAME_TYPE 区别在于统计的维度不同.

 */

DROP FUNCTION IF EXISTS gamebox_rakeback_api_map(TIMESTAMP, TIMESTAMP, hstore, hstore, TEXT);

create or replace function gamebox_rakeback_api_map(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	gradshash 	hstore,

	agenthash 	hstore,

	category 	TEXT

) returns hstore as $$



DECLARE

	hash 		hstore;--玩家API或玩家返水.

	rakeback 	FLOAT:=0.00;

	val 		FLOAT:=0.00;

	key 		TEXT:='';

	col_split 	TEXT:='_';

	rec 		record;

	param 		TEXT:='';

	sql 		TEXT:='';



BEGIN

	SELECT '-1=>-1' INTO hash;

	IF category = 'GAME_TYPE' THEN

		sql = 'SELECT rab.api_id,

					  rab.game_type,

					  rab.player_id,

					  COUNT(DISTINCT rab.player_id) 					as player_num,

				 FROM rakeback_api_base rab

			    WHERE rab.rakeback_time >= $1

				  AND rab.rakeback_time < $2

				  AND up.rakeback_id IS NOT NULL

			    GROUP BY rab.api_id, rab.game_type, rab.player_id';

	ELSE

		sql = 'SELECT rab.api_id,

					  rab.game_type,

					  rab.player_id,

					  SUM(rakeback)	rakeback

				 FROM rakeback_api_base rab

				WHERE rab.rakeback_time >= $1

				  AND rab.rakeback_time < $2

				GROUP BY rab.api_id, rab.game_type, rab.player_id';

	END IF;



	FOR rec IN EXECUTE sql USING start_time, end_time

	LOOP

		-- SELECT gamebox_rakeback_calculator(gradshash, agenthash, row_to_json(rec), NULL) into rakeback;



	  	IF category = 'GAME_TYPE' THEN

			key 	= rec.api_id||col_split||rec.game_type;

			param 	= key||'=>'||rec.rakeback||col_split||rec.player_num;

			hash 	= (SELECT param::hstore)||hash;

		ELSEIF category = 'API' THEN

			key 	= rec.player_id||col_split||rec.api_id||col_split||rec.game_type;

			param 	= key||'=>'||rec.rakeback;

			hash 	= (SELECT param::hstore)||hash;

		ELSE

			key 	= rec.player_id;

			param 	= key||'=>'||rakeback;

			IF isexists(hash,  key) THEN

				val = (hash->key)::FLOAT;

				val = val + rakeback;

				param = key||'=>'||val;

			END IF;

			hash = (SELECT param::hstore)||hash;

		END IF;

	END LOOP;

	-- raise info 'Last Hash = %',  hash;



	RETURN hash;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rakeback_api_map(start_time TIMESTAMP, end_time TIMESTAMP, gradshash hstore, agenthash hstore, category TEXT)

IS 'Lins-返水-玩家[API]返水-返佣调用';



----------------------------------------------------------------

---------------------------- rebate ----------------------------

----------------------------------------------------------------

/**

 * 分摊费用

 * @author 	Lins

 * @date 	2015.11.13

 * @param 	start_time 	开始时间

 * @param 	end_time 	结束时间

 */

drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP);

create or replace function gamebox_expense_gather(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP

) returns hstore as $$



DECLARE

	rec 		record;

	hash 		hstore;

	mhash 		hstore;

	param 		text:='';

	money 		float:=0.00;

	key_name 	TEXT;



BEGIN

	FOR rec IN

		 SELECT fund_type,

				SUM(transaction_money) 	as transaction_money

			FROM player_transaction

		   WHERE fund_type in ('backwater', 'favourable', 'recommend', 'refund_fee', 'artificial_deposit',

				'company_deposit', 'online_deposit', 'artificial_withdraw', 'player_withdraw')

			 AND status = 'success'

		 	 AND create_time >= start_time

		 	 AND create_time < end_time

		 	 AND (transaction_way <> 'artificial_favourable' OR transaction_way IS NULL)

		   GROUP BY fund_type

		   UNION ALL

		  SELECT fund_type||transaction_type,

				 SUM(transaction_money) 	as transaction_money

			FROM player_transaction

		   WHERE fund_type = 'artificial_deposit'

		     AND transaction_type = 'favorable'

			 AND status = 'success'

		 	 AND create_time >= start_time

		 	 AND create_time < end_time

		   GROUP BY fund_type, transaction_type

	 LOOP

		key_name = rec.fund_type;

		money = rec.transaction_money;

		SELECT key_name||'=>'||money INTO mhash;

		IF hash is null THEN

			hash = mhash;

		ELSE

			hash = hash||mhash;

		END IF;

	END LOOP;



	FOR rec IN

		SELECT COUNT(DISTINCT rab.player_id)					as player_num,

			   COALESCE(SUM(rab.profit_loss), 0.00)				as profit_amount,

			   COALESCE(SUM(rab.effective_transaction), 0.00)	as effective_trade_amount

  		  FROM rakeback_api_base rab

 		 WHERE rab.rakeback_time >= start_time

   		   AND rab.rakeback_time < end_time

	 LOOP

		param = 'profit_amount=>'||rec.profit_amount;

		param = param||',effective_trade_amount=>'||rec.effective_trade_amount;

		param = param||',player_num=>'||rec.player_num;

		IF hash is null THEN

			SELECT param INTO hash;

		ELSE

			hash = (SELECT param::hstore)||hash;

		END IF;

	END LOOP;



	return hash;

END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP)

IS 'Lins-分摊费用';



/**

 * 计算返佣MAP-外部调用

 * @author Lins

 * @date 2015.11.13

 * @param.运营商库.dblink URL

 * @param.开始时间

 * @param.结束时间

 * @param.类别.AGENT

 */

drop function if EXISTS gamebox_rebate_map(TEXT, TEXT, TEXT, TEXT);

create or replace FUNCTION gamebox_rebate_map(

	url 		TEXT,

	start_time 	TEXT,

	end_time 	TEXT,

	category 	TEXT

) RETURNS hstore[] as $$



DECLARE

	sys_map 				hstore;--系统参数.

	rebate_grads_map 		hstore;--返佣梯度设置

	agent_map 				hstore;--代理默认方案

	agent_check_map 		hstore;--代理梯度检查

	operation_occupy_map 	hstore;--运营商占成.

	rebate_map 				hstore;--API占成.

	expense_map 			hstore;--费用分摊



	sid 		INT;--站点ID.

	stTime 		TIMESTAMP;

	edTime 		TIMESTAMP;

	is_max 		BOOLEAN:=true;

	key_type 	int:=5;--API

	maps 		hstore[];

	flag		TEXT:='Y';

BEGIN

	stTime=start_time::TIMESTAMP;

	edTime=end_time::TIMESTAMP;



	raise info '占成.取得当前站点ID';

	SELECT gamebox_current_site() INTO sid;



	raise info '占成.系统各种分摊比例参数';

	SELECT gamebox_sys_param('apportionSetting') INTO sys_map;



	raise info '返佣.梯度设置信息';

  	SELECT gamebox_rebate_api_grads() INTO rebate_grads_map;



	raise info '返佣.代理默认方案';

  	SELECT gamebox_rebate_agent_default_set() INTO agent_map;



  	raise info '返佣.代理满足的梯度';

	SELECT gamebox_rebate_agent_check(rebate_grads_map, agent_map, stTime, edTime, flag) INTO agent_check_map;



	raise info '取得运营商各API占成';

	SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type, flag) INTO operation_occupy_map;



	SELECT gamebox_rebate_map(stTime, edTime, key_type, rebate_grads_map, agent_check_map, operation_occupy_map) INTO rebate_map;

	--统计各种费费用.

	SELECT gamebox_expense_map(stTime, edTime, sys_map) INTO expense_map;

	maps=array[rebate_map];

	maps=array_append(maps, expense_map);



	return maps;

END

$$ language plpgsql;



COMMENT ON FUNCTION gamebox_rebate_map(url TEXT, start_time TEXT, end_time TEXT, category TEXT)

IS 'Lins-返佣-外调';



DROP FUNCTION IF EXISTS gamebox_rebate_map(TIMESTAMP, TIMESTAMP, INT, hstore, hstore, hstore);

create or replace function gamebox_rebate_map(

	start_time 				TIMESTAMP,

	end_time 				TIMESTAMP,

	key_type 				INT,

	rebate_grads_map 		hstore,

	agent_check_map 		hstore,

	operation_occupy_map 	hstore

) returns hstore as $$



DECLARE

	rec 				record;

	rebate 		FLOAT:=0.00;--返佣.

	operation_occupy 	FLOAT:=0.00;--运营商占成额

	key_name 			TEXT;--运营商占成KEY值.

	rebate_map 			hstore;--各API返佣值.

	col_split 			TEXT:='_';

BEGIN

	FOR rec IN

		SELECT su.owner_id, od.*

		  FROM (SELECT pgo.player_id,

					   pgo.api_id,

					   pgo.game_type,

					   SUM(-pgo.profit_amount) 	profit_amount

				  FROM player_game_order pgo

				 WHERE pgo.create_time >= start_time

				   AND pgo.create_time < end_time

				   AND pgo.order_state = 'settle'

				   AND pgo.is_profit_loss = TRUE

				 GROUP BY pgo.player_id, pgo.api_id, pgo.game_type

			   ) od

		  LEFT JOIN sys_user su ON od.player_id = su."id"

		  LEFT JOIN sys_user ua ON su.owner_id = ua."id"

		 WHERE su.user_type = '24'

		   AND ua.user_type = '23'

	LOOP

		--检查当前代理是否满足返佣梯度.

		IF isexists(agent_check_map, (rec.owner_id)::text) = false THEN

			CONTINUE;

		END IF;



		raise info '取得各API各分类佣金总和';

		key_name = rec.api_id||col_split||rec.game_type;

		operation_occupy = (operation_occupy_map->key_name)::FLOAT;

		SELECT gamebox_rebate_calculator(rebate_grads_map, agent_check_map, rec.owner_id, rec.api_id, rec.game_type, rec.profit_amount, operation_occupy) INTO rebate;



		IF rebate_map is null THEN

			SELECT key_name||'=>'||rebate INTO rebate_map;

		ELSEIF exist(rebate_map, key_name) THEN

			rebate = rebate + ((rebate_map->key_name)::FLOAT);

			rebate_map = rebate_map||(SELECT (key_name||'=>'||rebate)::hstore);

		ELSE

			rebate_map = (SELECT (key_name||'=>'||rebate)::hstore)||rebate_map;

		END IF;

	END LOOP;



	RETURN rebate_map;



END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_map(start_time TIMESTAMP, end_time TIMESTAMP, key_type INT, rebate_grads_map hstore, agent_check_map hstore, operation_occupy_map hstore)

IS 'Lins-返佣-API返佣-外调';



----------------------------------------------------------------

---------------------------- occupy ----------------------------

----------------------------------------------------------------

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

COMMENT ON FUNCTION gamebox_occupy(name text, start_time text, end_time text, url text)

IS 'Lins-总代占成-入口';



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

	SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type, 'Y') into operation_occupy_map;



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

 * 根据统计周期算出运营商的占成-入口.

 * @param 	url 		运营库dblink URL.

 * @param 	start_time 	开始时间

 * @param 	end_time 	结束时间

 * @param 	category 	占成类别.category: AGENT、TOPAGENT、SITE指明各种占成类型统计

 */

drop function if EXISTS gamebox_operations_occupy(TEXT, TIMESTAMP, TIMESTAMP, TEXT, INT);

create or replace function gamebox_operations_occupy(

	url 		text,

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	category 	TEXT,

	key_type 	INT

) returns hstore as $$



DECLARE

	sid 	int;

	is_max 	BOOLEAN:=TRUE;

	hash 	hstore;

	hashs 	hstore[];

	tmp 	int:=0;



BEGIN

  	--取得当前站点.

	SELECT gamebox_current_site() INTO sid;

	--取得当前站点的包网方案

	SELECT gamebox_operations_occupy(url, sid, start_time, end_time, category, is_max, key_type, 'Y') into hash;

	-- raise info '%', hash;

	return hash;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operations_occupy(url text, start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, key_type INT)

IS 'Lins-运营商占成-入口';



drop function if EXISTS gamebox_operations_occupy(hstore[], TIMESTAMP, TIMESTAMP, TEXT, INT);

drop function if EXISTS gamebox_operations_occupy(hstore[], TIMESTAMP, TIMESTAMP, TEXT, INT, TEXT);

create or replace function gamebox_operations_occupy(

	hashs 		hstore[],

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	category 	TEXT,

	key_type 	INT,

	flag 		TEXT

) returns hstore as $$



DECLARE

	hash 		hstore;

	rec 		record;

	cur 		refcursor;

	amount 		FLOAT:=0.00;

	temp_amount FLOAT:=0.00;

	keyname 	TEXT:='';

	col_split 	TEXT:='_';



BEGIN

	--计算占成

	SELECT gamebox_operation_occupy(start_time, end_time, category, flag) INTO cur;

	FETCH cur into rec;

	WHILE FOUND LOOP



		IF key_type = 3 THEN

			keyname = (rec.id::TEXT);

		ELSIF key_type = 4 THEN

			keyname = (rec.id::TEXT);

			keyname = keyname||col_split||(rec.api_id::TEXT);

			keyname = keyname||col_split||(rec.game_type::TEXT);

		ELSIF key_type = 5 THEN

			keyname = rec.api_id::TEXT;

			keyname = keyname||col_split||(rec.game_type::TEXT);

		ELSE

			keyname = rec.owner_id::TEXT;

		END IF;



		amount = 0.00;

		temp_amount = 0.00;

		SELECT gamebox_operations_occupy_calculate(hashs[2], row_to_json(rec), category) INTO amount;



		IF hash is NULL THEN

			SELECT keyname||'=>'||amount INTO hash;

		ELSEIF isexists(hash, keyname) THEN

			temp_amount = (hash->keyname)::float;

			amount = amount + temp_amount;

			hash = hash||(SELECT (keyname||'=>'||amount)::hstore);

		ELSE

			hash = hash||(SELECT (keyname||'=>'||amount)::hstore);

		END IF;

		FETCH cur INTO rec;



	END LOOP;



	CLOSE cur;

	return hash;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operations_occupy(hashs hstore[], start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, key_type INT, flag TEXT)

IS 'Lins-运营商占成-统计周期内运营商的占成';



drop function IF EXISTS gamebox_operation_occupy(TIMESTAMP, TIMESTAMP, TEXT);

drop function IF EXISTS gamebox_operation_occupy(TIMESTAMP, TIMESTAMP, TEXT, TEXT);

create or replace function gamebox_operation_occupy(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	category 	TEXT,

	flag 		TEXT

) RETURNS refcursor as $$



DECLARE

	cur 			refcursor;

	settle_state	TEXT:='settle';

BEGIN



	IF flag = 'N' THEN

		-- settle_state = 'pending_settle';

	END IF;



	IF category = 'AGENT' THEN 	--代理

    	OPEN cur FOR

			SELECT ua."id" owner_id, pg.*

			  FROM (SELECT pgo.player_id "id",

						   pgo.api_id,

						   pgo.game_type,

						   COUNT(DISTINCT pgo.player_id)					as player_num,

						   COALESCE(SUM(-pgo.profit_amount), 0.00)			as profit_amount,

						   COALESCE(SUM(pgo.effective_trade_amount), 0.00)	as effective_trade_amount

					  FROM player_game_order pgo

					 WHERE pgo.create_time >= start_time

					   AND pgo.create_time < end_time

					   AND pgo.order_state = settle_state

					   AND pgo.is_profit_loss = TRUE

					 GROUP BY pgo.player_id, pgo.api_id, pgo.game_type) pg

			  LEFT JOIN sys_user su ON pg."id" = su."id"

			  LEFT JOIN sys_user ua ON su.owner_id = ua."id"

			 WHERE su.user_type = '24'

			   AND ua.user_type = '23'

			 ORDER BY ua.id;



	ELSEIF category = 'TOPAGENT' THEN 	--总代.

    	OPEN cur FOR

           	SELECT ut."id" owner_id, pg.*

			  FROM (SELECT pgo.player_id "id",

						   pgo.api_id,

						   pgo.game_type,

						   COUNT(DISTINCT pgo.player_id)					as player_num,

						   COALESCE(SUM(-pgo.profit_amount), 0.00)			as profit_amount,

						   COALESCE(SUM(pgo.effective_trade_amount), 0.00)	as effective_trade_amount

					  FROM player_game_order pgo

					 WHERE pgo.create_time >= start_time

					   AND pgo.create_time < end_time

					   AND pgo.order_state = settle_state

					   AND pgo.is_profit_loss = TRUE

					 GROUP BY pgo.player_id, pgo.api_id, pgo.game_type) pg

			  LEFT JOIN sys_user su ON pg."id" = su."id"

			  LEFT JOIN sys_user ua ON su.owner_id = ua."id"

			  LEFT JOIN sys_user ut ON ua.owner_id = ut."id"

			 WHERE su.user_type = '24'

			   AND ua.user_type = '23'

			   AND ut.user_type = '22'

			 ORDER BY ut."id";

	ELSE 	--站点统计

	   	OPEN cur FOR

           	SELECT pgo.api_id,

				   pgo.game_type,

				   COUNT(DISTINCT pgo.player_id)					as player_num,

				   COALESCE(SUM(-pgo.profit_amount), 0.00)			as profit_amount,

				   COALESCE(SUM(pgo.effective_trade_amount), 0.00)	as effective_trade_amount

			  FROM player_game_order pgo

			 WHERE pgo.create_time >= start_time

			   AND pgo.create_time < end_time

			   AND pgo.order_state = settle_state

			   AND pgo.is_profit_loss = TRUE

			 GROUP BY pgo.api_id, pgo.game_type;

	END IF;



	RETURN cur;

END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operation_occupy(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, flag TEXT)

IS 'Lins-运营商占成-API的下单信息';