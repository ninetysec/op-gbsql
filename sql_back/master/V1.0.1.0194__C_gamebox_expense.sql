/**
* 根据计算周期统计各代理的分摊费用(返水、优惠、推荐、返手续费)
* @author Lins
* @date 2015.11.13
* 参数1.返佣主表键值
* 参数2.开始时间
* 参数3.结束时间
* 参数4.行分隔符
* 参数5.列分隔符
* 返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。

*/
--drop function gamebox_expense(hstore,hstore,int,text,text);
create or replace function gamebox_expense(checkhash hstore,syshash hstore,hash hstore,keyId INTEGER,row_split_char text,col_split_char text) returns void as $$
DECLARE
  keys text[];
	mhash hstore;
	param text:='';
	agent_id int;
	money float:=0.00;

  player_num int:=0;
	profit_amount float:=0.00;
  effective_trade_amount float:=0.00;


	keyname text:='';
	val text:='';
	vals text[];
  backwater float:=0.00;
	favourable float:=0.00;
  refund_fee float:=0.00;
  recommend float:=0.00;
  rebate float:=0.00;
	retio float;
	agent_name text:='';
	tmp text:='';

BEGIN
		 keys=akeys(hash);
		 FOR i in 1..array_length(keys, 1) LOOP
				keyname=keys[i];
				val=hash->keyname;
				--raise info 'val=%',val;
				--转换成hstore数据格式:key1=>value1,key2=>value2
				val=replace(val,row_split_char,',');
		    val=replace(val,col_split_char,'=>');
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

				--INFO:  check=6_36_5_950_234
				val=checkhash->keyname;
				--raise info 'check=%',val;
				vals=regexp_split_to_array(val,'_');
				player_num=vals[3]::int;--有效玩家数
				profit_amount=vals[4]::float;--盈亏总额
				effective_trade_amount=vals[5]::float;--有效交易量
				agent_name=vals[6]::text;
				--raise info 'player_num:%',player_num;
			  --计算各种优惠.
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
					favourable=(favourable+recommend)*retio/100;
				ELSE
					favourable=0;
				END IF;
				--返水分摊
				IF isexists(syshash, 'agent.rakeback.percent') THEN
					retio=(syshash->'agent.rakeback.percent')::float;
					--raise info '返水分摊比例:%',retio;
					backwater=backwater*retio/100;
				ELSE
					backwater=0;
				END IF;
				--手续费分摊
				IF isexists(syshash, 'agent.poundage.percent') THEN
					retio=(syshash->'agent.poundage.percent')::float;
					--raise info '手续费优惠分摊比例:%',retio;
					refund_fee=refund_fee*retio/100;
				ELSE
					refund_fee=0;
				END IF;
				--代理佣金=各API佣金总和－优惠-返水-返手续费.
				rebate=rebate-favourable-backwater-refund_fee;

				agent_id=keyname::int;
				INSERT INTO settlement_rebate_agent(
					settlement_rabate_id,agent_id,agent_name
					,effective_player,effective_transaction,profit_loss
				  ,backwater,rebate_total
				)VALUES(
					keyId,agent_id,agent_name,player_num,effective_trade_amount,profit_amount
					,0,rebate
				);
			  SELECT currval(pg_get_serial_sequence('settlement_rebate_agent', 'id')) into tmp;
	      raise info '返佣代理表的键值:%',tmp;
				--raise EXCEPTION '失败';
        raise info '开始统计代理返佣.完成';
		 END LOOP;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense(checkhash hstore,syshash hstore,hash hstore,keyId INTEGER,row_split_char text,col_split_char text) IS '返佣-各代理的分摊费用(返水、优惠、推荐、返手续费)计算-Lins';