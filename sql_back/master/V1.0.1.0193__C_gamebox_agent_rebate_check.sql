/*
* 计算返水
* @author Lins
* @date 2015.11.10
	返回float类型，返水值.
*/
--drop function gamebox_rebate_agent_check(hstore,hstore);
create or replace function gamebox_rebate_agent_check(gradshash hstore,agenthash hstore) returns hstore as $$
DECLARE
	rec record;
	keys text[];
	subkeys text[];
	keyname text:='';
	--临时
	val text:='';
	vals text[];
	param text:='';
	--临时Hstore
	hash hstore;
	tmphash hstore;
	checkhash hstore;
	--梯度有效交易量
	valid_value float:=0.00;
	--上次梯度有效交易量
	pre_valid_value float:=0.00;
	pre_player_num int=0;
	pre_profit float=0.00;
	--返水值.
	back_water_value float:=0.00;
	--占成
	ratio float:=0.00;
	--最大返佣上限
	max_rebate float:=0.00;

	--盈亏总额
  profit_amount float:=0.00;
	--有效玩家数
	player_num int:=0;
	--玩家有效交易量
	effective_trade_amount float:=0.00;
	--代理返佣主方案.
	rebate_id int:=0;

	--API
	api int:=0;
	--游戏类型
	gameType text;
	--代理ID
	agent_id text;

	--有效玩家数.
  valid_player_num int:=0;
	total_profit float:=0.00;
BEGIN
  keys=akeys(gradshash);
  --raise info '%',agenthash;		 
	--raise info 'Len=%',array_length(keys, 1);
	FOR rec IN 
            SELECT 
            u.owner_id,a.username,
						count(DISTINCT o.player_id) player_num,
						sum(-o.profit_amount) as profit_amount,
            sum(o.effective_trade_amount) AS effective_trade_amount
            FROM player_game_order o,sys_user u left JOIN sys_user a on u.owner_id=a.id
	          where o.player_id=u.id 
            GROUP BY u.owner_id,a.username
   LOOP
		  --重置变量.
			pre_valid_value=0.00;
			pre_profit=0.00;
      pre_player_num=0;
			--玩家数.
			player_num=rec.player_num;
			--代理盈亏总额
			profit_amount=rec.profit_amount;
			--代理有效交易量
			effective_trade_amount=rec.effective_trade_amount;
	    --raise info '代理有效值:%,盈亏总额:%,玩家数:%',effective_trade_amount,profit_amount,player_num;
      --如果代理盈亏总额为正时，才有返佣.
			--为了作测试.先把盈亏总额置为正数.
			profit_amount=-profit_amount;
		  --player_num=5;
			if profit_amount<=0 THEN
				CONTINUE;
			end IF;
			--取得返佣主方案.
			agent_id:=(rec.owner_id)::text;
		  --raise info '代理ID:%',agent_id;
			--判断代理是否设置了返佣梯度.
			if isexists(agenthash,agent_id) THEN
					rebate_id=agenthash->agent_id;
				  --raise info 'rec=%',rec;
				for i in 1..array_length(keys, 1) loop
					subkeys=regexp_split_to_array(keys[i],'_');
					keyname=keys[i];
					--raise info 'key=%',subkeys;
					--raise info '%,%,rebate_id=%',subkeys[1],rebate_id,((subkeys[1]::int)=rebate_id);
          --取得当前返佣梯度.
					IF subkeys[1]::int=rebate_id THEN
						--判断是否已经比较过且有效交易量大于当前值.
						--raise info '%>%:%',effective_trade_amount,pre_valid_value,(effective_trade_amount>pre_valid_value);
						--IF effective_trade_amount>pre_valid_value THEN
	             --raise info 'val=%',gradshash->keyname;
              val=gradshash->keyname;
							--raise info 'val=%',val;
							--判断如果存在多条记录，取第一条.
							vals=regexp_split_to_array(val,'\^\&\^');
							--raise info 'vals.len:%',array_length(vals, 1);
							IF array_length(vals, 1)>1 THEN
								val=vals[1];
							END IF;
							select * from strToHash(val) into hash;
							--有效玩家数
							valid_player_num=(hash->'valid_player_num')::int;
							--占成数
							ratio=(hash->'ratio')::float;
							--梯度有效交易量
							valid_value=(hash->'valid_value')::float;
							--返佣上限
							max_rebate=(hash->'max_rebate')::float;
							--盈亏总额
							total_profit=(hash->'total_profit')::float;

							--raise info '梯度有效交易量:%,返佣上限:%,盈亏总额:%,玩家数:%,占成比例:%',valid_value,max_rebate,total_profit,valid_player_num,ratio;
							--raise info '代理有效值:%,盈亏总额:%,玩家数:%',effective_trade_amount,profit_amount,player_num;
							--有效交易量、盈亏总额、有效玩家数.进行比较.
						--因为一个返佣设置会有多个梯度.
						IF total_profit>=pre_profit OR valid_player_num>=pre_player_num THEN
							IF effective_trade_amount >= valid_value 
								and profit_amount>=total_profit 
								and player_num>=valid_player_num
							THEN
								--存储此次梯度有效交易量,作下次比较.
								--pre_valid_value=valid_value;
								pre_profit=total_profit;
								pre_player_num=valid_player_num;
								--代理满足第一阶条件，满足有效交易量与盈亏总额
								--param=agent_id||'=>'||'T|'||subkeys[1]||'|'||subkeys[2];
								--param=agent_id||'=>T_'||subkeys[1]||'_'||subkeys[2];
								param=agent_id||'=>'||subkeys[1]||'_'||subkeys[2]||'_'||player_num||'_'||profit_amount||'_'||effective_trade_amount||'_'||rec.username;
							 -- raise info 'hash is null:%',(hash is null);
								if checkhash is null THEN
									select param into checkhash;
								else 
									select param into tmphash;
									--合并
									checkhash=checkhash||tmphash;
								END IF;
							END IF;
						END IF;
					END IF;
				END LOOP;
			ELSE
				  raise info '代理ID:%,没有设置返佣梯度.',agent_id;
			END IF;
	END LOOP;
	return checkhash; 
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_agent_check(gradshash hstore,agenthash hstore) IS '返佣-代理返佣梯度检查-Lins';
--SELECT * FROM gamebox_rakeback_calculator();

