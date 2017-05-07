-- auto gen by admin 2016-04-26 11:07:41
----------------------------------------------------------------

---------------------------- common ----------------------------

----------------------------------------------------------------

/**

 * 玩家返佣-占成调用.

 * @author 	Fly

 * @date 	2016-02-23

 * @param 	startTime 	开始时间

 * @param 	endTime 	结束时间

 */

drop function IF EXISTS gamebox_occupy_rebate_map(TIMESTAMP, TIMESTAMP);

create or replace function gamebox_occupy_rebate_map(

	startTime 	TIMESTAMP,

	endTime 	TIMESTAMP

) returns hstore as $$



DECLARE

	rec record;

	sql TEXT:= '';

	key TEXT:= '';

	val TEXT:= '';

	hash hstore;

BEGIN

	raise info '统计玩家返佣';

	hash = '-1=>-1';

	sql = ' SELECT rp.user_id						as player_id,

				   COALESCE(rp.rebate_total, 0.00)	as rebate

			  FROM rebate_bill rb

			  LEFT JOIN rebate_agent ra ON rb."id" = ra.rebate_bill_id

			  LEFT JOIN rebate_player rp ON rb."id" = rp.rebate_bill_id

			 WHERE rb.start_time >= $1

			   AND rb.end_time < $2

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



/**

 * 计算各个代理适用的返佣梯度.

 * @author 	Lins

 * @date 	2015.11.10

 * @return 	返回float类型，返水值.

 */

drop function IF EXISTS gamebox_rebate_agent_check(hstore, hstore, TIMESTAMP, TIMESTAMP);

drop function IF EXISTS gamebox_rebate_agent_check(hstore, hstore, TIMESTAMP, TIMESTAMP, flag);

create or replace function gamebox_rebate_agent_check(

	gradshash 	hstore,

	agenthash 	hstore,

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	flag 		TEXT

) returns hstore as $$



DECLARE

	rec 		record;

	keys 		text[];

	subkeys 	text[];

	keyname 	text:='';

	val 		text:='';	--临时

	vals 		text[];

	param 		text:='';

	hash 		hstore;		--临时Hstore

	tmphash 	hstore;

	checkhash 	hstore;



	valid_value 		float:=0.00;	--梯度有效交易量

	pre_valid_value 	float:=0.00;	--上次梯度有效交易量

	pre_player_num 		int:=0;

	pre_profit 			float = 0.00;	--返水值.

	back_water_value 	float:=0.00;	--占成

	ratio 				float:=0.00;	--最大返佣上限



  	profit_amount 		float:=0.00;	--盈亏总额

	player_num 			int:=0;			--有效玩家数

	effective_trade_amount 	float:=0.00;--玩家有效交易量

	rebate_id 			int:=0;			--代理返佣主方案.



	api 		int:=0;	--API

	gameType 	text;	--游戏类型

	agent_id 	text;	--代理ID



  	valid_player_num 	int:=0;		--要达到的有效玩家数.

	total_profit 		float:=0.00;

	col_aplit 			TEXT:='_';

	settle_state 		TEXT:='settle';



BEGIN



	IF flag = 'N' THEN

		-- settle_state:='pending_settle';

	END IF;



  	keys = akeys(gradshash);

	FOR rec IN

		 SELECT ua."id",

				ua.username,

				SUM(COALESCE(pgo.effective_trade_amount, 0.00))	as effective_trade_amount,

				SUM(COALESCE(-pgo.profit_amount, 0.00))			as profit_amount

		   FROM player_game_order pgo

		   LEFT JOIN sys_user su ON pgo.player_id = su."id"

		   LEFT JOIN sys_user ua ON su.owner_id = ua."id"

		  WHERE su.user_type = '24'

			AND ua.user_type = '23'

			AND pgo.create_time >= start_time

			AND pgo.create_time < end_time

			AND pgo.order_state = settle_state

			AND pgo.is_profit_loss = TRUE

		  GROUP BY ua."id", ua.username



   	LOOP



		pre_valid_value 	= 0.00;	-- 重置变量.

		pre_profit 			= 0.00;

      	pre_player_num 		= 0;

		profit_amount 		= rec.profit_amount;	--代理盈亏总额

		effective_trade_amount = rec.effective_trade_amount;	--代理有效交易量

	    --raise info '代理有效值:%, 盈亏总额:%, 玩家数:%', effective_trade_amount, profit_amount, player_num;



      	--如果代理盈亏总额为正时，才有返佣.

		IF profit_amount <= 0 THEN

			CONTINUE;

		END IF;



		-- 取得返佣主方案.

		agent_id:=(rec.id)::text;



		-- 判断代理是否设置了返佣梯度.

		IF isexists(agenthash, agent_id) THEN

			rebate_id = agenthash->agent_id;



			FOR i IN 1..array_length(keys,  1)

			LOOP

				subkeys = regexp_split_to_array(keys[i], '_');

				keyname = keys[i];



      			--取得当前返佣梯度.

				IF subkeys[1]::int = rebate_id THEN



					--判断是否已经比较过且有效交易量大于当前值.

	          		val = gradshash->keyname;



					--判断如果存在多条记录，取第一条.

					vals = regexp_split_to_array(val, '\^\&\^');



					IF array_length(vals,  1) > 1 THEN

						val = vals[1];

					END IF;



					SELECT * FROM strToHash(val) into hash;



					valid_player_num = (hash->'valid_player_num')::int;	-- 有效玩家数

					ratio 			= (hash->'ratio')::float;			-- 占成数

					valid_value 	= (hash->'valid_value')::float;		-- 梯度有效交易量

					total_profit 	= (hash->'total_profit')::float;	-- 盈亏总额



					SELECT gamebox_valid_player_num(start_time, end_time, valid_value) INTO player_num;



					-- 有效交易量、盈亏总额、有效玩家数.进行比较.

					IF total_profit >= pre_profit OR valid_player_num >= pre_player_num THEN

						IF effective_trade_amount >= valid_value AND profit_amount >= total_profit AND player_num >= valid_player_num THEN

							-- 存储此次梯度有效交易量, 作下次比较.

							pre_profit 		= total_profit;

							pre_player_num 	= valid_player_num;

							-- 代理满足第一阶条件，满足有效交易量与盈亏总额

							param = agent_id||'=>'||subkeys[1]||col_aplit||subkeys[2]||col_aplit||player_num||col_aplit||profit_amount||col_aplit||effective_trade_amount||col_aplit||rec.username;



							IF checkhash IS NULL THEN

								SELECT param into checkhash;

							ELSE

								SELECT param into tmphash;



							checkhash = checkhash||tmphash;

							END IF;

						END IF;

					END IF;

				END IF;

			END LOOP;

		ELSE

			raise info '代理ID:%, 没有设置返佣梯度.', agent_id;

		END IF;

	END LOOP;



	return checkhash;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_agent_check(gradshash hstore, agenthash hstore, start_time TIMESTAMP, end_time TIMESTAMP, flag TEXT)

IS '计算各个代理适用的返佣梯度';



----------------------------------------------------------------

--------------------------- rakeback ---------------------------

----------------------------------------------------------------

/**

 * 各玩家API返水.

 * @author 	Lins

 * @date 	2015.12.2

 * @param 	bill_id 	返水键值

 * @param 	start_time 	开始时间

 * @param 	end_time 	结束时间

 * @param 	flag 		出账标示:Y-已出账, N-未出账

 */

DROP FUNCTION IF EXISTS gamebox_rakeback_api(INT, TIMESTAMP, TIMESTAMP, TEXT);

create or replace function gamebox_rakeback_api(

	bill_id 	INT,

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	flag 		TEXT

) returns void as $$



DECLARE

	rakeback 	FLOAT:=0.00;

	tmp 		INT:=0;

	rec 		record;



BEGIN

	IF flag = 'N' THEN

		TRUNCATE TABLE rakeback_api_nosettled;

  		TRUNCATE TABLE rakeback_player_nosettled;

	END IF;



	FOR rec IN

		SELECT rab.player_id,

			   rab.api_id,

			   rab.api_type_id,

			   rab.game_type,

			   up.rakeback_id,

			   up.rank_id,

			   SUM(rab.rakeback)				as rakeback,

			   SUM(rab.effective_transaction)	as effective_trade_amount,

			   SUM(rab.profit_loss) 			as profit_amount

	 	  FROM rakeback_api_base rab

	 	  LEFT JOIN sys_user su ON rab.player_id = su."id"

	 	  LEFT JOIN user_player up ON rab.player_id = up."id"

		 WHERE rakeback_time >= start_time

		   AND rakeback_time < end_time

		 GROUP BY rab.player_id, rab.api_id, rab.api_type_id, rab.game_type, up.rakeback_id, up.rank_id



    LOOP

		IF flag = 'Y' THEN

			INSERT INTO rakeback_api (

				rakeback_bill_id, player_id, api_id, api_type_id, game_type,

				rakeback, effective_transaction, profit_loss

			) VALUES (

			 	bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,

			 	rec.rakeback, rec.effective_trade_amount, rec.profit_amount

			);

		 	SELECT currval(pg_get_serial_sequence('rakeback_api', 'id')) into tmp;

		ELSEIF flag = 'N' THEN

			INSERT INTO rakeback_api_nosettled (

				rakeback_bill_nosettled_id, player_id, api_id, api_type_id, game_type,

				rakeback, effective_transaction, profit_loss

			) VALUES (

				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,

				rec.rakeback, rec.effective_trade_amount, rec.profit_amount

			);

		 	SELECT currval(pg_get_serial_sequence('rakeback_api_nosettled', 'id')) into tmp;

		END IF;

			raise info '各API玩家返水键值:%', tmp;

	END LOOP;



	raise info '收集每个API下每个玩家的返水.完成';

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rakeback_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, flag TEXT)

IS 'Lins-返水-各玩家API返水';



----------------------------------------------------------------

---------------------------- rebate ----------------------------

----------------------------------------------------------------

/**

 * 统计各玩家API返佣.

 * @author 	Lins

 * @date 	2015.12.2

 * @param 	bill_id 	返佣KEY.

 * @param 	start_time 	返佣周期开始时间(yyyy-mm-dd)

 * @param 	end_time 	返佣周期结束时间(yyyy-mm-dd)

 * @param 	gradshash 	各种费用(优惠、推荐、返手续费、返水)hash

 * @param 	mainhash 	各玩家返水hash

 * @param 	flag

 */

DROP FUNCTION IF EXISTS gamebox_rebate_api(INT, TIMESTAMP, TIMESTAMP, hstore, hstore, hstore, TEXT);

create or replace function gamebox_rebate_api(

    bill_id 		INT,

    start_time 		TIMESTAMP,

    end_time 		TIMESTAMP,

    gradshash 		hstore,

    checkhash 		hstore,

    mainhash 		hstore,

    flag 			TEXT

) returns void as $$



DECLARE

	rec 				record;

	rebate_value 		FLOAT:=0.00;--返佣.

	tmp 				int:=0;

	key_name 			TEXT:='';

	operation_occupy 	FLOAT:=0.00;

	col_split 			TEXT:='_';

	settle_state 		TEXT:='settle';



BEGIN

  	raise info '计算各API各代理的盈亏总和';



  	IF flag = 'N' THEN

  		-- settle_state:='pending_settle';

  		TRUNCATE TABLE rebate_api_nosettled;

  		TRUNCATE TABLE rebate_player_nosettled;

		TRUNCATE TABLE rebate_agent_nosettled;

  	END IF;



	FOR rec IN

         SELECT su.owner_id as agent_id,

				po.player_id,

				po.api_id,

				po.api_type_id,

				po.game_type,

				po.effective_trade_amount as effective_transaction,

				(po.profit_amount) as profit_loss

		   FROM (SELECT pgo.player_id,

						pgo.api_id,

						pgo.api_type_id,

						pgo.game_type,

						SUM(COALESCE(pgo.effective_trade_amount, 0.00))	as effective_trade_amount,

						SUM(-COALESCE(pgo.profit_amount, 0.00))			as profit_amount

				   FROM player_game_order pgo

				  WHERE pgo.create_time >= start_time

				    AND pgo.create_time < end_time

				    AND pgo.order_state = settle_state

					AND pgo.is_profit_loss = TRUE

				  GROUP BY pgo.player_id, pgo.api_id, pgo.api_type_id, pgo.game_type) po

		   LEFT JOIN sys_user su ON po.player_id = su."id"

		   LEFT JOIN user_player up ON po.player_id = up."id"

		   LEFT JOIN user_agent ua ON su.owner_id = ua."id"

		  WHERE su.user_type = '24'



	LOOP

		-- 检查当前代理是否满足返佣梯度.

		IF checkhash IS NULL THEN

			EXIT;

		END IF;



		IF isexists(checkhash, (rec.agent_id)::text) = false THEN

			CONTINUE;

		END IF;



		raise info '取得各API各分类佣金总和';

		key_name = rec.player_id||col_split||rec.api_id||col_split||rec.game_type;

		operation_occupy = (mainhash->key_name)::FLOAT;

		SELECT gamebox_rebate_calculator(

			gradshash,

			checkhash,

			rec.agent_id,

			rec.api_id,

			rec.game_type,

			rec.profit_loss,

			operation_occupy

		) INTO rebate_value;



		-- 新增各API代理返佣:目前返佣不分正负都新增.

	  	IF flag = 'Y' THEN

			INSERT INTO rebate_api (

				rebate_bill_id, player_id, api_id, api_type_id, game_type,

				rebate_total, effective_transaction, profit_loss

			) VALUES (

				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,

				rebate_value, rec.effective_transaction, rec.profit_loss

			);

		 	SELECT currval(pg_get_serial_sequence('rebate_api', 'id')) INTO tmp;

		 	raise info '返拥API.键值:%', tmp;

		ELSEIF flag = 'N' THEN

			INSERT INTO rebate_api_nosettled (

				rebate_bill_nosettled_id, player_id, api_id, api_type_id, game_type,

				rebate_total, effective_transaction, profit_loss

			) VALUES(

				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,

				rebate_value, rec.effective_transaction, rec.profit_loss

			);

		 	SELECT currval(pg_get_serial_sequence('rebate_api_nosettled', 'id')) INTO tmp;

		 	raise info '返拥API.键值:%',tmp;

		END IF;



	END LOOP;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, gradshash hstore, checkhash hstore, mainhash hstore, flag TEXT)

IS 'Lins-返佣-玩家API返佣';



/**

 * 统计各玩家API返佣.

 * @author 	Lins

 * @date 	2015.12.2

 * @param 	返佣KEY.

 * @param 	返佣周期开始时间(yyyy-mm-dd)

 * @param 	返佣周期结束时间(yyyy-mm-dd)

 * @param 	各种费用(优惠、推荐、返手续费、返水)hash

 * @param 	各玩家返水hash

 */

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

	rebate_value 		FLOAT:=0.00;--返佣.

	operation_occupy 	FLOAT:=0.00;--运营商占成额

	key_name 			TEXT;--运营商占成KEY值.

	rebate_map 			hstore;--各API返佣值.

	val 				FLOAT:=0.00;

	col_split 			TEXT:='_';

BEGIN

	FOR rec IN

        SELECT su.owner_id,

			   rab.api_id,

			   rab.game_type,

			   COUNT(DISTINCT rab.player_id)					as player_num,

			   COALESCE(SUM(rab.profit_loss), 0.00)				as profit_amount,

			   COALESCE(SUM(rab.effective_transaction), 0.00)	as effective_trade_amount

		  FROM rakeback_api_base rab

		  LEFT JOIN sys_user su ON rab.player_id = su."id"

		 WHERE rab.rakeback_time >= start_time

		   AND rab.rakeback_time < end_time

		   AND su.user_type = '24'

		 GROUP BY su.owner_id, rab.api_id, rab.game_type

		 ORDER BY su.owner_id

	LOOP

		--检查当前代理是否满足返佣梯度.

		IF isexists(agent_check_map, (rec.owner_id)::text) = false THEN

			CONTINUE;

		END IF;



		raise info '取得各API各分类佣金总和';

		key_name = rec.api_id||col_split||rec.game_type;

		operation_occupy = (operation_occupy_map->key_name)::FLOAT;



		SELECT gamebox_rebate_calculator(rebate_grads_map, agent_check_map, rec.owner_id, rec.api_id, rec.game_type, rec.profit_amount, operation_occupy) INTO rebate_value;

		val = rebate_value;



		IF rebate_map is null THEN

			SELECT key_name||'=>'||val INTO rebate_map;

		ELSEIF exist(rebate_map, key_name) THEN

			val = val + ((rebate_map->key_name)::FLOAT);

			rebate_map = (SELECT (key_name||'=>'||val)::hstore)||rebate_map;

		ELSE

			rebate_map = (SELECT (key_name||'=>'||val)::hstore)||rebate_map;

		END IF;

	END LOOP;



	RETURN rebate_map;



END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_map(start_time TIMESTAMP, end_time TIMESTAMP, key_type INT, rebate_grads_map hstore, agent_check_map hstore, operation_occupy_map hstore)

IS 'Lins-返佣-API返佣-外调';



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

 * 分摊费用

 * @author 	Lins

 * @date 	2015.11.13

 * @param	start_time 	开始时间

 * @param	end_time 	结束时间

 * @param	row_split 	行分隔符

 * @param	col_split 	列分隔符

 * 返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。

 */

drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, text, text);

create or replace function gamebox_expense_gather(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	row_split 	text,

	col_split 	text

) returns hstore as $$



DECLARE

	rec 		record;

	hash 		hstore;

	mhash 		hstore;

	param 		text:='';

	user_id 	text:='';

	money 		float:=0.00;



BEGIN

	FOR rec IN

		SELECT pt.*, su.owner_id FROM (

		  SELECT player_id,

				 fund_type,

				 SUM(transaction_money) 	as transaction_money

			FROM player_transaction

		   WHERE fund_type in ('backwater', 'favourable', 'recommend', 'refund_fee', 'artificial_deposit',

				'company_deposit', 'online_deposit', 'artificial_withdraw', 'player_withdraw')

			 AND status = 'success'

		 	 AND create_time >= start_time

		 	 AND create_time < end_time

		 	 AND (transaction_way <> 'artificial_favourable' OR transaction_way IS NULL)

		   GROUP BY player_id, fund_type

		   UNION ALL

		  SELECT player_id,

				 fund_type||transaction_type,

				 SUM(transaction_money) 	as transaction_money

			FROM player_transaction

		   WHERE fund_type = 'artificial_deposit'

		     AND transaction_type = 'favorable'

			 AND status = 'success'

		 	 AND create_time >= start_time

		 	 AND create_time < end_time

		   GROUP BY player_id, fund_type, transaction_type

		) pt

		LEFT JOIN sys_user su ON pt.player_id = su."id"

		WHERE su.user_type = '24'

	 LOOP

		user_id = rec.player_id::text;

		money 	= rec.transaction_money;

		IF isexists(hash, user_id) THEN

			param = hash->user_id;

			param = param||row_split||rec.fund_type||col_split||money::text;

		ELSE

			param = rec.fund_type||col_split||money::text;

		END IF;



		IF position('agent_id' IN param) = 0  THEN

			param = param||row_split||'agent_id'||col_split||rec.owner_id::TEXT;

		END IF;



		SELECT user_id||'=>'||param into mhash;

		IF hash is null THEN

			hash = mhash;

		ELSE

			hash = hash||mhash;

		END IF;

	END LOOP;



	return hash;

END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP, row_split text, col_split text)

IS 'Lins-分摊费用';



----------------------------------------------------------------

---------------------------- occupy ----------------------------

----------------------------------------------------------------

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

  	LOOP

		api 			= rec.api_id;

		game_type 		= rec.game_type;

		owner_id 		= rec.topagent_id::TEXT;

		name 			= rec.topagent_name;

		profit_amount 	= rec.profit_amount;



		--取得运营商API占成.

		key_name = api||col_split||game_type;



		operation_occupy_value = 0.00;

		IF exist(operation_occupy_map, key_name) THEN

			operation_occupy_value = (operation_occupy_map->key_name)::FLOAT;

		END IF;



		--计算总代占成.

		key_name = owner_id||col_split||api||col_split||game_type;



		occupy_value = 0.00;

		retio 		 = 0.00;



  IF exist(occupy_grads_map, key_name) THEN

			retio = (occupy_grads_map->key_name)::FLOAT;

			occupy_value = (profit_amount - operation_occupy_value) * retio / 100;

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

		   AND rb.end_time < $2

		   AND ra.settlement_state = ''lssuing''

		   AND su.user_type = ''24''

		   AND ua.user_type = ''23''

		   AND ut.user_type = ''22''

		 GROUP BY ut."id", ut.username'

	  	USING start_time, end_time

	LOOP

		key_name = rec.topagent_id::TEXT;

		name 	 = rec.name;

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



----------------------------------------------------------------

------------------------- operation ----------------------------

----------------------------------------------------------------

/**

 * 根据周期与统计类型查询各API的下单相关信息.

 * @author 	Lins

 * @date 	2015.12.1

 */

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

					 WHERE pgo.create_time >= '2016-04-01'::TIMESTAMP

					   AND pgo.create_time <= '2016-04-30'::TIMESTAMP

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

			 WHERE pgo.create_time >= '2016-04-01'::TIMESTAMP

			   AND pgo.create_time <= '2016-04-30'::TIMESTAMP

			   AND pgo.order_state = settle_state

			   AND pgo.is_profit_loss = TRUE

			 GROUP BY pgo.api_id, pgo.game_type;

	END IF;



	RETURN cur;

END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operation_occupy(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, flag TEXT)

IS 'Lins-运营商占成-API的下单信息';



/**

 * description:收集玩家经营报表.

 * @author 	Lins

 * @date 	2015.10.27

 * @param 	统计开始时间

 * @param 	统计结束时间

 * @param 	0时区当前日期

 * @param 	当前站点信息

 * @return 	返回执行LOG信息.

 */

drop function IF EXISTS gamebox_operations_player(text, text, TEXT, json);

create or replace function gamebox_operations_player(

	start_time 	text,

	end_time 	text,

	curday 		TEXT,

	rec 		json

) returns text as $$

DECLARE

	rtn 		text:='';

	v_COUNT		int4:=0;

	site_id 	INT;

	master_id 	INT;

	center_id 	INT;

	site_name 	TEXT:='';

	master_name TEXT:='';

	center_name TEXT:='';

BEGIN

  	--清除当天的统计信息，保证每天只作一次统计信息

	rtn = rtn||'| |清除当天的统计信息，保证每天只作一次统计信息||';

	delete from operate_player WHERE to_char(static_time, 'YYYY-MM-dd') = curday;



	GET DIAGNOSTICS v_COUNT = ROW_COUNT;

	raise notice '本次删除记录数 %', v_COUNT;

  	rtn = rtn||'| |执行完毕,删除记录数: '||v_COUNT||' 条||';



	--开始执行玩家经营报表信息收集

	site_id 	= COALESCE((rec->>'siteid')::INT, -1);

	site_name	= COALESCE(rec->>'sitename', '');

	master_id	= COALESCE((rec->>'masterid')::INT, -1);

	master_name	= COALESCE(rec->>'mastername', '');

	center_id	= COALESCE((rec->>'operationid')::INT, -1);

	center_name	= COALESCE(rec->>'operationname', '');



	raise info '开始日期:%, 结束日期:%', start_time, end_time;

 	INSERT INTO operate_player(

		center_id, center_name, master_id, master_name,

		site_id, site_name, topagent_id, topagent_name,

		agent_id, agent_name, player_id, player_name,

		api_id, api_type_id, game_type,

		static_time, create_time,

		transaction_order, transaction_volume, effective_transaction, profit_loss

  	) SELECT

	  	center_id, center_name, master_id, master_name,

	  	site_id, site_name, u.topagent_id, u.topagent_name,

	  	u.agent_id, u.agent_name, u.id, u.username,

	  	p.api_id, p.api_type_id, p.game_type,

	  	now(), now(),

	  	p.transaction_order, p.transaction_volume, p.effective_transaction, p.profit_loss

   	FROM (SELECT

			player_id, api_id, api_type_id, game_type,

            COUNT(order_no)  							as transaction_order,

            SUM(COALESCE(single_amount, 0.00))  		as transaction_volume,

            SUM(COALESCE(profit_amount, 0.00))  		as profit_loss,

            SUM(COALESCE(effective_trade_amount, 0.00)) as effective_transaction

           FROM player_game_order

		  WHERE create_time >= start_time::TIMESTAMP

		    AND create_time < end_time::TIMESTAMP

		    AND order_state = 'settle'

			AND is_profit_loss = TRUE

          GROUP BY player_id, api_id, api_type_id, game_type

		) p,v_sys_user_tier u

	WHERE p.player_id = u.id;



	GET DIAGNOSTICS v_COUNT = ROW_COUNT;

	raise notice '本次插入数据量 %', v_COUNT;

  	rtn = rtn||'| |执行完毕,新增记录数: '||v_COUNT||' 条||';



	return rtn;

END;



$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_player(start_time text, end_time text, curday TEXT, rec json)

IS 'Lins-经营报表-玩家报表';