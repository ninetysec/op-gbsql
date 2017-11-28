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
--drop function gamebox_rebate_calculator(hstore,hstore,hstore,json);
create or replace function gamebox_rebate_calculator(gradshash hstore,checkhash hstore,mainhash hstore,rec json) returns FLOAT as $$
DECLARE
	keys text[];
	subkeys text[];
	keyname text:='';
	--临时
	val text:='';
	vals text[];
	--临时Hstore
	hash hstore;

	--梯度有效交易量
	valid_value float:=0.00;
	--返佣值.
	rebate_value float:=0.00;
	--占成
	ratio float:=0.00;
	--最大返佣上限
	max_rebate float:=0.00;
	default_max_rebate float:=9999999999.00;
	--盈亏总额
	profit_amount float:=0.00;
	--玩家有效交易量
	effective_trade_amount float:=0.00;
	--梯度ID.
	rebate_id text;
	--API
	api int:=0;
	--游戏类型
	gameType text;
	--代理ID
	agent_id text;
	--有效玩家数.
  valid_player_num int:=0;
	player_num int:=0;
	total_profit float:=0.00;
	--运营商API占成比例.
	main_ratio float:=0.00;

BEGIN
		--raise info '%',agenthash;
		keys=akeys(gradshash);
		--raise info 'Len=%',array_length(keys, 1);
	  --raise info 'rec=%',rec;
		for i in 1..array_length(keys, 1) loop
			keyname=keys[i];
			subkeys=regexp_split_to_array(keyname,'_');
			--subkeys=regexp_split_to_array(keyname,col_split_char);
			api=rec->>'api_id';
			gameType=rtrim(ltrim(rec->>'game_type'));
			agent_id=rec->>'owner_id';
			rebate_id=checkhash->agent_id;
			vals=regexp_split_to_array(rebate_id,'_');
      --vals=regexp_split_to_array(rebate_id,col_split_char);
			rebate_id=vals[1]||'_'||vals[2];
			/*
			if position(rebate_id in keyname)=1 then
			raise info '%,api:%,game_type:%',keyname,api,gameType;
			end if;
			*/
			IF position(rebate_id in keyname)=1 AND subkeys[3]::int=api AND rtrim(ltrim(subkeys[4]))=gameType
			THEN
				--开始作比较.
				val=gradshash->keyname;
				--判断如果存在多条记录，取第一条.
				vals=regexp_split_to_array(val,'\^\&\^');
				--vals=regexp_split_to_array(val,row_split_char);
				IF array_length(vals, 1)>1 THEN
					val=vals[1];
				END IF;
			  --玩家有效交易量
				effective_trade_amount=(rec->>'effective_trade_amount')::float;
				--代理API盈亏总额
				profit_amount=(rec->>'profit_amount')::float;
				--玩家数
				player_num=(rec->>'player_num')::int;
				--判断是否已经比较够且有效交易量大于当前值.
					--raise info '%',val;
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

					--返佣计算公式如下：
					--各API各分类佣金总和
					--=[各API各分类盈亏总和-(各API各分类盈亏总和*运营商占成）]*代理的佣金比例；
					--此处需要取得各个API运营商占成.
					--@todo.运营商API占成
					main_ratio=0;
					rebate_value=profit_amount*(1-main_ratio)*ratio/100;
          --raise info '[各API各分类盈亏总和-(各API各分类盈亏总和*运营商占成）]*代理的佣金比例,计算:%*(1-%)*%/100=%',profit_amount,main_ratio,ratio,rebate_value;
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
COMMENT ON FUNCTION gamebox_rebate_calculator(gradshash hstore,checkhash hstore,mainhash hstore,rec json) IS '返佣-计算-Lins';
--SELECT * FROM gamebox_rakeback_calculator();