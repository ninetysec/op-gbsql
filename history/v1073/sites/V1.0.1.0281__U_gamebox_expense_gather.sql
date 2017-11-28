-- auto gen by bruce 2016-10-09 20:05:58
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
--v1.04  2016/10/08  Leisure  更新分摊费用的计算，改为returning防并发
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
	n_count		INT:=0;
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

	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次删除记录数 %', n_count;
	rtn = rtn||'|执行完毕,删除记录数: '||n_count||' 条||';

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
							 FROM player_game_order
							--WHERE bet_time >= start_time::TIMESTAMP
							--	AND bet_time < end_time::TIMESTAMP
							WHERE payout_time >= start_time::TIMESTAMP
							  AND payout_time < end_time::TIMESTAMP
								AND order_state = 'settle'
								AND is_profit_loss = TRUE --v1.03  2016/06/13  Leisure
							GROUP BY player_id, api_id, api_type_id, game_type
							) p, v_sys_user_tier u
	WHERE p.player_id = u.id;

	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次插入数据量 %', n_count;
	rtn = rtn||'|执行完毕,新增记录数: '||n_count||' 条||';

	return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-玩家报表';

drop function if exists gamebox_rebate_player(hstore, hstore, hstore, int, text, text, TEXT);
create or replace function gamebox_rebate_player(
    syshash 		hstore,
    expense_map 	hstore,
    rakeback_map 	hstore,
    bill_id 		INT,
    row_split 		text,
    col_split 		text,
    flag 			TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-玩家返佣
--v1.01  2016/10/03  Leisure  更新分摊费用的计算，favourable统一改为favorable
--v1.02  2016/10/08  Leisure  更新分摊费用的计算，改为returning防并发
*/
DECLARE

	keys 		text[];
	keyname 	text:='';
	val 		text:='';
	--vals 		text[];

	user_id 	INT:=-1;

	mhash 		hstore;
	--param 		text:='';
	--money 		float:=0.00;

	player_num 	int:=0;					-- 玩家数
	profit_amount float:=0.00;			-- 盈亏总和
	effective_trade_amount float:=0.00;	-- 有效交易量

	agent_id 	int;
	agent_name 	text:='';

	rebate 		float:=0.00;	-- 返佣
	backwater 	float:=0.00;			-- 返水费用
	backwater_apportion 	float:=0.00;-- 返水分摊费用

	favorable 	float:=0.00;			-- 优惠费用
	recommend 	float:=0.00;			-- 推荐费用
	--artificial_depositfavorable		float:=0.00;-- 手动存入优惠

	retio 		float;			-- 占成比
	favorable_apportion 	float:=0.00;-- 优惠分摊费用
	refund_fee 	float:=0.00;			-- 返手续费费用
	refund_fee_apportion 	float:=0.00;-- 返手续费分摊费用
	apportion 	FLOAT:=0.00;	-- 分摊总费用

	deposit 		float:=0.00;	-- 存款
	--company_deposit float:=0.00;	-- 存款:公司入款
	--online_deposit	float:=0.00;	-- 存款:线上支付
	--artificial_deposit float:=0.00; -- 存款:手动存款

	withdrawal 		float:=0.00;	-- 取款
	--artificial_withdraw	float:=0.00;-- 取款:手动取款
	--player_withdraw	float:=0.00;	-- 取款:玩家取款

	--rebate_keys		text[];
	--rebate_keyname  text:='';
	--rebate_val		text:='';
	--rebate_vals 	text[];
	--rebate_hash		hstore;
	--max_rebate		float:=0.00;

	--tmp 		text:='';
	return_id 		text:='';

BEGIN
	-- raise info 'expense_map = %', expense_map;
	IF expense_map is null THEN
		RETURN;
	END IF;

	keys = akeys(expense_map);
	-- raise info '---- keys = %', keys;

	FOR i in 1..array_length(keys, 1)

	LOOP
		keyname = keys[i];

		user_id = keyname::INT;
		val = expense_map->keyname;
		--转换成hstore数据格式:key1=>value1,key2=>value2
		val = replace(val, row_split, ',');
		val = replace(val, col_split, '=>');
		--raise info 'val=%',val;
		SELECT val INTO mhash;

		--代理id
		agent_id = -1;
		IF exist(mhash, 'agent_id') THEN
			agent_id = (mhash->'agent_id')::INT;
		END IF;

		--代理名称
		agent_name = '';
		IF exist(mhash, 'agent_name') THEN
			agent_name = mhash->'agent_name';
		END IF;

		--返佣
		rebate = 0.00;
		IF exist(mhash, 'rebate') THEN
			rebate = (mhash->'rebate')::float;
		END IF;

		--backwater = 0.00;
		-- raise info 'rakeback_map = %', rakeback_map;
		/*
		IF isexists(rakeback_map, keyname) THEN
			backwater = (rakeback_map->keyname)::FLOAT;
		END IF;
		*/

		backwater = 0.00;
		IF exist(mhash, 'backwater') THEN
			backwater = (mhash->'backwater')::float;
		END IF;

		-- raise info 'backwater = %', backwater;

		refund_fee = 0.00;
		IF exist(mhash, 'refund_fee') THEN
			refund_fee = (mhash->'refund_fee')::float;
		END IF;

		favorable = 0.00;
		IF exist(mhash, 'favorable') THEN
			favorable = (mhash->'favorable')::float;
		END IF;

		recommend = 0.00;
		IF exist(mhash, 'recommend') THEN
			recommend = (mhash->'recommend')::float;
		END IF;

		/*
		artificial_depositfavorable = 0.00;
		IF exist(mhash, 'artificial_depositfavorable') THEN
			artificial_depositfavorable = (mhash->'artificial_depositfavorable')::float;
		END IF;
		favorable = favorable + artificial_depositfavorable;
		*/

		/*
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
		*/
		/*
		artificial_withdraw = 0.00;
		IF exist(mhash, 'artificial_withdraw') THEN
			artificial_withdraw = (mhash->'artificial_withdraw')::float;
		END IF;
		player_withdraw = 0.00;
		IF exist(mhash, 'player_withdraw') THEN
			player_withdraw = (mhash->'player_withdraw')::float;
		END IF;
		withdraw = artificial_withdraw + player_withdraw;
		*/

		deposit = 0.00;
		IF exist(mhash, 'deposit') THEN
			refund_fee = (mhash->'deposit')::float;
		END IF;

		recommend = 0.00;
		IF exist(mhash, 'withdrawal') THEN
			withdrawal = (mhash->'withdrawal')::float;
		END IF;

		--有效交易量
		effective_trade_amount = 0.00;
		IF exist(mhash, 'effective_transaction') THEN
			effective_trade_amount = (mhash->'effective_transaction')::float;
		END IF;

		--盈亏总和
		profit_amount = 0.00;
		IF exist(mhash, 'profit_loss') THEN
			profit_amount = (mhash->'profit_loss')::float;
		END IF;

		/*
			计算各种优惠.
			1、返水承担费用 = 赠送给体系下玩家的返水 * 代理承担比例；
			2、优惠承担费用 = 赠送给体系下玩家的优惠 * 代理承担比例；
			3、返还手续费承担费用 = 返还给体系下玩家的手续费 * 代理承担比例；
		*/
		--优惠与推荐分摊
		IF isexists(syshash, 'agent.preferential.percent') THEN
			retio = (syshash->'agent.preferential.percent')::float;
			-- raise info '优惠与推荐分摊比例:%', retio;
			favorable_apportion = (favorable + recommend) * retio / 100;
		ELSE
			favorable_apportion = 0;
		END IF;
		--返水分摊
		IF isexists(syshash, 'agent.rakeback.percent') THEN
			retio = (syshash->'agent.rakeback.percent')::float;
			-- raise info '返水分摊比例:%', retio;
			backwater_apportion = backwater * retio / 100;
		ELSE
			backwater_apportion = 0;
		END IF;
		--返手续费分摊
		IF isexists(syshash, 'agent.poundage.percent') THEN
			retio = (syshash->'agent.poundage.percent')::float;
			-- raise info '手续费优惠分摊比例:%', retio;
			refund_fee_apportion = refund_fee * retio / 100;
		ELSE
			refund_fee_apportion = 0;
		END IF;

		--分摊总费用
		apportion = backwater_apportion + refund_fee_apportion + favorable_apportion;
		-- raise info '-------- 分摊总费用 = %', apportion;

		--代理佣金 = 各API佣金总和 - 优惠 - 返水 - 返手续费.
		rebate = rebate - apportion;

		IF flag = 'Y' THEN
			INSERT INTO rebate_player(
				rebate_bill_id, agent_id, user_id,
				effective_transaction, profit_loss, rebate_total, rakeback,
				preferential_value, recommend, refund_fee, apportion,
				deposit_amount, withdrawal_amount
			) VALUES (
				bill_id, agent_id, user_id,
				effective_trade_amount, profit_amount, rebate, backwater,
				favorable, recommend, refund_fee, apportion,
				deposit, withdraw
			) RETURNING id INTO return_id;
			--SELECT currval(pg_get_serial_sequence('rebate_player', 'id')) INTO tmp;
			-- raise info 'Y返佣代理表的键值:%', tmp;
		ELSEIF flag='N' THEN
			INSERT INTO rebate_player_nosettled (
				rebate_bill_nosettled_id, agent_id, player_id,
				effective_transaction, profit_loss, rebate_total, rakeback,
				preferential_value, recommend, refund_fee, apportion,
				deposit_amount, withdrawal_amount
			) VALUES (
				bill_id, agent_id, user_id,
				effective_trade_amount, profit_amount, rebate, backwater,
				favorable, recommend, refund_fee, apportion,
				deposit, withdrawal
			) RETURNING id INTO return_id;
			--SELECT currval(pg_get_serial_sequence('rebate_player_nosettled', 'id')) INTO tmp;

			raise info 'N返佣代理表的键值:%',return_id;
		END IF;
	END LOOP;
	raise info '开始统计代理返佣.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_player(syshash hstore, expense_map hstore, rakeback_map hstore, bill_id INT, row_split text, col_split text, flag TEXT)
IS 'Lins-返佣-玩家返佣';