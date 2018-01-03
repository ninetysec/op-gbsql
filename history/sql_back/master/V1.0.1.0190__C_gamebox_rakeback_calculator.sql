/*
* 计算返水
* @author Lins
* @date 2015.11.10
	返回float类型，返水值.
*/
--drop function gamebox_rakeback_calculator(hstore,hstore,json);
create or replace function gamebox_rakeback_calculator(gradshash hstore,agenthash hstore,rec json) returns FLOAT as $$
DECLARE
	--gradshash hstore;
	--agenthash hstore;
	--rec record;
	keys text[];
	subkeys text[];
	keyname text:='';
	--临时
	val text:='';
	--临时Hstore
	hash hstore;
	--梯度有效交易量
	valid_value float:=0.00;
	--上次梯度有效交易量
	pre_valid_value float:=0.00;
	--返水值.
	back_water_value float:=0.00;
	--占成
	ratio float:=0.00;
	--最大返水上限
	max_back_water float:=0.00;
	--玩家有效交易量
	effective_trade_amount float:=0.00;
	--梯度ID.
	back_water_id int:=0;
	--API
	api int:=0;
	--游戏类型
	gameType text;
	--代理ID
	agent_id text;
BEGIN
		--raise info '%',agenthash;
		keys=akeys(gradshash);
		--raise info 'Len=%',array_length(keys, 1);
	  --raise info 'rec=%',rec;
		for i in 1..array_length(keys, 1) loop
			subkeys=regexp_split_to_array(keys[i],'_');
			keyname=keys[i];

		  back_water_id=rec->>'rakeback_id';
			api=rec->>'api_id';
			gameType=rtrim(ltrim(rec->>'game_type'));
			--玩家未设置返水梯度,取当前玩家的代理返水梯度.
			agent_id=rec->>'owner_id';
			--raise info '代理ID:%,梯度:%',keyname,back_water_id;
			if back_water_id is null THEN
				back_water_id=agenthash->agent_id;
			end IF;
			if back_water_id is null THEN
				--raise exception '%:玩家未设置返水梯度,代理也未设置',rec->>'username';
				raise info '%:玩家未设置返水梯度,代理也未设置',rec->>'username';
				return 0;
			end IF;
			--raise info 'gameType=%',gameType;
			IF subkeys[1]::int=back_water_id AND subkeys[3]::int=api AND rtrim(ltrim(subkeys[4]))=gameType
			THEN
	      --raise info 'key=%',subkeys;
				--raise info '找到返水主方案:%',subkeys[1];
				--开始作比较.
			  --raise info 'val=%',gradshash->keyname;
				val=gradshash->keyname;
			  --玩家有效交易量
				effective_trade_amount=(rec->>'effective_trade_amount')::float;
				--判断是否已经比较够且有效交易量大于当前值.
				--raise info '%>%:%',effective_trade_amount,pre_valid_value,(effective_trade_amount>pre_valid_value);
				IF effective_trade_amount>pre_valid_value THEN
					select * from strToHash(val) into hash;
					--占成数
					ratio=(hash->'ratio')::float;
					--梯度有效交易量
					valid_value=(hash->'valid_value')::float;
					--返水上限
					max_back_water=(hash->'max_rakeback')::float;

					--raise info '梯度有效交易量:%,返水上限:%,占成比例:%,占成比例:%',valid_value,max_back_water,ratio,effective_trade_amount;
					--raise info '返水上限:%',max_back_water;
					--raise info '占成比例:%',ratio;
					--raise info '玩家有效值:%',effective_trade_amount;

					IF effective_trade_amount >= valid_value THEN
						--存储此次梯度有效交易量,作下次比较.
						pre_valid_value=valid_value;
						--返水计算:有效交易量*占成
						back_water_value=effective_trade_amount*ratio/100;
						--返水大于返水上限，以上限值为准.
						IF back_water_value>max_back_water THEN
								back_water_value=max_back_water;
						END IF;
						raise info '梯度有效交易量:%,返水上限:%,占成比例:%,玩家有效交易量:%',valid_value,max_back_water,ratio,effective_trade_amount;
					END IF;
					--raise info '玩家返水值:%',back_water_value;
				END IF;
			ELSE
			--	raise info '没找到返水方案';
			END IF;
		END LOOP;
	return back_water_value;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_calculator(gradshash hstore,agenthash hstore,rec json) IS '返水-玩家返水计算-Lins';
--SELECT * FROM gamebox_rakeback_calculator();