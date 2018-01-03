-- auto gen by tom 2016-03-16 15:44:41
CREATE OR REPLACE FUNCTION "gamebox_rebate_player"(syshash "hstore", expense_map "hstore", rakeback_map "hstore", gradshash "hstore", bill_id int4, row_split text, col_split text, flag text)
  RETURNS "pg_catalog"."void" AS $BODY$

DECLARE
  	keys 		text[];
	mhash 		hstore;
	param 		text:='';
	agent_id 	int;
	money 		float:=0.00;

  	player_num 	int:=0;					-- 玩家数
	profit_amount float:=0.00;			-- 盈亏总和
  	effective_trade_amount float:=0.00;	-- 有效交易量

	keyname 	text:='';
	val 		text:='';
	vals 		text[];

  	backwater 	float:=0.00;			-- 返水费用
  	backwater_apportion 	float:=0.00;-- 返水分摊费用

	favourable 	float:=0.00;			-- 优惠费用
  	recommend 	float:=0.00;			-- 推荐费用
  	artificial_depositfavorable		float:=0.00;-- 手动存入优惠
	favourable_apportion 	float:=0.00;-- 优惠分摊费用

  	refund_fee 	float:=0.00;			-- 返手续费费用
  	refund_fee_apportion 	float:=0.00;-- 返手续费分摊费用

  	rebate 		float:=0.00;	-- 返佣
	retio 		float;			-- 占成数
	agent_name 	text:='';
	tmp 		text:='';
	apportion 	FLOAT:=0.00;	-- 分摊总费用
	user_id 	INT:=-1;

	deposit 		float:=0.00;	-- 存款
	company_deposit float:=0.00;	-- 存款:公司入款
	online_deposit	float:=0.00;	-- 存款:线上支付
	artificial_deposit float:=0.00; -- 存款:手动存款

	withdraw 		float:=0.00;	-- 取款
	artificial_withdraw	float:=0.00;-- 取款:手动取款
	player_withdraw	float:=0.00;	-- 取款:玩家取款

	rebate_keys		text[];
	rebate_keyname  text:='';
	rebate_val		text:='';
	rebate_vals 	text[];
	rebate_hash		hstore;
	max_rebate		float:=0.00;

BEGIN
	-- raise info 'expense_map = %', expense_map;
	IF expense_map is null THEN
		RETURN;
	END IF;

	keys = akeys(expense_map);
	-- raise info 'keys = %', keys;

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

		backwater = 0.00;
		-- raise info 'rakeback_map = %', rakeback_map;
		IF isexists(rakeback_map, keyname) THEN
			backwater = (rakeback_map->keyname)::FLOAT;
		END IF;
		-- raise info 'backwater = %', backwater;

		favourable = 0.00;
		IF exist(mhash, 'favourable') THEN
			favourable = (mhash->'favourable')::float;
		END IF;

		refund_fee = 0.00;
		IF exist(mhash, 'refund_fee') THEN
			refund_fee = (mhash->'refund_fee')::float;
		END IF;

		recommend = 0.00;
		IF exist(mhash, 'recommend') THEN
			recommend = (mhash->'recommend')::float;
		END IF;

		artificial_depositfavorable = 0.00;
		IF exist(mhash, 'artificial_depositfavorable') THEN
			artificial_depositfavorable = (mhash->'artificial_depositfavorable')::float;
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
		favourable = favourable + artificial_depositfavorable;

		agent_id = -1;
		IF exist(mhash, 'agent_id') THEN
			agent_id = (mhash->'agent_id')::INT;
		END IF;
		agent_name = '';
		IF exist(mhash, 'agent_name') THEN
			agent_name = mhash->'agent_name';
		END IF;

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
			favourable_apportion = (favourable + recommend) * retio / 100;
		ELSE
			favourable_apportion = 0;
		END IF;

		--返水分摊
		IF isexists(syshash, 'agent.rakeback.percent') THEN
			retio = (syshash->'agent.rakeback.percent')::float;
			-- raise info '返水分摊比例:%', retio;
			backwater_apportion = backwater * retio / 100;
		ELSE
			backwater_apportion = 0;
		END IF;
		--手续费分摊
		IF isexists(syshash, 'agent.poundage.percent') THEN
			retio = (syshash->'agent.poundage.percent')::float;
			-- raise info '手续费优惠分摊比例:%', retio;
			refund_fee_apportion = refund_fee * retio / 100;
		ELSE
			refund_fee_apportion = 0;
		END IF;
		--代理佣金 = 各API佣金总和 - 优惠 - 返水 - 返手续费.
		rebate = rebate - favourable_apportion - backwater_apportion - refund_fee_apportion;

		rebate_keys = akeys(gradshash);
		rebate_keyname = rebate_keys[i];
		rebate_val = gradshash->rebate_keyname;
		-- 判断如果存在多条记录，取第一条.
		rebate_vals = regexp_split_to_array(rebate_val, '\^\&\^');
		IF array_length(rebate_vals, 1) > 1 THEN
			rebate_val = rebate_vals[1];
		END IF;
		select * from strToHash(rebate_val) into rebate_hash;
		max_rebate = (rebate_hash->'max_rebate')::float;-- 返佣上限
		IF rebate > max_rebate THEN
			rebate = max_rebate;
		END IF;

		--分摊总费用
		apportion = backwater_apportion + refund_fee_apportion + favourable_apportion;
		-- raise info '-------- 分摊总费用 = %', apportion;

		IF flag = 'Y' THEN
			INSERT INTO rebate_player(
				rebate_bill_id, agent_id, user_id,
				effective_transaction, profit_loss, rebate_total, rakeback,
				preferential_value, recommend, refund_fee, apportion,
				deposit_amount, withdrawal_amount
			) VALUES (
				bill_id, agent_id, user_id,
				effective_trade_amount, profit_amount, rebate, backwater,
				favourable, recommend, refund_fee, apportion,
				deposit, withdraw
			);
			SELECT currval(pg_get_serial_sequence('rebate_player', 'id')) INTO tmp;
			-- raise info 'Y返佣代理表的键值:%', tmp;
		ELSEIF flag='N' THEN
			INSERT INTO rebate_player_nosettled(
				rebate_bill_nosettled_id, player_id,
				effective_transaction, profit_loss, rebate_total, rakeback,
				preferential_value, recommend, refund_fee, apportion,
				deposit_amount, withdrawal_amount,agent_id
			) VALUES (
				bill_id, user_id,
				effective_trade_amount, profit_amount, rebate, backwater,
				favourable, recommend, refund_fee, apportion,
				deposit, withdraw,agent_id
			);
			SELECT currval(pg_get_serial_sequence('rebate_player_nosettled', 'id')) INTO tmp;
			-- raise info 'N返佣代理表的键值:%',tmp;
		END IF;
	END LOOP;
	raise info '开始统计代理返佣.完成';
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "gamebox_rebate_player"(syshash "hstore", expense_map "hstore", rakeback_map "hstore", gradshash "hstore", bill_id int4, row_split text, col_split text, flag text) OWNER TO "postgres";

COMMENT ON FUNCTION "gamebox_rebate_player"(syshash "hstore", expense_map "hstore", rakeback_map "hstore", gradshash "hstore", bill_id int4, row_split text, col_split text, flag text) IS 'Lins-返佣-玩家返佣';