-- auto gen by admin 2016-04-22 21:59:01
----------------------------------------------------------------
---------------------------- common ----------------------------
----------------------------------------------------------------
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
	max_rebate 			float:=0.00;

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
		settle_state:='pending_settle';
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
			AND pgo.create_time <= end_time
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
					max_rebate		= (hash->'max_rebate')::float;		-- 返佣上限
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

/**
 * 计算返佣
 * @author 	Lins
 * @date 	2015.11.13
 * @param 	rebate_grads_map 	各个API的返佣数据hash(KEY-VALUE)
 * @param 	agent_check_map 	各个代理梯度检查hash(KEY-VALUE)
 * @param 	agent_id 			运营商各个API的占成数据hash(KEY-VALUE)
 * @param 	api_id 				当前代理统计数据JSON格式
 * @param 	game_type 			游戏二级类型
 * @param 	profit_amount 		交易盈亏金额
 * @param 	operation_occupy 	运营商占成
 * @return 	返回float类型.
 */
drop function if EXISTS gamebox_rebate_calculator(hstore, hstore, INT, INT, TEXT, FLOAT, FLOAT);
create or replace function gamebox_rebate_calculator(
	rebate_grads_map 	hstore,
	agent_check_map 	hstore,
	agent_id 			INT,
	api_id 				INT,
	game_type 			TEXT,
	profit_amount 		FLOAT,
	operation_occupy 	FLOAT
) returns FLOAT as $$

DECLARE
	keys 		text[];
	subkeys 	text[];
	keyname 	text:='';
	val 		text:='';--临时
	vals 		text[];
	hash 		hstore;	--临时Hstore

	rebate_value 	float:=0.00;--返佣值.
	ratio 			float:=0.00;--占成
	max_rebate 		float:=0.00;--最大返佣上限

	rebate_id 	text;	--梯度ID.
	api 		TEXT; 	--API
	agent 		text;	--代理ID
	col_split 	TEXT:='_';

BEGIN
	api = (api_id::TEXT);
	agent = (agent_id::TEXT);
	raise info '---- api = %, agent = %', api, agent;

	IF isexists(agent_check_map,agent) = false THEN --梯度不满足时不返佣
		RETURN 0.00;
	ELSEIF profit_amount <= 0 THEN --盈亏为负时,不返佣
		RETURN 0.00;
	END IF;

	rebate_id = agent_check_map->agent;
	-- raise info '---- rebate_id1 = %', rebate_id;
	vals = regexp_split_to_array(rebate_id, '_');
	-- raise info '---- vals = %', vals;

	rebate_id = vals[1]||'_'||vals[2];
	-- raise info '---- rebate_id2 = %', rebate_id;
	keys = akeys(rebate_grads_map);
	-- raise info '---- keys = %', keys;

	FOR i IN 1..array_length(keys, 1)
	LOOP
		-- raise info '---------- LOOP S ----------';
		keyname = keys[i];
		subkeys = regexp_split_to_array(keyname, '_');
		-- raise info '---- keyname = %, subkeys = %, position = %', keyname, subkeys, position(rebate_id in keyname);
		IF position(rebate_id in keyname) = 1 AND subkeys[3] = api AND rtrim(ltrim(subkeys[4])) = game_type THEN
			val = rebate_grads_map->keyname;
			-- 判断如果存在多条记录，取第一条.
			vals = regexp_split_to_array(val, '\^\&\^');
			-- raise info '---- val = %, vals = %', val, vals;
			IF array_length(vals, 1) > 1 THEN
				val = vals[1];
			END IF;
			-- raise info '---- val = %', val;

			select * from strToHash(val) into hash;
			-- raise info '---- hash = %', hash;
			ratio = (hash->'ratio')::float;--占成数
			raise info '--代理的佣金比例(ratio) = %', ratio;

			--各个API运营商占成.
			operation_occupy = coalesce(operation_occupy, 0);
			--各API各分类佣金总和 = [各API各分类盈亏总和-(各API各分类盈亏总和*运营商占成）]*代理的佣金比例；
			rebate_value = (profit_amount - operation_occupy) * ratio / 100;
		END IF;

		raise info '---------- LOOP E ----------';
	END LOOP;
	RETURN rebate_value;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_calculator(rebate_grads_map hstore, agent_check_map hstore, agent_id INT, api_id INT, game_type TEXT, profit_amount FLOAT, operation_occupy FLOAT)
IS 'Lins-返佣-计算';

----------------------------------------------------------------
---------------------------- rebate ----------------------------
----------------------------------------------------------------
/**
 * 根据返佣周期统计各个API,各个玩家的返佣数据.
 * @author 	Lins
 * @date 	2015.11.10
 * @param 	name 		返佣周期名称.
 * @param 	startTime 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	endTime 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	url 		运营商库的dblink 格式数据(host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres)
 * @param 	flag 		出账标示:Y-已出账, N-未出账
 */
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

BEGIN
    stTime = startTime::TIMESTAMP;
    edTime = endTime::TIMESTAMP;
    raise info '开始统计第( % )期的返佣,周期( %-% )', name, startTime, endTime;
    raise info '取得玩家返水';
    -- SELECT gamebox_rakeback_map(stTime, edTime, url, 'PLAYER') INTO rakebackhash;
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

    IF checkhash IS NOT NULL THEN

    	--取得各API的运营商占成.
	    raise info '取得运营商各API占成';
	    SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type, flag) INTO mainhash;

	    --先插入返佣总记录并取得键值.
	    raise info '返佣rebate_bill新增记录';
	    SELECT gamebox_rebate_bill(name, stTime, edTime, rebate_bill_id, 'I', flag) INTO rebate_bill_id;

	    raise info '计算各玩家API返佣';
	    perform gamebox_rebate_api(rebate_bill_id, stTime, edTime, gradshash, checkhash, mainhash, flag);

	    raise info '收集各玩家的分摊费用';
	    SELECT gamebox_rebate_expense_gather(rebate_bill_id, rakebackhash, stTime, edTime, row_split, col_split, flag) INTO hash;

	    raise info '统计各玩家返佣';
	    perform gamebox_rebate_player(syshash, hash, rakebackhash, gradshash, rebate_bill_id, row_split, col_split, flag);

	    raise info '开始统计代理返佣';
	    perform gamebox_rebate_agent(rebate_bill_id,flag, checkhash);

	    raise info '更新返佣总表';
	    perform gamebox_rebate_bill(name, stTime, edTime, rebate_bill_id, 'U', flag);

	END IF;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate(name text, startTime text, endTime text, url text, flag text)
IS 'Lins-返佣-代理返佣计算入口';

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
  		settle_state:='pending_settle';
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
 * Fei-计算代理返佣
 * @author  Fei
 * @param 	bill_id 	返佣ID
 * @param 	flag 		出账标识: Y-已出账, N-未出账
 */
drop function if exists gamebox_rebate_agent(INT,TEXT, hstore);
create or replace function gamebox_rebate_agent(
	bill_id 	INT,
	flag 		TEXT,
	checkbash	hstore
) returns void as $$

DECLARE
	rec 		record;
	pending 	TEXT:='pending_lssuing';
	rebate 		FLOAT:=0.00;	-- 代理返佣
	max_rebate	FLOAT:=0.00;	-- 返佣上限
	limithash 	hstore;			-- 返佣上限
	agent_id	TEXT;
	subkeys		TEXT[];
	subkey 		TEXT;
	player_num	INT=0;

BEGIN
	IF flag = 'Y' THEN

		FOR rec IN
		 	SELECT p.rebate_bill_id,
		 		   p.agent_id,
		 		   u.username					agent_name,
		 		   COUNT(distinct p.user_id)	effective_player,
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
		 	SELECT gamebox_rebate_limit(checkbash) INTO limithash;

		 	agent_id:=rec.agent_id::TEXT;
		 	-- raise info '---- agent_id = %', agent_id;
		 	IF isexists(limithash, agent_id) THEN
		 		subkey = limithash->agent_id;
		 		subkeys = regexp_split_to_array(subkey, '_');
				max_rebate = subkeys[1];
				player_num = subkeys[2]::INT;
			END IF;
		 	-- raise info '---- max_rebate = %, player_num = %', max_rebate, player_num;

		 	rebate = rec.rebate_total;
		 	-- raise info '---- rebate1 = %', rebate;
		 	IF max_rebate != 0.0 AND rebate > max_rebate THEN
		 		rebate = max_rebate;
		 	END IF;
		 	-- raise info '---- rebate2 = %', rebate;
		 	INSERT INTO rebate_agent(
				rebate_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
				rakeback, rebate_total, rebate_actual, refund_fee, recommend, preferential_value,
				settlement_state, apportion, deposit_amount, withdrawal_amount
			) VALUES (
				bill_id, rec.agent_id, rec.agent_name, player_num, rec.effective_transaction, rec.profit_loss,
				rec.rakeback, rebate, rebate, rec.refund_fee, rec.recommend, rec.preferential_value,
				pending, rec.apportion, rec.deposit_amount, rec.withdrawal_amount
			);

		END LOOP;

	ELSEIF flag='N' THEN

		 FOR rec IN
			SELECT p.rebate_bill_nosettled_id,
				   p.agent_id,
				   u.username					agent_name,
				   COUNT(distinct p.player_id)	effective_player,
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

			SELECT gamebox_rebate_limit(checkbash) INTO limithash;

		 	agent_id:=rec.agent_id::TEXT;
		 	IF isexists(limithash, agent_id) THEN
				subkey = limithash->agent_id;
		 		subkeys = regexp_split_to_array(subkey, '_');
				max_rebate = subkeys[1];
				player_num = subkeys[2]::INT;
			END IF;

		 	rebate = rec.rebate_total;
		 	IF max_rebate != 0.0 AND rebate > max_rebate THEN
		 		rebate = max_rebate;
		 	END IF;
		 	INSERT INTO rebate_agent_nosettled (
				rebate_bill_nosettled_id, agent_id, agent_name, effective_player, effective_transaction,
				profit_loss, rakeback, rebate_total, refund_fee, recommend, preferential_value,
				apportion, deposit_amount, withdrawal_amount
			) VALUES (
				bill_id, rec.agent_id, rec.agent_name, player_num, rec.effective_transaction,
				rec.profit_loss, rec.rakeback, rebate, rec.refund_fee, rec.recommend, rec.preferential_value,
				rec.apportion, rec.deposit_amount, rec.withdrawal_amount
			);

		END LOOP;

	END IF;
    raise info '代理返佣.完成';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_agent(bill_id INT, flag TEXT, checkbash hstore)
IS 'Lins-返佣-代理返佣计算';

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
	category='AGENT';
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
 * 分摊费用与返佣统计
 * @author 	Lins
 * @date 	2015.11.13
 * @param  	bill_id 		返佣主表键值
 * @param 	rakebackhash
 * @param 	start_time 		开始时间
 * @param 	end_time		结束时间
 * @param 	row_split
 * @param 	col_split 		列分隔符
 * @return 	返回hstore类型, 以代理ID为KEY值.各种费用按一定格式组成VALUE。
 */
drop function if exists gamebox_rebate_expense_gather(int, hstore, TIMESTAMP, TIMESTAMP, text, text);
drop function if exists gamebox_rebate_expense_gather(int, hstore, TIMESTAMP, TIMESTAMP, text, text, text);
create or replace function gamebox_rebate_expense_gather(
	bill_id 		int,
	rakebackhash 	hstore,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	row_split 		text,
	col_split 		text,
	flag 			TEXT
) returns hstore as $$

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

	eff_transaction 	FLOAT:=0.00;
BEGIN

	SELECT gamebox_expense_gather(start_time, end_time, row_split, col_split) INTO hash;

	IF flag = 'N' THEN
		tbl = 'rebate_api_nosettled';
		tbl_id = 'rebate_bill_nosettled_id';
	END IF;

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
	--统计各代理返佣.
	FOR rec IN EXECUTE sqld

		LOOP
			user_id 		= rec.player_id::text;
			agent_id 		= rec.owner_id;
			agent_name 		= rec.username;
			money 			= rec.rebate_total;
			loss 			= rec.profit_loss;
			eff_transaction = rec.effective_transaction;

			IF isexists(hash, user_id) THEN
				param = hash->user_id;
				param = param||row_split||'rebate'||col_split||money::text;
				param = param||row_split||'profit_loss'||col_split||loss::text;
				param = param||row_split||'effective_transaction'||col_split||eff_transaction::text;
				param = param||row_split||'agent_name'||col_split||agent_name;
				param = param||row_split||'agent_id'||col_split||agent_id::text;
			ELSE
				param='rebate'||col_split||money::text;
				param = param||row_split||'profit_loss'||col_split||loss::text;
				param = param||row_split||'effective_transaction'||col_split||eff_transaction::text;
				param = param||row_split||'agent_name'||col_split||agent_name;
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

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_expense_gather(bill_id int, rakebackhash hstore, startTime TIMESTAMP, endTime TIMESTAMP, row_split_char text, col_split_char text, flag TEXT)
IS 'Lins-返佣-分摊费用与返佣统计';

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
 * 根据统计周期算出运营商的占成-入口.
 * @param 	url 		运营库dblink URL.
 * @param 	site_id 	站点ID
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	category 	占成类别.category: AGENT、TOPAGENT、SITE指明各种占成类型统计
 * @param 	is_max 		是否取最大梯度
 */
drop function if EXISTS gamebox_operations_occupy(TEXT, INT, TIMESTAMP, TIMESTAMP, TEXT, BOOLEAN, INT);
drop function if EXISTS gamebox_operations_occupy(TEXT, INT, TIMESTAMP, TIMESTAMP, TEXT, BOOLEAN, INT, TEXT);
create or replace function gamebox_operations_occupy(
	url 		text,
	site_id 	int,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	category 	TEXT,
	is_max 		BOOLEAN,
	key 		INT,
	flag 		TEXT
) returns hstore as $$

DECLARE
	hashs hstore[];
	hash hstore;

BEGIN
	--取得当前站点的包网方案
	SELECT * FROM dblink(url, 'SELECT gamebox_contract('||site_id||', '||is_max||')') as a(hash hstore[]) INTO hashs;
  	SELECT gamebox_operations_occupy(hashs, start_time, end_time, category, key, flag) INTO hash;
	--raise info '%', hash;
	return hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operations_occupy(url text, site_id int, start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, is_max BOOLEAN, key INT, flag TEXT)
IS 'Lins-运营商占成-入口';

/**
 * 根据统计周期算出运营商的占成.
 * @param 	hashs 		包网方案信息
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	category 	占成类别.category: AGENT、TOPAGENT、SITE指明各种占成类型统计
 * @param 	key_type 	指明统计时KEY的细度.1.站点.2.代理或总代.3.玩家.4.玩家+API, 5.API.默认是2.
 */
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

		keyname = rec.owner_id::TEXT;
		IF key_type = 3 THEN
			keyname = (rec.id::TEXT);
		ELSIF key_type = 4 THEN
			keyname = (rec.id::TEXT);
			keyname = keyname||col_split||(rec.api_id::TEXT);
			keyname = keyname||col_split||(rec.game_type::TEXT);
		ELSIF key_type = 5 THEN
			keyname = rec.api_id::TEXT;
			keyname = keyname||col_split||(rec.game_type::TEXT);
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
		settle_state = 'pending_settle';
	END IF;

	IF category = 'AGENT' THEN 	--代理
    	OPEN cur FOR
			SELECT ua."id" owner_id, pg.*
			  FROM (SELECT pgo.player_id "id",
						   pgo.api_id,
						   pgo.game_type,
						   COUNT(DISTINCT pgo.player_id)					as player_num,
						   COALESCE(SUM(-pgo.profit_amount), 0.00)			as profit_amount,
						   COALESCE(SUM(-pgo.effective_trade_amount), 0.00)	as effective_trade_amount
					  FROM player_game_order pgo
					 WHERE pgo.create_time >= start_time
					   AND pgo.create_time <= end_time
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
						   COALESCE(SUM(-pgo.effective_trade_amount), 0.00)	as effective_trade_amount
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
				   COALESCE(SUM(-pgo.effective_trade_amount), 0.00)	as effective_trade_amount
			  FROM player_game_order pgo
			 WHERE pgo.create_time >= '2016-04-01'::TIMESTAMP
			   AND pgo.create_time <= '2016-04-30'::TIMESTAMP
			   AND pgo.order_state = settle_state
			   AND pgo.is_profit_loss = TRUE
			 GROUP BY pgo.api_id, pgo.game_type;
	END IF;

	-- raise info '------ cur = %', cur;
	RETURN cur;
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, flag TEXT)
IS 'Lins-运营商占成-API的下单信息';

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