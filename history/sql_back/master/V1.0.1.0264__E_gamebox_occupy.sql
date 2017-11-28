-- auto gen by Lins 2015-12-16 06:25:37



/*
* 统计总代API占成.
* @author Lins
* @date 2015.12.2
* @参数1:返佣KEY.
* @参数2:返佣周期开始时间(yyyy-mm-dd)
* @参数3:返佣周期结束时间(yyyy-mm-dd)
* @参数4:各种费用(优惠、推荐、返手续费、返水)hash
* @参数5:各玩家返水hash
*/
DROP FUNCTION IF EXISTS gamebox_occupy_api(INT,TIMESTAMP,TIMESTAMP,hstore,hstore,hstore,hstore,hstore);
create or replace function gamebox_occupy_api(
bill_id INT
,start_time TIMESTAMP
,end_time TIMESTAMP
,occupy_grads_map hstore
,operation_occupy_map hstore
,rakeback_map hstore
,rebate_grads_map hstore
,agent_check_map hstore
) returns void as $$
DECLARE
	rec record;
	rakeback FLOAT:=0.00;--返水.
	rebate_value FLOAT:=0.00;--返佣.
	occupy_value FLOAT:=0.00;--占成.
	operation_occupy FLOAT:=0.00;--运营商API占成额

	tmp int:=0;
	keyname TEXT:='';
	col_split TEXT:='_';
	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
BEGIN
  raise info '计算各API各代理的盈亏总和';
	FOR rec IN
		SELECT
		a.owner_id,--总代
		a.id agent_id,--代理
		u.id,--玩家
		g.api_id,
		g.game_type,
		g.api_type_id,
		COALESCE(sum(-o.profit_amount),0.00) as profit_amount,
		COALESCE(sum(o.effective_trade_amount),0.00) AS effective_trade_amount
		from player_game_order o,v_site_game g,sys_user u,sys_user a
		where o.game_id=g.id
		and o.player_id=u.id
		and u.user_type='24' --TYPE 为玩家
		and u.owner_id=a.id --代理
		and a.user_type='23' --TYPE 为代理
		and o.create_time>=start_time and o.create_time<end_time
		group by a.owner_id,a.id,u.id,g.api_id,g.game_type,g.api_type_id
		order by a.owner_id,a.id,u.id
  LOOP
		keyname=rec.id||col_split||rec.api_id||col_split||rec.game_type;
		operation_occupy=(operation_occupy_map->keyname)::FLOAT;
		operation_occupy=coalesce(operation_occupy,0);

		select gamebox_rebate_calculator(rebate_grads_map,agent_check_map
		,rec.agent_id,rec.api_id,rec.game_type,rec.profit_amount,operation_occupy) INTO rebate_value;
		--取得各API占成
		select gamebox_occupy_api_calculator(occupy_grads_map,operation_occupy_map
			,rec.owner_id,rec.id,rec.api_id,rec.game_type,rec.profit_amount) into occupy_value;

		--keyname=rec.id||col_split||rec.api_id||col_split||rec.game_type;
		rakeback=0.00;
		--raise info 'rakeback_map=%',rakeback_map;
		IF isexists(rakeback_map,keyname) THEN
			rakeback=(rakeback_map->keyname)::FLOAT;
		END IF;
		INSERT INTO occupy_api(
			occupy_bill_id,player_id,api_id
			,game_type,api_type_id,occupy_total
			,effective_transaction,profit_loss,rakeback,rebate
			) VALUES(
			 bill_id,rec.id,rec.api_id
			 ,rec.game_type,rec.api_type_id,occupy_value
			,rec.effective_trade_amount,rec.profit_amount,rakeback,rebate_value
			);
		SELECT currval(pg_get_serial_sequence('occupy_api', 'id')) into tmp;
		-- raise info '总代占成.API键值:%',tmp;
  --END IF;
	END LOOP;
END;
$$ language plpgsql;
COMMENT ON FUNCTION
 gamebox_occupy_api(
bill_id INT
,start_time TIMESTAMP
,end_time TIMESTAMP
,occupy_grads_map hstore
,operation_occupy_map hstore
,rakeback_map hstore
,rebate_grads_map hstore
,agent_check_map hstore
) IS 'Lins-返佣-统计各玩家API返佣';



/*
* 总代各API占成.
* @author Lins
* @date 2015.12.17
* @参数1:开始时间 TIMESTAMP
* @参数2:结束时间 TIMESTAMP
* @参数3:总代占成梯度map
* @参数4:运营商占成map
*/
DROP FUNCTION IF EXISTS gamebox_occupy_api_map(TIMESTAMP,TIMESTAMP,hstore,hstore);
create or replace function gamebox_occupy_api_map(
start_time TIMESTAMP
,end_time TIMESTAMP
,occupy_grads_map hstore
,operation_occupy_map hstore
) returns hstore as $$
DECLARE
	rec record;
	key_name TEXT:='';
	col_split TEXT:='_';

	operation_occupy_value FLOAT:=0.00;--运营商API占成金额
	occupy_value FLOAT:=0.00;--占成金额
	profit_amount FLOAT:=0.00;--盈亏总和

	api INT;
	game_type TEXT;
	owner_id TEXT;
	name TEXT:='';
	retio FLOAT:=0.00;--占成比例

	api_map hstore;
	--rs TEXT:='~';--此值调用同步
	--cs TEXT:='^';--此值调用同步
	--sp TEXT:='@';--此值调用同步
	param TEXT:='';

	sys_config hstore;
	sp TEXT:='@';
	rs TEXT:='\~';
	cs TEXT:='\^';
BEGIN
	--取得系统变量
	select sys_config() INTO sys_config;
	sp=sys_config->'sp_split';
	rs=sys_config->'row_split';
	cs=sys_config->'col_split';

	FOR rec IN
		SELECT
		u.topagent_id,
		u.topagent_name,
		o.api_id,
		o.game_type,
		COALESCE(sum(-o.profit_amount),0.00) as profit_amount,
		COALESCE(sum(o.effective_trade_amount),0.00) AS effective_trade_amount
		FROM player_game_order o,v_sys_user_tier u
		WHERE o.player_id=u.id
		AND o.create_time>=start_time
		AND o.create_time<end_time
		GROUP BY u.topagent_id,u.topagent_name,o.api_id,o.game_type
  LOOP
		api=rec.api_id;
		game_type=rec.game_type;
		owner_id=rec.topagent_id::TEXT;
		name=rec.topagent_name;
		profit_amount=rec.profit_amount;

		--取得运营商API占成.
		key_name=api||col_split||game_type;
		operation_occupy_value=0.00;
		IF exist(operation_occupy_map,key_name) THEN
			operation_occupy_value=(operation_occupy_map->key_name)::FLOAT;
		END IF;

		--计算总代占成.
		occupy_value=0.00;
		key_name=owner_id||col_split||api||col_split||game_type;
		retio=0.00;
		IF exist(occupy_grads_map,key_name) THEN
			retio=(occupy_grads_map->key_name)::FLOAT;
			occupy_value=(profit_amount-operation_occupy_value)*retio/100;
		ELSE
			raise info '总代ID:%,API:%,GAME_TYPE:%未设置占成.',owner_id,api,game_type;
		END IF;
		--格式:id->'name@api^type^val~api^type^val^retio

		key_name=owner_id;
		IF api_map is null THEN
			param=name||sp||api||cs||game_type||cs||occupy_value||cs||retio||cs||profit_amount;
			SELECT key_name||'=>'||param INTO api_map;
		ELSEIF exist(api_map,key_name) THEN
			param=api_map->key_name;
			param=param||rs||api||cs||game_type||cs||occupy_value||cs||retio||cs||profit_amount;
			api_map=api_map||(SELECT (key_name||'=>'||param)::hstore);
		ELSE
			param=name||sp||api||cs||game_type||cs||occupy_value||cs||retio||cs||profit_amount;
			api_map=api_map||(SELECT (key_name||'=>'||param)::hstore);
		END IF;

	END LOOP;
	RETURN api_map;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_api_map(
start_time TIMESTAMP
,end_time TIMESTAMP
,occupy_grads_map hstore
,operation_occupy_map hstore
) IS 'Lins-总代占成-各API占成';


/**
* 总代占成-当前周期的返佣
* @author Lins
* @date 2015.12.17
* 参数1.开始时间
* 参数2.结束时间
* 参数3.行分隔符
* 参数4.列分隔符
* 参数5.各种费用map
* 返回hstore类型
*/
drop function if EXISTS gamebox_occupy_value(TIMESTAMP,TIMESTAMP,hstore);
create or replace function gamebox_occupy_value(
start_time TIMESTAMP
,end_time TIMESTAMP
,expense_map hstore
) returns hstore as $$
DECLARE
	rec record;
	--cs text:='^';--列分隔符
	--rs text:='^&^';--行分隔符
	key_name TEXT:='';
	param TEXT:='';
	name TEXT:='';

	sys_config hstore;
	sp TEXT:='@';
	rs TEXT:='\~';
	cs TEXT:='\^';
BEGIN
	--取得系统变量
	select sys_config() INTO sys_config;
	sp=sys_config->'sp_split';
	rs=sys_config->'row_split';
	cs=sys_config->'col_split';

		FOR rec IN EXECUTE
			'SELECT u.topagent_id,u.topagent_name as name,SUM(a.rebate_total) rebate_total
			FROM rebate_bill b,rebate_agent a,v_sys_user_tier u
			WHERE b.id=a.rebate_bill_id
			AND b.start_time>=$1 AND b.end_time<$2
			AND a.agent_id=u.agent_id
			GROUP BY u.topagent_id,u.topagent_name '
		  USING start_time,end_time
		LOOP
			key_name=rec.topagent_id::TEXT;
			name=rec.name;
			IF expense_map is null THEN
				param='user_name'||cs||name||rs||'rebate'||cs||rec.rebate_total::TEXT;
				SELECT key_name||'=>'||param INTO expense_map;
			ELSEIF exist(expense_map,key_name) THEN
				param=expense_map->key_name;
				param=param||rs||'rebate'||cs||rec.rebate_total::TEXT;
				expense_map=expense_map||(SELECT (key_name||'=>'||param)::hstore);
			ELSE
				param='user_name'||cs||name||rs||'rebate'||cs||re.rebate_total;
				expense_map=expense_map||(SELECT (key_name||'=>'||param)::hstore);
			END IF;
		END LOOP;
		RETURN expense_map;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_value(
start_time TIMESTAMP
,end_time TIMESTAMP
,expense_map hstore
) IS 'Lins-总代占成-当前周期的返佣';

/*
* 分摊计算.
* @author Lins
* @date 2015.12.17
* @参数1:各种分摊费用
* @参数2:系统参数
* @参数3:类别.REBATE.返佣,OCCUPY.占成
*/
drop function if exists gamebox_expense_calculate(hstore,hstore,TEXT);
create or replace function gamebox_expense_calculate(
cost_map hstore
,sys_map hstore
,category TEXT
) returns hstore as $$
DECLARE
  keys text[];
	mhash hstore;
	keyname text:='';
	val text:='';
	tmp TEXT:='';
	--返水
  backwater float:=0.00;
  backwater_apportion float:=0.00;
	--优惠
	favourable float:=0.00;
	favourable_apportion float:=0.00;
	--手续费
  refund_fee float:=0.00;
	refund_fee_apportion float:=0.00;
	--推荐
  recommend float:=0.00;
	recommend_apportion float:=0.00;
	--返佣
  rebate float:=0.00;
	rebate_apportion float:=0.00;
	--分摊费用
	apportion FLOAT:=0.00;
	retio FLOAT:=0.00;
	retio2 FLOAT:=0.00;

	sys_config hstore;
	sp TEXT:='@';
	rs TEXT:='\~';
	cs TEXT:='\^';
BEGIN
	--取得系统变量
	select sys_config() INTO sys_config;
	sp=sys_config->'sp_split';
	rs=sys_config->'row_split';
	cs=sys_config->'col_split';

		 IF cost_map is null THEN
				RETURN cost_map;
		 END IF;
		 keys=akeys(cost_map);
		 FOR i in 1..array_length(keys, 1) LOOP
				keyname=keys[i];
				val=cost_map->keyname;
				tmp=val;
				--转换成hstore数据格式:key1=>value1,key2=>value2
				tmp=replace(tmp,rs,',');
		    tmp=replace(tmp,cs,'=>');
				select tmp into mhash;
        --val=backwater=>20,favourable=>6,refund_fee=>18,recommend=>14,rebate=>-29.5
				backwater=0.00;--返水
				IF exist(mhash, 'backwater') THEN
					backwater=(mhash->'backwater')::float;
				END IF;
				favourable=0.00;--优惠
				IF exist(mhash, 'favourable') THEN
					favourable=(mhash->'favourable')::float;
				END IF;
				refund_fee=0.00;--返手续费
				IF exist(mhash, 'refund_fee') THEN
					refund_fee=(mhash->'refund_fee')::float;
				END IF;
				recommend=0.00;--推荐
				IF exist(mhash, 'recommend') THEN
					recommend=(mhash->'recommend')::float;
				END IF;

				rebate=0.00;
				IF exist(mhash, 'rebate') THEN
					rebate=(mhash->'rebate')::float;
				END IF;

				backwater=COALESCE(backwater,0);
				favourable=COALESCE(favourable,0);
				refund_fee=COALESCE(refund_fee,0);
				recommend=COALESCE(recommend,0);
				rebate=COALESCE(rebate,0);

			  --计算各种优惠.
				/*
				计算各种优惠.
				1、返水承担费用=赠送给体系下玩家的返水 * 代理承担比例；
				2、优惠承担费用=赠送给体系下玩家的优惠 * 代理承担比例；
				3、返还手续费承担费用=返还给体系下玩家的手续费 * 代理承担比例；
			  */
			  --优惠与推荐分摊
				retio2=0.00;
				retio=0.00;
			  IF isexists(sys_map, 'agent.preferential.percent') THEN
					retio2=(sys_map->'agent.preferential.percent')::float;--代理分摊比例
				END IF;
				IF isexists(sys_map, 'topagent.preferential.percent') THEN
					retio=(sys_map->'topagent.preferential.percent')::float;
				END IF;
				IF category='OCCUPY' THEN
					retio=(1-retio2/100)*retio/100;
				ELSE
					retio=retio2/100;
				END IF;
				favourable_apportion=(favourable+recommend)*retio;

				--返水分摊
				retio2=0.00;
				retio=0.00;
			  IF isexists(sys_map, 'agent.rakeback.percent') THEN
					retio2=(sys_map->'agent.rakeback.percent')::float;--代理分摊比例
				END IF;
				IF isexists(sys_map, 'topagent.rakeback.percent') THEN
					retio=(sys_map->'topagent.rakeback.percent')::float;
				END IF;
				IF category='OCCUPY' THEN
					retio=(1-retio2/100)*retio/100;
				ELSE
					retio=retio2/100;
				END IF;
				backwater_apportion=backwater*retio;

				--手续费优惠分摊
				retio2=0.00;
				retio=0.00;
			  IF isexists(sys_map, 'agent.poundage.percent') THEN
					retio2=(sys_map->'agent.poundage.percent')::float;--代理分摊比例
				END IF;
				IF isexists(sys_map, 'topagent.poundage.percent') THEN
					retio=(sys_map->'topagent.poundage.percent')::float;
				END IF;
				IF category='OCCUPY' THEN
					retio=(1-retio2/100)*retio/100;
				ELSE
					retio=retio2/100;
				END IF;
				refund_fee_apportion=refund_fee*retio;

				--返佣分摊
				rebate_apportion=0;
				retio=0.00;
				IF isexists(sys_map, 'topagent.rebate.percent') THEN
					retio=(sys_map->'topagent.rebate.percent')::float;
					rebate_apportion=rebate*retio/100;
				END IF;

				--occupy=occupy-rebate-favourable-backwater-refund_fee;
				apportion=favourable_apportion+backwater_apportion+refund_fee_apportion;

				val=val||rs||'apportion'||cs||apportion;
				val=val||rs||'rebate_apportion'||cs||rebate_apportion;
				val=val||rs||'favourable_apportion'||cs||favourable_apportion;
				val=val||rs||'backwater_apportion'||cs||backwater_apportion;
				val=val||rs||'refund_fee_apportion'||cs||refund_fee_apportion;
				cost_map=cost_map||(SELECT (keyname||'=>'||val)::hstore);
		 END LOOP;
   RETURN cost_map;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense_calculate(
cost_map hstore
,sys_map hstore
,category TEXT
) IS 'Lins-费用分摊计算';


/**
* 总代各种费用及分摊
* @author Lins
* @date 2015.11.13
* 参数2.开始时间
* 参数3.结束时间
* 参数4.行分隔符
* 参数5.列分隔符
* 返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
*/
drop function if EXISTS gamebox_occupy_expense_map(TIMESTAMP,TIMESTAMP,hstore);
create or replace function gamebox_occupy_expense_map(
start_time TIMESTAMP
,end_time TIMESTAMP
,sys_map hstore
) returns hstore as $$
DECLARE
	expense_map hstore;
BEGIN
		--取得各项费用
		select gamebox_expense_gather(start_time,end_time,'TOP') INTO expense_map;
		raise info '各项费用:%',expense_map;
		--取得返佣值
		SELECT gamebox_occupy_value(start_time,end_time,expense_map) INTO expense_map;
		--计算费用分摊
		SELECT gamebox_expense_calculate(expense_map,sys_map,'OCCUPY') INTO expense_map;
		raise info '费用分摊%',expense_map;
		RETURN expense_map;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_expense_map(
start_time TIMESTAMP
,end_time TIMESTAMP
,sys_map hstore
)IS 'Lins-总代占成-费用及分摊';


/*
* 总代占成.入口
* @author Lins
* @date 2015.11.18
* @参数1:占成周期名称.
* @参数2:占成周期开始时间(yyyy-mm-dd HH:mm:ss),周期一般以月为周期.
* @参数3:占成周期结束时间(yyyy-mm-dd HH:mm:ss)
* @参数4:dblink格式URL
	返回为空.
* 调用例子:
* select * from gamebox_occupy('2015-01-08','2015-11-14'
	,'host=192.168.0.88 dbname=gamebox_mainsite user=postgres password=postgresql');
*/
drop function if exists gamebox_occupy_map(text,text,text);
create or replace function gamebox_occupy_map(
url text
,start_time text
,end_time text
) returns hstore[] as $$
DECLARE
	sys_map hstore;--系统设置各种承担比例.
  occupy_grads_map hstore;--各API的占成设置
	operation_occupy_map hstore;--运营商各API占成比例.

	mhash hstore;--临时
	api_map hstore;--各API占成额
	cost_map hstore;--费用及分摊

	stTime TIMESTAMP;
	edTime TIMESTAMP;

	sid INT;--站点ID.

	is_max BOOLEAN:=true;
	key_type int:=4;
	category TEXT:='AGENT';
BEGIN
	--url='host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres';
	stTime=start_time::TIMESTAMP;
	edTime=end_time::TIMESTAMP;

	raise info '统计总代占成,时间( %-% )',start_time,end_time;

	raise info '占成.取得当前站点ID';
	select gamebox_current_site() INTO sid;

	raise info '占成.系统各种分摊比例参数';
	select gamebox_sys_param('apportionSetting') into sys_map;

	--取得各API的运营商占成.
	raise info '取得运营商各API占成';
	select gamebox_operations_occupy(url,sid,stTime,edTime
	,category,is_max,key_type) into operation_occupy_map;

	raise info '取得当前返佣梯度设置信息';
  select gamebox_occupy_api_set() into occupy_grads_map;

  raise info '总代.API占成';
	select gamebox_occupy_api_map(stTime,edTime,occupy_grads_map,operation_occupy_map) INTO api_map;

  raise info '总代.费用及分摊';
	select gamebox_occupy_expense_map(stTime,edTime,sys_map) INTO cost_map;
	--sys_map=(select ('site_id=>'||sid)::hstore)||sys_map;
	raise info 'API占成:%',api_map;
	raise info '各项费用:%',cost_map;
	RETURN array[api_map,cost_map];
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_map(
url text
,start_time text
,end_time text
) IS 'Lins-总代占成-入口-外调';



/**
* 根据计算周期统计各总代的分摊费用(返佣,返水、优惠、推荐、返手续费)
* @author Lins
* @date 2015.11.13
* 参数1.占成主表键值
* 参数2.开始时间
* 参数3.结束时间
* 参数4.行分隔符
* 参数5.列分隔符
* 返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
*/
drop function if EXISTS gamebox_occupy_expense_gather(INT,TIMESTAMP,TIMESTAMP);
create or replace function gamebox_occupy_expense_gather(
bill_id INT
,start_time TIMESTAMP
,end_time TIMESTAMP
) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	mhash hstore;
	param text:='';
	player_id text:='';
	money float:=0.00;--占成.
	--发放状态
	issue_state text:='lssuing';
	col_split text:='^';
	row_split text:='^&^';
	trans FLOAT:=0.00;--有效交易量
	loss FLOAT:=0.00;--盈亏总和
	backwater FLOAT:=0.00;--返水.
	rebate_value FLOAT:=0.00;--返佣

BEGIN
		raise info '分摊费用[返水、优惠、推荐、返手续费]';
		--select gamebox_expense_gather(start_time,end_time,row_split,col_split) INTO hash;
		select gamebox_expense_gather(start_time,end_time,'TOP') INTO hash;
		raise info '%',hash;
	  --统计各代理返佣.
		FOR rec IN
			 SELECT p.player_id,u.username
			 ,SUM(p.effective_transaction) effective_transaction,SUM(p.profit_loss) profit_loss
			 ,SUM(occupy_total) occupy_total,SUM(rakeback) rakeback,SUM(rebate) rebate
			 FROM occupy_api p,sys_user u
			 WHERE p.player_id=u.id
			 AND p.occupy_bill_id=bill_id
			 AND u.user_type='24'
			 GROUP BY p.player_id,u.username
		LOOP
			player_id=rec.player_id::text;
			money=rec.occupy_total;
			trans=rec.effective_transaction;
			loss=	rec.profit_loss;
			backwater=rec.rakeback;
			rebate_value=rec.rebate;
			IF isexists(hash,player_id) THEN
				param=hash->player_id;
				raise info 'param=%',param;
				param=param||row_split||'occupy_total'||col_split||money::text;
				param=param||row_split||'effective_transaction'||col_split||trans::TEXT;
				param=param||row_split||'profit_loss'||col_split||loss::TEXT;
				param=param||row_split||'rakeback'||col_split||backwater::TEXT;
				param=param||row_split||'rebate'||col_split||rebate_value::TEXT;
				param=param||row_split||'username'||col_split||rec.username;
			ELSE
				raise info 'player_id:%',player_id;
				param='occupy_total'||col_split||money::text;
				param=param||row_split||'effective_transaction'||col_split||trans::TEXT;
				param=param||row_split||'profit_loss'||col_split||loss::TEXT;
				param=param||row_split||'rakeback'||col_split||backwater::TEXT;
				param=param||row_split||'rebate'||col_split||rebate_value::TEXT;
				param=param||row_split||'username'||col_split||rec.username;
			END IF;

			select player_id||'=>'||param into mhash;
			IF hash is null THEN
				hash=mhash;
			ELSE
				hash=hash||mhash;
			END IF;
		END LOOP;
		RETURN hash;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_expense_gather(
bill_id INT
,start_time TIMESTAMP
,end_time TIMESTAMP
)IS 'Lins-总代占成-各分摊费用';


/*
* 生成流水号
* @author: Lins
* @date:2015.12.22
* 参数1.交易类型:B或T
* 参数2.站点code
* 参数3.流水号类型
*/
DROP FUNCTION if exists gamebox_generate_order_no(TEXT,TEXT,TEXT);
create or replace function gamebox_generate_order_no(
trans_type TEXT
,site_code TEXT
,order_type TEXT
) returns TEXT as $$
DECLARE
	currentDate VARCHAR := (SELECT to_char(CURRENT_DATE, 'yyMMdd'));
	nextSeqNum	VARCHAR := '';
BEGIN
	site_code=lpad(site_code,4,'0');
	IF trans_type='B' THEN
		IF order_type = '01' THEN		-- 01-游戏API与总控的结算
			nextSeqNum := lpad((SELECT nextval('settlement_id_api_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '02' THEN	-- 02-总控与运营商的结算
			nextSeqNum := lpad((SELECT nextval('settlement_id_boss_seq'))::VARCHAR , 7, '0');
		ELSEIF order_type = '03' THEN	-- 03-运营商与站长的结算
			nextSeqNum := lpad((SELECT nextval('settlement_id_company_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '04' THEN	-- 04-站长与总代的结算
			nextSeqNum := lpad((SELECT nextval('settlement_id_generalagent_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '05' THEN	-- 05-站长与代理的结算
			nextSeqNum := lpad((SELECT nextval('settlement_id_agent_seq'))::VARCHAR, 7, '0');
		END IF;
	ELSEIF trans_type='T' THEN
		IF order_type = '01' THEN		-- 01-充值
			nextSeqNum := lpad((SELECT nextval('order_id_recharge_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '02' THEN	-- 02-优惠
			nextSeqNum := lpad((SELECT nextval('order_id_discount_seq'))::VARCHAR , 7, '0');
		ELSEIF order_type = '03' THEN	-- 03-游戏API
			nextSeqNum := lpad((SELECT nextval('order_id_gameapi_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '04' THEN	-- 04-返水
			nextSeqNum := lpad((SELECT nextval('order_id_backwater_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '05' THEN	-- 05-返佣
			nextSeqNum := lpad((SELECT nextval('order_id_rebate_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '06' THEN	-- 06-玩家取款
			nextSeqNum := lpad((SELECT nextval('order_id_withdraw_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '07' THEN	-- 07-代理提现
			nextSeqNum := lpad((SELECT nextval('order_id_agent_withdraw_seq'))::VARCHAR, 7, '0');
		ELSEIF order_type = '08' THEN	-- 08-转账
			nextSeqNum := lpad((SELECT nextval('order_id_transfers_seq'))::VARCHAR, 7, '0');
		END IF;
	END IF;
	RETURN trans_type||currentDate||site_code||order_type||nextSeqNum;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_generate_order_no
(
trans_type TEXT
,site_code TEXT
,order_type TEXT
) IS 'Lins-生成流水号';

/*

SELECT gamebox_generate_order_no('B','1','03');


	select gamebox_occupy('2015-11第二期','2015-01-08','2015-12-14'
	,'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres');


	select * from gamebox_occupy_map(
'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'2015-01-08','2015-12-31');

*/