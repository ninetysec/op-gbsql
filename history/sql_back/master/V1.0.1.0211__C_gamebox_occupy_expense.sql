/**
* 根据计算周期统计总代的分摊费用(返水、优惠、推荐、返手续费)
* @author Lins
* @date 2015.11.18
* 参数1.代理数hash
* 参数2.系统参数hash
* 参数3.各费用hash
* 参数4.占成ID
* 参数2.开始时间
* 参数3.结束时间
*/
--drop function gamebox_occupy_expense(hstore,hstore,hstore,int);
create or replace function gamebox_occupy_expense(numhash hstore,syshash hstore,hash hstore,keyId INT) returns void as $$
DECLARE
  keys text[];
	mhash hstore;
	param text:='';
	top_agent_id int;
	money float:=0.00;

  agent_num int:=0;
	profit_amount float:=0.00;
  effective_trade_amount float:=0.00;


	keyname text:='';
	val text:='';
	vals text[];
	--返水
  backwater float:=0.00;
	--优惠
	favourable float:=0.00;
	--手续费
  refund_fee float:=0.00;
	--推荐
  recommend float:=0.00;
	--返佣
  rebate float:=0.00;
	--占成
	occupy float:=0.00;
	retio float;
	agent_name text:='';
	tmp text:='';
	row_split text='^&^';
	col_split text:='^';
BEGIN
		 keys=akeys(hash);
		 FOR i in 1..array_length(keys, 1) LOOP
				keyname=keys[i];
				val=hash->keyname;
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
				rebate=0.00;
				IF exist(mhash, 'rebate') THEN
					rebate=(mhash->'rebate')::float;
				END IF;
				profit_amount=0.00;
				IF exist(mhash, 'profit_amount') THEN
					profit_amount=(mhash->'profit_amount')::float;--盈亏总额
				END IF;
				effective_trade_amount=0.00;
				IF exist(mhash, 'effective_transaction') THEN
					effective_trade_amount=(mhash->'effective_transaction')::float;--有效交易量
				END IF;
				agent_name='';
				IF exist(mhash, 'username') THEN
					agent_name=(mhash->'username');
				END IF;
				occupy=0.00;
				IF exist(mhash, 'occupy') THEN
					occupy=(mhash->'occupy')::float;
				END IF;
				--raise info '各费用数据:返水:%,优惠:%,手续费:%,推荐:%,返佣:%,API占成:%,有效交易量:%,盈亏:%',
				--backwater,favourable,refund_fee,recommend,rebate,occupy,effective_trade_amount,profit_amount;

        agent_num=numhash->'agent_num';

			  --计算各种优惠.
				/*
				计算各种优惠.
				1、返水承担费用=赠送给体系下玩家的返水 * 代理承担比例；
				2、优惠承担费用=赠送给体系下玩家的优惠 * 代理承担比例；
				3、返还手续费承担费用=返还给体系下玩家的手续费 * 代理承担比例；
			  */
			  --优惠与推荐分摊
				IF isexists(syshash, 'topagent.preferential.percent') THEN
					retio=(syshash->'topagent.preferential.percent')::float;
					--raise info '优惠与推荐分摊比例:%',retio;
					favourable=(favourable+recommend)*retio/100;
				ELSE
					favourable=0;
				END IF;
				--返水分摊

				IF isexists(syshash, 'topagent.rakeback.percent') THEN

					retio=(syshash->'topagent.rakeback.percent')::float;
					--raise info '返水分摊比例:%',retio;
					backwater=backwater*retio/100;
				ELSE
					backwater=0;
				END IF;

				--手续费优惠分摊
				IF isexists(syshash, 'topagent.poundage.percent') THEN
					retio=(syshash->'topagent.poundage.percent')::float;
					--raise info '手续费优惠分摊比例:%',retio;
					refund_fee=refund_fee*retio/100;
				ELSE
					refund_fee=0;
				END IF;
				--返佣分摊

				IF isexists(syshash, 'topagent.rebate.percent') THEN
					retio=(syshash->'topagent.rebate.percent')::float;
					--raise info '手续费优惠分摊比例:%',retio;
					rebate=rebate*retio/100;
				ELSE
					rebate=0;
				END IF;

				--总代占成=各API佣金总和－返佣-优惠-返水-返手续费.
				occupy=occupy-rebate-favourable-backwater-refund_fee;
				--raise info 'occupy=%',occupy;
				top_agent_id=keyname::int;
				INSERT INTO settlement_occupy_topagent(
					settlement_occupy_id,top_agent_id,top_agent_name
					,effective_agent,effective_transaction,profit_loss
				  ,rebate,occupy_total
				)VALUES(
					keyId,top_agent_id,agent_name,agent_num,effective_trade_amount,profit_amount
					,rebate,occupy
				);
			  SELECT currval(pg_get_serial_sequence('settlement_occupy_topagent', 'id')) into tmp;
	      raise info '占成总代表的键值:%',tmp;
				--raise EXCEPTION '失败';
        raise info '统计总代占成.完成';
		 END LOOP;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_expense(numhash hstore,syshash hstore,hash hstore,keyId INT) IS '总代占成-占成计算-Lins';