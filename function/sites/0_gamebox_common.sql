/**
 * MAP.新增健值.
**/
DROP FUNCTION IF exists put(INOUT hstore, TEXT, TEXT);
create or replace function put(
	INOUT map 	hstore,
	key 		TEXT,
	value 		TEXT
) returns hstore as $$

BEGIN
	IF value is null OR key is null THEN
		RETURN;
	END IF;

	IF map is null THEN
		SELECT key||'=>'||value INTO map;
	ELSE
		map = map||(SELECT (key||'=>'||value)::hstore);
	END IF;

	RETURN;
END;

$$ language plpgsql;
COMMENT ON FUNCTION put(INOUT map hstore, key TEXT, value TEXT)
IS 'Lins-Hashmap.put方法';

/**
 * 设置一些系统常量
**/
DROP FUNCTION IF exists sys_config();
create or replace function sys_config() returns hstore as $$
DECLARE
	config hstore;

BEGIN
	SELECT put(config, 'row_split', '^&^') INTO config;
	SELECT put(config, 'col_split', '^') INTO config;
	--格式:key|id^name^&^id^name;
	SELECT put(config, 'sp_split', '@') INTO config;

	RETURN config;
END;

$$ language plpgsql;
COMMENT ON FUNCTION sys_config() IS 'Lins-系统变量';

/**
 * 玩家[API]返水.
 * @author 	Lins
 * @date 	2015.12.3
 * @param 	startTime 	返水周期开始时间(yyyy-mm-dd HH:mm:ss)
 * @param 	endTime 	返水周期结束时间(yyyy-mm-dd HH:mm:ss)
 * @param 	url 		运营商库的dblink 格式数据
 * @param 	category	类型.API或PLAYER,区别在于KEY值不同.
**/
/*
drop function IF EXISTS gamebox_rakeback_map(TIMESTAMP, TIMESTAMP, text, text);
create or replace function gamebox_rakeback_map(
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP,
	url 		TEXT,
	category 	TEXT
) returns hstore as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-玩家入口-返佣调用
--v1.01  2016/05/25  Leisure  返回值类型由hstore[]改为hstore
/
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
*/

/**
 * 玩家[API]返水.
 * @author 	Lins
 * @date 	2015.12.3
 * @param 	startTime 	返水周期开始时间(yyyy-mm-dd HH:mm:ss)
 * @param 	endTime 	返水周期结束时间(yyyy-mm-dd HH:mm:ss)
 * @param 	url 		运营商库的dblink 格式数据
 * @param 	category	类型.API或PLAYER,区别在于KEY值不同.
**/
--drop function IF EXISTS gamebox_rakeback_map(TIMESTAMP, TIMESTAMP, text, text);
DROP FUNCTION IF EXISTS gamebox_rakeback_map(TIMESTAMP, TIMESTAMP, TEXT);
create or replace function gamebox_rakeback_map(
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP,
	--url 		TEXT, --v1.02  2016/06/01  Leisure
	category 	TEXT
) returns hstore[] as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-玩家入口-返佣调用
--v1.01  2016/05/25  Leisure  返回值类型由hstore[]改为hstore
--v1.02  2016/06/01  Leisure  修改参数，返水梯度改为内部获取，
                              返回值类型由hstore改回hstore[]
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
	--SELECT gamebox_rakeback_api_grads() into gradshash;
	--SELECT gamebox_agent_rakeback() into agenthash;

	raise info '统计玩家API返水';
	--v1.02  2016/06/01  Leisure
	--SELECT gamebox_rakeback_api_map(startTime, endTime, gradshash, agenthash, category) INTO hash;
	SELECT gamebox_rakeback_api_map(startTime, endTime, category) INTO hash;

	SELECT gamebox_rakeback_act(startTime, endTime) INTO rhash;

	--hash = hash || rhash;
	--RETURN hash;

	maps = array[hash];
	maps = array_append(maps, rhash);

	RETURN maps;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_map(startTime TIMESTAMP, endTime TIMESTAMP, category TEXT)
IS 'Lins-返水-玩家入口-返佣调用';

/**
 * 获取玩家实际返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	startTime 	开始时间
 * @param 	endTime 	结束时间
**/
DROP FUNCTION IF EXISTS gamebox_rakeback_act(TIMESTAMP, TIMESTAMP);
create or replace function gamebox_rakeback_act(
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP
) returns hstore as $$

DECLARE
	hash 		hstore;--玩家返水.
	rec 		record;
	param 		TEXT:='';

BEGIN

	FOR rec IN
		SELECT SUM(rp.rakeback_total) 	rakeback_total,
			   SUM(rp.rakeback_actual)	rakeback_actual
		  FROM rakeback_player rp
		  LEFT JOIN rakeback_bill rb ON rp.rakeback_bill_id = rb."id"
		 WHERE rb.start_time >= startTime
		   AND rb.end_time <= endTime
	LOOP
		param = 'rakeback_tot=>'||rec.rakeback_total||',rakeback_act=>'||rec.rakeback_actual;
		SELECT param::hstore INTO hash;
	END LOOP;

	RETURN hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_act(start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Lins-返水-获取玩家实际返水.';

/**
 * 玩家[API]返水-返佣调用.
 * @author 	Lins
 * @date 	2015.12.3
 * @param 	startTime 	返水结算开始时间(yyyy-mm-dd)
 * @param 	endTime 	返水结算结束时间(yyyy-mm-dd)
**/
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

/**
 * 玩家返佣-占成调用.
 * @author 	Fly
 * @date 	2016-02-23
 * @param 	startTime 	开始时间
 * @param 	endTime 	结束时间
**/
drop function IF EXISTS gamebox_occupy_rebate_map(TIMESTAMP, TIMESTAMP);
create or replace function gamebox_occupy_rebate_map(
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fly      创建此函数: 总返佣返佣-占成调用
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
	--v1.01  2016/06/16  Leisure
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

/**
 * 返水计算
 * @author 	Lins
 * @date 	2015.11.10
 * @return 	返回float类型，返水值.
**/
DROP FUNCTION IF EXISTS gamebox_rakeback_calculator(hstore, hstore, json, TIMESTAMP);
CREATE OR REPLACE FUNCTION gamebox_rakeback_calculator(
	gradshash 	hstore,
	agenthash 	hstore,
	rec 		json,
	p_rakeback_time 	TIMESTAMP
) returns FLOAT as $$
/*版本更新说明
版本   时间        作者     内容
v1.00  2015/01/01  Lins     创建此函数: 返水-返水计算
*/
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

/**
 * 计算玩家一天的有效交易量
 * @author 	Fei
 * @date 	2016-04-12
 * @param	back_time   统计日期
 * @return 	hstore
**/
 DROP FUNCTION IF EXISTS gamebox_effective_volume(TIMESTAMP);
 CREATE OR REPLACE FUNCTION gamebox_effective_volume(
 	p_rakeback_time  TIMESTAMP
 ) returns hstore as $$
 /*版本更新说明
 版本   时间        作者     内容
 v1.00  2015/01/01  Fei      创建此函数: 计算玩家一天的有效交易量
 v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time，交易时间条件改为参数值和此后24小时
**/
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

/**
 * 生成流水号
 * @author 	Lins
 * @date 	2015.12.22
 * @param 	trans_type 	交易类型:B或T
 * @param 	site_code 	站点code
 * @param 	order_type 	流水号类型
**/
DROP FUNCTION if exists gamebox_generate_order_no(TEXT, TEXT, TEXT);
create or replace function gamebox_generate_order_no(
	trans_type 	TEXT,
	site_code 	TEXT,
	order_type 	TEXT
) returns TEXT as $$

DECLARE
	currentDate VARCHAR:=(SELECT to_char(CURRENT_DATE, 'yyMMdd'));
	nextSeqNum	VARCHAR:='';
BEGIN
	site_code = lpad(site_code, 4,'0');
	IF trans_type = 'B' THEN
		IF order_type = '01' THEN		-- 01-游戏API与总控的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_api_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '02' THEN	-- 02-总控与运营商的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_boss_seq'))::VARCHAR , 7, '0');
		ELSEIF order_type = '03' THEN	-- 03-运营商与站长的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_company_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '04' THEN	-- 04-站长与总代的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_generalagent_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '05' THEN	-- 05-站长与代理的结算
			nextSeqNum:=lpad((SELECT nextval('settlement_id_agent_seq'))::VARCHAR, 7, '0');
		END IF;
	ELSEIF trans_type = 'T' THEN
		IF order_type = '01' THEN		-- 01-充值
			nextSeqNum:=lpad((SELECT nextval('order_id_recharge_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '02' THEN	-- 02-优惠
			nextSeqNum:=lpad((SELECT nextval('order_id_discount_seq'))::VARCHAR , 7, '0');
		ELSEIF order_type = '03' THEN	-- 03-游戏API
			nextSeqNum:=lpad((SELECT nextval('order_id_gameapi_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '04' THEN	-- 04-返水
			nextSeqNum:=lpad((SELECT nextval('order_id_backwater_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '05' THEN	-- 05-返佣
			nextSeqNum:=lpad((SELECT nextval('order_id_rebate_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '06' THEN	-- 06-玩家取款
			nextSeqNum:=lpad((SELECT nextval('order_id_withdraw_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '07' THEN	-- 07-代理提现
			nextSeqNum:=lpad((SELECT nextval('order_id_agent_withdraw_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '08' THEN	-- 08-转账
			nextSeqNum:=lpad((SELECT nextval('order_id_transfers_seq'))::VARCHAR, 7, '0');
		END IF;
	END IF;
	RETURN trans_type||currentDate||site_code||order_type||nextSeqNum;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_generate_order_no(trans_type TEXT, site_code TEXT, order_type TEXT)
IS 'Lins-生成流水号';

/**
 * 计算有效玩家数
**/
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

/**
 * 计算各个代理适用的返佣梯度.
 * @author 	Lins
 * @date 	2015.11.10
 * @return 	返回float类型，返水值.
**/
--drop function IF EXISTS gamebox_rebate_agent_check(hstore, hstore, TIMESTAMP, TIMESTAMP);
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

/**
 * 代理返佣默认方案.
 * @author 	Lins
 * @date 	2015-11-11
 * @return 	返回hstore类型
**/
drop function if exists gamebox_rebate_agent_default_set();
create or replace function gamebox_rebate_agent_default_set() returns hstore as $$
DECLARE
	hash 	hstore;
	rec 	record;
	param 	text:='';
BEGIN
	FOR rec IN
		SELECT a.user_id,
			   a.rebate_id
		  FROM user_agent_rebate a, sys_user u
		 WHERE a.user_id = u.id
		   AND u.user_type = '23'
    LOOP
		param = param||rec.user_id||'=>'||rec.rebate_id||',';
	end LOOP;

	IF length(param) > 0 THEN
		param = substring(param, 1, length(param) - 1);
	END IF;
	--raise info '结果:%',param;

	select param::hstore into hash;
  	--raise info '4:%',hash->'3';

	return hash;
END;

$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_agent_default_set()
IS 'Lins-返佣-代理返佣默认方案';

/**
 * 各种API返佣方案.
 * @author 	Lins
 * @date 	2015.11.11
**/
drop function IF exists gamebox_rebate_api_grads();
create or replace function gamebox_rebate_api_grads() returns hstore as $$
DECLARE
	rec 		record;
	param 		text:='';
	gradshash 	hstore;
	tmphash 	hstore;
	keyname 	text:='';
	val 		text:='';
	val2 		text:='';

BEGIN
	FOR rec in
		SELECT DISTINCT m.id, 			--返佣方案ID
			   m.name,
			   s.id 	as grads_id, 	--返佣梯度ID
			   d.api_id,
			   d.game_type,
			   d.ratio, 				--API占成比例
			   m.valid_value,			--有效交易量
			   s.total_profit,			--有效盈利总额
			   s.max_rebate,			--返佣上限
			   s.valid_player_num		--有效玩家数
		  FROM rebate_set 		m,
		  	   rebate_grads 	s,
		  	   rebate_grads_api d
		 WHERE m.id = s.rebate_id
		   AND m.status = '1'
		   AND s.id = d.rebate_grads_id
		 ORDER BY m.id, s.total_profit desc, s.valid_player_num desc, d.api_id, d.game_type, m.valid_value desc

    LOOP
		--判断主方案是否存在.
		--键值格式:ID+GRADSID+API+GAMETYPE
		keyname = rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text;
		val:=row_to_json(rec);
		--raise info 'rec=%',val;

		val:=replace(val, ',', '\|');
		val:=replace(val, '\:null\,', '\:-1\,');

		IF (gradshash?keyname) is null OR (gradshash?keyname) = false THEN

		IF gradshash is null then
			SELECT keyname||'=>'||val into gradshash;
		ELSE
			SELECT keyname||'=>'||val into tmphash;
			gradshash = gradshash||tmphash;
		END IF;

		ELSE
			val2 = gradshash->keyname;
			SELECT keyname||'=>'||val||'^&^'||val2 into tmphash;
			gradshash = gradshash||tmphash;
		END IF;

	END LOOP;
	raise info 'gamebox_rebate_set.键的数量：%', array_length(akeys(gradshash), 1);

	return gradshash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_api_grads()
IS 'Lins-返佣-返佣API梯度';

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
**/
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

	IF isexists(agent_check_map,agent) = false THEN --梯度不满足时不返佣
		RETURN 0.00;
	ELSEIF profit_amount <= 0 THEN --盈亏为负时,不返佣
		RETURN 0.00;
	END IF;

	rebate_id = agent_check_map->agent;
	vals = regexp_split_to_array(rebate_id, '_');

	rebate_id = vals[1]||'_'||vals[2];
	keys = akeys(rebate_grads_map);

	FOR i IN 1..array_length(keys, 1)
	LOOP
		keyname = keys[i];
		subkeys = regexp_split_to_array(keyname, '_');
		IF position(rebate_id in keyname) = 1 AND subkeys[3] = api AND rtrim(ltrim(subkeys[4])) = game_type THEN
			val = rebate_grads_map->keyname;
			-- 判断如果存在多条记录，取第一条.
			vals = regexp_split_to_array(val, '\^\&\^');
			IF array_length(vals, 1) > 1 THEN
				val = vals[1];
			END IF;

			select * from strToHash(val) into hash;
			ratio = (hash->'ratio')::float;--占成数

			-- 各个API运营商占成.
			operation_occupy = coalesce(operation_occupy, 0);
			-- 各API各分类佣金总和 = [各API各分类盈亏总和-(各API各分类盈亏总和*运营商占成）]*代理的佣金比例；
			rebate_value = (profit_amount - operation_occupy) * ratio / 100;
		END IF;

	END LOOP;
	RETURN rebate_value;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_calculator(rebate_grads_map hstore, agent_check_map hstore, agent_id INT, api_id INT, game_type TEXT, profit_amount FLOAT, operation_occupy FLOAT)
IS 'Lins-返佣-计算';

/**
 * 根据参数类型取得当前系统中所设置的各种参数的KEY-VALUE。
 * 目前应该是取得站点中代理与总代各种承担比例的KEY-VALUE键值对.
 * 各种承担比例的参数类型为:apportionSetting
 * @author 	Lins
 * @date 	2015.11.9
 * 调用例子: 	select * from gamebox_sys_param('apportionSetting');
 * 返回JSON格式内容.
 * 调用：hstore变量名->key 取得值.
 * 比如变量名为hash,取总代-返水优惠分摊比例
 * hash->'topagent.rakeback.percent'
 * 修改:增加站点ID.
**/
drop function if exists gamebox_sys_param(TEXT);
create or replace function gamebox_sys_param(
	paramType text
) returns hstore as $$

DECLARE
	param 	text:='';
	hash 	hstore;
	rec 	record;
	sid 	INT;

BEGIN
	FOR rec IN SELECT param_code, case when param_value ='' then '0' when param_value is null then '0' else param_value end FROM sys_param WHERE param_type = $1
	LOOP
		param = param||rec.param_code||'=>'||rec.param_value||',';
	END LOOP;
	--raise notice '结果:%',param;

	IF length(param) > 0 THEN
		param = substring(param, 1, length(param) - 1);
	END IF;

	SELECT param::hstore into hash;
  	--raise info '取得优惠值比例:%', hash->'topagent.rakeback.percent';
	SELECT gamebox_current_site() INTO sid;
	hash = hash||(SELECT ('site_id=>'||sid)::hstore);

	return hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_sys_param(paramType text)
IS 'Lins-返佣-系统各种参数萃取';

--玩家层级信息
drop view if EXISTS v_sys_user_tier;
create or REPLACE view v_sys_user_tier as
	SELECT p.id,
		   p.username,
		   r.id rank_id,
		   r.rank_name,
		   r.rank_code,
		   r.risk_marker,
		   a.id agent_id,
		   a.username agent_name,
		   t.id topagent_id,
		   t.username topagent_name
	  FROM sys_user a, sys_user p, sys_user t, user_player up, player_rank r
	 WHERE a.id = p.owner_id
	   AND a.owner_id = t.id
	   AND a.user_type = '23'
	   AND p.user_type = '24'
	   AND t.user_type = '22'
	   AND p.id = up.id
	   --AND p.status = '1'
	   AND up.rank_id = r.id
	 ORDER BY p.id;
COMMENT ON VIEW "v_sys_user_tier"
IS '玩家层级信息-Lins';

/**
 * 取得当前站点库的站点ID
 * @author 	Lins
 * @date 	2015.11.27
**/
drop function if exists gamebox_current_site();
create or replace function gamebox_current_site() returns int as $$
DECLARE
	id int;
BEGIN
	SELECT site_id FROM sys_user WHERE site_id is not null LIMIT 1 INTO id;
	return id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_current_site()
IS 'Lins-运营商占成-取得当前站点ID';
