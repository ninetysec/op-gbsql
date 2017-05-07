-- auto gen by Lins 2015-12-11 03:22:07

/*
* 根据返佣周期统计各个API,各个玩家的返佣数据.
* @author Lins
* @date 2015.11.10
* @参数1:返佣周期名称.
* @参数2:返佣周期开始时间(yyyy-mm-dd)
* @参数3:返佣周期结束时间(yyyy-mm-dd)
* @参数4:运营商库的dblink 格式数据
* @参数5:出账标示:Y.已出账,N.未出账
	返回为空.
* 调用例子:
* select * from gamebox_rebate('2015-11第二期','2015-01-08','2015-11-14');
*/
drop function if exists gamebox_rebate(text,text,text,text,int);
drop function if exists gamebox_rebate(text,text,text,text);
drop function if exists gamebox_rebate(text,text,text,text,text);
create or replace function gamebox_rebate(
name text
,startTime text
,endTime text
,url text
,flag text
) returns void as $$
DECLARE
	rec record;
	--系统设置各种承担比例.
	syshash hstore;
	--各API的返佣设置
  gradshash hstore;
	--各个代理的返佣设置
	agenthash hstore;
	--运营商各API占成比例.
	mainhash hstore;
	--存储每个代理是否满足梯度.
	checkhash hstore;

	rakebackhash hstore;--各玩家返水.
	--临时
	hash hstore;
	mhash hstore;
	--返佣值
	rebate_value FLOAT;

	sid int;
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
	row_split text:='^&^';
	col_split text:='^';

	vname text:='v_site_game';
	--运营商占成参数.
	is_max BOOLEAN:=true;
	key_type int:=4;
	category TEXT:='AGENT';

	rebate_bill_id INT:=-1;--返佣主表键值.
BEGIN
	stTime=startTime::TIMESTAMP;
	edTime=endTime::TIMESTAMP;
	raise info '开始统计( % )的返佣,周期( %-% )',name,startTime,endTime;
	raise info '取得玩家返水';
	select gamebox_rakeback_map(stTime,edTime,url,'PLAYER') INTO rakebackhash;
	raise info '创建站点游戏视图';
  --取得当前站点.
	select gamebox_current_site() INTO sid;
	--url='host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres';
  perform gamebox_site_game(url,vname,sid,'C');
	--取得系统关于各种承担比例参数.
	select gamebox_sys_param('apportionSetting') into syshash;
	--取得当前返佣梯度设置信息.
  select gamebox_rebate_api_grads() into gradshash;
	--取得代理默认返佣方案
  select gamebox_rebate_agent_default_set() into agenthash;
  --判断各个代理满足的返佣梯度.
	select gamebox_rebate_agent_check(gradshash,agenthash,stTime,edTime) into checkhash;
	--raise info 'keys:%',checkhash;
	--取得各API的运营商占成.
	raise info '取得运营商各API占成';
	select gamebox_operations_occupy(url,sid,stTime,edTime,category,is_max,key_type) into mainhash;


	--先插入返水总记录并取得键值.
  raise info '返佣rebate_bill新增记录';
	SELECT gamebox_rebate_bill(name,stTime,edTime,rebate_bill_id,'I',flag) INTO rebate_bill_id;
  raise info '返佣rebate_bill.ID=%',rebate_bill_id;
	--先统计每个代理的有效交易量、有效玩家、盈亏总额.
  raise info '计算各玩家API返佣';
	perform gamebox_rebate_api(rebate_bill_id,stTime,edTime,gradshash,checkhash,mainhash,flag);

  raise info '收集各玩家的分摊费用';
	select gamebox_rebate_expense_gather(rebate_bill_id,rakebackhash
	,stTime,edTime,row_split,col_split) into hash;

	raise info '统计各玩家返佣';
  perform gamebox_rebate_player(syshash,hash,rakebackhash,rebate_bill_id,row_split,col_split,flag);

	raise info '开始统计代理返佣';
	--perform gamebox_rebate_agent(checkhash,syshash,hash,rebate_bill_id,row_split_char,col_split_char);
	perform gamebox_rebate_agent(rebate_bill_id,flag);

  raise info '更新返佣总表';
	perform gamebox_rebate_bill(name,stTime,edTime,rebate_bill_id,'U',flag);
	--删除临时视图表.
	perform gamebox_site_game(url,vname,sid,'D');

	--异常处理
	EXCEPTION
	WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS a1 = MESSAGE_TEXT,a2 = PG_EXCEPTION_DETAIL,a3 = PG_EXCEPTION_HINT;
		raise EXCEPTION '异常:%,%,%',a1,a2,a3;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate(
name text
,startTime text
,endTime text
,url text
,flag text
) IS 'Lins-返佣-代理返佣计算入口';



/*
* 返佣插入与更新数据.
* @author Lins
* @date 2015.12.2
* @参数1:周期数.
* @参数2:返佣周期开始时间(yyyy-mm-dd)
* @参数3:返佣周期结束时间(yyyy-mm-dd)
* @参数4:返佣键值
* @参数5:操作类型.I:新增.U:更新.
* @参数6:出账标示:Y.已出账,N.未出账
*/
--删除上期函数
DROP FUNCTION IF EXISTS gamebox_rebate_bill(TEXT,TIMESTAMP,TIMESTAMP,INT,TEXT);
DROP FUNCTION IF EXISTS gamebox_rebate_bill(TEXT,TIMESTAMP,TIMESTAMP,INT,TEXT,TEXT);
create or replace function gamebox_rebate_bill(
name TEXT
,start_time TIMESTAMP
,end_time TIMESTAMP
,INOUT bill_id INT
,op TEXT
,flag TEXT
)
 returns INT as $$
DECLARE
	rec record;
	pending_pay text:='pending_pay';
	key_id INT;
BEGIN
	IF flag='Y' THEN
		IF op='I' THEN--已出账
			INSERT INTO rebate_bill
			(
			 period,start_time,end_time
			,agent_count,agent_lssuing_count,agent_reject_count
			,rebate_total,rebate_actual,last_operate_time
			,create_time,lssuing_state
			)
			VALUES(
			 name,start_time,end_time
			 ,0,0,0,0,0,now(),
			 now(),pending_pay
			);
			SELECT currval(pg_get_serial_sequence('rebate_bill', 'id')) into bill_id;
			raise info 'rebate_bill.完成.键值:%',bill_id;
		ELSE
			FOR rec in
					SELECT rebate_bill_id,count(agent_id) agent_num
					,SUM(effective_transaction) effective_transaction ,SUM(profit_loss) profit_loss
					,SUM(rakeback) rakeback,SUM(rebate_total) rebate_total,SUM(refund_fee) refund_fee
					,SUM(recommend) recommend,SUM(preferential_value) preferential_value,SUM(apportion) apportion
					FROM rebate_agent
					WHERE rebate_bill_id=bill_id
					GROUP BY rebate_bill_id

			LOOP
				UPDATE rebate_bill
				SET agent_count=rec.agent_num
				,rebate_total=rec.rebate_total
				,effective_transaction=rec.effective_transaction
				,profit_loss=rec.profit_loss
				,rakeback=rec.rakeback
				,refund_fee=rec.refund_fee
				,recommend=rec.recommend
				,preferential_value=rec.preferential_value
				,apportion=rec.apportion
				where id=rec.rebate_bill_id;
			END LOOP;
		END IF;
	ELSEIF flag='N' THEN--未出账
		IF op='I' THEN
			INSERT INTO rebate_bill_nosettled
			(
			 start_time,end_time,create_time
			,rebate_total,effective_transaction
			,profit_loss,refund_fee,recommend
			,preferential_value,apportion,rakeback
			)
			VALUES(
			 start_time,end_time,now()
			 ,0,0
			 ,0,0,0
			 ,0,0,0
			);
			SELECT currval(pg_get_serial_sequence('rebate_bill_nosettled', 'id')) into bill_id;
			raise info 'rebate_bill_nosettled.完成.键值:%',bill_id;
		ELSE
			FOR rec in
					SELECT rebate_bill_nosettled_id
					,SUM(effective_transaction) effective_transaction ,SUM(profit_loss) profit_loss
					,SUM(rakeback) rakeback,SUM(rebate_total) rebate_total,SUM(refund_fee) refund_fee
					,SUM(recommend) recommend,SUM(preferential_value) preferential_value,SUM(apportion) apportion
					FROM rebate_agent_nosettled
					WHERE rebate_bill_nosettled_id=bill_id
					GROUP BY rebate_bill_nosettled_id

			LOOP
				UPDATE rebate_bill_nosettled
				SET
				rebate_total=rec.rebate_total
				,effective_transaction=rec.effective_transaction
				,profit_loss=rec.profit_loss
				,rakeback=rec.rakeback
				,refund_fee=rec.refund_fee
				,recommend=rec.recommend
				,preferential_value=rec.preferential_value
				,apportion=rec.apportion
				where id=rec.rebate_bill_nosettled_id;
			END LOOP;
		END IF;
	END IF;
	RETURN;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_bill(
name TEXT
,start_time TIMESTAMP
,end_time TIMESTAMP
,bill_id INT
,op TEXT
,flag TEXT
)
IS 'Lins-返佣-返佣周期主表';



/*
* 统计各玩家API返佣.
* @author Lins
* @date 2015.12.2
* @参数1:返佣KEY.
* @参数2:返佣周期开始时间(yyyy-mm-dd)
* @参数3:返佣周期结束时间(yyyy-mm-dd)
* @参数4:各种费用(优惠、推荐、返手续费、返水)hash
* @参数5:各玩家返水hash
*/
DROP FUNCTION IF EXISTS gamebox_rebate_api(INT,TIMESTAMP,TIMESTAMP,hstore,hstore,hstore);
DROP FUNCTION IF EXISTS gamebox_rebate_api(INT,TIMESTAMP,TIMESTAMP,hstore,hstore,hstore,TEXT);
create or replace function gamebox_rebate_api(
bill_id INT
,start_time TIMESTAMP
,end_time TIMESTAMP
,gradshash hstore
,checkhash hstore
,mainhash hstore
,flag TEXT
) returns void as $$
DECLARE
	rec record;
	rebate_value FLOAT:=0.00;--返佣.
	tmp int:=0;
	key_name TEXT:='';
	operation_occupy FLOAT:=0.00;
	col_split TEXT:='_';
BEGIN
  raise info '计算各API各代理的盈亏总和';
	 FOR rec IN
            SELECT
            u.owner_id,
						u.id,
            g.api_id,
            g.game_type,
	          g.api_type_id,
						count(DISTINCT o.player_id) player_num,
						sum(-COALESCE(o.profit_amount,0.00)) as profit_amount,
            sum(COALESCE(o.effective_trade_amount,0.00)) AS effective_trade_amount
            from player_game_order o,v_site_game g,sys_user u
	          where
            o.create_time>=start_time
						and o.create_time<end_time
            and o.game_id=g.id
						and o.player_id=u.id
            group by u.owner_id,u.id,g.api_id,g.game_type,g.api_type_id
			LOOP
			--检查当前代理是否满足返佣梯度.
			IF isexists(checkhash, (rec.owner_id)::text)=false THEN
				CONTINUE;
			END IF;
			raise info '取得各API各分类佣金总和';
			--select gamebox_rebate_calculator(gradshash,checkhash,mainhash,row_to_json(rec)) into rebate_value;
			--select gamebox_rebate_calculator(gradshash,checkhash,mainhash,rec.owner_id,rec.id,rec.api_id,rec.game_type,rec.profit_amount) into rebate_value;

			key_name=rec.id||col_split||rec.api_id||col_split||rec.game_type;
			operation_occupy=(mainhash->key_name)::FLOAT;
			operation_occupy=coalesce(operation_occupy,0);
			select gamebox_rebate_calculator(gradshash,checkhash,rec.owner_id,rec.api_id,rec.game_type,rec.profit_amount,operation_occupy) into rebate_value;
			--raise info '各API各分类佣金总和:代理:%,有效交易量:%,返佣:%',rec.owner_id,rec.effective_trade_amount,rebate_value;
			--新增各API代理返佣:目前返佣不分正负都新增.
		  IF flag='Y' THEN
			 INSERT INTO rebate_api(
				rebate_bill_id,player_id,api_id
				,api_type_id,game_type,rebate_total
				,effective_transaction,profit_loss
				) VALUES(
				 bill_id,rec.id,rec.api_id
				 ,rec.api_type_id,rec.game_type,rebate_value
				 ,rec.effective_trade_amount,rec.profit_amount
				);
			 SELECT currval(pg_get_serial_sequence('rebate_api', 'id')) into tmp;
			 raise info '返拥API.键值:%',tmp;
			ELSEIF flag='N' THEN

			 INSERT INTO rebate_api_nosettled(
				rebate_bill_nosettled_id,player_id,api_id
				,api_type_id,game_type,rebate_total
				,effective_transaction,profit_loss
				) VALUES(
				 bill_id,rec.id,rec.api_id
				 ,rec.api_type_id,rec.game_type,rebate_value
				 ,rec.effective_trade_amount,rec.profit_amount
				);
			 SELECT currval(pg_get_serial_sequence('rebate_api_nosettled', 'id')) into tmp;
			 raise info '返拥API.键值:%',tmp;

			END IF;
		END LOOP;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_api(
bill_id INT
,start_time TIMESTAMP
,end_time TIMESTAMP
,gradshash hstore
,checkhash hstore
,mainhash hstore
,flag TEXT
) IS 'Lins-返佣-玩家API返佣';



/**
* 各玩家返佣统计
* @author Lins
* @date 2015.11.13
* 参数1.系统参数
* 参数2.费用Map
* 参数3.返水Map
* 参数4.主键
* 参数5.行分隔符
* 参数6.列分隔符
* 返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
*/
drop function if exists gamebox_rebate_player(hstore,hstore,hstore,int,text,text);
drop function if exists gamebox_rebate_player(hstore,hstore,hstore,int,text,text,TEXT);
create or replace function gamebox_rebate_player(
syshash hstore
,expense_map hstore
,rakeback_map hstore
,bill_id INT
,row_split text
,col_split text
,flag TEXT
) returns void as $$
DECLARE
  keys text[];
	mhash hstore;
	param text:='';
	agent_id int;
	money float:=0.00;

  player_num int:=0;--玩家数
	profit_amount float:=0.00;--盈亏总和
  effective_trade_amount float:=0.00;--有效交易量


	keyname text:='';
	val text:='';
	vals text[];
  backwater float:=0.00;--返水费用
	favourable float:=0.00;--优惠费用
  refund_fee float:=0.00;--返手续费费用
  recommend float:=0.00;--推荐费用

  backwater_apportion float:=0.00;--返水分摊费用
	favourable_apportion float:=0.00;--优惠分摊费用
  refund_fee_apportion float:=0.00;--返手续费分摊费用
  recommend_apportion float:=0.00;--推荐分摊费用

  rebate float:=0.00;--返佣
	retio float;--占成数
	agent_name text:='';
	tmp text:='';
	apportion FLOAT:=0.00;--分摊总费用
	user_id INT:=-1;
BEGIN
		IF expense_map is null THEN
			RETURN;
		END IF;
		keys=akeys(expense_map);
		FOR i in 1..array_length(keys, 1)
		LOOP
			keyname=keys[i];
			user_id=keyname::INT;
			val=expense_map->keyname;
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
			--返水暂以此周期应付金额为准
			--.此数可因未来需求而变
			IF isexists(rakeback_map,keyname) THEN
				backwater=(rakeback_map->keyname)::FLOAT;
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
			--返佣
			rebate=0.00;
			IF exist(mhash, 'rebate') THEN
				rebate=(mhash->'rebate')::float;
			END IF;

			--盈亏总和
			profit_amount=0.00;
			IF exist(mhash, 'profit_loss') THEN
				profit_amount=(mhash->'profit_loss')::float;
			END IF;
			--有效交易量
			effective_trade_amount=0.00;
			IF exist(mhash, 'effective_transaction') THEN
				effective_trade_amount=(mhash->'effective_transaction')::float;
			END IF;

			agent_id=-1;
			IF exist(mhash, 'agent_id') THEN
				agent_id=(mhash->'agent_id')::INT;
			END IF;
			agent_name='';
			IF exist(mhash, 'agent_name') THEN
				agent_name=mhash->'agent_name';
			END IF;

			/*
				计算各种优惠.
				1、返水承担费用=赠送给体系下玩家的返水 * 代理承担比例；
				2、优惠承担费用=赠送给体系下玩家的优惠 * 代理承担比例；
				3、返还手续费承担费用=返还给体系下玩家的手续费 * 代理承担比例；
			*/
			--优惠与推荐分摊
			IF isexists(syshash, 'agent.preferential.percent') THEN
				retio=(syshash->'agent.preferential.percent')::float;
				--raise info '优惠与推荐分摊比例:%',retio;
				favourable_apportion=(favourable+recommend)*retio/100;
				--recommend_apportion=(recommend)*retio/100;
			ELSE
				favourable_apportion=0;
				--recommend_apportion=0;
			END IF;
			--返水分摊
			IF isexists(syshash, 'agent.rakeback.percent') THEN
				retio=(syshash->'agent.rakeback.percent')::float;
				--raise info '返水分摊比例:%',retio;
				backwater_apportion=backwater*retio/100;
			ELSE
				backwater_apportion=0;
			END IF;
			--手续费分摊
			IF isexists(syshash, 'agent.poundage.percent') THEN
				retio=(syshash->'agent.poundage.percent')::float;
				--raise info '手续费优惠分摊比例:%',retio;
				refund_fee_apportion=refund_fee*retio/100;
			ELSE
				refund_fee_apportion=0;
			END IF;
			--代理佣金=各API佣金总和－优惠-返水-返手续费.
			--佣金
			rebate=rebate-favourable_apportion-backwater_apportion-refund_fee_apportion;
			--分摊总费用
			apportion=backwater_apportion+refund_fee_apportion+favourable_apportion;

			IF flag='Y' THEN
				INSERT INTO rebate_player(
					rebate_bill_id,
					agent_id,
					user_id,
					effective_transaction,
					profit_loss,
					rebate_total,
					rakeback,
					preferential_value,
					recommend,
					refund_fee,
					apportion
				) VALUES(bill_id,agent_id,user_id
					,effective_trade_amount,profit_amount,rebate
					,backwater,favourable,recommend,refund_fee,apportion);
				SELECT currval(pg_get_serial_sequence('rebate_player', 'id')) into tmp;
				raise info '返佣代理表的键值:%',tmp;
			ELSEIF flag='N' THEN
				INSERT INTO rebate_player_nosettled(
					rebate_bill_nosettled_id,
					player_id,
					effective_transaction,
					profit_loss,
					rebate_total,
					rakeback,
					preferential_value,
					recommend,
					refund_fee,
					apportion
				) VALUES(bill_id
					,user_id
					,effective_trade_amount
					,profit_amount
					,rebate
					,backwater
					,favourable
					,recommend
					,refund_fee
					,apportion
				);
				SELECT currval(pg_get_serial_sequence('rebate_player_nosettled', 'id')) into tmp;
				raise info '返佣代理表的键值:%',tmp;
			END IF;
		END LOOP;
		raise info '开始统计代理返佣.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_player(
syshash hstore
,expense_map hstore
,rakeback_map hstore
,bill_id INT
,row_split text
,col_split text
,flag TEXT
)
IS 'Lins-返佣-玩家返佣';


/**
*/
drop function if exists gamebox_rebate_agent(INT);
drop function if exists gamebox_rebate_agent(INT,TEXT);
create or replace function gamebox_rebate_agent(
bill_id INT
,flag TEXT
) returns void as $$
DECLARE
BEGIN
	IF flag='Y' THEN
		INSERT INTO rebate_agent(
			rebate_bill_id,agent_id,agent_name
			,effective_player,effective_transaction,profit_loss
			,rakeback,rebate_total,refund_fee
			,recommend,preferential_value,apportion
		 )
		 SELECT p.rebate_bill_id,p.agent_id,u.username
		 ,COUNT(distinct p.user_id),sum(p.effective_transaction),SUM(p.profit_loss)
		 ,SUM(p.rakeback),SUM(p.rebate_total),SUM(p.refund_fee),
		 SUM(p.recommend),SUM(p.preferential_value),SUM(p.apportion)
		 FROM rebate_player p,sys_user u
		 WHERE p.agent_id=u.id
		 AND p.rebate_bill_id=bill_id
		 AND u.user_type='23'
		 GROUP BY p.rebate_bill_id,p.agent_id,u.username;
	ELSEIF flag='N' THEN
		INSERT INTO rebate_agent_nosettled(
			rebate_bill_nosettled_id,agent_id,agent_name
			,effective_player,effective_transaction,profit_loss
			,rakeback,rebate_total,refund_fee
			,recommend,preferential_value,apportion
		 )
		 SELECT p.rebate_bill_nosettled_id,u.agent_id,u.agent_name
		 ,COUNT(distinct p.player_id),sum(p.effective_transaction),SUM(p.profit_loss)
		 ,SUM(p.rakeback),SUM(p.rebate_total),SUM(p.refund_fee),
		 SUM(p.recommend),SUM(p.preferential_value),SUM(p.apportion)
		 FROM rebate_player_nosettled p,v_sys_user_tier u
		 WHERE p.rebate_bill_nosettled_id=bill_id
		 AND p.player_id=u.id
		 GROUP BY p.rebate_bill_nosettled_id,u.agent_id,u.agent_name;

	END IF;
   raise info '代理返佣.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_agent(
bill_id INT
,flag TEXT
)
IS 'Lins-返佣-代理返佣计算';



/*
* 统计各玩家API返佣.
* @author Lins
* @date 2015.12.2
* @参数1:返佣KEY.
* @参数2:返佣周期开始时间(yyyy-mm-dd)
* @参数3:返佣周期结束时间(yyyy-mm-dd)
* @参数4:各种费用(优惠、推荐、返手续费、返水)hash
* @参数5:各玩家返水hash
*/
DROP FUNCTION IF EXISTS gamebox_rebate_api(INT,TIMESTAMP,TIMESTAMP,hstore,hstore,hstore);
create or replace function gamebox_rebate_api(
rebate_bill_id INT,start_time TIMESTAMP,end_time TIMESTAMP
,gradshash hstore,checkhash hstore,mainhash hstore
) returns void as $$
DECLARE
	rec record;
	rebate_value FLOAT:=0.00;--返佣.
	tmp int:=0;
	operation_occupy FLOAT:=0.00;--运营商占成额
	key_name TEXT;--运营商占成KEY值.
	col_split TEXT:='_';
BEGIN
  raise info '计算各API各代理的盈亏总和';
	 FOR rec IN
            SELECT
            u.owner_id,
						u.id,
            g.api_id,
            g.game_type,
	          g.api_type_id,
						sum(-COALESCE(o.profit_amount,0.00)) as profit_amount,
            sum(COALESCE(o.effective_trade_amount,0.00)) AS effective_trade_amount
            from player_game_order o,v_site_game g,sys_user u
	          where
            o.create_time>=start_time and o.create_time<end_time and
            o.game_id=g.id and o.player_id=u.id
            group by u.owner_id,u.id,g.api_id,g.game_type,g.api_type_id
					  order by u.owner_id
			LOOP
			--检查当前代理是否满足返佣梯度.
			IF isexists(checkhash, (rec.owner_id)::text)=false THEN
				CONTINUE;
			END IF;
			raise info '取得各API各分类佣金总和';
			key_name=rec.id||col_split||rec.api_id||col_split||rec.game_type;
			operation_occupy=(operation_occupy_map->key_name)::FLOAT;
			operation_occupy=coalesce(operation_occupy,0);
			select gamebox_rebate_calculator(gradshash,checkhash,rec.owner_id,rec.api_id,rec.game_type,rec.profit_amount,operation_occupy) into rebate_value;
			--raise info '各API各分类佣金总和:代理:%,有效交易量:%,返佣:%',rec.owner_id,rec.effective_trade_amount,rebate_value;
			--新增各API代理返佣:目前返佣不分正负都新增.
		  --IF rebate_value>0 THEN
			 INSERT INTO rebate_api(
				rebate_bill_id,player_id,api_id
				,api_type_id,game_type,rebate_total
				,effective_transaction,profit_loss
				) VALUES(
				 rebate_bill_id,rec.id,rec.api_id
				 ,rec.api_type_id,rec.game_type,rebate_value
				 ,rec.effective_trade_amount,rec.profit_amount
				);
			 SELECT currval(pg_get_serial_sequence('rebate_api', 'id')) into tmp;
			 raise info '各API代理返佣表键值:%',tmp;
			--END IF;
		END LOOP;
END;
$$ language plpgsql;
COMMENT ON FUNCTION
 gamebox_rebate_api(
rebate_bill_id INT,start_time TIMESTAMP,end_time TIMESTAMP
,gradshash hstore,checkhash hstore,mainhash hstore
) IS 'Lins-返佣-统计各玩家API返佣';


/*
* 计算返佣
* @author Lins
* @date 2015.11.13
* @参数1.各个API的返佣数据hash(KEY-VALUE)
* @参数2.各个代理梯度检查hash(KEY-VALUE)
* @参数3.运营商各个API的占成数据hash(KEY-VALUE)
* @参数4.当前代理统计数据JSON格式
	返回float类型，返佣值.
*/

drop function if EXISTS gamebox_rebate_calculator(hstore,hstore,hstore,INT,INT,INT,TEXT,FLOAT);
drop function if EXISTS gamebox_rebate_calculator(hstore,hstore,INT,INT,TEXT,FLOAT,FLOAT);
create or replace function gamebox_rebate_calculator(
rebate_grads_map hstore
,agent_check_map hstore
,agent_id INT
,api_id INT
,game_type TEXT
,profit_amount FLOAT
,operation_occupy FLOAT
) returns FLOAT as $$
DECLARE
	keys text[];
	subkeys text[];
	keyname text:='';
	val text:='';--临时
	vals text[];
	hash hstore;	--临时Hstore

	rebate_value float:=0.00;--返佣值.
	ratio float:=0.00;--占成
	max_rebate float:=0.00;--最大返佣上限

	rebate_id text;	--梯度ID.
	api TEXT;--API
	agent text;--代理ID
	col_split TEXT:='_';
BEGIN
		api=(api_id::TEXT);
		agent=(agent_id::TEXT);
		--raise info 'check_map:%,agent:%',agent_check_map,agent;
		IF isexists(agent_check_map,agent)=false THEN --梯度不满足时不返佣
			RETURN 0.00;
		ELSEIF profit_amount<=0 THEN --盈亏为负时,不返佣
			RETURN 0.00;
		END IF;

		rebate_id=agent_check_map->agent;
		vals=regexp_split_to_array(rebate_id,'_');
    --vals=regexp_split_to_array(rebate_id,col_split_char);
		rebate_id=vals[1]||'_'||vals[2];
		keys=akeys(rebate_grads_map);

		for i in 1..array_length(keys, 1) loop
			keyname=keys[i];
			subkeys=regexp_split_to_array(keyname,'_');
			--subkeys=regexp_split_to_array(keyname,col_split_char);
			/*
			if position(rebate_id in keyname)=1 then
			raise info '%,api:%,game_type:%',keyname,api,gameType;
			end if;
			*/
			--raise info 'rebate_id:%,keyname:%,api:%,game_type:%',rebate_id,keyname,api,game_type;
			IF position(rebate_id in keyname)=1 AND subkeys[3]=api AND rtrim(ltrim(subkeys[4]))=game_type
			THEN
				--开始作比较.
				val=rebate_grads_map->keyname;
				--判断如果存在多条记录，取第一条.
				vals=regexp_split_to_array(val,'\^\&\^');
				--vals=regexp_split_to_array(val,row_split_char);
				IF array_length(vals, 1)>1 THEN
					val=vals[1];
				END IF;

				select * from strToHash(val) into hash;
				ratio=(hash->'ratio')::float;--占成数
				max_rebate=(hash->'max_rebate')::float;--返佣上限

				--raise info '梯度有效交易量:%,返佣上限:%,盈亏总额:%,玩家数:%,占成比例:%',valid_value,max_rebate,total_profit,valid_player_num,ratio;
				--raise info '代理有效值:%,盈亏总额:%,玩家数:%',effective_trade_amount,profit_amount,player_num;

				--返佣计算公式如下：
				--各API各分类佣金总和
				--=[各API各分类盈亏总和-(各API各分类盈亏总和*运营商占成）]*代理的佣金比例；
				--此处需要取得各个API运营商占成.
				--@todo.运营商API占成
				--main_ratio=0;
				--根据playerId+apiId+gameType取得运营商占成.
				--keyname=player||col_split||api||col_split||game_type;
				--operation_occupy=(operation_occupy_map->keyname)::FLOAT;
				operation_occupy=coalesce(operation_occupy,0);

				raise info '运营商占成额:%',operation_occupy;
				rebate_value=(profit_amount-operation_occupy)*ratio/100;
        --raise info '[各API各分类盈亏总和 -(各API各分类盈亏总和*运营商占成）]*代理的佣金比例,计算:%*(1-%)*%/100=%',profit_amount,main_ratio,ratio,rebate_value;
				--返水大于返水上限，以上限值为准.
				IF max_rebate is not null and rebate_value>max_rebate THEN
					rebate_value=max_rebate;
				END IF;
				raise info '代理返佣值:%',rebate_value;
			END IF;
		END LOOP;
	return rebate_value;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_calculator(
rebate_grads_map hstore
,agent_check_map hstore
,agent_id INT
,api_id INT
,game_type TEXT
,profit_amount FLOAT
,operation_occupy FLOAT
)IS 'Lins-返佣-计算';

/*
* 计算返佣MAP-外部调用
* @author Lins
* @date 2015.11.13
* @参数1.运营商库.dblink URL
* @参数2.开始时间
* @参数3.结束时间
* @参数4.类别.AGENT
*/

drop function if EXISTS gamebox_rebate_map(TEXT,TEXT,TEXT,TEXT);
create or replace FUNCTION gamebox_rebate_map(
url TEXT
,start_time TEXT
,end_time TEXT
,category TEXT
)
RETURNS hstore[] as $$
DECLARE
	sys_map hstore;--系统参数.
	rebate_grads_map hstore;--返佣梯度设置
	agent_map hstore;--代理默认方案
	agent_check_map hstore;--代理梯度检查
	operation_occupy_map hstore;--运营商占成.
	rebate_map hstore;--API占成.
	expense_map hstore;--费用分摊

	sid INT;--站点ID.
	stTime TIMESTAMP;
	edTime TIMESTAMP;
	vname TEXT:='v_site_game';
	is_max BOOLEAN:=true;
	key_type int:=5;--API
	--category TEXT:='AGENT';
	maps hstore[];
BEGIN
	category='AGENT';
	stTime=start_time::TIMESTAMP;
	edTime=end_time::TIMESTAMP;

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
	select gamebox_operations_occupy(url,sid,stTime,edTime,category,is_max,key_type) INTO operation_occupy_map;

	select gamebox_rebate_map(stTime,edTime,key_type,rebate_grads_map,agent_check_map,operation_occupy_map) INTO rebate_map;
	--统计各种费费用.
	select gamebox_expense_map(stTime,edTime,sys_map) INTO expense_map;
	maps=array[rebate_map];
	maps=array_append(maps,expense_map);
	return maps;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_map(
url TEXT
,start_time TEXT
,end_time TEXT
,category TEXT
)IS 'Lins-返佣-外调';


/*
* 统计各玩家API返佣.
* @author Lins
* @date 2015.12.2
* @参数1:返佣KEY.
* @参数2:返佣周期开始时间(yyyy-mm-dd)
* @参数3:返佣周期结束时间(yyyy-mm-dd)
* @参数4:各种费用(优惠、推荐、返手续费、返水)hash
* @参数5:各玩家返水hash
*/
DROP FUNCTION IF EXISTS gamebox_rebate_map(TIMESTAMP,TIMESTAMP,INT,hstore,hstore,hstore);
create or replace function gamebox_rebate_map(
start_time TIMESTAMP
,end_time TIMESTAMP
,key_type INT
,rebate_grads_map hstore
,agent_check_map hstore
,operation_occupy_map hstore
) returns hstore as $$
DECLARE
	rec record;
	rebate_value FLOAT:=0.00;--返佣.
	operation_occupy FLOAT:=0.00;--运营商占成额
	key_name TEXT;--运营商占成KEY值.
	rebate_map hstore;--各API返佣值.
	val FLOAT:=0.00;
	col_split TEXT:='_';
BEGIN
	 FOR rec IN
            SELECT
            u.owner_id,
            g.api_id,
            g.game_type,
						count(DISTINCT o.player_id) player_num,
						sum(-COALESCE(o.profit_amount,0.00)) as profit_amount,
            sum(COALESCE(o.effective_trade_amount,0.00)) AS effective_trade_amount
            from player_game_order o,v_site_game g,sys_user u
	          where o.create_time>=start_time and o.create_time<end_time
            and o.game_id=g.id and o.player_id=u.id
            group by u.owner_id,g.api_id,g.game_type
			LOOP
			--检查当前代理是否满足返佣梯度.
			IF isexists(agent_check_map, (rec.owner_id)::text)=false THEN
				CONTINUE;
			END IF;
			raise info '取得各API各分类佣金总和';
			key_name=rec.api_id||col_split||rec.game_type;
			operation_occupy=(operation_occupy_map->key_name)::FLOAT;
			operation_occupy=coalesce(operation_occupy,0);

			select gamebox_rebate_calculator(rebate_grads_map,agent_check_map,rec.owner_id,rec.api_id,rec.game_type,rec.profit_amount,operation_occupy) into rebate_value;
			val=rebate_value;

			IF rebate_map is null THEN
				--param=sub_key||'='||rake_map->keys[i];
				SELECT key_name||'=>'||val INTO rebate_map;
			ELSEIF exist(rebate_map,key_name) THEN
				val=val+((rebate_map->key_name)::FLOAT);
				rebate_map=(SELECT (key_name||'=>'||val)::hstore)||rebate_map;
			ELSE
				rebate_map=(SELECT (key_name||'=>'||val)::hstore)||rebate_map;
			END IF;
		END LOOP;
	RETURN rebate_map;
END
$$ language plpgsql;
COMMENT ON FUNCTION
 gamebox_rebate_map(
start_time TIMESTAMP
,end_time TIMESTAMP
,key_type INT
,rebate_grads_map hstore
,agent_check_map hstore
,operation_occupy_map hstore
) IS 'Lins-返佣-API返佣-外调';



/**
* 分摊费用
* @author Lins
* @date 2015.11.13
* 参数1.开始时间
* 参数2.结束时间
* 参数3.统计类别.1.PLAYER,2.FUND_TYPE,3.PLAYER+FUND_TYPE
* 参数4.行分隔符
* 参数5.列分隔符
* 返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
*/
drop function if exists gamebox_expense_gather(TIMESTAMP,TIMESTAMP);
create or replace function gamebox_expense_gather(
start_time TIMESTAMP
,end_time TIMESTAMP
) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	mhash hstore;
	param text:='';
	money float:=0.00;
	key_name TEXT;
BEGIN
		FOR rec IN
			select fund_type,sum(transaction_money) as transaction_money
			from player_transaction
			where fund_type in ('backwater','favourable','recommend','refund_fee')
			and status='success'
			and create_time>=start_time and create_time<end_time
			group by fund_type
		 LOOP
			key_name=rec.fund_type;
			money=rec.transaction_money;
			select key_name||'=>'||money into mhash;
			IF hash is null THEN
				hash=mhash;
			ELSE
				hash=hash||mhash;
			END IF;
		END LOOP;

		FOR rec IN
			SELECT
			count(DISTINCT o.player_id) as player_num,
			sum(COALESCE(o.profit_amount,0.00)) as profit_amount,
      sum(COALESCE(o.effective_trade_amount,0.00)) AS effective_trade_amount
      from player_game_order o
	    where o.create_time>=start_time
			and o.create_time<end_time
		 LOOP
				param='profit_amount=>'||rec.profit_amount;
				param=param||',effective_trade_amount=>'||rec.effective_trade_amount;
				param=param||',player_num=>'||rec.player_num;
			IF hash is null THEN
				SELECT param INTO hash;
			ELSE
				hash=(SELECT param::hstore)||hash;
			END IF;
		END LOOP;

	return hash;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_gather(
start_time TIMESTAMP
,end_time TIMESTAMP
) IS 'Lins-分摊费用';


/**
* 分摊费用
* @author Lins
* @date 2015.11.13
* 参数1.开始时间
* 参数2.结束时间
* 参数3.行分隔符
* 参数4.列分隔符
* 参数5.统计类别.TOP,AGENT,PLAYER
* 返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
*/
drop function if exists gamebox_expense_gather(TIMESTAMP,TIMESTAMP,text);
create or replace function gamebox_expense_gather(
start_time TIMESTAMP
,end_time TIMESTAMP
,category TEXT
) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	mhash hstore;
	param text:='';
	user_id text:='';
	money float:=0.00;
	name TEXT:='';
	cols TEXT;
  tables TEXT;
	grups TEXT;

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

	IF category='TOP' THEN
			cols='u.topagent_id as id,u.topagent_name as name, ';
			tables=' player_transaction p,v_sys_user_tier u ';
			grups='u.topagent_id,u.topagent_name ';
	ELSEIF category='AGENT' THEN
			cols='u.agent_id as id,u.agent_name as name, ';
			tables=' player_transaction p,v_sys_user_tier u ';
			grups='u.agent_id,u.agent_name ';
	ELSE
			cols='p.player_id as id,u.username as name, ';
			tables=' player_transaction p,v_sys_user_tier u';
			grups='p.player_id,u.username ';
	END IF;
	FOR rec IN EXECUTE
			'SELECT '||cols||' p.fund_type,sum(p.transaction_money) as transaction_money
			from '||tables||'
			where p.fund_type in (''backwater'',''favourable'',''recommend'',''refund_fee'')
			and p.status=''success''
			and p.create_time>=$1 and p.create_time<$2
			group by '||grups||',p.fund_type'
			USING start_time,end_time
	LOOP
			user_id=rec.id::text;
			money=rec.transaction_money;
			name=rec.name;
			IF isexists(hash,user_id) THEN
				param=hash->user_id;
				--param=param||'^&^'||rec.fund_type||'^'||money::text;
				param=param||rs||rec.fund_type||cs||money::text;
			ELSE
				param='user_name'||cs||name||rs||rec.fund_type||cs||money::text;
			END IF;
			select user_id||'=>'||param into mhash;
			IF hash is null THEN
				hash=mhash;
			ELSE
				hash=hash||mhash;
			END IF;
		END LOOP;
	return hash;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_gather(
start_time TIMESTAMP
,end_time TIMESTAMP
,category TEXT
)IS 'Lins-分摊费用';

/**
* 分摊费用
* @author Lins
* @date 2015.11.13
* 参数1.开始时间
* 参数2.结束时间
* 参数3.统计类别.1.PLAYER,2.FUND_TYPE,3.PLAYER+FUND_TYPE
* 参数4.行分隔符
* 参数5.列分隔符
* 返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
*/
drop function if exists gamebox_expense_share(hstore,hstore);
create or replace function gamebox_expense_share(
cost_map hstore
,sys_map hstore
) returns hstore as $$
DECLARE
	hash hstore;
	retio FLOAT:=0.00;
	backwater FLOAT:=0.00;
	favourable FLOAT:=0.00;
	refund_fee FLOAT:=0.00;
	recommend FLOAT:=0.00;
	favourable_apportion FLOAT:=0.00;

	backwater_apportion FLOAT:=0.00;
	refund_fee_apportion FLOAT:=0.00;
	apportion FLOAT:=0.00;
BEGIN
	backwater=0.00;
	IF exist(cost_map, 'backwater') THEN
	backwater=(cost_map->'backwater')::float;
	END IF;

	favourable=0.00;
	IF exist(cost_map, 'favourable') THEN
	favourable=(cost_map->'favourable')::float;
	END IF;
	refund_fee=0.00;
	IF exist(cost_map, 'refund_fee') THEN
		refund_fee=(cost_map->'refund_fee')::float;
	END IF;
	recommend=0.00;
	IF exist(cost_map, 'recommend') THEN
		recommend=(cost_map->'recommend')::float;
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
		--recommend_apportion=(recommend)*retio/100;
	ELSE
		favourable_apportion=0;
		--recommend_apportion=0;
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
COMMENT ON FUNCTION gamebox_expense_share(
cost_map hstore
,sys_map hstore
) IS 'Lins-分摊费用';


/**
* 分摊费用
* @author Lins
* @date 2015.11.13
* 参数1.开始时间
* 参数2.结束时间
* 参数3.统计类别.1.PLAYER,2.FUND_TYPE,3.PLAYER+FUND_TYPE
* 参数4.行分隔符
* 参数5.列分隔符
* 返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
*/
drop function if exists gamebox_expense_map(TIMESTAMP,TIMESTAMP,hstore);
create or replace function gamebox_expense_map(
start_time TIMESTAMP
,end_time TIMESTAMP
,sys_map hstore
) returns hstore as $$
DECLARE
	cost_map hstore;
	share_map hstore;
	sid INT;
BEGIN
	SELECT gamebox_expense_gather(start_time,end_time) INTO cost_map;
	SELECT gamebox_expense_share(cost_map,sys_map) INTO share_map;
	SELECT gamebox_current_site() INTO sid;
	share_map=(SELECT ('site_id=>'||sid)::hstore)||share_map;
	RETURN cost_map||share_map;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_map(
start_time TIMESTAMP
,end_time TIMESTAMP
,sys_map hstore
) IS 'Lins-返佣-其它费用.外调';


/*
*根据参数类型取得当前系统中所设置的各种参数的KEY-VALUE。
* 目前应该是取得站点中代理与总代各种承担比例的KEY-VALUE键值对.
* 各种承担比例的参数类型为:apportionSetting
* @author Lins
* @date 2015.11.9
* 调用例子:
* select * from gamebox_sys_param('apportionSetting');
* 返回JSON格式内容.
* 调用：hstore变量名->key 取得值.
* 比如变量名为hash,取总代-返水优惠分摊比例
* hash->'topagent.rakeback.percent'
* 修改:增加站点ID.
*/
drop function if exists gamebox_sys_param(TEXT);
create or replace function gamebox_sys_param(paramType text) returns hstore as $$
DECLARE
	param text:='';
	hash hstore;
	rec record;
	sid INT;
BEGIN
	for rec in select param_code,param_value from sys_param where param_type=$1 loop
		param=param||rec.param_code||'=>'||rec.param_value||',';
	end loop;
	--raise notice '结果:%',param;
	if length(param)>0 THEN
		param=substring(param,1,length(param)-1);
	end IF;
	select param::hstore into hash;
  --raise info '取得优惠值比例:%',hash->'topagent.rakeback.percent';
	select gamebox_current_site() INTO sid;
	hash=hash||(select ('site_id=>'||sid)::hstore);
	return hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_sys_param(paramType text) IS 'Lins-返佣-系统各种参数萃取';

/*
--测试返佣已出账
select * from gamebox_rebate(
'2015-11第二期','2015-01-08','2015-12-14'
,'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'Y');


--测试返佣未出账
select * from gamebox_rebate(
'2015-11第二期','2015-01-08','2015-12-14'
,'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'N');


select * from gamebox_rebate_map(
'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'2015-01-08','2015-12-14','AGENT');



*/
