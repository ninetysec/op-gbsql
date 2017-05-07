/*
* 计算各API占成金额
* @author Lins
* @date 2015.11.18
* @参数1.各个API的占成数据hash(KEY-VALUE)
* @参数2.运营商各个API的占成数据hash(KEY-VALUE)
* @参数3.当前代理统计数据JSON格式
	返回float类型，返佣值.
*/
--drop function gamebox_occupy_calculator(hstore,hstore,json);
create or replace function gamebox_occupy_calculator(occupyhash hstore,mainhash hstore,rec json) returns FLOAT as $$
DECLARE
	--占成
	ratio float:=0.00;
	--API
	api int:=0;
	--游戏类型
	game_type text;
	--代理ID
	top_agent_id text;
	--运营商API占成比例.
	main_ratio float:=0.00;
	keyname text:='';
	col_split text:='_';

	--占成金额
	occupy_value float:=0.00;
	--盈亏总额
	profit_amount float:=0.00;
BEGIN
			api=rec->>'api_id';
			game_type=rtrim(ltrim(rec->>'game_type'));
			top_agent_id=rec->>'owner_id';
		  keyname=top_agent_id||col_split||api||col_split||game_type;
			--raise info 'Hash健值:%',keyname;
			IF isexists(occupyhash, keyname) THEN
				ratio=(occupyhash->keyname)::float;
				main_ratio=0;
				--总代API盈亏总额
				profit_amount=(rec->>'profit_amount')::float;
				occupy_value=profit_amount*(1-main_ratio)*ratio/100;
				raise info '各API占成总额:%',occupy_value;
			ELSE
				raise info '总代:%,未设置当前API:%,GAME_TYPE:% 的梯度,未设置的占成金额置为:0.请检查!',top_agent_id,api,game_type;
			END IF;
	return occupy_value;
END
$$ language plpgsql;

--SELECT * FROM gamebox_occupy_calculator();
COMMENT ON FUNCTION gamebox_occupy_calculator(occupyhash hstore,mainhash hstore,rec json) IS '总代占成-各API占成计算-Lins';