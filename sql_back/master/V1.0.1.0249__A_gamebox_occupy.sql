
/*
* 总代占成数据更新.
* @author Lins
* @date 2015.12.2
* @参数1:周期数.
* @参数2:返佣周期开始时间(yyyy-mm-dd)
* @参数3:返佣周期结束时间(yyyy-mm-dd)
* @参数4:返佣键值
* @参数5:操作类型.I:新增.U:更新.
*/
DROP FUNCTION IF EXISTS gamebox_occupy_bill(TEXT,TIMESTAMP,TIMESTAMP,INOUT BIGINT,TEXT);
create or replace function gamebox_occupy_bill(
name TEXT
,start_time TIMESTAMP
,end_time TIMESTAMP
,INOUT bill_id BIGINT
,op TEXT
) returns BIGINT as $$
DECLARE
	rec record;
	pending_pay text:='pending_pay';
	--key_id BIGINT;
BEGIN
	IF op='I' THEN
		INSERT INTO occupy_bill
		(
		 period,start_time,end_time
		,top_agent_count,top_agent_lssuing_count,top_agent_reject_count
		,occupy_total,occupy_actual,last_operate_time
		,create_time,lssuing_state
		)
		VALUES(
		 name,start_time,end_time
		 ,0,0,0,0,0,now(),
		 now(),pending_pay
		);
		SELECT currval(pg_get_serial_sequence('occupy_bill', 'id')) into bill_id;
		raise info 'occupy_bill.完成.键值:%',bill_id;
	ELSE
		FOR rec in
			SELECT occupy_bill_id,count(top_agent_id) top_agent_num
			,SUM(effective_transaction) effective_transaction ,SUM(profit_loss) profit_loss
			,SUM(rakeback) rakeback,SUM(rebate) rebate,SUM(occupy_total) occupy_total,SUM(refund_fee) refund_fee
			,SUM(recommend) recommend,SUM(preferential_value) preferential_value,SUM(apportion) apportion
			FROM occupy_topagent
			WHERE occupy_bill_id=bill_id
			GROUP BY occupy_bill_id

		LOOP
			UPDATE occupy_bill
			SET top_agent_count=rec.top_agent_num
			,occupy_total=rec.occupy_total
			,effective_transaction=rec.effective_transaction
			,profit_loss=rec.profit_loss
			,rakeback=rec.rakeback
			,rebate=rec.rebate
			,refund_fee=rec.refund_fee
			,recommend=rec.recommend
			,preferential_value=rec.preferential_value
			,apportion=rec.apportion
			where id=rec.occupy_bill_id;
		END LOOP;
	END IF;
	RETURN;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_bill(
name TEXT
,start_time TIMESTAMP
,end_time TIMESTAMP
,INOUT bill_id BIGINT
,op TEXT)
IS 'Lins-总代占成-数据更新';



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
		select gamebox_rebate_calculator(rebate_grads_map,agent_check_map,operation_occupy_map
		,rec.agent_id,rec.id,rec.api_id,rec.game_type,rec.profit_amount) INTO rebate_value;
		--取得各API占成
		select gamebox_occupy_api_calculator(occupy_grads_map,operation_occupy_map
			,rec.owner_id,rec.id,rec.api_id,rec.game_type,rec.profit_amount) into occupy_value;

		keyname=rec.id||col_split||rec.api_id||col_split||rec.game_type;
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
* 总代占成-玩家贡献度.
* @author Lins
* @date 2015.12.2
* @参数1:占成键值
* @参数2:各种分摊费用
* @参数3:系统参数
*/
drop function if exists gamebox_occupy_player(INT,hstore,hstore);
create or replace function gamebox_occupy_player(
bill_id INT
,cost_map hstore
,sys_map hstore
) returns void as $$
DECLARE
  keys text[];
	mhash hstore;
	param text:='';
	id int;
	money float:=0.00;

  agent_num int:=0;
	profit_loss float:=0.00;
  effective_transaction float:=0.00;


	keyname text:='';
	val text:='';
	vals text[];
	--返水
	rakeback FLOAT:=0.00;
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
	--占成
	occupy_total float:=0.00;
	--分摊费用
	apportion FLOAT:=0.00;
	retio FLOAT:=0.00;
	retio_2 FLOAT:=0.00;
	username text:='';
	tmp text:='';
	row_split text='^&^';
	col_split text:='^';

	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
BEGIN
		 IF cost_map is null THEN
				RETURN;
		 END IF;
		 keys=akeys(cost_map);
		 FOR i in 1..array_length(keys, 1) LOOP
				keyname=keys[i];
				val=cost_map->keyname;
				--raise info 'val=%',val;
				--转换成hstore数据格式:key1=>value1,key2=>value2
				val=replace(val,row_split,',');
		    val=replace(val,col_split,'=>');
				--raise info 'val=%',val;
				select val into mhash;
        --val=backwater=>20,favourable=>6,refund_fee=>18,recommend=>14,rebate=>-29.5
				backwater=0.00;
				IF exist(mhash, 'backwater') THEN
					backwater=(mhash->'backwater')::float;
				END IF;
				favourable=0.00;
				IF exist(mhash, 'favourable') THEN
					favourable=(mhash->'favourable')::float;
				END IF;
				refund_fee=0.00;
				IF exist(mhash, 'refund_fee') THEN
					refund_fee=(mhash->'refund_fee')::float;
				END IF;
				recommend=0.00;
				IF exist(mhash, 'recommend') THEN
					recommend=(mhash->'recommend')::float;
				END IF;
				occupy_total=0.00;
				IF exist(mhash, 'occupy_total') THEN
					occupy_total=(mhash->'occupy_total')::float;
				END IF;
				profit_loss=0.00;
				IF exist(mhash, 'profit_loss') THEN
					profit_loss=(mhash->'profit_loss')::float;--盈亏总额
				END IF;
				effective_transaction=0.00;
				IF exist(mhash, 'effective_transaction') THEN
					effective_transaction=(mhash->'effective_transaction')::float;--有效交易量
				END IF;
				username='';
				IF exist(mhash, 'username') THEN
					username=(mhash->'username');
				END IF;
				rebate=0.00;
				IF exist(mhash, 'rebate') THEN
					rebate=(mhash->'rebate')::float;
				END IF;

				rakeback=0.00;
				IF exist(mhash, 'rakeback') THEN
					rakeback=(mhash->'rakeback')::float;
				END IF;


			  --计算各种优惠.
				/*
				计算各种优惠.
				1、返水承担费用=赠送给体系下玩家的返水 * 代理承担比例；
				2、优惠承担费用=赠送给体系下玩家的优惠 * 代理承担比例；
				3、返还手续费承担费用=返还给体系下玩家的手续费 * 代理承担比例；
			  */
			  --优惠与推荐分摊
			  IF isexists(sys_map, 'agent.preferential.percent') THEN
					retio_2=(sys_map->'agent.preferential.percent')::float;--代理分摊比例
				END IF;
				IF isexists(sys_map, 'topagent.preferential.percent') THEN
					retio=(sys_map->'topagent.preferential.percent')::float;
					--raise info '优惠与推荐分摊比例:%',retio;
					favourable_apportion=(favourable+recommend)*(1-retio_2/100)*retio/100;
				ELSE
					favourable_apportion=0;
				END IF;
				--返水分摊
			  IF isexists(sys_map, 'agent.rakeback.percent') THEN
					retio_2=(sys_map->'agent.rakeback.percent')::float;--代理分摊比例
				END IF;

				IF isexists(sys_map, 'topagent.rakeback.percent') THEN

					retio=(sys_map->'topagent.rakeback.percent')::float;
					--raise info '返水分摊比例:%',retio;
					backwater_apportion=backwater*(1-retio_2/100)*retio/100;
				ELSE
					backwater_apportion=0;
				END IF;

				--手续费优惠分摊
			  IF isexists(sys_map, 'agent.poundage.percent') THEN
					retio_2=(sys_map->'agent.poundage.percent')::float;--代理分摊比例
				END IF;
				IF isexists(sys_map, 'topagent.poundage.percent') THEN
					retio=(sys_map->'topagent.poundage.percent')::float;
					--raise info '手续费优惠分摊比例:%',retio;
					refund_fee_apportion=refund_fee*(1-retio_2/100)*retio/100;
				ELSE
					refund_fee_apportion=0;
				END IF;

				--返佣分摊
				IF isexists(sys_map, 'topagent.rebate.percent') THEN
					retio=(sys_map->'topagent.rebate.percent')::float;
					rebate_apportion=rebate*retio/100;
				ELSE
					rebate_apportion=0;
				END IF;

				--总代占成=各API佣金总和－返佣-优惠-返水-返手续费.
				--occupy=occupy-rebate-favourable-backwater-refund_fee;
				apportion=favourable_apportion+backwater_apportion+refund_fee_apportion;
				--raise info 'occupy=%',occupy;
				id=keyname::int;

				INSERT INTO occupy_player(
					occupy_bill_id,player_id,player_name
					,effective_transaction,profit_loss,preferential_value
					,rakeback,occupy_total,refund_fee,recommend,apportion,rebate,lssuing_state
				 )VALUES(bill_id,id,username
					,effective_transaction,profit_loss,favourable
					,rakeback,occupy_total,refund_fee,recommend,apportion,rebate,pending_pay
				 );
			  SELECT currval(pg_get_serial_sequence('occupy_player', 'id')) into tmp;
	      raise info '占成玩家表.键值:%',tmp;
		 END LOOP;
   raise info '总代占成之玩家贡献度.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_player(
bill_id INT
,cost_map hstore
,sys_map hstore)
IS 'Lins-总代占成-玩家贡献度';

/*
* 总代占成-代理贡献度.
* @author Lins
* @date 2015.12.2
* @参数1:占成键值
*/
drop function if exists gamebox_occupy_agent(INT);
create or replace function gamebox_occupy_agent(bill_id INT) returns void as $$
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
BEGIN

	INSERT INTO occupy_agent(
		occupy_bill_id,agent_id,agent_name
		,effective_player,effective_transaction,profit_loss
		,preferential_value,rakeback,occupy_total
		,refund_fee,recommend,apportion,rebate,lssuing_state
	)
	 SELECT a1.*,pending_pay FROM
	 (SELECT p.occupy_bill_id,a.id,a.username
	 ,COUNT(distinct p.player_id),sum(p.effective_transaction),SUM(p.profit_loss)
	 ,SUM(preferential_value),SUM(rakeback),SUM(occupy_total)
	 ,SUM(refund_fee),SUM(recommend),SUM(apportion),SUM(rebate)
	 FROM occupy_player p,sys_user u,sys_user a
	 WHERE p.player_id=u.id
   AND p.occupy_bill_id=bill_id
	 AND u.owner_id=a.id
	 AND u.user_type='24'
	 AND a.user_type='23'
	 GROUP BY p.occupy_bill_id,a.id,a.username
	 ) a1;

   raise info '总代占成-代理贡献度.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_agent(INT)
IS 'Lins-总代占成-代理贡献';



/*
* 总代占成-总代明细.
* @author Lins
* @date 2015.12.2
* @参数1:占成键值
*/
drop function if exists gamebox_occupy_topagent(INT);
create or replace function gamebox_occupy_topagent(bill_id INT) returns void as $$
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
BEGIN
	INSERT INTO occupy_topagent(
		occupy_bill_id,top_agent_id,top_agent_name
		,effective_agent,effective_transaction,profit_loss
		,preferential_value,rakeback,occupy_total,rebate
		,refund_fee,recommend,apportion,lssuing_state
	)
	SELECT a1.*,pending_pay FROM
	( SELECT p.occupy_bill_id,a.id,a.username
	 ,COUNT(distinct p.agent_id),sum(p.effective_transaction),SUM(p.profit_loss)
	 ,SUM(preferential_value),SUM(rakeback),SUM(occupy_total),SUM(rebate)
	 ,SUM(refund_fee),SUM(recommend),SUM(apportion)
	 FROM occupy_agent p,sys_user u,sys_user a
	 WHERE p.agent_id=u.id
	 AND p.occupy_bill_id=bill_id
	 AND u.owner_id=a.id
	 AND u.user_type='23'
	 AND a.user_type='22'
	 GROUP BY p.occupy_bill_id,a.id,a.username) a1;

   raise info '总代占成-总代明细.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_topagent(INT)
IS 'Lins-总代占成-总代明细';


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
		select gamebox_expense_gather(start_time,end_time,row_split,col_split) INTO hash;
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
* 计算各API占成金额
* @author Lins
* @date 2015.11.18
* @参数1.各个API的占成数据hash(KEY-VALUE)
* @参数2.运营商各个API的占成数据hash(KEY-VALUE)
* @参数3.当前代理统计数据JSON格式
	返回float类型，返佣值.
*/
drop function if exists gamebox_occupy_api_calculator(hstore,hstore,INT,INT,INT,TEXT,FLOAT);
create or replace function gamebox_occupy_api_calculator(
occupy_grads_map hstore
,operation_occupy_map hstore
,owner_id INT
,player_id INT
,api_id INT
,game_type TEXT
,profit_amount FLOAT
)
returns FLOAT as $$
DECLARE
	ratio float:=0.00;--占成比例
	api TEXT;--API
	--game_type text;--游戏类型
	player TEXT;--玩家ID
	owners text;--代理ID
	operation_occupy_value float:=0.00;--运营商API占成.
	occupy_value float:=0.00;	--占成金额
	keyname text:='';--键值
	col_split text:='_';--列分隔符
BEGIN
			--api=rec->>'api_id';
			--game_type=rtrim(ltrim(rec->>'game_type'));
			--top_agent_id=rec->>'owner_id';
			api=api_id::TEXT;
			owners=owner_id::TEXT;
			player=player_id::TEXT;
		  keyname=player||col_split||api||col_split||game_type;
			--raise info 'Hash健值:%',keyname;
			operation_occupy_value=0.00;
		  --raise info 'keyname=%,operation_occupy_map:%',keyname,operation_occupy_map;
			IF isexists(operation_occupy_map, keyname) THEN
				operation_occupy_value=(operation_occupy_map->keyname)::FLOAT;
			END IF;
			--raise info 'operation_occupy_value:%',operation_occupy_value;

			keyname=owners||col_split||api||col_split||game_type;
			--raise info 'key2=%,map=%',keyname,occupy_grads_map;
			IF isexists(occupy_grads_map, keyname) THEN
				ratio=(occupy_grads_map->keyname)::float;
				occupy_value=(profit_amount-operation_occupy_value)*ratio/100;
				--raise info 'profit_amount=%,operation_occupy_value=%,ratio=%,API占成总额:%',profit_amount,operation_occupy_value,ratio,occupy_value;
			ELSE
				raise info '总代:%,未设置当前API:%,GAME_TYPE:% 的梯度,未设置的占成金额置为:0.请检查!',owners,api,game_type;
			END IF;
	return occupy_value;
END
$$ language plpgsql;

--SELECT * FROM gamebox_occupy_calculator();
COMMENT ON FUNCTION gamebox_occupy_api_calculator(
occupy_grads_map hstore
,operation_occupy_map hstore
,owner_id INT
,player_id INT
,api_id INT
,game_type TEXT
,profit_amount FLOAT
)
IS 'Lins-总代占成-各API占成计算';

/*
* 取得各代API占成信息
* @author Lins
* @date 2015.11.18
* 调用方式：
* select * from gamebox_occupy_api_set();
*/
create or replace function gamebox_occupy_api_set() returns hstore as $$
DECLARE
	hash hstore;
	mhash hstore;
	param text:='';
	rec record;
	row_split text:='^&^';
	col_split text:='_';
BEGIN
	FOR rec in
		select DISTINCT user_id,api_id,game_type,ratio from user_agent_api order by user_id,api_id,game_type
	LOOP
		param=rec.user_id||col_split||rec.api_id||col_split||rec.game_type||'=>'||rec.ratio;
		IF hash is NULL THEN
			SELECT param into hash;
		ELSE
			SELECT param into mhash;
			hash=hash||mhash;
		END IF;
	END LOOP;
	--raise info 'API占成信息:%',hash->'3_1_01';
	return hash;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_api_set() IS 'Lins-总代占成-梯度信息';


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
* select * from gamebox_occupy('2015-11第二期','2015-01-08','2015-11-14'
	,'host=192.168.0.88 dbname=gamebox_mainsite user=postgres password=postgresql');
*/
drop function if exists gamebox_occupy(text,text,text,text);
create or replace function gamebox_occupy(name text,start_time text,end_time text,url text) returns void as $$
DECLARE
	rec record;
	sys_map hstore;--系统设置各种承担比例.
  occupy_map hstore;--各API的返佣设置
	operation_occupy_map hstore;--运营商各API占成比例.
	rebate_grads_map hstore;--返佣梯度设置.
	agent_map hstore;--代理默认梯度.
	agent_check_map hstore;--代理满足的梯度.
	cost_map hstore;--费用分摊
	rakeback_map hstore;--玩家API返水.
	--存储每个总代的玩家数.
	numhash hstore;

	--临时
	mhash hstore;


	--返佣值
	occupy_value FLOAT;

	keyId int;
	tmp int;
	a1 text;
	a2 text;
	a3 text;
	stTime TIMESTAMP;
	edTime TIMESTAMP;

	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
	--分隔符
	row_split_char text:='^&^';
	col_split_char text:='^';

	vname text:='v_site_game';
	sid INT;--站点ID.
	bill_id INT;

	is_max BOOLEAN:=true;
	key_type int:=4;
	category TEXT:='AGENT';
BEGIN
	--url='host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres';
	stTime=start_time::TIMESTAMP;
	edTime=end_time::TIMESTAMP;

	raise info '统计( % )的占成,时间( %-% )',name,start_time,end_time;

	raise info '占成.玩家API返水';
	select gamebox_rakeback_map(stTime,edTime,url,'API') INTO rakeback_map;

	raise info '占成.取得当前站点ID';
	select gamebox_current_site() INTO sid;

	raise info '占成.site_game临时视图';
  perform gamebox_site_game(url,vname,sid,'C');


	raise info '占成.系统各种分摊比例参数';
	select gamebox_sys_param('apportionSetting') into sys_map;

	raise info '返佣.梯度设置信息';
  select gamebox_rebate_api_grads() into rebate_grads_map;

	raise info '返佣.代理默认方案';
  select gamebox_rebate_agent_default_set() into agent_map;

  raise info '返佣.代理满足的梯度';
	select gamebox_rebate_agent_check(rebate_grads_map,agent_map,stTime,edTime) into agent_check_map;

	--取得各API的运营商占成.
	raise info '取得运营商各API占成';
	select gamebox_operations_occupy(url,sid,stTime,edTime
	,category,is_max,key_type) into operation_occupy_map;


	raise info '取得当前返佣梯度设置信息';
  select gamebox_occupy_api_set() into occupy_map;

  raise info '占成.总表新增';
	select gamebox_occupy_bill(name,stTime,edTime,bill_id,'I') into bill_id;
	raise info 'occupy_bill.键值:%',bill_id;

  raise info '总代.玩家API贡献度';
	perform gamebox_occupy_api(bill_id,stTime,edTime,occupy_map,operation_occupy_map
	,rakeback_map,rebate_grads_map,agent_check_map);

	raise info '占成.各种分摊费用';
	select gamebox_occupy_expense_gather(bill_id,stTime,edTime) into cost_map;

  raise info '占成.玩家贡献度.';
	perform gamebox_occupy_player(bill_id,cost_map,sys_map);

  raise info '占成.代理贡献度.';
	perform gamebox_occupy_agent(bill_id);

	raise info '占成.总代明细';
	perform gamebox_occupy_topagent(bill_id);

	raise info '占成.总表更新';
	perform gamebox_occupy_bill(name,stTime,edTime,bill_id,'U');

	--删除临时视图表.
	perform gamebox_site_game(url,vname,sid,'D');
		--异常处理
	EXCEPTION
	WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS a1 = MESSAGE_TEXT,a2 = PG_EXCEPTION_DETAIL,a3 = PG_EXCEPTION_HINT;
		raise EXCEPTION '异常:%,%,%',a1,a2,a3;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy(
name text,start_time text,end_time text,url text)
 IS 'Lins-总代占成-入口';
/*
	select gamebox_occupy('2015-11第二期','2015-01-08','2015-12-14'
	,'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres');

*/