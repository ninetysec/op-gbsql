-- auto gen by fly 2016-01-25 20:12:51

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
	rec 		record;
	--系统设置各种承担比例.
	syshash 	hstore;
	--各API的返佣设置
  	gradshash 	hstore;
	--各个代理的返佣设置
	agenthash 	hstore;
	--运营商各API占成比例.
	mainhash 	hstore;
	--存储每个代理是否满足梯度.
	checkhash 	hstore;
	--各玩家返水.
	rakebackhash hstore;
	--临时
	hash 		hstore;
	mhash 		hstore;
	--返佣值
	rebate_value FLOAT;

	sid 	int;
	keyId 	int;
	tmp 	int;
	e1 		text;	-- 异常信息
	e2 		text;
	e3 		text;
	stTime 	TIMESTAMP;
	edTime 	TIMESTAMP;

	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
	--分隔符
	row_split 	text:='^&^';
	col_split 	text:='^';

	vname 		text:='v_site_game';
	--运营商占成参数.
	is_max 		BOOLEAN:=true;
	key_type 	int:=4;
	category 	TEXT:='AGENT';

	rebate_bill_id INT:=-1;--返佣主表键值.

BEGIN
	stTime = startTime::TIMESTAMP;
	edTime = endTime::TIMESTAMP;
	raise info '开始统计第( % )期的返佣,周期( %-% )', name, startTime, endTime;
	raise info '取得玩家返水';
	-- ============================================================================================================================
	-- SELECT gamebox_rakeback_map(stTime, edTime, url, 'PLAYER') INTO rakebackhash;
	SELECT gamebox_rebate_rakeback_map(stTime, edTime) INTO rakebackhash;
	raise info 'rakebackhash = %', rakebackhash;
	raise info '创建站点游戏视图';
  	--取得当前站点.
	SELECT gamebox_current_site() INTO sid;
  	perform gamebox_site_game(url,vname,sid, 'C');
	--取得系统关于各种承担比例参数.
	SELECT gamebox_sys_param('apportionSetting') INTO syshash;
	--取得当前返佣梯度设置信息.
  	SELECT gamebox_rebate_api_grads() INTO gradshash;
	--取得代理默认返佣方案
  	SELECT gamebox_rebate_agent_default_set() INTO agenthash;
  	--判断各个代理满足的返佣梯度.
	SELECT gamebox_rebate_agent_check(gradshash, agenthash, stTime, edTime) INTO checkhash;
	--raise info 'keys:%', checkhash;
	--取得各API的运营商占成.
	raise info '取得运营商各API占成';
	SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type) INTO mainhash;

	--先插入返佣总记录并取得键值.
  	raise info '返佣rebate_bill新增记录';
	SELECT gamebox_rebate_bill(name, stTime, edTime, rebate_bill_id, 'I', flag) INTO rebate_bill_id;
  	raise info '返佣rebate_bill.ID=%', rebate_bill_id;
	--先统计每个代理的有效交易量、有效玩家、盈亏总额.
  	raise info '计算各玩家API返佣';
	perform gamebox_rebate_api(rebate_bill_id, stTime, edTime, gradshash, checkhash, mainhash, flag);

  	raise info '收集各玩家的分摊费用';
	SELECT gamebox_rebate_expense_gather(rebate_bill_id, rakebackhash, stTime, edTime, row_split, col_split) INTO hash;

	raise info '统计各玩家返佣';
  	perform gamebox_rebate_player(syshash, hash, rakebackhash, rebate_bill_id, row_split, col_split, flag);

	raise info '开始统计代理返佣';
	perform gamebox_rebate_agent(rebate_bill_id,flag);

  	raise info '更新返佣总表';
	perform gamebox_rebate_bill(name, stTime, edTime, rebate_bill_id, 'U', flag);
	--删除临时视图表.
	perform gamebox_site_game(url, vname, sid, 'D');

	--异常处理
	EXCEPTION
	WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS e1 = MESSAGE_TEXT, e2 = PG_EXCEPTION_DETAIL, e3 = PG_EXCEPTION_HINT;
	raise EXCEPTION '异常:%,%,%', e1, e2, e3;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate(name text, startTime text, endTime text, url text, flag text)
IS 'Lins-返佣-代理返佣计算入口';

/**
 * 返佣插入与更新数据.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	name 		周期数.
 * @param 	start_time 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	end_time 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	bill_id 	返佣键值
 * @param 	op 			操作类型: I-新增, U-更新.
 * @param 	flag 		出账标示: Y-已出账, N-未出账
 */
--删除上期函数
DROP FUNCTION IF EXISTS gamebox_rebate_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rebate_bill(
	name 			TEXT,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	INOUT bill_id 	INT,
	op 				TEXT,
	flag 			TEXT
)
 returns INT as $$

DECLARE
	rec 		record;
	pending_pay text:='pending_pay';
	key_id 		INT;

BEGIN
	IF flag='Y' THEN 	--未出账
		IF op='I' THEN
			INSERT INTO rebate_bill (
				period, start_time, end_time,
				agent_count, agent_lssuing_count, agent_reject_count, rebate_total, rebate_actual,
				last_operate_time, create_time, lssuing_state
			) VALUES (
				name, start_time, end_time,
				0, 0, 0, 0, 0,
				now(), now(), pending_pay
			);
			SELECT currval(pg_get_serial_sequence('rebate_bill', 'id')) INTO bill_id;
			raise info 'rebate_bill.完成.Y键值:%', bill_id;
		ELSE
			FOR rec in
				SELECT rebate_bill_id,
					   count(agent_id) 				agent_num,
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
				 GROUP BY rebate_bill_id
			LOOP
				UPDATE rebate_bill SET
					   agent_count 				= rec.agent_num,
					   rebate_total 			= rec.rebate_total,
					   effective_transaction 	= rec.effective_transaction,
					   profit_loss 				= rec.profit_loss,
					   rakeback 				= rec.rakeback,
					   refund_fee 				= rec.refund_fee,
					   recommend 				= rec.recommend,
					   preferential_value 		= rec.preferential_value,
					   apportion 				= rec.apportion
				 WHERE id = rec.rebate_bill_id;
			END LOOP;
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
			);
			SELECT currval(pg_get_serial_sequence('rebate_bill_nosettled', 'id')) INTO bill_id;
			raise info 'rebate_bill_nosettled.完成.N键值:%', bill_id;
		ELSE
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
				UPDATE rebate_bill_nosettled SET
					   rebate_total				= rec.rebate_total,
					   effective_transaction	= rec.effective_transaction,
					   profit_loss			 	= rec.profit_loss,
					   rakeback 				= rec.rakeback,
					   refund_fee 				= rec.refund_fee,
					   recommend 				= rec.recommend,
					   preferential_value 		= rec.preferential_value,
					   apportion 				= rec.apportion
				 WHERE id = rec.rebate_bill_nosettled_id;
			END LOOP;
		END IF;

	END IF;

	RETURN;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, bill_id INT, op TEXT, flag TEXT) IS 'Lins-返佣-返佣周期主表';

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
		SELECT u.owner_id, u.id, o.api_id, o.game_type, o.api_type_id,
			   count(DISTINCT o.player_id) 					as 	player_num,
			   sum(-COALESCE(o.profit_amount,0.00)) 		as 	profit_amount,
               sum(COALESCE(o.effective_trade_amount,0.00)) as effective_trade_amount
          FROM player_game_order o,sys_user u
	     WHERE o.create_time >= start_time
		   AND o.create_time < end_time
		   AND o.player_id = u.id
         GROUP BY u.owner_id, u.id, o.api_id, o.game_type, o.api_type_id
	LOOP
		--检查当前代理是否满足返佣梯度.
		IF isexists(checkhash, (rec.owner_id)::text) = false THEN
			CONTINUE;
		END IF;

		raise info '取得各API各分类佣金总和';
		key_name = rec.id||col_split||rec.api_id||col_split||rec.game_type;
		raise info 'key_name = %', key_name;
		operation_occupy = (mainhash->key_name)::FLOAT;
		operation_occupy = coalesce(operation_occupy, 0);
		SELECT gamebox_rebate_calculator(gradshash, checkhash, rec.owner_id, rec.api_id, rec.game_type, rec.profit_amount, operation_occupy) INTO rebate_value;
		--raise info '各API各分类佣金总和:代理:%,有效交易量:%,返佣:%',rec.owner_id,rec.effective_trade_amount,rebate_value;

		--新增各API代理返佣:目前返佣不分正负都新增.
	  	IF flag='Y' THEN
			INSERT INTO rebate_api (
				rebate_bill_id, player_id, api_id, api_type_id, game_type,
				rebate_total, effective_transaction, profit_loss
			) VALUES (
				bill_id, rec.id, rec.api_id, rec.api_type_id, rec.game_type,
				rebate_value, rec.effective_trade_amount, rec.profit_amount
			);
		 	SELECT currval(pg_get_serial_sequence('rebate_api', 'id')) INTO tmp;
		 	raise info '返拥API.键值:%', tmp;
		ELSEIF flag='N' THEN
			INSERT INTO rebate_api_nosettled (
				rebate_bill_nosettled_id, player_id, api_id, api_type_id, game_type,
				rebate_total, effective_transaction, profit_loss
			) VALUES(
				bill_id, rec.id, rec.api_id, rec.api_type_id, rec.game_type,
				rebate_value, rec.effective_trade_amount, rec.profit_amount
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
 * 各玩家返佣统计
 * @author 	Lins
 * @date 	2015.11.13
 * @param 	syshash		系统参数
 * @param 	expense_map 费用Map
 * @param 	rakeback_map 返水Map
 * @param 	bill_id 	主键
 * @param 	row_split 	行分隔符
 * @param 	col_split 	列分隔符
 * @param 	flag 		Y, N
 * 返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
 */
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

DECLARE
  	keys 		text[];
	mhash 		hstore;
	param 		text:='';
	agent_id 	int;
	money 		float:=0.00;

  	player_num 	int:=0;--玩家数
	profit_amount float:=0.00;--盈亏总和
  	effective_trade_amount float:=0.00;--有效交易量

	keyname 	text:='';
	val 		text:='';
	vals 		text[];
  	backwater 	float:=0.00;--返水费用
	favourable 	float:=0.00;--优惠费用
  	refund_fee 	float:=0.00;--返手续费费用
  	recommend 	float:=0.00;--推荐费用

  	backwater_apportion 	float:=0.00;--返水分摊费用
	favourable_apportion 	float:=0.00;--优惠分摊费用
  	refund_fee_apportion 	float:=0.00;--返手续费分摊费用
  	recommend_apportion 	float:=0.00;--推荐分摊费用

  	rebate 		float:=0.00;--返佣
	retio 		float;--占成数
	agent_name 	text:='';
	tmp 		text:='';
	apportion 	FLOAT:=0.00;--分摊总费用
	user_id 	INT:=-1;

BEGIN
	raise info 'expense_map = %', expense_map;
	IF expense_map is null THEN
		RETURN;
	END IF;

	keys = akeys(expense_map);
	raise info 'keys = %', keys;

	FOR i in 1..array_length(keys, 1)

	LOOP
		keyname = keys[i];

		raise info 'keyname = %', keyname;

		user_id = keyname::INT;
		val = expense_map->keyname;
		--转换成hstore数据格式:key1=>value1,key2=>value2
		val = replace(val, row_split, ',');
		val = replace(val, col_split, '=>');
		--raise info 'val=%',val;
		SELECT val INTO mhash;
		raise info 'val = %', val;

		backwater = 0.00;
		IF exist(mhash, 'backwater') THEN
			backwater = (mhash->'backwater')::float;
		END IF;
		--返水暂以此周期应付金额为准
		--此数可因未来需求而变
		IF isexists(rakeback_map, keyname) THEN
			backwater = (rakeback_map->keyname)::FLOAT;
		END IF;

		favourable = 0.00;
		IF exist(mhash, 'favourable') THEN
			favourable = (mhash->'favourable')::float;
		END IF;

		refund_fee = 0.00;
		IF exist(mhash, 'refund_fee') THEN
			refund_fee = (mhash->'refund_fee')::float;
		END IF;

		recommend=0.00;
		IF exist(mhash, 'recommend') THEN
			recommend = (mhash->'recommend')::float;
		END IF;

		--返佣
		rebate = 0.00;
		IF exist(mhash, 'rebate') THEN
			rebate = (mhash->'rebate')::float;
		END IF;

		--盈亏总和
		profit_amount = 0.00;
		IF exist(mhash, 'profit_loss') THEN
			profit_amount=(mhash->'profit_loss')::float;
		END IF;

		--有效交易量
		effective_trade_amount = 0.00;
		IF exist(mhash, 'effective_transaction') THEN
			effective_trade_amount = (mhash->'effective_transaction')::float;
		END IF;

		agent_id = -1;
		IF exist(mhash, 'agent_id') THEN
			agent_id = (mhash->'agent_id')::INT;
		END IF;
		agent_name = '';
		IF exist(mhash, 'agent_name') THEN
			agent_name = mhash->'agent_name';
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
			raise info '优惠与推荐分摊比例:%', retio;
			favourable_apportion = (favourable+recommend) * retio / 100;
		ELSE
			favourable_apportion = 0;
		END IF;

		--返水分摊
		IF isexists(syshash, 'agent.rakeback.percent') THEN
			retio = (syshash->'agent.rakeback.percent')::float;
			raise info '返水分摊比例:%', retio;
			backwater_apportion = backwater * retio / 100;
		ELSE
			backwater_apportion = 0;
		END IF;
		--手续费分摊
		IF isexists(syshash, 'agent.poundage.percent') THEN
			retio = (syshash->'agent.poundage.percent')::float;
			raise info '手续费优惠分摊比例:%', retio;
			refund_fee_apportion = refund_fee * retio / 100;
		ELSE
			refund_fee_apportion = 0;
		END IF;
		--代理佣金 = 各API佣金总和－优惠 - 返水 - 返手续费.
		--佣金
		rebate = rebate - favourable_apportion - backwater_apportion - refund_fee_apportion;
		--分摊总费用
		apportion = backwater_apportion + refund_fee_apportion + favourable_apportion;

		IF flag = 'Y' THEN
			INSERT INTO rebate_player(
				rebate_bill_id, agent_id, user_id,
				effective_transaction, profit_loss, rebate_total, rakeback,
				preferential_value, recommend, refund_fee, apportion
			) VALUES (
				bill_id, agent_id, user_id,
				effective_trade_amount, profit_amount, rebate, backwater,
				favourable, recommend, refund_fee,apportion
			);
			SELECT currval(pg_get_serial_sequence('rebate_player', 'id')) INTO tmp;
			raise info 'Y返佣代理表的键值:%', tmp;
		ELSEIF flag='N' THEN
			INSERT INTO rebate_player_nosettled(
				rebate_bill_nosettled_id, player_id,
				effective_transaction, profit_loss, rebate_total, rakeback,
				preferential_value, recommend, refund_fee, apportion
			) VALUES (
				bill_id, user_id,
				effective_trade_amount, profit_amount, rebate, backwater,
				favourable, recommend, refund_fee, apportion
			);
			SELECT currval(pg_get_serial_sequence('rebate_player_nosettled', 'id')) INTO tmp;
			raise info 'N返佣代理表的键值:%',tmp;
		END IF;
	END LOOP;
		raise info '开始统计代理返佣.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_player(syshash hstore, expense_map hstore, rakeback_map hstore, bill_id INT, row_split text, col_split text, flag TEXT)
IS 'Lins-返佣-玩家返佣';

/**
 * 计算代理返佣
 * @param 	bill_id 	返佣ID
 * @param 	flag 		出账标识: Y-已出账, N-未出账
 */
drop function if exists gamebox_rebate_agent(INT,TEXT);
create or replace function gamebox_rebate_agent(
	bill_id INT,
	flag TEXT
) returns void as $$

DECLARE
BEGIN
	IF flag='Y' THEN
		INSERT INTO rebate_agent(
			rebate_bill_id, agent_id, agent_name,
			effective_player, effective_transaction, profit_loss, rakeback,rebate_total,
			refund_fee, recommend, preferential_value, apportion
		 )
		 SELECT
		 	p.rebate_bill_id, p.agent_id, u.username,
		 	COUNT(distinct p.user_id), sum(p.effective_transaction), SUM(p.profit_loss), SUM(p.rakeback), SUM(p.rebate_total),
		 	SUM(p.refund_fee), SUM(p.recommend), SUM(p.preferential_value), SUM(p.apportion)
		  FROM rebate_player p, sys_user u
		 WHERE p.agent_id = u.id
		   AND p.rebate_bill_id = bill_id
		   AND u.user_type = '23'
		 GROUP BY p.rebate_bill_id, p.agent_id, u.username;
	ELSEIF flag='N' THEN
		INSERT INTO rebate_agent_nosettled(
			rebate_bill_nosettled_id, agent_id, agent_name,\
			effective_player, effective_transaction, profit_loss, rakeback, rebate_total,
			refund_fee, recommend, preferential_value, apportion
		 )
		 SELECT
		 	p.rebate_bill_nosettled_id, u.agent_id, u.agent_name,
		 	COUNT(distinct p.player_id), sum(p.effective_transaction), SUM(p.profit_loss), SUM(p.rakeback), SUM(p.rebate_total),
		 	SUM(p.refund_fee), SUM(p.recommend), SUM(p.preferential_value), SUM(p.apportion)
		  FROM rebate_player_nosettled p, v_sys_user_tier u
		 WHERE p.rebate_bill_nosettled_id = bill_id
		   AND p.player_id = u.id
		 GROUP BY p.rebate_bill_nosettled_id, u.agent_id, u.agent_name;
	END IF;
    raise info '代理返佣.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_agent(bill_id INT, flag TEXT) IS 'Lins-返佣-代理返佣计算';


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
	url TEXT,
	start_time TEXT,
	end_time TEXT,
	category TEXT
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
	vname 		TEXT:='v_site_game';
	is_max 		BOOLEAN:=true;
	key_type 	int:=5;--API
	maps 		hstore[];
BEGIN
	category='AGENT';
	stTime=start_time::TIMESTAMP;
	edTime=end_time::TIMESTAMP;

	raise info '占成.取得当前站点ID';
	SELECT gamebox_current_site() INTO sid;

	raise info '占成.site_game临时视图';
  	perform gamebox_site_game(url,vname,sid,'C');

	raise info '占成.系统各种分摊比例参数';
	SELECT gamebox_sys_param('apportionSetting') INTO sys_map;

	raise info '返佣.梯度设置信息';
  	SELECT gamebox_rebate_api_grads() INTO rebate_grads_map;

	raise info '返佣.代理默认方案';
  	SELECT gamebox_rebate_agent_default_set() INTO agent_map;

  	raise info '返佣.代理满足的梯度';
	SELECT gamebox_rebate_agent_check(rebate_grads_map,agent_map,stTime,edTime) INTO agent_check_map;

	--取得各API的运营商占成.
	raise info '取得运营商各API占成';
	SELECT gamebox_operations_occupy(url,sid,stTime,edTime,category,is_max,key_type) INTO operation_occupy_map;

	SELECT gamebox_rebate_map(stTime,edTime,key_type,rebate_grads_map,agent_check_map,operation_occupy_map) INTO rebate_map;
	--统计各种费费用.
	SELECT gamebox_expense_map(stTime,edTime,sys_map) INTO expense_map;
	maps=array[rebate_map];
	maps=array_append(maps,expense_map);

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
        SELECT u.owner_id, g.api_id, g.game_type,
			   count(DISTINCT o.player_id) 					as player_num,
			   sum(-COALESCE(o.profit_amount,0.00)) 		as profit_amount,
               sum(COALESCE(o.effective_trade_amount,0.00)) as effective_trade_amount
          FROM player_game_order o,v_site_game g,sys_user u
	     WHERE o.create_time >= start_time
	       AND o.create_time < end_time
	       AND o.game_id = g.id
	       AND o.player_id = u.id
         GROUP BY u.owner_id, g.api_id, g.game_type
	LOOP
		--检查当前代理是否满足返佣梯度.
		IF isexists(agent_check_map, (rec.owner_id)::text) = false THEN
			CONTINUE;
		END IF;

		raise info '取得各API各分类佣金总和';
		key_name = rec.api_id||col_split||rec.game_type;
		operation_occupy = (operation_occupy_map->key_name)::FLOAT;
		operation_occupy = coalesce(operation_occupy, 0);

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
	start_time TIMESTAMP,
	end_time TIMESTAMP
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
			   sum(transaction_money) as transaction_money
		  FROM player_transaction
		 WHERE fund_type in ('backwater', 'favourable', 'recommend', 'refund_fee')
		   AND status = 'success'
		   AND create_time >= start_time
		   AND create_time < end_time
		 GROUP BY fund_type
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
		SELECT count(DISTINCT o.player_id) 					as player_num,
			   sum(COALESCE(o.profit_amount,0.00)) 			as profit_amount,
  		  	   sum(COALESCE(o.effective_trade_amount,0.00)) as effective_trade_amount
  		  FROM player_game_order o
         WHERE o.create_time >= start_time
		   AND o.create_time < end_time
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
		cols 	= 'u.topagent_id as id,u.topagent_name as name, ';
		tables	= ' player_transaction p,v_sys_user_tier u ';
		grups	= 'u.topagent_id,u.topagent_name ';
	ELSEIF category ='AGENT' THEN
		cols 	= 'u.agent_id as id,u.agent_name as name, ';
		tables 	= ' player_transaction p,v_sys_user_tier u ';
		grups 	= 'u.agent_id,u.agent_name ';
	ELSE
		cols 	= 'p.player_id as id,u.username as name, ';
		tables 	= ' player_transaction p,v_sys_user_tier u';
		grups 	= 'p.player_id,u.username ';
	END IF;
	FOR rec IN EXECUTE
		'SELECT '||cols||' p.fund_type, sum(p.transaction_money) as transaction_money
		   FROM '||tables||'
		  WHERE p.fund_type in (''backwater'', ''favourable'', ''recommend'', ''refund_fee'')
		    AND p.status = ''success''
			AND p.create_time >= $1 and p.create_time < $2
		  GROUP BY '||grups||',p.fund_type'
		USING start_time,end_time
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
 * 分摊费用
 * @author 	Lins
 * @date 	2015.11.13
 * @return 	返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
 */
drop function if exists gamebox_expense_share(hstore, hstore);
create or replace function gamebox_expense_share(
	cost_map hstore,
	sys_map hstore
) returns hstore as $$

DECLARE
	hash 		hstore;
	retio 		FLOAT:=0.00;
	backwater 	FLOAT:=0.00;
	favourable 	FLOAT:=0.00;
	refund_fee 	FLOAT:=0.00;
	recommend 	FLOAT:=0.00;

	favourable_apportion 	FLOAT:=0.00;
	backwater_apportion 	FLOAT:=0.00;
	refund_fee_apportion 	FLOAT:=0.00;
	apportion 				FLOAT:=0.00;
BEGIN
	backwater = 0.00;
	IF exist(cost_map, 'backwater') THEN
		backwater = (cost_map->'backwater')::float;
	END IF;

	favourable = 0.00;
	IF exist(cost_map, 'favourable') THEN
		favourable = (cost_map->'favourable')::float;
	END IF;

	refund_fee = 0.00;
	IF exist(cost_map, 'refund_fee') THEN
		refund_fee = (cost_map->'refund_fee')::float;
	END IF;

	recommend = 0.00;
	IF exist(cost_map, 'recommend') THEN
		recommend = (cost_map->'recommend')::float;
	END IF;

	/*
		计算各种优惠.
		1、返水承担费用=赠送给体系下玩家的返水 * 代理承担比例；
		2、优惠承担费用=赠送给体系下玩家的优惠 * 代理承担比例；
		3、返还手续费承担费用=返还给体系下玩家的手续费 * 代理承担比例；
	*/
 	--优惠与推荐分摊
	IF isexists(sys_map, 'agent.preferential.percent') THEN
		retio=(sys_map->'agent.preferential.percent')::float;
		--raise info '优惠与推荐分摊比例:%',retio;
		favourable_apportion=(favourable+recommend)*retio/100;
	ELSE
		favourable_apportion=0;
	END IF;

 	--返水分摊
	IF isexists(sys_map, 'agent.rakeback.percent') THEN
		retio=(sys_map->'agent.rakeback.percent')::float;
		--raise info '返水分摊比例:%',retio;
		backwater_apportion=backwater*retio/100;
	ELSE
		backwater_apportion=0;
	END IF;

	--手续费分摊
	IF isexists(sys_map, 'agent.poundage.percent') THEN
		retio=(sys_map->'agent.poundage.percent')::float;
 		--raise info '手续费优惠分摊比例:%',retio;
		refund_fee_apportion=refund_fee*retio/100;
	ELSE
		refund_fee_apportion=0;
	END IF;

	--分摊总费用
	apportion=backwater_apportion+refund_fee_apportion+favourable_apportion;
	SELECT 'apportion=>'||apportion INTO hash;
	return hash;
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_share(cost_map hstore, sys_map hstore)
IS 'Lins-分摊费用';

/**
 * 分摊费用
 * @author Lins
 * @date 2015.11.13
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @return 	返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
 */
drop function if exists gamebox_expense_map(TIMESTAMP, TIMESTAMP, hstore);
create or replace function gamebox_expense_map(
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	sys_map hstore
) returns hstore as $$

DECLARE
	cost_map hstore;
	share_map hstore;
	sid INT;
BEGIN
	SELECT gamebox_expense_gather(start_time,end_time) INTO cost_map;
	SELECT gamebox_expense_share(cost_map,sys_map) INTO share_map;
	SELECT gamebox_current_site() INTO sid;
	share_map = (SELECT ('site_id=>'||sid)::hstore)||share_map;
	RETURN cost_map||share_map;
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_map(start_time TIMESTAMP, end_time TIMESTAMP, sys_map hstore)
IS 'Lins-返佣-其它费用.外调';

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
create or replace function gamebox_rebate_expense_gather(
	bill_id 		int,
	rakebackhash 	hstore,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	row_split 		text,
	col_split 		text
) returns hstore as $$

DECLARE
	rec 		record;
	hash 		hstore;
	mhash 		hstore;
	param 		text:='';
	user_id 	text:='';
	money 		float:=0.00;
	loss 		FLOAT:=0.00;

	eff_transaction 	FLOAT:=0.00;

	agent_id 	INT;
	agent_name 	TEXT:='';
BEGIN

	SELECT gamebox_expense_gather(start_time, end_time, row_split, col_split) INTO hash;
	--raise info '%', hash;

	--统计各代理返佣.
	FOR rec IN
		SELECT p.player_id,
			   u.owner_id,
			   a.username,
			   p.rebate_total,
			   p.effective_transaction,
			   p.profit_loss
		  FROM (SELECT player_id,
		  			   sum(rebate_total) 			as rebate_total,
		  			   sum(effective_transaction)  	as effective_transaction,
		  			   sum(profit_loss)  			as profit_loss
				  FROM rebate_api
				 WHERE rebate_bill_id = bill_id
				 GROUP BY player_id) p,
		  	   sys_user u,
		  	   sys_user a
		 WHERE p.player_id = u.id
		   AND u.owner_id = a.id
		   AND u.user_type='24'
		   AND a.user_type='23'

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
COMMENT ON FUNCTION gamebox_rebate_expense_gather(bill_id int, rakebackhash hstore, startTime TIMESTAMP, endTime TIMESTAMP, row_split_char text, col_split_char text)
IS 'Lins-返佣-分摊费用与返佣统计';

/*
--测试返佣已出账
SELECT * FROM gamebox_rebate (
	'1',
	'2016-01-01',
	'2016-01-15',
	'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres',
	'Y'
);

--测试返佣未出账
SELECT * FROM gamebox_rebate (
	'1',
	'2016-01-01',
	'2016-01-15',
	'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres',
	'N'
);

SELECT * FROM gamebox_rebate_map (
	'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres',
	'2016-01-01',
	'2016-01-15',
	'AGENT'
);
*/
