-- auto gen by fei 2016-04-14 20:08:35

/**
 * 根据返水周期统计各个API, 各个玩家的返水数据.
 * @author 	Lins
 * @date 	2015.11.10
 * @param 	返水期数.
 * @param 	返水周期开始时间(yyyy-mm-dd)
 * @param 	返水周期结束时间(yyyy-mm-dd)
 * @param 	运营商库的dblink 格式数据
 * @param 	出账标示:Y-已出账, N-未出账
 */
drop function IF EXISTS gamebox_rakeback(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_rakeback(
	name 		text,
	startTime 	text,
	endTime 	text,
	url 		text,
	flag 		TEXT
) returns void as $$

DECLARE
	stTime 	TIMESTAMP;
	edTime 	TIMESTAMP;
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
	bill_id 		INT:=-1;
	sid 			INT;
BEGIN
	raise info '开始统计( % )的返水, 周期( %-% )', name, startTime, endTime;
	raise info '创建站点游戏视图';

	SELECT gamebox_current_site() INTO sid;

	stTime = startTime::TIMESTAMP;
	edTime = endTime::TIMESTAMP;

	raise info '返水总表数据预新增.';
	SELECT gamebox_rakeback_bill(name, stTime, edTime, bill_id, 'I', flag) INTO bill_id;

	-- 收集每个API下每个玩家的返水.
  	raise info '统计玩家API返水';
	perform gamebox_rakeback_api(bill_id, stTime, edTime, flag);
	raise info '统计玩家API返水.完成';

	raise info '统计玩家返水';
  	perform gamebox_rakeback_player(bill_id, flag);
	raise info '统计玩家返水.完成';

  	raise info '更新返水总表';
	perform gamebox_rakeback_bill(name, stTime, edTime, bill_id, 'U', flag);

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback(name text, startTime text, endTime text, url text, flag TEXT)
IS 'Lins-返水-玩家返水入口';

/**
 * 返水插入与更新数据.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	周期数.
 * @param 	返水周期开始时间(yyyy-mm-dd)
 * @param 	返水周期结束时间(yyyy-mm-dd)
 * @param 	返水键值
 * @param 	操作类型.I:新增.U:更新.
 * @param 	出账标示:Y.已出账, N.未出账
 */
DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rakeback_bill (
	name TEXT,
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	INOUT bill_id INT,
	op TEXT,
	flag TEXT
) returns INT as $$
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
	rec 			record;
	max_back_water 	float:=0.00;
	backwater 		float:=0.00;
BEGIN
	IF flag='Y' THEN--已出账

		IF op='I' THEN
			--先插入返水总记录并取得键值.
			INSERT INTO rakeback_bill (
			 	period, start_time, end_time,
			 	player_count, player_lssuing_count, player_reject_count, rakeback_total, rakeback_actual,
			 	create_time, lssuing_state
			) VALUES (
			 name, start_time, end_time,
			 0, 0, 0, 0, 0,
			 now(), pending_pay
			);
			SELECT currval(pg_get_serial_sequence('rakeback_bill',  'id')) into bill_id;
		ELSE
			FOR rec IN
				SELECT rakeback_bill_id,
					   COUNT(DISTINCT player_id) 	as cl,
					   SUM(rakeback_total) 				as sl
				  FROM rakeback_player
				 WHERE rakeback_bill_id = bill_id
				 GROUP BY rakeback_bill_id
			LOOP
				update rakeback_bill set player_count = rec.cl, rakeback_total = rec.sl WHERE id = bill_id;
			END LOOP;
		END IF;

	ELSEIF flag='N' THEN--未出账

		IF op='I' THEN
			--先插入返水总记录并取得键值.
			INSERT INTO rakeback_bill_nosettled (
			 	start_time, end_time, rakeback_total, create_time
			) VALUES (
			 	start_time, end_time, 0, now()
			);
			SELECT currval(pg_get_serial_sequence('rakeback_bill_nosettled',  'id')) into bill_id;
		ELSE
			FOR rec in
				SELECT rakeback_bill_nosettled_id,
					   COUNT(DISTINCT player_id) 	as cl,
					   SUM(rakeback_total) 				as sl
				FROM rakeback_player_nosettled
				WHERE rakeback_bill_nosettled_id = bill_id
				GROUP BY rakeback_bill_nosettled_id
			LOOP
				update rakeback_bill_nosettled set rakeback_total = rec.sl WHERE id = bill_id;
			END LOOP;
		END IF;

	END IF;
	raise info 'rakeback_bill.完成.键值:%', bill_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, bill_id INT, op TEXT, flag TEXT)
IS 'Lins-返水-返水周期主表';

/**
 * 各玩家API返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	bill_id 	返水键值
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	flag 		出账标示:Y-已出账, N-未出账
 */
DROP FUNCTION IF EXISTS gamebox_rakeback_api(INT, TIMESTAMP, TIMESTAMP, TEXT);
create or replace function gamebox_rakeback_api(
	bill_id 	INT,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	flag 		TEXT
) returns void as $$

DECLARE
	rakeback 	FLOAT:=0.00;
	tmp 		INT:=0;
	rec 		record;

BEGIN
	FOR rec IN
		SELECT rab.player_id,
			   rab.api_id,
			   rab.api_type_id,
			   rab.game_type,
			   up.rakeback_id,
			   up.rank_id,
			   SUM(rab.rakeback)				as rakeback,
			   SUM(rab.effective_transaction)	as effective_trade_amount,
			   SUM(rab.profit_loss) 			as profit_amount
	 	  FROM rakeback_api_base rab
	 	  LEFT JOIN sys_user su ON rab.player_id = su."id"
	 	  LEFT JOIN user_player up ON rab.player_id = up."id"
		 WHERE rakeback_time >= start_time
		   AND rakeback_time < end_time
		 GROUP BY rab.player_id, rab.api_id, rab.api_type_id, rab.game_type, up.rakeback_id, up.rank_id

    LOOP
		IF flag = 'Y' THEN
			INSERT INTO rakeback_api(
				rakeback_bill_id, player_id, api_id, api_type_id, game_type,
				rakeback, effective_transaction, profit_loss
			) VALUES (
			 	bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,
			 	rec.rakeback, rec.effective_trade_amount, rec.profit_amount
			);
		 	SELECT currval(pg_get_serial_sequence('rakeback_api', 'id')) into tmp;
		ELSEIF flag = 'N' THEN
			INSERT INTO rakeback_api_nosettled(
				rakeback_bill_nosettled_id, player_id, api_id, api_type_id, game_type,
				rakeback, effective_transaction, profit_loss
			) VALUES(
				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,
				rec.rakeback, rec.effective_trade_amount, rec.profit_amount
			);
		 	SELECT currval(pg_get_serial_sequence('rakeback_api_nosettled', 'id')) into tmp;
		END IF;
			raise info '各API玩家返水键值:%', tmp;
	END LOOP;

	raise info '收集每个API下每个玩家的返水.完成';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, flag TEXT)
IS 'Lins-返水-各玩家API返水';

/**
 * 各玩家返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	bill_id 	返水键值
 * @param 	flag 		出账标示:Y.已出账, N.未出账
 */
 DROP FUNCTION IF EXISTS gamebox_rakeback_player(INT, TEXT);
 create or replace function gamebox_rakeback_player(
 	bill_id INT,
 	flag TEXT
 ) returns void as $$
 DECLARE
 	rec 				record;
 	pending_lssuing 	text:='pending_lssuing';
 	pending_pay 		text:='pending_pay';
 	max_back_water 		float:=0.00; -- 返水上限
 	backwater 			float:=0.00;
 	gradshash 			hstore;
 	agenthash 			hstore;
 BEGIN
 	raise info '取得当前返水梯度设置信息.';
   	SELECT gamebox_rakeback_api_grads() into gradshash;
   	raise info '取得代理返水设置.';
   	SELECT gamebox_agent_rakeback() 	into agenthash;

 	IF flag = 'Y' THEN--已出账
 		FOR rec IN
 			SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
 				   s.rakeback, pending_lssuing, u.agent_id, u.topagent_id, up.rakeback_id, s.effTrans
 		  	  FROM ( SELECT player_id,
 						    SUM(rakeback) rakeback,
 							SUM(effective_transaction) effTrans
 					   FROM rakeback_api
 					  WHERE rakeback_bill_id = bill_id
 					  GROUP BY player_id) s,
 		  	   	   v_sys_user_tier u,
 				   user_player up
 		 	 WHERE s.player_id = u.id
 			   AND s.player_id = up."id"
 			 ORDER BY u.id, s.effTrans asc
 		LOOP
 			SELECT gamebox_rakeback_limit(rec.rakeback_id, gradshash, agenthash, rec.effTrans) into max_back_water;
 			backwater = rec.rakeback;
 			-- max_back_water 为0表示未设置返水上限
 			IF backwater > max_back_water AND max_back_water<>0 THEN
 				backwater = max_back_water;
 			END IF;
 			INSERT INTO rakeback_player(
 				rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker,
 				rakeback_total, rakeback_actual, settlement_state, agent_id, top_agent_id
 			) VALUES (
 				bill_id, rec.id, rec.username, rec.rank_id, rec.rank_name, rec.risk_marker,
 				backwater, backwater, pending_lssuing, rec.agent_id, rec.topagent_id
 			);
 		END LOOP;

 	ELSEIF flag = 'N' THEN--未出账
 		FOR rec IN
 			SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
 				   s.rakeback, u.agent_id, u.topagent_id, up.rakeback_id, s.effTrans
 		  	  FROM ( SELECT player_id,
 						    SUM(rakeback) rakeback,
 						SUM(effective_transaction) effTrans
 					   FROM rakeback_api_nosettled
 					  WHERE rakeback_bill_nosettled_id = bill_id
 					  GROUP BY player_id) s,
 		  	   	   v_sys_user_tier u,
 				   user_player up
 		 	 WHERE s.player_id = u.id
 			   AND s.player_id = up."id"

 		LOOP
 			SELECT gamebox_rakeback_limit(rec.rakeback_id, gradshash, agenthash, rec.effTrans) into max_back_water;
 			backwater = rec.rakeback;
 			IF backwater > max_back_water AND max_back_water<>0 THEN
 				backwater = max_back_water;
 			END IF;
 			INSERT INTO rakeback_player_nosettled (
 				rakeback_bill_nosettled_id, player_id, username, rank_id, rank_name, risk_marker,
 				rakeback_total, agent_id, top_agent_id
 			) VALUES (
 				bill_id, rec.id, rec.username, rec.rank_id, rec.rank_name, rec.risk_marker,
 				backwater, rec.agent_id, rec.topagent_id
 			);
 		END LOOP;
 	END IF;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_player(bill_id INT, flag TEXT)
IS 'Lins-返水-各玩家返水';

/**
 * 计算返水上限
 * @author 	Tom
 * @date 	2016.03.22
 * @return 	返回float类型，返水值.
 */
drop function IF EXISTS gamebox_rakeback_limit(hstore, hstore);
drop function IF EXISTS gamebox_rakeback_limit(int, hstore, hstore);
drop function IF EXISTS gamebox_rakeback_limit(int, hstore, hstore, float);
CREATE OR REPLACE FUNCTION gamebox_rakeback_limit(
	rakeback_id int,
	gradshash 	hstore,
	agenthash 	hstore,
	volume 		float
) RETURNS FLOAT as $$
DECLARE
	keys 		text[];
	subkeys 	text[];
	keyname 	text:='';
	val 		text:='';
	hash 		hstore;
	max_back_water 	float:=0.00;	--最大返水上限
	tmp_back_water 	float:=0.00;
	tmp_rb_id		int;
  	tmp_rb_volume 	int;
BEGIN
	keys = akeys(gradshash);
	FOR i IN 1..array_length(keys, 1)
	LOOP
		subkeys = regexp_split_to_array(keys[i], '_');
		keyname = keys[i];
		val = gradshash->keyname;
		SELECT * FROM strToHash(val) INTO hash;
		tmp_rb_id = hash->'id';
 		tmp_rb_volume = (hash->'valid_value')::FLOAT;

		IF rakeback_id = tmp_rb_id  THEN
			IF volume >= (tmp_rb_volume::float) THEN
				tmp_back_water = (hash->'max_rakeback')::float;
				IF tmp_back_water > max_back_water THEN
					max_back_water = tmp_back_water;
				end IF;
			end IF;
		end IF;

	END LOOP;
	RETURN max_back_water;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_limit(rakeback_id int, gradshash hstore, agenthash hstore, volume float)
IS 'Lins-返水-计算返水上限';

/**
 * 玩家[API]返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	gradshash 	返水梯度
 * @param 	agenthash 	各代理设置的梯度ID.
 * @param 	category 	类型.API或PLAYER,  区别在于KEY值不同. 另外GAME_TYPE 区别在于统计的维度不同.
 */
DROP FUNCTION IF EXISTS gamebox_rakeback_api_map(TIMESTAMP, TIMESTAMP, hstore, hstore, TEXT);
create or replace function gamebox_rakeback_api_map(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	gradshash 	hstore,
	agenthash 	hstore,
	category 	TEXT
) returns hstore as $$

DECLARE
	hash 		hstore;--玩家API或玩家返水.
	rakeback 	FLOAT:=0.00;
	val 		FLOAT:=0.00;
	key 		TEXT:='';
	col_split 	TEXT:='_';
	rec 		record;
	param 		TEXT:='';
	sql 		TEXT:='';

BEGIN
	SELECT '-1=>-1' INTO hash;
	IF category = 'GAME_TYPE' THEN
		sql = '';
	ELSE
		sql = 'SELECT rab.api_id,
					  rab.game_type,
					  rab.player_id,
					  su.username,
					  COUNT(DISTINCT rab.player_id) 					as player_num,
					  SUM(COALESCE(rab.effective_transaction, 0.00)) 	as effective_trade_amount,
					  up.rakeback_id
				 FROM rakeback_api_base rab
				 LEFT JOIN sys_user su ON rab.player_id = su."id"
				 LEFT JOIN user_player up ON rab.player_id = up."id"
			    WHERE rab.rakeback_time >= $1
				  AND rab.rakeback_time < $2
				  AND up.rakeback_id IS NOT NULL
			    GROUP BY rab.api_id, rab.game_type, rab.player_id, su.username, up.rakeback_id';
	END IF;

	FOR rec IN EXECUTE sql USING start_time, end_time
	LOOP
		-- raise info '用户:%, 梯度:%, api:%, game_type:%', rec.player_id, rec.rakeback_id, rec.api_id, rec.game_type;
		SELECT gamebox_rakeback_calculator(gradshash, agenthash, row_to_json(rec), NULL) into rakeback;
		-- raise info '玩家:%, 有效交易量:%, 返水:%', rec.username, rec.effective_trade_amount, rakeback;

	  	IF category = 'GAME_TYPE' THEN
			key = rec.api_id||col_split||rec.game_type;
			param = key||'=>'||rakeback||col_split||rec.player_num;
			hash = (SELECT param::hstore)||hash;
		ELSEIF category = 'API' THEN
			key = rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
			param = key||'=>'||rakeback;
			hash = (SELECT param::hstore)||hash;
		ELSE
			key = rec.player_id;
			param = key||'=>'||rakeback;
			IF isexists(hash,  key) THEN
				val = (hash->key)::FLOAT;
				val = val + rakeback;
				param = key||'=>'||val;
			END IF;
			hash = (SELECT param::hstore)||hash;
		END IF;
	END LOOP;
	-- raise info 'Last Hash = %',  hash;

	RETURN hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_map(start_time TIMESTAMP, end_time TIMESTAMP, gradshash hstore, agenthash hstore, category TEXT)
IS 'Lins-返水-玩家[API]返水-返佣调用';

/**
 * 返水API梯度.
 * @author 	Lins
 * @date	2015.11.10
 */
drop function if exists gamebox_rakeback_api_grads();
create or replace function gamebox_rakeback_api_grads() returns hstore as $$
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
 		SELECT m.id,
 			   s.id as grads_id,
 			   d.api_id,
 			   d.game_type,
 			   COALESCE(d.ratio,0) 			as ratio,
 			   COALESCE(s.max_rakeback,0) 	as max_rakeback,
 			   COALESCE(s.valid_value,0) 	as valid_value,
 			   m.name,
 			   COALESCE(m.audit_num,0) 		as audit_num
 		  FROM rakeback_grads s, rakeback_grads_api d, rakeback_set m
 		 WHERE s.id = d.rakeback_grads_id
 		   AND s.rakeback_id = m.id
 		   AND m.status='1'
 		 ORDER BY m.id, s.valid_value desc, d.api_id, d.game_type
    	LOOP
 		-- 判断主方案是否存在.
 		-- 键值格式:ID + gradsId + API + gameType
 		keyname = rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text||'_'||rec.valid_value::float;

 		val:=row_to_json(rec);
 		val:=replace(val,',','\|');
 		val:=replace(val,'null','-1');
 		IF (gradshash?keyname) is null OR (gradshash?keyname) = false THEN
 			--gradshash=hash||tmphash;
 			IF gradshash is null THEN
 				select keyname||'=>'||val into gradshash;
 			ELSE
 				select keyname||'=>'||val into tmphash;
 				gradshash = gradshash||tmphash;
 			END IF;

 		ELSE
 			val2 = gradshash->keyname;
 			select keyname||'=>'||val||'^&^'||val2 into tmphash;
 			gradshash = gradshash||tmphash;
 		END IF;
 	END LOOP;

 	return gradshash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_grads()
IS 'Lins-返水-API梯度';

/**
 * 代理默认返水方案.
 * @author 	Lins
 * @date 	2015-11-10
 * @return 	hstore类型
 */
drop function IF EXISTS gamebox_agent_rakeback();
CREATE OR REPLACE FUNCTION gamebox_agent_rakeback()
	returns hstore as $$
DECLARE
	hash 	hstore;
	rec		record;
	param 	text:='';
BEGIN
	FOR rec IN
		SELECT a.user_id,
			   a.rakeback_id
		  FROM user_agent_rakeback a,
			   sys_user u
	     WHERE a.user_id = u.id
		   AND u.user_type = '23'
		   AND a.rakeback_id >= 0
    LOOP
		param = param||rec.user_id||'=>'||rec.rakeback_id||', ';
	END LOOP;
	IF length(param)>0 THEN
		param = substring(param,  1 , length(param)-1);
	END IF;
	--raise info '结果:%', param;
	SELECT param::hstore INTO hash;
	--测试引用值.
  	--raise info '4:%', hash->'3';
	RETURN hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_agent_rakeback()
IS '返水-代理默认方案萃取-Lins';

/*
--测试返水已出账
SELECT  * FROM gamebox_rakeback(
	'5',
	'2016-01-25',
	'2016-01-27',
	'host = 192.168.0.88 port = 5432 dbname = gamebox-mainsite user = postgres password = postgres',
	'Y'
);

--测试返水未出账
SELECT  * FROM gamebox_rakeback(
	'6',
	'2015-01-25',
	'2015-01-27',
	'host = 192.168.0.88 port = 5432 dbname = gamebox-mainsite user = postgres password = postgres',
	'N'
 );
*/
