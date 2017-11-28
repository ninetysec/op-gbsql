-- auto gen by cheery 2016-03-04 10:01:28

/**
 * 根据统计周期算出运营商的占成-入口.
 * @param 	url 		运营库dblink URL.
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	category 	占成类别.category: AGENT、TOPAGENT、SITE指明各种占成类型统计
 */
drop function if EXISTS gamebox_operations_occupy(TEXT, TIMESTAMP, TIMESTAMP, TEXT, INT);
create or replace function gamebox_operations_occupy(
	url 		text,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	category 	TEXT,
	key_type 	INT
) returns hstore as $$

DECLARE
	sid 	int;
	is_max 	BOOLEAN:=TRUE;
	hash 	hstore;
	hashs 	hstore[];
	tmp 	int:=0;

BEGIN
  	--取得当前站点.
	SELECT gamebox_current_site() INTO sid;
	--取得当前站点的包网方案
	SELECT gamebox_operations_occupy(url, sid, start_time, end_time, category, is_max, key_type) into hash;
	-- raise info '%', hash;
	return hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operations_occupy(url text, start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, key_type INT)
IS 'Lins-运营商占成-入口';

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
create or replace function gamebox_operations_occupy(
	url 		text,
	site_id 	int,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	category 	TEXT,
	is_max 		BOOLEAN,
	key 		INT
) returns hstore as $$

DECLARE
	hashs hstore[];
	hash hstore;

BEGIN
	--取得当前站点的包网方案
	SELECT * FROM dblink(url, 'SELECT gamebox_contract('||site_id||', '||is_max||')') as a(hash hstore[]) INTO hashs;
  	SELECT gamebox_operations_occupy(hashs, start_time, end_time, category, key) INTO hash;
	--raise info '%', hash;
	return hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operations_occupy(url text, site_id int, start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, is_max BOOLEAN, key INT)
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
create or replace function gamebox_operations_occupy(
	hashs 		hstore[],
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	category 	TEXT,
	key_type 	INT
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
	SELECT gamebox_operation_occupy(start_time, end_time, category) INTO cur;
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
COMMENT ON FUNCTION gamebox_operations_occupy(hashs hstore[], start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, key_type INT)
IS 'Lins-运营商占成-统计周期内运营商的占成';

/**
 * 计算当前API的运营商占成．
 * 按梯度计算. 当代理、总代直接取梯度最大值算运营商占成.
 * @author 	Lins
 * @date 	2015.12.1
 * @param 	keyname 	包网方案中设置的API占成信息
 * @param 	col_split 	API下单记录
 * @param 	amount 		占成类别.category: AGENT、TOPAGENT、SITE指明各种占成类型统计
 * @TODO 	目前未实现站点的梯度运算
 */
drop function if EXISTS gamebox_operations_occupy_calculate(hstore, json, text);
create or replace function gamebox_operations_occupy_calculate(
	hash 		hstore,
	rec 		json,
	category 	text
) returns FLOAT as $$

DECLARE
	keyname text:='';
	col_split text:='_';
	amount float:=0.00;

BEGIN
	amount = (rec->>'profit_amount')::float;

	IF category != 'SITE' THEN
		--raise info '%', rec;
		keyname = (rec->>'api_id')::TEXT||col_split||(rec->>'game_type')::TEXT;

		IF isexists(hash, keyname) THEN
			amount = amount * ((hash->keyname)::float) / 100;
			-- raise info 'key = %, amount = %, ratio = %, occupy = %', keyname, (rec->>'profit_amount'), hash->keyname, amount;
			RETURN amount;
		ELSE
			RETURN 0.00;
		END IF;

	END IF;

	RETURN 0.00;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operations_occupy_calculate(hash hstore, rec json, category text)
IS 'Lins-运营商占成-计算当前API的运营商占成';

/**
 * 根据周期与统计类型查询各API的下单相关信息.
 * @author 	Lins
 * @date 	2015.12.1
 */
drop function IF EXISTS gamebox_operation_occupy(TIMESTAMP, TIMESTAMP, TEXT);
create or replace function gamebox_operation_occupy(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	category 	TEXT
) RETURNS refcursor as $$

DECLARE
	cur refcursor;
BEGIN
	IF category = 'AGENT' THEN 	--代理
    	OPEN cur FOR
           	SELECT su.owner_id,
				   su."id",
				   rab.api_id,
				   rab.game_type,
				   COUNT(DISTINCT rab.player_id)					as player_num,
				   COALESCE(SUM(-rab.profit_loss), 0.00)			as profit_amount,
				   COALESCE(SUM(rab.effective_transaction), 0.00)	as effective_trade_amount
			  FROM rakeback_api_base rab
			  LEFT JOIN sys_user su ON rab.player_id = su."id"
			 WHERE rab.rakeback_time >= start_time
			   AND rab.rakeback_time < end_time
			 GROUP BY su.owner_id, su."id", rab.api_id, rab.game_type
			 ORDER BY su.owner_id;

	ELSEIF category = 'TOPAGENT' THEN 	--总代.
    	OPEN cur FOR
           	SELECT ua.owner_id,
				   su."id",
				   rab.api_id,
				   rab.game_type,
				   COUNT(DISTINCT rab.player_id)					as player_num,
				   COALESCE(SUM(-rab.profit_loss), 0.00)			as profit_amount,
				   COALESCE(SUM(rab.effective_transaction), 0.00)	as effective_trade_amount
			  FROM rakeback_api_base rab
			  LEFT JOIN sys_user su ON rab.player_id = su."id"
			  LEFT JOIN sys_user ua ON su.owner_id = ua.id
			 WHERE rab.rakeback_time >= start_time
			   AND rab.rakeback_time < end_time
			   AND su.user_type = '24'
			   AND ua.user_type = '23'
			 GROUP BY ua.owner_id, su."id", rab.api_id, rab.game_type
			 ORDER BY ua.owner_id;
	ELSE 	--站点统计
	   	OPEN cur FOR
           	SELECT rab.api_id,
				   rab.game_type,
				   COUNT(DISTINCT rab.player_id)					as player_num,
				   COALESCE(SUM(-rab.profit_loss), 0.00)			as profit_amount,
				   COALESCE(SUM(rab.effective_transaction), 0.00)	as effective_trade_amount
			  FROM rakeback_api_base rab
			 WHERE rab.rakeback_time >= start_time
			   AND rab.rakeback_time < end_time
			 GROUP BY rab.api_id, rab.game_type;
	END IF;

	-- raise info '------ cur = %', cur;
	RETURN cur;
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy(start_time TIMESTAMP, end_time TIMESTAMP, category TEXT)
IS 'Lins-运营商占成-API的下单信息';

/**
 * 根据统计周期算出运营商的占成-入口.
 * @param 	url 		运营库dblink URL.
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	category 	占成类别.category: AGENT、TOPAGENT、SITE指明各种占成类型统计
 */
drop function if EXISTS gamebox_operations_occupy(TEXT, TIMESTAMP, TIMESTAMP, TEXT, INT);
create or replace function gamebox_operations_occupy(
	url 		text,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	category 	TEXT,
	key_type 	INT
) returns hstore as $$

DECLARE
	sid 	int;
	is_max 	BOOLEAN:=TRUE;
	hash 	hstore;
	hashs 	hstore[];
	tmp 	int:=0;
BEGIN
  	-- 取得当前站点.
	SELECT gamebox_current_site() INTO sid;
	-- 取得当前站点的包网方案
	SELECT gamebox_operations_occupy(url, sid, start_time, end_time, category, is_max, key_type) into hash;
	-- raise info 'gamebox_operations_occupy hash = %', hash;
	return hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operations_occupy(url text, start_time TIMESTAMP, end_time TIMESTAMP, category TEXT, key_type INT)
IS 'Lins-运营商占成-入口';

--测试
/*
SELECT gamebox_operations_occupy(
	'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres',
	'2015-1-01'::TIMESTAMP,
	'2015-12-01'::TIMESTAMP,
	'TOPAGENT',
	4
);

SELECT gamebox_operations_occupy(
	'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres',
	'2015-1-01'::TIMESTAMP,
	'2015-12-01'::TIMESTAMP,
	'AGENT',
	3
);
*/