-- auto gen by fly 2016-01-25 19:15:04

--玩家层级信息
drop view if EXISTS v_sys_user_tier;
create or REPLACE view v_sys_user_tier as
	SELECT p.id, p.username,
		   r.id rank_id,
		   r.rank_name,
		   r.rank_code,
		   r.risk_marker,
		   a.id agent_id,
		   a.username agent_name,
		   t.id topagent_id,
		   t.username topagent_name
	  FROM sys_user a,  sys_user p,  sys_user t,  user_player up,  player_rank r
	 WHERE a.id = p.owner_id
	   AND a.owner_id = t.id
	   AND a.user_type='23'
	   AND p.user_type='24'
	   AND t.user_type='22'
	   AND p.id = up.id
	   AND p.status='1'
	   AND up.rank_id = r.id
	 ORDER BY p.id;
COMMENT ON VIEW "v_sys_user_tier" IS '玩家层级信息-Lins';

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
  	gradshash 	hstore;
	agenthash 	hstore;
	a1 	text;
	a2 	text;
	a3 	text;
	stTime 	TIMESTAMP;
	edTime 	TIMESTAMP;
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
	vname 			text:='v_site_game';
	bill_id 		INT:=-1;
	sid 			INT;
BEGIN
	raise info '开始统计( % )的返水, 周期( %-% )', name, startTime, endTime;
	raise info '创建站点游戏视图';

	SELECT gamebox_current_site() INTO sid;

  	perform gamebox_site_game(url, vname, sid, 'C');

	-- 取得当前返水梯度设置信息.
  	SELECT gamebox_rakeback_api_grads() into gradshash;
  	SELECT gamebox_agent_rakeback() 	into agenthash;

	stTime = startTime::TIMESTAMP;
	edTime = endTime::TIMESTAMP;

	raise info '返水总表数据预新增.';
	SELECT gamebox_rakeback_bill(name, stTime, edTime, bill_id, 'I', flag) INTO bill_id;

	-- 收集每个API下每个玩家的返水.
  	raise info '统计玩家API返水';
	perform gamebox_rakeback_api(bill_id, stTime, edTime, gradshash, agenthash, flag);
	raise info '统计玩家API返水.完成';

	raise info '统计玩家返水';
  	perform gamebox_rakeback_player(bill_id, flag);
	raise info '统计玩家返水.完成';

  	raise info '更新返水总表';
	perform gamebox_rakeback_bill(name, stTime, edTime, bill_id, 'U', flag);

	-- 删除临时视图表.
	perform gamebox_site_game(url, vname, sid, 'D');

	-- exception
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS a1 = MESSAGE_TEXT, a2 = PG_EXCEPTION_DETAIL, a3 = PG_EXCEPTION_HINT;
	raise EXCEPTION '异常:%, %, %', a1, a2, a3;

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
			FOR rec in
				SELECT rakeback_bill_id,
					   count(player_id) as cl,
					   sum(rakeback) 	as sl
				  FROM rakeback_api
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
					   count(player_id) as cl,
					   sum(rakeback) 	as sl
				FROM rakeback_api_nosettled
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
 * @param 	返水键值
 * @param 	开始时间
 * @param 	结束时间
 * @param 	返水梯度
 * @param 	各代理设置的梯度ID.
 * @param 	出账标示:Y-已出账, N-未出账
 */
DROP FUNCTION IF EXISTS gamebox_rakeback_api(INT, TIMESTAMP, TIMESTAMP, hstore, hstore, TEXT);
create or replace function gamebox_rakeback_api(
	bill_id 	INT,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	gradshash 	hstore,
	agenthash 	hstore,
	flag 		TEXT
) returns void as $$

DECLARE
	rakeback 	FLOAT:=0.00;
	tmp 		INT:=0;
	rec 		record;

BEGIN
	FOR rec IN
		SELECT pg.player_id userid,
			   su.username,
			   su.owner_id,
			   pg.api_id,
			   pg.api_type_id,
			   pg.game_type,
			   pg.effective_trade_amount,
			   up.rakeback_id,
			   up.rank_id,
			   pg.profit_amount
		  FROM ( SELECT po.player_id,
						po.api_id,
						po.game_type,
						po.api_type_id,
						sum(COALESCE(po.effective_trade_amount, 0.00)) 	as effective_trade_amount,
						sum(COALESCE(po.profit_amount, 0.00)) 			as profit_amount
				   FROM player_game_order po
				  WHERE po.create_time >= start_time
					AND po.create_time < end_time
				  GROUP BY po.player_id, po.api_id, po.game_type, po.api_type_id) pg
		  LEFT JOIN user_player up ON pg.player_id = up.id, sys_user su
	 	 WHERE pg.player_id = su.id
	 	   AND pg.player_id = 611

    LOOP
    	raise info 'rakeback calc start...';
		SELECT gamebox_rakeback_calculator(gradshash, agenthash, row_to_json(rec)) into rakeback;
    	raise info 'rakeback calc over.';

		raise info '玩家:%, 有效交易量:%, 返水:%', rec.username, rec.effective_trade_amount, rakeback;
		raise info '梯度:%, api:%, game_type:%', rec.rakeback_id, rec.api_id, rec.game_type;
		--新增玩家返水:有返水才新增.
		IF rakeback > 0 THEN
			IF flag = 'Y' THEN
				INSERT INTO rakeback_api(
					rakeback_bill_id, player_id, api_id, api_type_id, game_type,
					rakeback, effective_transaction, profit_loss
				) VALUES (
				 	bill_id, rec.userId, rec.api_id, rec.api_type_id, rec.game_type,
				 	rakeback, rec.effective_trade_amount, rec.profit_amount
				);
			 	SELECT currval(pg_get_serial_sequence('rakeback_api',  'id')) into tmp;
			ELSEIF flag = 'N' THEN
				INSERT INTO rakeback_api_nosettled(
					rakeback_bill_nosettled_id, player_id, api_id, api_type_id, game_type,
					rakeback, effective_transaction, profit_loss
				) VALUES(
					bill_id, rec.userId, rec.api_id, rec.api_type_id, rec.game_type,
					rakeback, rec.effective_trade_amount, rec.profit_amount
				);
			 	SELECT currval(pg_get_serial_sequence('rakeback_api_nosettled',  'id')) into tmp;
			END IF;
			raise info '各API玩家返水键值:%', tmp;
		END IF;
	END LOOP;

	raise info '收集每个API下每个玩家的返水.完成';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, gradshash hstore, agenthash hstore, flag TEXT)
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
	pending_lssuing 	text:='pending_lssuing';
	pending_pay 		text:='pending_pay';
BEGIN
	IF flag = 'Y' THEN--已出账
		INSERT INTO rakeback_player(
			rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker,
			rakeback_total, settlement_state, agent_id, top_agent_id
		)
		SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
			s.rakeback, pending_lssuing, u.agent_id, u.topagent_id
		  FROM ( SELECT player_id,
						sum(rakeback) rakeback
				   FROM rakeback_api
				  WHERE rakeback_bill_id = bill_id
				  GROUP BY player_id) s,
		  	   v_sys_user_tier u
		 WHERE s.player_id = u.id;

	ELSEIF flag='N' THEN--未出账
		INSERT INTO rakeback_player_nosettled (
			rakeback_bill_nosettled_id, player_id, username, rank_id, rank_name, risk_marker,
			rakeback_total, top_agent_id, agent_id
		)
		SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
			s.rakeback, u.topagent_id, u.agent_id
		  FROM ( SELECT player_id,
					  	sum(rakeback) rakeback
				 FROM rakeback_api_nosettled
				WHERE rakeback_bill_nosettled_id = bill_id
				GROUP BY player_id) s,
		  	   v_sys_user_tier u
		 WHERE s.player_id = u.id;
	END IF;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_player(bill_id INT, flag TEXT)
IS 'Lins-返水-各玩家返水';

/**
 * 玩家[API]返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @param 	gradshash 	返水梯度
 * @param 	agenthash 	各代理设置的梯度ID.
 * @param 	category 	类型.API或PLAYER,  区别在于KEY值不同. 另外GAME_TYPE 区别在于统计的维度不同.
 * @param 	vname 		站点游戏表临时视图.
 */
DROP FUNCTION IF EXISTS gamebox_rakeback_api_map(TIMESTAMP,  TIMESTAMP,  hstore,  hstore,  TEXT,  TEXT);
create or replace function gamebox_rakeback_api_map(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	gradshash 	hstore,
	agenthash 	hstore,
	category 	TEXT,
	vname 		TEXT
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
		sql = ' SELECT p.api_id,
					   p.game_type,
					   p.player_num,
					   p.effective_trade_amount,
					   up.rakeback_id
				  FROM (SELECT g.api_id,
				  			   g.game_type,
				  			   sum(distinct po.player_id)  		as player_num,
				  			   sum(po.effective_trade_amount) 	as effective_trade_amount
						  FROM player_game_order po,  '||vname||' g
						 WHERE po.game_id = g.id
						   AND po.create_time >= $1
						   AND po.create_time < $2
						 GROUP BY g.api_id,  g.game_type
					   ) p
				  LEFT JOIN user_player up on p.player_id = up.id';
	END IF;

	raise info 'gamebox_rakeback_api_map.sql = %',  sql;

	FOR rec IN EXECUTE sql USING start_time,  end_time
	LOOP
		--raise info '用户:%,  梯度:%,  api:%,  game_type:%',  rec.player_id,  rec.rakeback_id,  rec.api_id,  rec.game_type;
		SELECT gamebox_rakeback_calculator(gradshash,  agenthash,  row_to_json(rec)) into rakeback;
		--raise info '玩家:%,  有效交易量:%,  返水:%',  rec.username,  rec.effective_trade_amount,  rakeback;

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
				val = val+rakeback;
				param = key||'=>'||val;
			END IF;
			hash = (SELECT param::hstore)||hash;
		END IF;
	END LOOP;
	raise info 'Last Hash = %',  hash;

	RETURN hash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_map(start_time TIMESTAMP,  end_time TIMESTAMP,  gradshash hstore,  agenthash hstore,  category TEXT,  vname TEXT)
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
	FOR rec IN
		SELECT rs.id,
			   rg.id as grads_id,
			   rga.api_id,
			   rga.game_type,
			   COALESCE(rga.ratio, 0) 		as ratio,
			   COALESCE(rg.max_rakeback, 0) as max_rakeback,
			   COALESCE(rg.valid_value, 0) 	as valid_value,
			   rs.name,
			   COALESCE(rs.audit_num, 0) 	as audit_num
		  FROM rakeback_grads 		rg,
		  	   rakeback_grads_api 	rga,
		  	   rakeback_set 		rs
		 WHERE rg.id = rga.rakeback_grads_id
		   AND rg.rakeback_id = rs.id
		   AND rs.status = '1'
		 ORDER BY rs.id, rga.api_id, rga.game_type, rg.valid_value desc;
   LOOP
		--判断主方案是否存在.
		--键值格式:ID+GRADSID+API+GAMETYPE
		keyname = rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text;
		--val:=row_to_json(row(5, 6, 7, 8, 9));
		val:=row_to_json(rec);
		val:=replace(val, ', ', '\|');
		val:=replace(val, 'null', '-1');
		--raise info 'count:%', array_length(akeys(gradshash),  1);
		if (gradshash?keyname) is null OR (gradshash?keyname) =false THEN
		--gradshash = hash||tmphash;

		if gradshash is null then
			SELECT keyname||'=>'||val into gradshash;
		ELSE
			SELECT keyname||'=>'||val into tmphash;
			gradshash = gradshash||tmphash;
		end IF;
		-- raise info 'gradsHash=%', gradshash->keyname;

		else
			val2 = gradshash->keyname;
			--raise info '原值=%', gradshash->keyname;
			SELECT keyname||'=>'||val||'^&^'||val2 into tmphash;
			gradshash = gradshash||tmphash;
			--raise info '新值=%', gradshash->keyname;
		end if;
		--raise info '============';
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
		   AND u.user_type = '22'
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
COMMENT ON FUNCTION gamebox_agent_rakeback() IS '返水-代理默认方案萃取-Lins';

/*
--测试返水已出账
SELECT  * FROM gamebox_rakeback(
	'5',
	'2016-01-25',
	'2016-01-26',
	'host = 192.168.0.88 port = 5432 dbname = gamebox-mainsite user = postgres password = postgres',
	'Y'
);

--测试返水未出账
 SELECT  * FROM gamebox_rakeback('2015-11第二期', '2015-01-08', '2015-11-14'
, 'host = 192.168.0.88 port = 5432 dbname = gamebox-mainsite user = postgres password = postgres'
 , 'N');

 */
