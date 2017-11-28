-- auto gen by admin 2016-04-22 11:47:39
----------------------------------------------------------------
---------------------------- common ----------------------------
----------------------------------------------------------------
/**
 * 计算玩家一天的有效交易量
 * @author 	Fei
 * @date 	2016-04-12
 * @param	back_time   统计日期
 * @return 	hstore
 */
DROP FUNCTION IF EXISTS gamebox_effective_volume(TIMESTAMP);
CREATE OR REPLACE FUNCTION gamebox_effective_volume(
	back_time  TIMESTAMP
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
         WHERE to_char(pgo.create_time, 'yyyy-MM-dd') = to_char(back_time, 'yyyy-MM-dd')
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
COMMENT ON FUNCTION gamebox_effective_volume(back_time TIMESTAMP)
IS 'Fei-计算玩家一天的有效交易量';

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
			  AND rp.settlement_time <= $2
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

/**
 * 计算有效玩家数
 */
drop function if exists gamebox_valid_player_num(TIMESTAMP, TIMESTAMP, FLOAT);
create or replace function gamebox_valid_player_num(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	valid_value FLOAT
) returns INT as $$

DECLARE
	player_num 	INT:=0;

BEGIN
	SELECT COUNT(1)
	  FROM (SELECT pgo.player_id, SUM(pgo.effective_trade_amount) effeTa
		  	  FROM player_game_order pgo
		 	 WHERE pgo.create_time >= start_time
		 	   AND pgo.create_time < end_time
		 	   AND pgo.order_state = 'settle'
			   AND pgo.is_profit_loss = TRUE
		 	 GROUP BY pgo.player_id) pn
	 WHERE pn.effeTa >= valid_value INTO player_num;
	RETURN player_num;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_valid_player_num(start_time TIMESTAMP, end_time TIMESTAMP, valid_value FLOAT)
IS 'Fei-计算有效玩家数';

/**
 * 计算各个代理适用的返佣梯度.
 * @author 	Lins
 * @date 	2015.11.10
 * @return 	返回float类型，返水值.
 */
drop function IF EXISTS gamebox_rebate_agent_check(hstore, hstore, TIMESTAMP, TIMESTAMP);
create or replace function gamebox_rebate_agent_check(
	gradshash 	hstore,
	agenthash 	hstore,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP
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

BEGIN
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
			AND pgo.order_state = 'settle'
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
COMMENT ON FUNCTION gamebox_rebate_agent_check(gradshash hstore, agenthash hstore, start_time TIMESTAMP, end_time TIMESTAMP)
IS '计算各个代理适用的返佣梯度';

----------------------------------------------------------------
--------------------------- rakeback ---------------------------
----------------------------------------------------------------

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
    SELECT gamebox_rebate_agent_check(gradshash, agenthash, stTime, edTime) INTO checkhash;

    IF checkhash IS NOT NULL THEN

    	--取得各API的运营商占成.
	    raise info '取得运营商各API占成';
	    SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type) INTO mainhash;

	    --先插入返佣总记录并取得键值.
	    raise info '返佣rebate_bill新增记录';
	    SELECT gamebox_rebate_bill(name, stTime, edTime, rebate_bill_id, 'I', flag) INTO rebate_bill_id;

	    raise info '计算各玩家API返佣';
	    perform gamebox_rebate_api(rebate_bill_id, stTime, edTime, gradshash, checkhash, mainhash, flag);

	    raise info '收集各玩家的分摊费用';
	    SELECT gamebox_rebate_expense_gather(rebate_bill_id, rakebackhash, stTime, edTime, row_split, col_split) INTO hash;

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

BEGIN
  	raise info '计算各API各代理的盈亏总和';
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
					AND pgo.order_state = 'settle'
					AND pgo.is_profit_loss = TRUE
				  GROUP BY pgo.player_id, pgo.api_id, pgo.api_type_id, pgo.game_type) po
		   LEFT JOIN sys_user su ON po.player_id = su."id"
		   LEFT JOIN user_player up ON po.player_id = up."id"
		   LEFT JOIN user_agent ua ON su.owner_id = ua."id"
		  WHERE su.user_type = '24'

	LOOP
		--检查当前代理是否满足返佣梯度.
		IF isexists(checkhash, (rec.agent_id)::text) = false THEN
			CONTINUE;
		END IF;

		raise info '取得各API各分类佣金总和';
		key_name = rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
		-- raise info 'key_name = %', key_name;
		operation_occupy = (mainhash->key_name)::FLOAT;
		operation_occupy = coalesce(operation_occupy, 0);
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
 * Fei-计算代理梯度的返佣上限.
 * @author 	Fei
 * @date 	2015.11.10
 * @return 	返回float类型，返水值.
 */
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
	            limithash = (SELECT (keyname||'=>'||keyvalue'_'||subkeys[3])::hstore)||limithash;
	        END IF;

		END IF;

	END LOOP;
	RETURN limithash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_limit(checkhash hstore)
IS 'Fei-计算代理梯度的返佣上限.';

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
		 	raise info '---- max_rebate = %, player_num = %', max_rebate, player_num;

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
				rec.profit_loss, rec.rakeback, rebate, rebate, rec.refund_fee, rec.recommend, rec.preferential_value,
				rec.apportion, rec.deposit_amount, rec.withdrawal_amount
			);

		END LOOP;

	END IF;
    raise info '代理返佣.完成';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_agent(bill_id INT, flag TEXT, checkbash hstore)
IS 'Lins-返佣-代理返佣计算';

----------------------------------------------------------------
------------------- f_player_recommend_award -------------------
----------------------------------------------------------------
-- 推荐奖励计划任务
DROP FUNCTION IF EXISTS f_player_recommend_award(VARCHAR, VARCHAR);
/**
 * 玩家推荐奖励存储函数
 * @author: Fly
 * @date: 2015-12-18
 */
CREATE OR REPLACE FUNCTION f_player_recommend_award (
	siteCode VARCHAR,		-- 站点代码
	orderType VARCHAR		-- 订单类型: 01-充值, 02-优惠, 03-游戏API, 04-返水, 05-返佣, 06-玩家取款, 07-代理提现, 08-转账
)
	RETURNS INTEGER AS $BODY$
DECLARE
	rec record;
	-- 单次奖励
	singleReward BOOLEAN:= (SELECT active FROM sys_param WHERE param_type = 'recommended' AND param_code = 'reward');
	-- 奖励方式: 1-奖励双方,2-奖励推荐人,3-奖励被推荐人
	rewardWay INTEGER:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'reward');
	-- 单次奖励存款金额
	deposit NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'reward.theWay');
	-- 奖励金额
	rewardAmount NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'reward.money');
	-- 单次奖励优惠稽核倍数
	rewardMultiple NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'audit');
	-- 优惠稽核点
	rewardPoint NUMERIC:= (rewardAmount * rewardMultiple);

	br record;
	-- 推荐红利
	bonusReward BOOLEAN:= (SELECT active FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus');
	-- 推荐红利有效玩家交易量
	effeTrade NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus.trading');
	-- 红利上限
	toplimit NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus.bonusMax');
	-- 奖励金额
	bonusAmount NUMERIC:=0.0;
	-- 优惠稽核点
	bonusPoint NUMERIC:=0.0;

	orderNo 	VARCHAR:='';
	transType 	VARCHAR:='recommend';		-- 交易类型:推荐
	transStatus VARCHAR:='success';			-- 交易状态:待处理
	fundType 	VARCHAR:='recommend';		-- 资金类型:推荐
	single 		VARCHAR:='single_reward'; 	-- 单次奖励
	bonus 		VARCHAR:='bonus_awards';	-- 推荐红利
	referee 	VARCHAR:='2';				-- 推荐人
	referen 	VARCHAR:='3';				-- 被推荐人
BEGIN
	IF singleReward THEN	-- 单次奖励
		FOR rec IN
			SELECT * FROM (
				/* 去除已奖励的玩家 */
				SELECT up."id", up.recommend_user_id recommend_id, su.username recommend_name
				  FROM user_player up
				 INNER JOIN sys_user su ON up."recommend_user_id" = su."id"
				 WHERE su.user_type = '24'
				   AND up.recommend_user_id IS NOT NULL
				   AND up."id" NOT IN (
					 	SELECT DISTINCT recommend_user_id FROM player_recommend_award
					 	 WHERE reward_mode = 'single_reward'
						   AND user_id IN (SELECT DISTINCT(recommend_user_id) FROM user_player WHERE recommend_user_id IS NOT NULL)
				   )
			) tr INNER JOIN (
				/* 被推荐人满足交易量 */
				SELECT su."id" berecommend_id, su.username berecommend_name, ep.trade_amount
				  FROM (SELECT *
				  		  FROM (SELECT player_id, SUM(transaction_money) trade_amount
							      FROM player_transaction
							     WHERE transaction_type = 'deposit'
							       AND status = 'success'
							     GROUP BY player_id) pt
				  		 WHERE trade_amount >= deposit
					   ) ep
				  LEFT JOIN sys_user su ON ep.player_id = su."id"
				 WHERE su.user_type = '24'
			) ta ON tr."id" = ta.berecommend_id

			LOOP

				IF rewardWay = '1' THEN	-- 奖励双方
					orderNo := (SELECT f_order_no(siteCode, orderType));
					/** 奖励推荐人 */
					WITH award1 AS (
						-- 新增推荐记录数据
						INSERT INTO player_recommend_award (
							transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)
						VALUES (
							orderNo, rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '推荐')
						RETURNING id
					)
					-- 新增交易订单数据
					INSERT INTO player_transaction (
						transaction_no, create_time, transaction_type, remark, transaction_money, balance,
						status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,
						fund_type, transaction_way, transaction_data)
					VALUES (
						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id),
						transStatus,rec.recommend_id, (SELECT id FROM award1), rewardPoint, false, false,
						fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referee||'"}');
					-- 修改玩家余额
					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.recommend_id;

					/** 奖励被推荐人 */
					orderNo := (SELECT f_order_no(siteCode, orderType));
					WITH award2 AS (
						-- 新增推荐记录数据
						INSERT INTO player_recommend_award (
							transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)
						VALUES (
							orderNo, rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '被推荐')
						RETURNING id
					)
					-- 新增交易订单数据
					INSERT INTO player_transaction (
						transaction_no, create_time, transaction_type, remark, transaction_money, balance,
						status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,
						fund_type, transaction_way, transaction_data)
					VALUES (
						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.berecommend_id),
						transStatus, rec.berecommend_id, (SELECT id FROM award2), rewardPoint, false, false,
						fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referen||'"}');
					-- 修改玩家余额
					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.berecommend_id;

				ELSEIF rewardWay = '2' THEN 	-- 奖励推荐人
					orderNo := (SELECT f_order_no(siteCode, orderType));
					WITH award AS (
						-- 新增推荐记录数据
						INSERT INTO player_recommend_award (
							transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)
						VALUES (
							orderNo, rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '推荐')
						RETURNING id
					)
					-- 新增交易订单数据
					INSERT INTO player_transaction (
						transaction_no, create_time, transaction_type, remark, transaction_money, balance,
						status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,
						fund_type, transaction_way, transaction_data)
					VALUES (
						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id),
						transStatus, rec.recommend_id, (SELECT id FROM award), rewardPoint, false, false,
						fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referee||'"}');
					-- 修改玩家余额
					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.recommend_id;

				ELSEIF rewardWay = '3' THEN	-- 奖励被推荐人
					orderNo := (SELECT f_order_no(siteCode, orderType));
					WITH award AS (
						-- 新增推荐记录数据
						INSERT INTO player_recommend_award (
							transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)
						VALUES (
							orderNo, rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '被推荐')
						RETURNING id
					)
					-- 新增交易订单数据
					INSERT INTO player_transaction (
						transaction_no, create_time, transaction_type, remark, transaction_money, balance, status,
						player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,
						fund_type, transaction_way, transaction_data)
					VALUES (
						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.berecommend_id),
						transStatus, rec.berecommend_id, (SELECT id FROM award), rewardPoint, false, false,
						fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referen||'"}');
					-- 修改玩家余额
					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.berecommend_id;

				END IF;

			END LOOP;

	END IF;

	IF bonusReward THEN 	--推荐红利

		FOR rec IN
			SELECT up.recommend_user_id recommend_id,
				   su.username 			recommend_name,
				   COUNT(DISTINCT pgo.player_id) 	recommend_total,
				   SUM(pgo.effective_trade_amount) 	trade_amount
			  FROM user_player up
		 	  LEFT JOIN sys_user su ON up.recommend_user_id = su."id"
			  LEFT JOIN player_game_order pgo ON up."id" = pgo.player_id
		 	 WHERE recommend_user_id IS NOT NULL
		 	   AND to_char(pgo.create_time, 'yyyy-MM-dd') = to_char((CURRENT_DATE - INTERVAL '1 day'), 'yyyy-MM-dd')
			   AND su.user_type = '24'
			   AND pgo.is_profit_loss = TRUE
   			   AND pgo.order_state = 'settle'
		 	 GROUP BY up.recommend_user_id, su.username

		LOOP

			-- 达到有效交易量
			IF rec.trade_amount >= effeTrade THEN

				FOR br IN
					SELECT playernum, proportion
					  FROM json_to_recordset((SELECT lower(param_value) FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus.json')::json)
						AS x(id INTEGER,playernum INTEGER,proportion FLOAT)
					 ORDER BY playernum DESC

				LOOP

					-- 达到推荐人数
					IF rec.recommend_total >= br.playernum THEN

						bonusAmount := br.proportion / 100 * rec.trade_amount; -- 奖励金额
						IF bonusAmount > toplimit THEN -- 奖励金额高于红利上限取上限值
							bonusAmount := toplimit;
						END IF;

						-- 优惠稽核点	(奖励稽核 x 优惠稽核倍数)
						bonusPoint := bonusAmount * rewardPoint;

						orderNo := (SELECT f_order_no(siteCode, orderType));
						WITH award AS (
							-- 新增推荐记录数据
							INSERT INTO player_recommend_award (
								transaction_no, user_id, user_name, reward_mode, reward_amount, reward_time, reward_reason)
							VALUES (
								orderNo, rec.recommend_id, rec.recommend_name, bonus, bonusAmount, now(), '推荐')
							RETURNING id
						)
						-- 新增交易订单数据
						INSERT INTO player_transaction (
							transaction_no, create_time, transaction_type, remark, transaction_money, balance,
							status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,
							fund_type, transaction_way, transaction_data)
						VALUES (
							orderNo, now(), transType, '推荐奖励-红利', bonusAmount, bonusAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id),
							transStatus, rec.recommend_id, (SELECT id FROM award), bonusPoint, false, false,
							fundType, bonus, '{"username":"'||rec.recommend_name||'"}');
						-- 修改玩家余额
						UPDATE user_player SET wallet_balance = wallet_balance + bonusAmount WHERE id = rec.recommend_id;

						EXIT; -- 跳出循环

					END IF; -- end 达到推荐人数

				END LOOP;

			END IF; -- end 达到有效交易量

		END LOOP;

	END IF;

	RETURN 1;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE;

ALTER FUNCTION f_player_recommend_award(siteCode VARCHAR, orderType VARCHAR) OWNER TO "postgres";
COMMENT ON FUNCTION f_player_recommend_award(siteCode VARCHAR, orderType VARCHAR) IS 'Fly - 玩家推荐奖励存储函数';

----------------------------------------------------------------
-------------------------- operations --------------------------
----------------------------------------------------------------
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