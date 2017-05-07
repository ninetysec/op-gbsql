-- auto gen by bruce 2016-10-08 11:06:46
drop function if exists gamebox_valid_player_num(TIMESTAMP, TIMESTAMP, INT, FLOAT);
create or replace function gamebox_valid_player_num(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	agent_id	INT,
	valid_value	FLOAT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fei      创建此函数: 计算有效玩家数
--v1.01  2016/05/12  Leisure  修改为计算某代理的有效玩家数
--v1.02  2016/06/22  Leisure  <= end_time改为< end_time
--v1.03  2016/10/03  Leisure  统计时间由bet_time改为payout_time
*/
DECLARE
	player_num 	INT:=0;

BEGIN
	SELECT COUNT(1)
	  FROM (SELECT pgo.player_id, SUM(pgo.effective_trade_amount) effeTa
	         FROM player_game_order pgo LEFT JOIN sys_user su ON pgo.player_id = su."id"
	        WHERE pgo.order_state = 'settle'
	          AND pgo.is_profit_loss = TRUE
	          --v1.03  2016/10/03  Leisure
	          --AND pgo.create_time >= start_time
	          --AND pgo.create_time < end_time
	          AND pgo.payout_time >= start_time
	          AND pgo.payout_time < end_time
	          AND su.owner_id = agent_id
	        GROUP BY pgo.player_id) pn
	 WHERE pn.effeTa >= valid_value
	  INTO player_num;
	RETURN player_num;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_valid_player_num(start_time TIMESTAMP, end_time TIMESTAMP, agent_id INT, valid_value FLOAT)
IS 'Fei-计算有效玩家数';

drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, text, text);
create or replace function gamebox_expense_gather(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	row_split 	text,
	col_split 	text
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：返佣--分摊费用
--v1.01  2016/05/12  Leisure  修正统计优惠信息的条件（返佣）
--v1.02  2016/06/06  Leisure  公司存款、线上支付增加微信、支付宝存款、支付
--v1.03  2016/10/03  Leisure  调整player_transaction金额类型的判断方法；
                              时间由create_time改为completion_time
*/
DECLARE
	rec 		record;
	hash 		hstore;
	mhash 		hstore;
	param 		text:='';
	user_id 	text:='';
	money 		float:=0.00;

BEGIN
	/*--v1.03  2016/10/03  Leisure
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
		                                     'artificial_withdraw', 'player_withdraw')
		                   AND create_time >= start_time
		                   AND create_time < end_time
		                   AND NOT (fund_type = 'artificial_deposit' AND
		                            transaction_type = 'favorable')

		                UNION ALL
		                --优惠、推荐
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

		                UNION ALL
		                --公司存款 --v1.02  2016/06/06  Leisure
		                SELECT player_id,
		                       --fund_type||transaction_type,
		                       'company_deposit' fund_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND fund_type IN ('company_deposit','wechatpay_fast' ,'alipay_fast')
		                   AND create_time >= start_time
		                   AND create_time < end_time

		                UNION ALL
		                --线上支付 --v1.02  2016/06/06  Leisure
		                SELECT player_id,
		                       --fund_type||transaction_type,
		                       'online_deposit' fund_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND fund_type IN ('online_deposit','wechatpay_scan' ,'alipay_scan')
		                   AND create_time >= start_time
		                   AND create_time < end_time
		               ) ptu
		         GROUP BY player_id, fund_type
		       ) pt
		       LEFT JOIN
		       sys_user su ON pt.player_id = su."id"
		 WHERE su.user_type = '24'
	LOOP
	*/
	FOR rec IN
		SELECT pt.*, su.owner_id
		  FROM (SELECT player_id,
		               transaction_type,
		               SUM(transaction_money) as transaction_money
		          FROM (--存款
		                SELECT player_id,
		                       'deposit' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND transaction_type = 'deposit'
		                   AND (fund_type <> 'artificial_deposit' OR transaction_way = 'manual_deposit')
		                   AND completion_time >= start_time
		                   AND completion_time < end_time
		                   AND NOT (fund_type = 'artificial_deposit' AND
		                            transaction_type = 'favorable')

		                UNION ALL
		                --取款
		                SELECT player_id,
		                       'withdrawal' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND transaction_type = 'withdrawals'
		                   AND (fund_type <> 'artificial_withdraw' OR transaction_way = 'manual_deposit')
		                   AND completion_time >= start_time
		                   AND completion_time < end_time

		                UNION ALL
		                --优惠
		                SELECT player_id,
		                       'favorable' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND (transaction_type = 'favorable'
		                        AND fund_type <> 'refund_fee'
		                        AND transaction_way <> 'manual_rakeback')
		                   AND completion_time >= start_time
		                   AND completion_time < end_time

		                UNION ALL
		                --推荐
		                SELECT player_id,
		                       'recommend' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND transaction_type = 'recommend'
		                   AND completion_time >= start_time
		                   AND completion_time < end_time

		                UNION ALL
		                --返水
		                SELECT player_id,
		                       'backwater' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND (transaction_type = 'backwater' OR
		                        (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))
		                   AND completion_time >= start_time
		                   AND completion_time < end_time

		                UNION ALL
		                --返手续费
		                SELECT player_id,
		                       'refund_fee' transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND fund_type = 'refund_fee'
		                   AND completion_time >= start_time
		                   AND completion_time < end_time
		               ) ptu
		         GROUP BY player_id, transaction_type
		       ) pt
		       LEFT JOIN
		       sys_user su ON pt.player_id = su."id"
		 WHERE su.user_type = '24'
	LOOP
		user_id = rec.player_id::text;
		money 	= rec.transaction_money;
		IF isexists(hash, user_id) THEN
			param = hash->user_id;
			param = param||row_split||rec.transaction_type||col_split||money::text;
		ELSE
			param = rec.transaction_type||col_split||money::text;
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

drop function IF EXISTS gamebox_operations_player(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_player(
	start_time 	TEXT,
	end_time 	TEXT,
	curday 		TEXT,
	rec 		JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-玩家报表
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.03  2016/06/13  Leisure  is_profit_loss=false的记录也需要统计by acheng
--v1.04  2016/06/27  Leisure  统计时间由bet_time改为payout_time --by acheng
--v1.05  2016/07/08  Leisure  优化输出日志
--v1.05  2016/10/05  Leisure  撤销v1.03的修改 by kitty
*/
DECLARE
	rtn 		text:='';
	v_COUNT		int4:=0;
	site_id 	INT;
	master_id 	INT;
	center_id 	INT;
	site_name 	TEXT:='';
	master_name TEXT:='';
	center_name TEXT:='';
	d_static_date DATE; --v1.02  2016/05/31
BEGIN
	--v1.02  2016/05/31  Leisure
	d_static_date := to_date(curday, 'YYYY-MM-DD');

	--清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	--delete from operate_player WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
	delete from operate_player WHERE static_date = d_static_date;

	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次删除记录数 %', v_COUNT;
	rtn = rtn||'|执行完毕,删除记录数: '||v_COUNT||' 条||';

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
		--static_time, create_time, --v1.02  2016/05/31  Leisure
		static_date, static_time, static_time_end, create_time,
		transaction_order, transaction_volume, effective_transaction, profit_loss
		) SELECT
				center_id, center_name, master_id, master_name,
				site_id, site_name, u.topagent_id, u.topagent_name,
				u.agent_id, u.agent_name, u.id, u.username,
				p.api_id, p.api_type_id, p.game_type,
				--now(), now(), --v1.02  2016/05/31  Leisure
				d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
				p.transaction_order, p.transaction_volume, p.effective_transaction, p.profit_loss
				FROM (SELECT
								player_id, api_id, api_type_id, game_type,
								COUNT(order_no)  							as transaction_order,
								SUM(COALESCE(single_amount, 0.00))  		as transaction_volume,
								SUM(COALESCE(profit_amount, 0.00))  		as profit_loss,
								SUM(COALESCE(effective_trade_amount, 0.00)) as effective_transaction
							 FROM player_game_orders
							--WHERE bet_time >= start_time::TIMESTAMP
							--	AND bet_time < end_time::TIMESTAMP
							WHERE payout_time >= start_time::TIMESTAMP
							  AND payout_time < end_time::TIMESTAMP
								AND order_state = 'settle'
								AND is_profit_loss = TRUE --v1.03  2016/06/13  Leisure
							GROUP BY player_id, api_id, api_type_id, game_type
							) p, v_sys_user_tier u
	WHERE p.player_id = u.id;

	GET DIAGNOSTICS v_COUNT = ROW_COUNT;
	raise notice '本次插入数据量 %', v_COUNT;
	rtn = rtn||'|执行完毕,新增记录数: '||v_COUNT||' 条||';

	return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-玩家报表';

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
--v1.00  2015/01/01  Lins     创建此函数: 返佣-代理返佣计算入口
--v1.01  2016/05/12  Leisure  未达返佣梯度，依然需要计算代理承担费用
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
		/*
		raise info '取得玩家返水';
		SELECT gamebox_rebate_rakeback_map(stTime, edTime) INTO rakebackhash;
		*/
		--取得当前站点.
		SELECT gamebox_current_site() INTO sid;
		--取得系统关于各种承担比例参数.
		SELECT gamebox_sys_param('apportionSetting') INTO syshash;
		--取得当前返佣梯度设置信息.
		SELECT gamebox_rebate_api_grads() INTO gradshash;
		--取得代理默认返佣方案
		SELECT gamebox_rebate_agent_default_set() INTO agenthash;
		--判断各个代理满足的返佣梯度.
		raise info '判断各个代理满足的返佣梯度';
		SELECT gamebox_rebate_agent_check(gradshash, agenthash, stTime, edTime, flag) INTO checkhash;

		--IF checkhash IS NOT NULL THEN
		--COMMENT BY Leisure 2016-05-06 对于当期返佣为0的，需要计算承担费用

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

drop function IF EXISTS gamebox_rebate_agent_check(hstore, hstore, TIMESTAMP, TIMESTAMP, TEXT);
create or replace function gamebox_rebate_agent_check(
	gradshash 	hstore,
	agenthash 	hstore,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	flag 	TEXT
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 计算各个代理适用的返佣梯度
--v1.01  2016/05/12  Leisure  修改计算有效玩家函数的参数
--v1.02  2016/10/03  Leisure  统计时间由bet_time改为payout_time
*/
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
		   --v1.03  2016/10/03  Leisure
		   --AND pgo.create_time >= start_time
		   --AND pgo.create_time < end_time
		   AND pgo.payout_time >= start_time
		   AND pgo.payout_time < end_time
		   AND pgo.order_state = settle_state
		   AND pgo.is_profit_loss = TRUE
		 GROUP BY ua."id", ua.username
	LOOP

		profit_amount = rec.profit_amount;	--代理盈亏总额
		--如果代理盈亏总额为正时，才有返佣.
		IF profit_amount <= 0 THEN
			CONTINUE;
		END IF;

		pre_valid_value 	= 0.00;	-- 重置变量.
		pre_profit 			  = 0.00;
		pre_player_num 		= 0;
		effective_trade_amount = rec.effective_trade_amount;	--代理有效交易量
		raise info '代理id:%, 代理名称:%, 代理有效值:%, 盈亏总额:%, 玩家数:%', rec.id, rec.username, effective_trade_amount, profit_amount, player_num;

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
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-玩家API返佣
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/10/03  Leisure  统计时间由bet_time改为payout_time；
                              改用returning返回键值
*/
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
		               COALESCE(SUM(pgo.effective_trade_amount), 0.00) 	as effective_trade_amount,
		               COALESCE(-SUM(pgo.profit_amount), 0.00) 	as profit_amount
		          FROM player_game_order pgo
		         --v1.02  2016/10/03  Leisure
		         --WHERE pgo.bet_time >= start_time
		         --  AND pgo.bet_time < end_time
		         WHERE pgo.payout_time >= start_time
		           AND pgo.payout_time < end_time
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
  **/
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
			) RETURNING id INTO tmp;
			--v1.02  2016/10/03  Leisure
			--SELECT currval(pg_get_serial_sequence('rebate_api', 'id')) INTO tmp;
			raise info '返拥API.键值:%', tmp;
		ELSEIF flag = 'N' THEN
			INSERT INTO rebate_api_nosettled (
				rebate_bill_nosettled_id, player_id, api_id, api_type_id, game_type,
				rebate_total, effective_transaction, profit_loss
			) VALUES(
				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,
				rebate_value, rec.effective_transaction, rec.profit_loss
			) RETURNING id INTO tmp;
			--v1.02  2016/10/03  Leisure
			--SELECT currval(pg_get_serial_sequence('rebate_api_nosettled', 'id')) INTO tmp;
			raise info '返拥API.键值:%',tmp;
		END IF;

	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, gradshash hstore, checkhash hstore, mainhash hstore, flag TEXT)
IS 'Lins-返佣-玩家API返佣';

drop function if exists gamebox_rebate_expense_gather(INT, TIMESTAMP, TIMESTAMP, TEXT, TEXT, TEXT);
create or replace function gamebox_rebate_expense_gather(
	bill_id 		INT,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	row_split 		TEXT,
	col_split 		TEXT,
	flag 			TEXT
) returns hstore as $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-分摊费用与返佣统计
--v1.01  2016/05/12  Leisure  对于有优惠而没有返佣的玩家，需要计算其最终佣金（佣金-费用）
--v1.02  2016/10/03  Leisure  分摊费用条件更新；时间由create_time改为completion_time
*/
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
	                        0.00	as effective_transaction,
	                        0.00	as profit_loss
	                   FROM player_transaction
	                  WHERE status = ''success''
	                    --v1.02  2016/10/03  Leisure
	                    --AND (fund_type in (''backwater'', ''refund_fee'', ''favourable'', ''recommend'') OR
	                    --    (fund_type = ''artificial_deposit'' AND transaction_type = ''favorable''))
	                    --AND create_time >= ''' || start_time || '''
	                    --AND create_time < ''' || end_time || '''
	                    AND transaction_type IN (''favorable'', ''recommend'', ''backwater'')
	                    AND completion_time >= ''' || start_time || '''
	                    AND completion_time < ''' || end_time || '''
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