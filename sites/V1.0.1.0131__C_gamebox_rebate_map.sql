-- auto gen by admin 2016-04-29 20:50:04
/**
 * 玩家[API]返水.
 * @author 	Lins
 * @date 	2015.12.3
 * @param 	startTime 	返水周期开始时间(yyyy-mm-dd HH:mm:ss)
 * @param 	endTime 	返水周期结束时间(yyyy-mm-dd HH:mm:ss)
 * @param 	url 		运营商库的dblink 格式数据
 * @param 	category	类型.API或PLAYER,区别在于KEY值不同.
 */
drop function IF EXISTS gamebox_rakeback_map(TIMESTAMP, TIMESTAMP, text, text);
create or replace function gamebox_rakeback_map(
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP,
	url 		TEXT,
	category 	TEXT
) returns hstore[] as $$

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

	maps = array[hash];
	maps = array_append(maps, rhash);

	RETURN maps;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_map(startTime TIMESTAMP, endTime TIMESTAMP, url TEXT, category TEXT)
IS 'Lins-返水-玩家入口-返佣调用';

/**
 * 获取玩家实际返水.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	startTime 	开始时间
 * @param 	endTime 	结束时间
 */
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
	key_type 	int:=5;	-- API
	maps 		hstore[];
	flag		TEXT:='Y';
BEGIN
	stTime=start_time::TIMESTAMP;
	edTime=end_time::TIMESTAMP;

	raise info '占成.取得当前站点ID';
	SELECT gamebox_current_site() INTO sid;

	raise info '占成.系统各种分摊比例参数';
	SELECT gamebox_sys_param('apportionSetting') INTO sys_map;

	SELECT gamebox_rebate_map(stTime, edTime) INTO rebate_map;
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
DROP FUNCTION IF EXISTS gamebox_rebate_map(TIMESTAMP, TIMESTAMP);
create or replace function gamebox_rebate_map(
	startTime 				TIMESTAMP,
	endTime 				TIMESTAMP
) returns hstore as $$

DECLARE
	rec 				record;
	rebate 				FLOAT:=0.00;--返佣.
	key_name 			TEXT;--运营商占成KEY值.
	rebate_map 			hstore;--各API返佣值.
	col_split 			TEXT:='_';
BEGIN
	FOR rec IN
		SELECT ra.api_id, ra.game_type, SUM(ra.rebate_total) rebate_total
		  FROM rebate_api ra
		  LEFT JOIN rebate_bill rb ON ra.rebate_bill_id = rb."id"
		 WHERE rb.start_time >= startTime
		   AND rb.end_time <= endTime
		 GROUP BY ra.api_id, ra.game_type
		 ORDER BY ra.api_id
	LOOP
		key_name = rec.api_id||col_split||rec.game_type;
		rebate = rec.rebate_total;

		IF rebate_map is null THEN
			SELECT key_name||'=>'||rebate INTO rebate_map;
		ELSEIF exist(rebate_map, key_name) THEN
			rebate = rebate + ((rebate_map->key_name)::FLOAT);
			rebate_map = rebate_map||(SELECT (key_name||'=>'||rebate)::hstore);
		ELSE
			rebate_map = (SELECT (key_name||'=>'||rebate)::hstore)||rebate_map;
		END IF;
	END LOOP;

	RETURN rebate_map;

END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_map(start_time TIMESTAMP, end_time TIMESTAMP)
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
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP
) returns hstore as $$

DECLARE
	rec 		record;
	hash 		hstore;
	mhash 		hstore;
	param 		text:='';
	money 		float:=0.00;
	key_name 	TEXT;

	player_num 	INT:=0;
	apportion 	FLOAT:=0.00;
	rakeback 	FLOAT:=0.00;
	recommend	FLOAT:=0.00;
	refund_fee 	FLOAT:=0.00;
	profit_loss FLOAT:=0.00;
	deposit 	FLOAT:=0.00;
	effe_trans 	FLOAT:=0.00;
	favorable 	FLOAT:=0.00;
	withdraw 	FLOAT:=0.00;
	rebate_tot 	FLOAT:=0.00;
	rebate_act 	FLOAT:=0.00;

BEGIN

	FOR rec IN
		SELECT SUM(ra.effective_player) 		player_num,
			   SUM(ra.apportion) 				apportion,
			   SUM(ra.rakeback) 				rakeback,
			   SUM(ra.recommend) 				recommend,
		 	   SUM(ra.refund_fee) 				refund_fee,
			   SUM(ra.profit_loss) 				profit_loss,
			   SUM(ra.deposit_amount) 			deposit,
			   SUM(ra.effective_transaction) 	effe_trans,
			   SUM(ra.preferential_value) 		favorable,
			   SUM(ra.withdrawal_amount) 		withdraw,
			   SUM(ra.rebate_total) 			rebate_total,
			   SUM(ra.rebate_actual) 			rebate_actual
		  FROM rebate_agent ra
		  LEFT JOIN rebate_bill rb ON ra.rebate_bill_id = rb."id"
		 WHERE rb.start_time >= startTime
		   AND rb.end_time <= endTime
	 LOOP
	 	player_num 	= player_num + rec.player_num;
	 	apportion 	= apportion + rec.apportion;
	 	rakeback 	= rakeback + rec.rakeback;
	 	recommend 	= recommend + rec.recommend;
	 	refund_fee 	= refund_fee + rec.refund_fee;
	 	profit_loss = profit_loss + rec.profit_loss;
	 	deposit 	= deposit + rec.deposit;
	 	effe_trans 	= effe_trans + rec.effe_trans;
	 	favorable 	= favorable + rec.favorable;
		withdraw  	= withdraw + rec.withdraw;
		rebate_tot 	= rebate_tot + rec.rebate_total;
		rebate_act  = rebate_act + rec.rebate_actual;
	END LOOP;

	param = 'player_num=>'||player_num;
	param = param||',apportion=>'||apportion||',rakeback=>'||rakeback||',recommend=>'||recommend;
	param = param||',refund_fee=>'||refund_fee||',profit_loss=>'||profit_loss||',deposit=>'||deposit;
	param = param||',effe_trans=>'||effe_trans||',favorable=>'||favorable||',withdraw=>'||withdraw;
	param = param||',rebate_tot=>'||rebate_tot||',rebate_act=>'||rebate_act;

	SELECT param::hstore INTO hash;

	return hash;
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Lins-分摊费用';

/**
 * 分摊费用与返佣统计
 * @author 	Lins
 * @date 	2015.11.13
 * @param  	bill_id 		返佣主表键值
 * @param 	start_time 		开始时间
 * @param 	end_time		结束时间
 * @param 	row_split
 * @param 	col_split 		列分隔符
 * @return 	返回hstore类型, 以代理ID为KEY值.各种费用按一定格式组成VALUE。
 */
drop function if exists gamebox_rebate_expense_gather(int, hstore, TIMESTAMP, TIMESTAMP, text, text);
drop function if exists gamebox_rebate_expense_gather(int, hstore, TIMESTAMP, TIMESTAMP, text, text, text);
drop function if exists gamebox_rebate_expense_gather(int, TIMESTAMP, TIMESTAMP, text, text, text);
create or replace function gamebox_rebate_expense_gather(
	bill_id 		int,
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

	eff_trans 	FLOAT:=0.00;
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
		user_id 	= rec.player_id::text;
		agent_id 	= rec.owner_id;
		agent_name 	= rec.username;
		money 		= rec.rebate_total;
		loss 		= rec.profit_loss;
		eff_trans 	= rec.effective_transaction;

		IF isexists(hash, user_id) THEN
			param = hash->user_id;
			param = param||row_split||'rebate'||col_split||money::text;
			param = param||row_split||'profit_loss'||col_split||loss::text;
			param = param||row_split||'effective_transaction'||col_split||eff_trans::text;
			param = param||row_split||'agent_name'||col_split||agent_name;
		ELSE
			param = 'rebate'||col_split||money::text;
			param = param||row_split||'profit_loss'||col_split||loss::text;
			param = param||row_split||'effective_transaction'||col_split||eff_trans::text;
			param = param||row_split||'agent_name'||col_split||agent_name;
		END IF;
		IF position('agent_id' in param) = 0 THEN
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
COMMENT ON FUNCTION gamebox_rebate_expense_gather(bill_id int, startTime TIMESTAMP, endTime TIMESTAMP, row_split_char text, col_split_char text, flag TEXT)
IS 'Lins-返佣-分摊费用与返佣统计';

DROP VIEW IF EXISTS v_rebate_report;
CREATE OR REPLACE VIEW v_rebate_report AS
SELECT rg."id",
	   rg.agent_name,
	   su.username	topagent_name,
	   rg.effective_player,
	   rg.effective_transaction,
	   rg.profit_loss,
	   rg.deposit_amount,
	   rg.withdrawal_amount,
	   rg.rakeback,
	   (rg.preferential_value + rg.recommend) as preferential_value,
	   rg.apportion,
	   rg.refund_fee,
	   rg.rebate_total,
	   rg.rebate_actual,
	   rg.settlement_state,
	   rb.start_time,
	   rb.end_time,
	   rb.period
  FROM rebate_bill rb
  LEFT JOIN rebate_agent rg ON rb."id" = rg.rebate_bill_id
  LEFT JOIN user_agent ua ON rg.agent_id = ua."id"
  LEFT JOIN sys_user su ON ua.parent_id = su."id"
 WHERE rg."id" IS NOT NULL
   AND rb.end_time >= now()-interval '90 day';

ALTER TABLE v_rebate_report OWNER TO postgres;
COMMENT ON VIEW v_rebate_report IS '返佣统计详细视图 - Fei';