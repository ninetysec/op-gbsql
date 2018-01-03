-- auto gen by admin 2016-05-13 21:18:41
--001--修正统计优惠信息的条件（返佣）

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

		SELECT pt.*, su.owner_id

		  FROM (SELECT player_id,

		               fund_type,

		               SUM(transaction_money) as transaction_money

		          FROM (SELECT player_id,

		                       fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND fund_type in ('backwater', 'refund_fee', 'artificial_deposit',

		                                     'company_deposit', 'online_deposit', 'artificial_withdraw', 'player_withdraw')

		                   AND create_time >= start_time

		                   AND create_time < end_time

		                   AND NOT (fund_type = 'artificial_deposit' AND

		                            transaction_type = 'favorable')

		                UNION ALL

		                SELECT player_id,

		                       --fund_type||transaction_type,

		                       'favourable' fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND (fund_type = 'favourable' OR

		                        fund_type = 'recommend'  OR

		                        (fund_type = 'artificial_deposit' AND transaction_type = 'favorable'))

		                   AND create_time >= start_time

		                   AND create_time < end_time

		               ) ptu

		         GROUP BY player_id, fund_type

		       ) pt

		       LEFT JOIN

		       sys_user su ON pt.player_id = su."id"

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



--002--修正统计优惠信息的条件（占成）

drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, TEXT);

create or replace function gamebox_expense_gather(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	category 	TEXT

) returns hstore as $$



DECLARE

	rec 	record;

	hash 	hstore;

	mhash 	hstore;

	param 	text:='';

	user_id 	text:='';

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

		cols = 'u.topagent_id as id, u.topagent_name as name, ';

		tables= 'player_transaction p, v_sys_user_tier u';

		grups= 'u.topagent_id, u.topagent_name ';

	ELSEIF category ='AGENT' THEN

		cols = 'u.agent_id as id, u.agent_name as name, ';

		tables = 'player_transaction p, v_sys_user_tier u';

		grups = 'u.agent_id, u.agent_name ';

	ELSE

		cols = 'p.player_id as id, u.username as name, ';

		tables = 'player_transaction p, v_sys_user_tier u';

		grups = 'p.player_id, u.username ';

	END IF;

	FOR rec IN EXECUTE

		'SELECT id,

		        name,

		        fund_type,

		        SUM(transaction_money) as transaction_money

		   FROM (SELECT '||cols||'

		                p.fund_type,

		                transaction_money

		           FROM '||tables||'

		          WHERE p.player_id = u.id

		            AND p.fund_type IN (''backwater'', ''refund_fee'', ''artificial_deposit'',

		                                ''company_deposit'', ''online_deposit'', ''artificial_withdraw'', ''player_withdraw'')

		            AND p.status = ''success''

		            AND NOT (fund_type = ''artificial_deposit'' AND

                         transaction_type = ''favorable'')

		            AND p.create_time >= $1

		            AND p.create_time < $2

		         UNION ALL

		         SELECT '||cols||'

		                --p.fund_type||p.transaction_type,

		                ''favourable'' fund_type,

		                transaction_money

		           FROM '||tables||'

		          WHERE p.player_id = u.id

                AND (fund_type = ''favourable'' OR

		                 fund_type = ''recommend'' OR

		                 (fund_type = ''artificial_deposit'' AND transaction_type = ''favorable''))

		            AND status = ''success''

		            AND create_time >= $1

		            AND create_time < $2) fund_union

		  GROUP BY id, name, fund_type'

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

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT)

IS 'Lins-分摊费用';



--003--当期返佣的逻辑修正为：所有当前周期内审核通过的返佣

drop function if EXISTS gamebox_occupy_value(TIMESTAMP, TIMESTAMP, hstore);

create or replace function gamebox_occupy_value(

	start_time TIMESTAMP,

	end_time TIMESTAMP,

	expense_map hstore

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：总代占成-当前周期的返佣

--v1.01  2016/05/12  Leisure  当期返佣的逻辑修正为，所有当前周期内审核通过的返佣

--v1.02  2016/05/12  Leisure  修正分组统计的SQL

*/

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

/*

	FOR rec IN EXECUTE

		'SELECT ut."id"  as topagent_id,

					  ut.username  as name,

					  SUM (ra.rebate_total)  as rebate_total

		   FROM rebate_agent ra, sys_user ua, sys_user ut

		  WHERE ra.agent_id = ua."id"

		    AND ua.owner_id = ut."id"

				AND ua.user_type = ''23''

				AND ut.user_type = ''22''

				AND ra.settlement_time >= $1

				AND ra.settlement_time < $2

				AND ra.settlement_state = ''lssuing''

		  GROUP BY ut.id, ut.username'

*/--v1.02

	FOR rec IN EXECUTE

		'SELECT ut."id"  as topagent_id,

		        ut.username  as name,

		        SUM (ra.rebate_total)  as rebate_total

		   FROM rebate_agent ra, sys_user ua, sys_user ut

		  WHERE ra.agent_id = ua."id"

		    AND ua.owner_id = ut."id"

		    AND ua.user_type = ''23''

		    AND ut.user_type = ''22''

		    AND ra.settlement_time >= $1

		    AND ra.settlement_time < $2

		    AND ra.settlement_state = ''lssuing''

		  GROUP BY ut.id, ut.username'

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



--004--修改计算有效玩家函数的参数

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

          SUM(COALESCE(-pgo.profit_amount, 0.00))			    as profit_amount

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



	  profit_amount 		= rec.profit_amount;	--代理盈亏总额

		--如果代理盈亏总额为正时，才有返佣.

		IF profit_amount <= 0 THEN

			CONTINUE;

		END IF;



		pre_valid_value 	= 0.00;	-- 重置变量.

		pre_profit 			  = 0.00;

    pre_player_num 		= 0;

		effective_trade_amount = rec.effective_trade_amount;	--代理有效交易量

	  --raise info '代理有效值:%, 盈亏总额:%, 玩家数:%', effective_trade_amount, profit_amount, player_num;



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



					SELECT gamebox_valid_player_num(start_time, end_time, rec.id, valid_value) INTO player_num;



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



--005--代理返佣，插入数据时，对于只有费用，没有返佣的记录，settlement_state值设为next_lssuing

drop function if exists gamebox_rebate_agent(INT, TEXT, hstore);

create or replace function gamebox_rebate_agent(

	bill_id	INT,

	flag		TEXT,

	checkhash	hstore

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：返佣-代理返佣计

--v1.01  2016/05/12  Leisure  对于只有费用，没有返佣的记录，settlement_state值设为next_lssuing

--v1.02  2016/05/13  Leisure  对于未结算账单，未满足返佣梯度的，不统计

--v1.03  2016/05/13  Leisure  需要将上期未结金额，写入字段中

*/

DECLARE

	rec		record;

	pending	TEXT:='pending_lssuing';

	rebate		FLOAT:=0.00;	-- 代理返佣

	max_rebate	FLOAT:=0.00;	-- 返佣上限

	limithash	hstore;			-- 返佣上限

	agent_id	TEXT;

	subkeys		TEXT[];

	subkey		TEXT;

	player_num	INT=0;

	next_lssuing_total FLOAT:=0.00; --未结算佣金



BEGIN

	IF flag = 'Y' THEN



		FOR rec IN

			SELECT p.rebate_bill_id,

				   p.agent_id,

				   u.username					agent_name,

				   --COUNT(distinct p.user_id)	effective_player,

				   SUM(p.effective_transaction)	effective_transaction,

				   SUM(p.profit_loss)			profit_loss,

				   SUM(p.rakeback)				rakeback,

				   SUM(p.rebate_total)			rebate_total,

				   SUM(p.refund_fee)			refund_fee,

				   SUM(p.recommend)				recommend,

				   SUM(p.preferential_value)	preferential_value,

				   SUM(p.apportion)				apportion,

				   SUM(p.deposit_amount)		deposit_amount,

				   SUM(p.withdrawal_amount)		withdrawal_amount

			  FROM rebate_player p, sys_user u

			 WHERE p.agent_id = u.id

			   AND p.rebate_bill_id = bill_id

			   AND u.user_type = '23'

			 GROUP BY p.rebate_bill_id, p.agent_id, u.username

		LOOP



			next_lssuing_total = 0.00; --v1.03



			--player_num = rec.effective_player;

			player_num = 0;



			agent_id:=rec.agent_id::TEXT;



			IF isexists(checkhash, agent_id) THEN

				subkey = checkhash->agent_id;

				subkeys = regexp_split_to_array(subkey, '_');

				player_num = subkeys[3]::INT;

			END IF;



			SELECT gamebox_rebate_limit(checkhash) INTO limithash;



			IF limithash is NOT null AND isexists(limithash, agent_id) THEN

				subkey = limithash->agent_id;

				subkeys = regexp_split_to_array(subkey, '_');

				max_rebate = subkeys[1];

				--player_num = subkeys[2]::INT;

			END IF;



			rebate = rec.rebate_total;

			IF max_rebate != 0.0 AND rebate > max_rebate THEN

				rebate = max_rebate;

			END IF;



			--如果代理本期完成返佣梯度

			IF checkhash IS NOT NULL AND isexists(checkhash, agent_id) THEN



				pending :='pending_lssuing';



				--如果本期满足返佣梯度，需要结算往期费用

				SELECT COALESCE(SUM(rebate_actual), 0.00)

				  INTO next_lssuing_total

				  FROM rebate_agent rao

				 WHERE rao.settlement_state = 'next_lssuing'

				   AND rao.agent_id = rec.agent_id

				   --AND rao.rebate_bill_id <= bill_id

				   AND rao.rebate_bill_id > (

				     SELECT COALESCE(MAX(rebate_bill_id), 0)

				       FROM rebate_agent rai

				      WHERE rai.settlement_state <> 'next_lssuing'

				        AND rai.agent_id = rec.agent_id

				        --AND rai.rebate_bill_id < bill_id

				   );



				rebate := rebate + next_lssuing_total;

			ELSE

				pending := 'next_lssuing';

			END IF;



			INSERT INTO rebate_agent(

				rebate_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,

				rakeback, rebate_total, rebate_actual, refund_fee, recommend, preferential_value,

				settlement_state, apportion, deposit_amount, withdrawal_amount, history_apportion

			) VALUES (

				bill_id, rec.agent_id, rec.agent_name, player_num, rec.effective_transaction, rec.profit_loss,

				rec.rakeback, rebate, rebate, rec.refund_fee, rec.recommend, rec.preferential_value,

				pending, rec.apportion, rec.deposit_amount, rec.withdrawal_amount, next_lssuing_total

			);



		END LOOP;



	ELSEIF flag='N' THEN

		--v1.02 对于未结算账单，未满足返佣梯度的，不统计

		IF checkhash IS NULL THEN

			RETURN;

		END IF;

		FOR rec IN

			SELECT p.rebate_bill_nosettled_id,

				   p.agent_id,

				   u.username					agent_name,

				   --COUNT(distinct p.player_id)	effective_player,

				   SUM(p.effective_transaction)	effective_transaction,

				   SUM(p.profit_loss)			profit_loss,

				   SUM(p.rakeback)				rakeback,

				   SUM(p.rebate_total)			rebate_total,

				   SUM(p.refund_fee)			refund_fee,

				   SUM(p.recommend)				recommend,

				   SUM(p.preferential_value)	preferential_value,

				   SUM(p.apportion)				apportion,

				   SUM(p.deposit_amount)		deposit_amount,

				   SUM(p.withdrawal_amount)		withdrawal_amount

			  FROM rebate_player_nosettled p, sys_user u

			 WHERE p.agent_id = u.id

			   AND p.rebate_bill_nosettled_id = bill_id

			   AND u.user_type = '23'

			 GROUP BY p.rebate_bill_nosettled_id, p.agent_id, u.username

		LOOP



			next_lssuing_total = 0.00;



			agent_id:=rec.agent_id::TEXT;



			--v1.02 对于未结算账单，未满足返佣梯度的，不统计

			IF isexists(checkhash, agent_id) = false THEN

				CONTINUE;

			END IF;

			--player_num = rec.effective_player;

			player_num = 0;



			IF isexists(checkhash, agent_id) THEN

				subkey = checkhash->agent_id;

				subkeys = regexp_split_to_array(subkey, '_');

				player_num = subkeys[3]::INT;

			END IF;



			SELECT gamebox_rebate_limit(checkhash) INTO limithash;



			IF isexists(limithash, agent_id) THEN

				subkey = limithash->agent_id;

				subkeys = regexp_split_to_array(subkey, '_');

				max_rebate = subkeys[1];

				--player_num = subkeys[2]::INT;

			END IF;



			rebate = rec.rebate_total;

			IF max_rebate != 0.0 AND rebate > max_rebate THEN

				rebate = max_rebate;

			END IF;



			--如果代理本期完成返佣梯度

			IF checkhash IS NOT NULL AND isexists(checkhash, agent_id) THEN



				pending :='pending_lssuing';

				--如果本期满足返佣梯度，需要结算往期费用

				SELECT COALESCE(SUM(rebate_actual), 0.00)

				  INTO next_lssuing_total

				  FROM rebate_agent rao

				 WHERE rao.settlement_state = 'next_lssuing'

				   AND rao.agent_id = rec.agent_id

				   --AND rao.rebate_bill_id < bill_id

				   AND rao.rebate_bill_id > (

				     SELECT COALESCE(MAX(rebate_bill_id), 0)

				       FROM rebate_agent rai

				      WHERE rai.settlement_state <> 'next_lssuing'

                AND rai.agent_id = rec.agent_id

				        --AND rai.rebate_bill_id < bill_id

				   );



				rebate := rebate + next_lssuing_total;

			ELSE

				pending := 'next_lssuing';

			END IF;



			INSERT INTO rebate_agent_nosettled (

				rebate_bill_nosettled_id, agent_id, agent_name, effective_player, effective_transaction,

				profit_loss, rakeback, rebate_total, refund_fee, recommend, preferential_value,

				apportion, deposit_amount, withdrawal_amount, history_apportion

			) VALUES (

				bill_id, rec.agent_id, rec.agent_name, player_num, rec.effective_transaction,

				rec.profit_loss, rec.rakeback, rebate, rec.refund_fee, rec.recommend, rec.preferential_value,

				rec.apportion, rec.deposit_amount, rec.withdrawal_amount, next_lssuing_total

			);



		END LOOP;



	END IF;

raise info '代理返佣.完成';

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_agent(bill_id INT, flag TEXT, checkhash hstore)

IS 'Lins-返佣-代理返佣计算';



--006--只统计settlement_state = 'pending_lssuing'的代理账单（'next_lssuing'为下期结算，不统计）

DROP FUNCTION IF EXISTS gamebox_rebate_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);

create or replace function gamebox_rebate_bill(

	name		TEXT,

	start_time		TIMESTAMP,

	end_time		TIMESTAMP,

	INOUT bill_id		INT,

	op		TEXT,

	flag		TEXT

)

returns INT as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：返佣-返佣周期主表

--v1.01  2016/05/12  Leisure  只统计settlement_state = 'pending_lssuing'的代理账单（'next_lssuing'为下期结算，不统计）

--v1.02  2016/05/12  Leisure  本期没有代理达到返佣梯度，依然需要出账单

*/

DECLARE

	rec 		record;

	pending_pay text:='pending_pay';

	key_id 		INT;

	ra_count    INT:=0; -- rebate_agent 条数



BEGIN

	IF flag='Y' THEN 	--已出账

		IF op='I' THEN

			INSERT INTO rebate_bill (

				period, start_time, end_time,

				agent_count, agent_lssuing_count, agent_reject_count, rebate_total, rebate_actual,

				last_operate_time, create_time, lssuing_state

			) VALUES (

				name, start_time, end_time,

				0, 0, 0, 0, 0,

				now(), now(), pending_pay

			) returning id into bill_id;

			--改为returning，防止并发 Leisure 20160505

			--SELECT currval(pg_get_serial_sequence('rebate_bill', 'id')) INTO bill_id;

			raise info 'rebate_bill.完成.Y键值:%', bill_id;

		ELSE

			--v1.02

			--SELECT COUNT(1) FROM rebate_agent WHERE rebate_bill_id = bill_id INTO ra_count;

			--IF ra_count = 0 THEN

				--DELETE FROM rebate_bill WHERE id = bill_id;

			--ELSE

			  SELECT COUNT(1) FROM rebate_agent WHERE rebate_bill_id = bill_id AND settlement_state = 'pending_lssuing' INTO ra_count;

				IF ra_count = 0 THEN

					UPDATE rebate_bill SET lssuing_state = 'next_pay' WHERE id = bill_id;

				ELSE

					FOR rec in

						SELECT rebate_bill_id,

									 COUNT(DISTINCT agent_id) 	agent_num,

									 SUM(effective_transaction) 	effective_transaction,

									 SUM(profit_loss) 			profit_loss,

									 SUM(rakeback) 				rakeback,

									 SUM(rebate_total) 			rebate_total,

									 SUM(refund_fee) 				refund_fee,

									 SUM(recommend) 				recommend,

									 SUM(preferential_value) 		preferential_value,

									 SUM(apportion) 				apportion

							FROM rebate_agent

						 WHERE rebate_bill_id = bill_id

							 AND settlement_state = 'pending_lssuing'

						 GROUP BY rebate_agent.rebate_bill_id

					LOOP

						UPDATE rebate_bill

							 SET agent_count = rec.agent_num,

									 rebate_total = rec.rebate_total,

									 effective_transaction = rec.effective_transaction,

									 profit_loss = rec.profit_loss,

									 rakeback = rec.rakeback,

									 refund_fee = rec.refund_fee,

									 recommend = rec.recommend,

									 preferential_value = rec.preferential_value,

									 apportion = rec.apportion

						 WHERE id = rec.rebate_bill_id;

					END LOOP;

				END IF;

			--END IF;

		END IF;



	ELSEIF flag = 'N' THEN 	--未出账

		IF op='I' THEN

			INSERT INTO rebate_bill_nosettled (

				start_time, end_time, create_time,

				rebate_total, effective_transaction, profit_loss, refund_fee,

				recommend, preferential_value, apportion, rakeback

			) VALUES (

				start_time, end_time, now(),

				0, 0, 0, 0,

				0, 0, 0, 0

			) returning id into bill_id;

			--改为returning，防止并发 Leisure 20160505

			--SELECT currval(pg_get_serial_sequence('rebate_bill_nosettled', 'id')) INTO bill_id;

			raise info 'rebate_bill_nosettled.完成.N键值:%', bill_id;

		ELSE

			--v1.02

			--SELECT COUNT(1) FROM rebate_agent_nosettled WHERE rebate_bill_nosettled_id = bill_id INTO ra_count;

			--IF ra_count = 0 THEN

				--DELETE FROM rebate_bill_nosettled WHERE id = bill_id;

			--ELSE

				FOR rec IN

					SELECT rebate_bill_nosettled_id,

								 SUM(effective_transaction) 	effective_transaction,

								 SUM(profit_loss) 			profit_loss,

								 SUM(rakeback) 				rakeback,

								 SUM(rebate_total) 			rebate_total,

								 SUM(refund_fee) 				refund_fee,

								 SUM(recommend) 				recommend,

								 SUM(preferential_value) 		preferential_value,

								 SUM(apportion) apportion

						FROM rebate_agent_nosettled

					 WHERE rebate_bill_nosettled_id = bill_id

					 GROUP BY rebate_bill_nosettled_id

				LOOP

					UPDATE rebate_bill_nosettled

						 SET rebate_total = rec.rebate_total,

								 effective_transaction = rec.effective_transaction,

								 profit_loss = rec.profit_loss,

								 rakeback = rec.rakeback,

								 refund_fee = rec.refund_fee,

								 recommend = rec.recommend,

								 preferential_value = rec.preferential_value,

								 apportion = rec.apportion

					 WHERE id = rec.rebate_bill_nosettled_id;

				END LOOP;

				DELETE FROM rebate_bill_nosettled WHERE id <> bill_id;

			--END IF;

		END IF;



	END IF;



	RETURN;



END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, bill_id INT, op TEXT, flag TEXT)

IS 'Lins-返佣-返佣周期主表';



--007--统计代理返佣的时候，对于有优惠而没有返佣的玩家，需要计算其最终佣金（佣金-费用）

drop function if exists gamebox_rebate_expense_gather(INT, TIMESTAMP, TIMESTAMP, TEXT, TEXT, TEXT);

create or replace function gamebox_rebate_expense_gather(

	bill_id 		INT,

	start_time 		TIMESTAMP,

	end_time 		TIMESTAMP,

	row_split 		TEXT,

	col_split 		TEXT,

	flag 			TEXT

) returns hstore as $BODY$



DECLARE

	rec 		record;

	hash 		hstore;

	mhash 		hstore;

	param 		text:='';

	user_id 	text:='';

	money 		float:=0.00;

	loss 		FLOAT:=0.00;



	agent_id 	INT;

	agent_name 	TEXT:='';

	tbl 		TEXT:='rebate_api';

	tbl_id 		TEXT:='rebate_bill_id';

	sqld 		TEXT;



	eff_trans 	FLOAT:=0.00;

BEGIN



	SELECT gamebox_expense_gather(start_time, end_time, row_split, col_split) INTO hash;



	IF flag = 'N' THEN

		tbl = 'rebate_api_nosettled';

		tbl_id = 'rebate_bill_nosettled_id';

	END IF;

	/*

	sqld = 'SELECT ra.player_id,

			   su.owner_id,

			   sa.username,

			   ra.rebate_total,

			   ra.effective_transaction,

			   ra.profit_loss

		  FROM (SELECT player_id,

		  			   sum(rebate_total) 			as rebate_total,

		  			   sum(effective_transaction)  	as effective_transaction,

		  			   sum(profit_loss)  			as profit_loss

				  FROM '||tbl||'

				 WHERE '||tbl_id||'='||bill_id||'

				 GROUP BY player_id) ra,

			   sys_user su,

			   sys_user sa

		 WHERE ra.player_id = su.id

		   AND su.owner_id  = sa.id

		   AND su.user_type = ''24''

		   AND sa.user_type = ''23''';

	*/



	sqld =

	'SELECT ra.player_id,

	        su.owner_id,

	        sa.username,

	        ra.rebate_total,

	        ra.effective_transaction,

	        ra.profit_loss

	   FROM (SELECT player_id,

	                sum(rebate_total) 			as rebate_total,

	                sum(effective_transaction)  	as effective_transaction,

	                sum(profit_loss)  			as profit_loss

	           FROM (SELECT player_id,

	                        rebate_total,

	                        effective_transaction,

	                        profit_loss

	                   FROM '||tbl||'

	                  WHERE '||tbl_id||'='||bill_id||'

	                 UNION ALL

	                 SELECT player_id,

	                        0.00	as rebate_total,

	                        0.00 as effective_transaction,

	                        0.00	as profit_loss

	                   FROM player_transaction

	                  WHERE status = ''success''

	                    AND (fund_type in (''backwater'', ''refund_fee'', ''favourable'', ''recommend'') OR

	                        (fund_type = ''artificial_deposit'' AND transaction_type = ''favorable''))

	                    AND create_time >= ''' || start_time || '''

	                    AND create_time < ''' || end_time || '''

	                ) rebate_union

	          GROUP BY player_id

	         ) ra,

	         sys_user su,

	         sys_user sa

	  WHERE ra.player_id = su.id

	    AND su.owner_id  = sa.id

	    AND su.user_type = ''24''

	    AND sa.user_type = ''23''';



	--统计各代理返佣.

	FOR rec IN EXECUTE sqld



	LOOP

		user_id 	= rec.player_id::text;

		agent_id 	= rec.owner_id;

		agent_name 	= rec.username;

		money 		= rec.rebate_total;

		loss 		= rec.profit_loss;

		eff_trans 	= rec.effective_transaction;



		IF isexists(hash, user_id) THEN

			param = hash->user_id;

			param = param||row_split||'rebate'||col_split||money::text;

			param = param||row_split||'profit_loss'||col_split||loss::text;

			param = param||row_split||'effective_transaction'||col_split||eff_trans::text;

			param = param||row_split||'agent_name'||col_split||agent_name;

		ELSE

			param = 'rebate'||col_split||money::text;

			param = param||row_split||'profit_loss'||col_split||loss::text;

			param = param||row_split||'effective_transaction'||col_split||eff_trans::text;

			param = param||row_split||'agent_name'||col_split||agent_name;

		END IF;

		IF position('agent_id' in param) = 0 THEN

			param = param||row_split||'agent_id'||col_split||agent_id::text;

		END IF;



		SELECT user_id||'=>'||param INTO mhash;

		IF hash is null THEN

			hash = mhash;

		ELSE

			hash = hash||mhash;

		END IF;



	END LOOP;

	raise info '统计当前周期内各代理的各种费用信息.完成';



	RETURN hash;

END;



$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



COMMENT ON FUNCTION gamebox_rebate_expense_gather(bill_id INT, startTime TIMESTAMP, endTime TIMESTAMP, row_split_char TEXT, col_split_char TEXT, flag TEXT)

IS 'Lins-返佣-分摊费用与返佣统计';



--008--修正一处小bug，keyvalue'_'改为keyvalue||'_'

drop function IF EXISTS gamebox_rebate_limit(hstore);

create or replace function gamebox_rebate_limit(

	checkhash 	hstore

) returns hstore as $$



DECLARE

	rec 		record;

	rebate_info TEXT;

	agent_id	TEXT;

	subkeys 	TEXT[];

	limithash	hstore;

	keyname     TEXT;

    keyvalue    FLOAT:=0.0;

BEGIN

  	FOR rec IN

  		SELECT ua.user_id, rg."id", rg.rebate_id, rg.max_rebate

		  FROM rebate_grads rg

		  LEFT JOIN rebate_set rs ON rg.rebate_id = rs."id"

		  LEFT JOIN user_agent_rebate ua ON rg.rebate_id = ua.rebate_id

		 WHERE rs.status = '1'

	LOOP



		agent_id:=rec.user_id::TEXT;

		---- agent_id = 927

		rebate_info = checkhash->agent_id;

		---- rebate_info = 62_79_3_580_2080_feiagent

		subkeys = regexp_split_to_array(rebate_info, '_');

		IF subkeys[1] = rec.rebate_id::TEXT AND subkeys[2] = rec.id::TEXT THEN



			keyname:=agent_id;

	        keyvalue:=rec.max_rebate::FLOAT;

	        IF limithash IS NULL THEN

	            SELECT keyname||'=>'||keyvalue||'_'||subkeys[3] into limithash;

	        ELSE

	            limithash = (SELECT (keyname||'=>'||keyvalue||'_'||subkeys[3])::hstore)||limithash;

	        END IF;



		END IF;



	END LOOP;

	RETURN limithash;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_limit(checkhash hstore)

IS 'Fei-计算代理梯度的返佣上限.';



--009--修改执行逻辑，未达返佣梯度，依然需要计算代理承担费用

drop function if exists gamebox_rebate(text, text, text, text, text);

create or replace function gamebox_rebate(

		name 		text,

		startTime 	text,

		endTime 	text,

		url 		text,

		flag 		text

) returns void as $$



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

					DELETE FROM rebate_api WHERE rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);

					DELETE FROM rebate_player  WHERE rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);

					DELETE FROM rebate_agent WHERE rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);

					DELETE FROM rebate_bill WHERE "id" IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);

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



--010--修改为计算某代理的有效玩家数

drop function if exists gamebox_valid_player_num(TIMESTAMP, TIMESTAMP, INT, FLOAT);

create or replace function gamebox_valid_player_num(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	agent_id	INT,

	valid_value	FLOAT

) returns INT as $$



DECLARE

	player_num 	INT:=0;



BEGIN

	SELECT COUNT(1)

	  FROM (SELECT pgo.player_id, SUM(pgo.effective_trade_amount) effeTa

	         FROM player_game_order pgo LEFT JOIN sys_user su ON pgo.player_id = su."id"

	        WHERE pgo.create_time >= start_time

	          AND pgo.create_time <= end_time

	          AND pgo.order_state = 'settle'

	          AND pgo.is_profit_loss = TRUE

	          AND su.owner_id = agent_id

	        GROUP BY pgo.player_id) pn

	 WHERE pn.effeTa >= valid_value

	  INTO player_num;

	RETURN player_num;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_valid_player_num(start_time TIMESTAMP, end_time TIMESTAMP, valid_value FLOAT)

IS 'Fei-计算有效玩家数';



--011--交易时间由create_time改为bet_time，交易时间条件改为参数值和此后24小时

DROP FUNCTION IF EXISTS gamebox_effective_volume(TIMESTAMP);

CREATE OR REPLACE FUNCTION gamebox_effective_volume(

	p_rakeback_time  TIMESTAMP

) returns hstore as $$

DECLARE

    rec         record;

    volumehash  hstore;

    keyname     TEXT;

    keyvalue    FLOAT:=0.0;

BEGIN

    FOR rec IN

        SELECT pgo.player_id, SUM(COALESCE(effective_trade_amount, 0.00)) volume

          FROM player_game_order pgo

         WHERE pgo.bet_time >= p_rakeback_time

				   AND pgo.bet_time < p_rakeback_time + '24hour'

           AND order_state = 'settle'

		   AND is_profit_loss = TRUE

         GROUP BY pgo.player_id

         ORDER BY pgo.player_id



    LOOP

        keyname:=rec.player_id::TEXT;

        keyvalue:=rec.volume::FLOAT;

        IF volumehash IS NULL THEN

            SELECT keyname||'=>'||keyvalue into volumehash;

        ELSE

            volumehash = (SELECT (keyname||'=>'||keyvalue)::hstore)||volumehash;

        END IF;



    END LOOP;

    RETURN volumehash;



END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_effective_volume(p_rakeback_time TIMESTAMP)

IS 'Fei-计算玩家一天的有效交易量';



--012--交易时间由create_time改为bet_time

DROP FUNCTION IF EXISTS gamebox_rakeback_api_base(TIMESTAMP);

create or replace function gamebox_rakeback_api_base(

	p_rakeback_time 	TIMESTAMP

) returns void as $$



DECLARE

	rakeback 	FLOAT:=0.00;

	rec 		record;

	gradshash 	hstore;

	agenthash 	hstore;

	is_prefer	int:=0;



BEGIN

	raise info '取得当前返水梯度设置信息';

	SELECT gamebox_rakeback_api_grads() into gradshash;

	raise info '取得代理返水设置';

	SELECT gamebox_agent_rakeback() 	into agenthash;



	raise info '统计前清空当前日期( % )已有数据', p_rakeback_time;

	DELETE FROM rakeback_api_base WHERE rakeback_time >= p_rakeback_time AND rakeback_time < p_rakeback_time + '24hour';



	raise info '统计日期( % )内是否有返水优惠活动', p_rakeback_time;

	SELECT COUNT(1) FROM activity_message

	 WHERE p_rakeback_time >= start_time

	   AND p_rakeback_time <end_time

	   AND check_status = '1'

	   AND is_display = TRUE

	   AND is_deleted = FALSE

	   AND activity_type_code = 'back_water' into is_prefer;



	FOR rec IN

		SELECT ua.parent_id,

		       su.owner_id,

		       su.username,

		       po.player_id 	as userid,

		       po.api_id,

		       po.api_type_id,

		       po.game_type,

		       po.effective_trade_amount,

		       po.profit_amount,

		       up.rakeback_id,

		       up.rank_id

		  FROM (SELECT pgo.player_id,

		               pgo.api_id,

		               pgo.api_type_id,

		               pgo.game_type,

		               SUM(COALESCE(pgo.effective_trade_amount, 0.00))	as effective_trade_amount,

		               SUM(COALESCE(pgo.profit_amount, 0.00))			as profit_amount

		              FROM player_game_order pgo

		             WHERE bet_time >= p_rakeback_time

                   AND bet_time < p_rakeback_time + '24hour'

		               AND pgo.order_state = 'settle'

		               AND pgo.is_profit_loss = TRUE

		             GROUP BY pgo.player_id, pgo.api_id, pgo.api_type_id, pgo.game_type) po

		       LEFT JOIN sys_user su ON po.player_id = su."id"

		       LEFT JOIN user_player up ON po.player_id = up."id"

		       LEFT JOIN user_agent ua ON su.owner_id = ua."id"

		 WHERE su.user_type = '24'



		LOOP

			IF is_prefer > 0 THEN

			SELECT gamebox_rakeback_calculator(gradshash, agenthash, row_to_json(rec), p_rakeback_time) into rakeback;

		END IF;

		raise info '玩家[%]返水 = %', rec.username, rakeback;



		-- 新增玩家返水:有返水才新增.

		IF rakeback > 0 THEN

			INSERT INTO rakeback_api_base(

			    top_agent_id, agent_id, player_id, api_id, api_type_id, game_type,

			    effective_transaction, profit_loss, rakeback, rakeback_time

			) VALUES (

			    rec.parent_id, rec.owner_id, rec.userid, rec.api_id, rec.api_type_id, rec.game_type,

			    rec.effective_trade_amount, rec.profit_amount, rakeback, p_rakeback_time

			);

		END IF;

	END LOOP;



	raise info '收集每个API下每个玩家的返水.完成';

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rakeback_api_base(p_rakeback_time TIMESTAMP)

IS 'Lins-返水-各玩家API返水基础表.入口';





--013
DROP FUNCTION IF EXISTS gamebox_rakeback_calculator(hstore, hstore, json, TIMESTAMP);

CREATE OR REPLACE FUNCTION gamebox_rakeback_calculator(

	gradshash 	hstore,

	agenthash 	hstore,

	rec 		json,

	p_rakeback_time 	TIMESTAMP

) returns FLOAT as $$

DECLARE

	keys 		text[];

	subkeys 	text[];

	keyname 	text:='';

	val 		text:='';		--临时

	hash 		hstore;			--临时Hstore

	valid_value 		float:=0.00;	--梯度有效交易量

	pre_valid_value 	float:=0.00;	--上次梯度有效交易量

	back_water_value 	float:=0.00;	--返水值

	ratio 				float:=0.00;	--占成

	effective_trade_amount 	float:=0.00;	--玩家有效交易量

	grad_id 		int:=0;		--梯度ID.

	api 			int:=0;		--API

	gameType 		text;		--游戏类型

	agent_id 		text;		--代理ID

	volumehash 		hstore;		--玩家一天的有效交易量hstore

	volume 			FLOAT:=0;	--玩家一天的有效交易量

	player_id		int:=0;		--玩家ID

	selvolume		FLOAT:=0;



BEGIN

	IF p_rakeback_time IS NOT NULL THEN

		raise info '计算玩家 [%] 号有效交易量', p_rakeback_time;

		SELECT gamebox_effective_volume(p_rakeback_time) INTO volumehash;

	END IF;



	keys = akeys(gradshash);

	FOR i IN 1..array_length(keys, 1)

	LOOP

		subkeys = regexp_split_to_array(keys[i], '_');

		keyname = keys[i];

		grad_id = rec->>'rakeback_id';

		api = rec->>'api_id';

		gameType = rtrim(ltrim(rec->>'game_type'));

		--玩家未设置返水梯度,取当前玩家的代理返水梯度.

		agent_id = rec->>'owner_id';



		-- keyname = 63_127_6_Casino



		IF grad_id IS NULL THEN

			grad_id = agenthash->agent_id;

		END IF;



		IF grad_id IS NULL THEN

			raise info '[%] 玩家未设置返水梯度,代理也未设置', rec->>'username';

			RETURN 0;

		END IF;



		IF subkeys[1]::int = grad_id AND subkeys[3]::int = api AND rtrim(ltrim(subkeys[4])) = gameType THEN

			-- 开始作比较.

			val = gradshash->keyname;



			IF p_rakeback_time IS NOT NULL THEN

				player_id = rec->>'userid';

				-- 玩家一天所有游戏的有效交易量

				volume = volumehash->player_id::TEXT;

			END IF;



			-- 单个API单个gametype的有效交易量

			effective_trade_amount = (rec->>'effective_trade_amount')::float;



			IF volume > 0.0 THEN

				selvolume = volume;

			ELSE

				selvolume = effective_trade_amount;

			END IF;



			-- 判断是否已经比较够且有效交易量大于当前值.

			IF selvolume > pre_valid_value THEN

				SELECT * FROM strToHash(val) INTO hash;

				-- 占成数

				ratio = (hash->'ratio')::float;

				-- 梯度有效交易量

				valid_value = (hash->'valid_value')::float;



				IF selvolume >= valid_value THEN

					-- 存储此次梯度有效交易量,作下次比较.

					pre_valid_value = valid_value;



					-- 返水计算:有效交易量 x 占成

					back_water_value = effective_trade_amount * ratio / 100;

				END IF;

				-- raise info '玩家返水值:%', back_water_value;



			END IF;

			-- ELSE

			-- 	raise info '没找到返水方案';

			END IF;

		END LOOP;

		-- raise info 'back_water_value = %', back_water_value;

	RETURN back_water_value;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rakeback_calculator(gradshash hstore, agenthash hstore, rec json, p_rakeback_time TIMESTAMP)

IS 'Lins-返水-返水计算';



--014--交易时间由create_time改为bet_time

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

					 WHERE pgo.bet_time >= start_time

					   AND pgo.bet_time < end_time

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

					 WHERE pgo.bet_time >= start_time

					   AND pgo.bet_time < end_time

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

			 WHERE pgo.bet_time >= start_time

			   AND pgo.bet_time < end_time

			   AND pgo.order_state = settle_state

			   AND pgo.is_profit_loss = TRUE

			 GROUP BY pgo.api_id, pgo.game_type;

	END IF;



	RETURN cur;

END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_operation_occupy(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, flag TEXT)

IS 'Lins-运营商占成-API的下单信息';



--015﻿--交易时间由create_time改为bet_time

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

		  WHERE bet_time >= start_time::TIMESTAMP

		    AND bet_time < end_time::TIMESTAMP

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



--016--交易时间由create_time改为bet_time

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

      	    WHERE pgo.bet_time >= start_time

      	      AND pgo.bet_time < end_time

      	      AND pgo.order_state = settle_state

      	  	  AND pgo.is_profit_loss = TRUE

      	    GROUP BY pgo.player_id, pgo.api_id, pgo.api_type_id, pgo.game_type) po

	         LEFT JOIN sys_user su ON po.player_id = su."id"

	         LEFT JOIN user_player up ON po.player_id = up."id"

	         LEFT JOIN user_agent ua ON su.owner_id = ua."id"

	   WHERE su.user_type = '24'

	LOOP

    --EDIT BY Leisure 2016-05-06 对于当期返佣为0的，需要计算承担费用

    /*

    -- 检查当前代理是否满足返佣梯度.

		IF checkhash IS NULL THEN

			EXIT;

		END IF;



		IF isexists(checkhash, (rec.agent_id)::text) = false THEN

			CONTINUE;

		END IF;

    */

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



--017--交易时间由create_time改为bet_time

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

		           WHERE pgo.bet_time >= start_time

		             AND pgo.bet_time < end_time

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