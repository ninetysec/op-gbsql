-- auto gen by admin 2016-05-04 20:56:48
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
		   AND rb.end_time <= $2
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

drop function if exists gamebox_expense_calculate(hstore, hstore, TEXT);
create or replace function gamebox_expense_calculate(
	cost_map 	hstore,
	sys_map 	hstore,
	category TEXT
) returns hstore as $$

DECLARE
  	keys 		text[];
	mhash 		hstore;
	keyname 	text:='';
	val 		text:='';
	tmp 		TEXT:='';

	backwater 				float:=0.00;	-- 返水
	backwater_apportion 	float:=0.00;

	favourable 				float:=0.00;	-- 优惠 = (优惠 + 推荐 + 手动存入优惠)
  	--recommend 				float:=0.00;
  	--artificial_depositfavorable		float:=0.00;	-- 手动存入优惠
	favourable_apportion 	float:=0.00;

  	refund_fee 				float:=0.00;	-- 手续费
	refund_fee_apportion 	float:=0.00;


  	rebate 					float:=0.00;	-- 返佣
	rebate_apportion 		float:=0.00;

	apportion 				FLOAT:=0.00;	-- 总分摊费用

	retio 					FLOAT:=0.00;
	retio2 					FLOAT:=0.00;

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

	 IF cost_map is null THEN
		RETURN cost_map;
	 END IF;
	 keys = akeys(cost_map);
	 FOR i in 1..array_length(keys, 1)
	 LOOP
		keyname = keys[i];
		val = cost_map->keyname;
		tmp = val;
		--转换成hstore数据格式:key1=>value1, key2=>value2
		tmp = replace(tmp, rs,',');
	    tmp = replace(tmp, cs,'=>');
		SELECT tmp into mhash;

		backwater = 0.00;--返水
		IF exist(mhash, 'backwater') THEN
			backwater = (mhash->'backwater')::float;
		END IF;

		favourable = 0.00;--优惠
		IF exist(mhash, 'favourable') THEN
			favourable = (mhash->'favourable')::float;
		END IF;

		refund_fee = 0.00;--返手续费
		IF exist(mhash, 'refund_fee') THEN
			refund_fee = (mhash->'refund_fee')::float;
		END IF;
		/* 优惠/推荐已全部归入favorable
		recommend = 0.00;--推荐
		IF exist(mhash, 'recommend') THEN
			recommend = (mhash->'recommend')::float;
		END IF;

		artificial_depositfavorable = 0.00; -- 手动存入优惠
		IF exist(mhash, 'artificial_depositfavorable') THEN
			artificial_depositfavorable = (mhash->'artificial_depositfavorable')::float;
		END IF;
		*/
		rebate = 0.00;
		IF exist(mhash, 'rebate') THEN
			rebate=(mhash->'rebate')::float;
		END IF;

		backwater 	= COALESCE(backwater, 0);
		favourable 	= COALESCE(favourable, 0);
		--recommend 	= COALESCE(recommend, 0);
		--artificial_depositfavorable = COALESCE(artificial_depositfavorable, 0);
		refund_fee 	= COALESCE(refund_fee, 0);
		rebate 		= COALESCE(rebate, 0);

		--计算各种优惠.
		/*
			计算各种优惠.
			1、返水承担费用=赠送给体系下玩家的返水 * 代理承担比例；
			2、优惠承担费用=赠送给体系下玩家的优惠 * 代理承担比例；
			3、返还手续费承担费用=返还给体系下玩家的手续费 * 代理承担比例；
		*/
		--优惠与推荐分摊
		retio2 = 0.00;
		retio = 0.00;

	  	IF isexists(sys_map, 'agent.preferential.percent') THEN
			retio2 = (sys_map->'agent.preferential.percent')::float;--代理分摊比例
		END IF;

		IF isexists(sys_map, 'topagent.preferential.percent') THEN
			retio = (sys_map->'topagent.preferential.percent')::float;
		END IF;

		IF category = 'OCCUPY' THEN
			retio = (1 - retio2 / 100) * retio / 100;
		ELSE
			retio = retio2 / 100;
		END IF;

		--favourable_apportion = (favourable + recommend + artificial_depositfavorable) * retio;
		favourable_apportion = favourable * retio;

		--返水分摊
		retio2 = 0.00;
		retio = 0.00;

		IF isexists(sys_map, 'agent.rakeback.percent') THEN
			retio2 = (sys_map->'agent.rakeback.percent')::float;--代理分摊比例
		END IF;

		IF isexists(sys_map, 'topagent.rakeback.percent') THEN
		retio = (sys_map->'topagent.rakeback.percent')::float;
		END IF;

		IF category = 'OCCUPY' THEN
			retio = (1 - retio2 / 100) * retio / 100;
		ELSE
			retio = retio2 / 100;
		END IF;

		backwater_apportion = backwater * retio;

		--手续费优惠分摊
		retio2 = 0.00;
		retio = 0.00;

		IF isexists(sys_map, 'agent.poundage.percent') THEN
			retio2 = (sys_map->'agent.poundage.percent')::float;--代理分摊比例
		END IF;

		IF isexists(sys_map, 'topagent.poundage.percent') THEN
			retio = (sys_map->'topagent.poundage.percent')::float;
		END IF;

		IF category = 'OCCUPY' THEN
			retio = (1 - retio2 / 100) * retio / 100;
		ELSE
			retio = retio2 / 100;
		END IF;

		refund_fee_apportion = refund_fee * retio;

		--返佣分摊
		rebate_apportion = 0;
		retio = 0.00;

		IF isexists(sys_map, 'topagent.rebate.percent') THEN
			retio = (sys_map->'topagent.rebate.percent')::float;
			rebate_apportion = rebate * retio / 100;
		END IF;

		apportion = favourable_apportion + backwater_apportion + refund_fee_apportion;

		val = val||rs||'apportion'||cs||apportion;
		val = val||rs||'rebate_apportion'||cs||rebate_apportion;
		val = val||rs||'favourable_apportion'||cs||favourable_apportion;
		val = val||rs||'backwater_apportion'||cs||backwater_apportion;
		val = val||rs||'refund_fee_apportion'||cs||refund_fee_apportion;
		cost_map = cost_map||(SELECT (keyname||'=>'||val)::hstore);
	 END LOOP;

   	RETURN cost_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_calculate(cost_map hstore, sys_map hstore, category TEXT)
IS 'Lins-费用分摊计算';

drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, text);
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
		cols 	= 'u.topagent_id as id, u.topagent_name as name, ';
		tables	= 'player_transaction p, v_sys_user_tier u';
		grups	= 'u.topagent_id, u.topagent_name ';
	ELSEIF category ='AGENT' THEN
		cols 	= 'u.agent_id as id, u.agent_name as name, ';
		tables 	= 'player_transaction p, v_sys_user_tier u';
		grups 	= 'u.agent_id, u.agent_name ';
	ELSE
		cols 	= 'p.player_id as id, u.username as name, ';
		tables 	= 'player_transaction p, v_sys_user_tier u';
		grups 	= 'p.player_id, u.username ';
	END IF;
	FOR rec IN EXECUTE
		' SELECT '||cols||'
			 	 p.fund_type, SUM(p.transaction_money) as transaction_money
			FROM '||tables||'
		   WHERE p.player_id = u.id
			 AND p.fund_type IN (''backwater'', ''refund_fee'', ''artificial_deposit'',
		    	''company_deposit'', ''online_deposit'', ''artificial_withdraw'', ''player_withdraw'')
			 AND p.status = ''success''
		 	 AND NOT (fund_type = ''artificial_deposit'' AND
                transaction_type = ''favorable'')
		   AND p.create_time >= $1
		 	 AND p.create_time < $2
		   GROUP BY '||grups||', p.fund_type
		   UNION ALL
		  SELECT '||cols||'
				 --p.fund_type||p.transaction_type,
				 ''favourable'' fund_type,
				 SUM(transaction_money) 	as transaction_money
			FROM '||tables||'
		   WHERE p.player_id = u.id
                   AND (fund_type = ''favourable'' OR fund_type = ''recommend'' OR
                   (fund_type = ''artificial_deposit''
		   AND transaction_type = ''favorable''))
			 AND status = ''success''
		 	 AND create_time >= $1
		 	 AND create_time < $2
		   GROUP BY '||grups||''
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