/*
* 代理返佣默认方案.
* @author Lins
* @date 2015-11-11
* 返回hstore类型
*/
drop function if exists gamebox_agent_rebate();
drop function if exists gamebox_rebate_agent_default_set();
create or replace function gamebox_rebate_agent_default_set() returns hstore as $$
DECLARE
	hash hstore;
	rec record;
	param text:='';
BEGIN
	for rec in
		select a.user_id,a.rebate_id
		from user_agent_rebate a,sys_user u
		where a.user_id=u.id and u.user_type='23'
    loop
			param=param||rec.user_id||'=>'||rec.rebate_id||',';
	end loop;
	IF length(param)>0 THEN
		param=substring(param,1,length(param)-1);
	END IF;
	--raise info '结果:%',param;
	select param::hstore into hash;
	--测试引用值.
  --raise info '4:%',hash->'3';
	return hash;
END;
$$ language plpgsql;

--SELECT * FROM gamebox_agent_rebate();
COMMENT ON FUNCTION gamebox_rebate_agent_default_set() IS 'Lins-返佣-代理返佣默认方案';


/*
* 计算各个代理适用的返佣梯度.
* @author Lins
* @date 2015.11.10
	返回float类型，返水值.
*/
drop function IF EXISTS gamebox_rebate_agent_check(hstore,hstore,TIMESTAMP,TIMESTAMP);
create or replace function gamebox_rebate_agent_check(
gradshash hstore
,agenthash hstore
,start_time TIMESTAMP
,end_time TIMESTAMP
) returns hstore as $$
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
	col_aplit TEXT:='_';
BEGIN
  keys=akeys(gradshash);
  --raise info '%',agenthash;
	--raise info 'Len=%',array_length(keys, 1);
	FOR rec IN
            SELECT
            a.id,a.username,
						count(DISTINCT o.player_id) player_num,
						sum(-COALESCE(o.profit_amount,0)) as profit_amount,
            sum(COALESCE(o.effective_trade_amount,0)) AS effective_trade_amount
            FROM player_game_order o,sys_user u,sys_user a
	          where o.player_id=u.id
					  and u.owner_id=a.id
						and o.create_time>=start_time and o.create_time<end_time
            GROUP BY a.id,a.username
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
			--profit_amount=-profit_amount;
		  --player_num=5;
			if profit_amount<=0 THEN
				CONTINUE;
			end IF;
			--取得返佣主方案.
			agent_id:=(rec.id)::text;
		  --raise info '代理ID:%',agent_id;
			--判断代理是否设置了返佣梯度.
			--raise info 'isexists(agenthash,agent_id)=%',isexists(agenthash,agent_id);
			if isexists(agenthash,agent_id) THEN
					rebate_id=agenthash->agent_id;
				  --raise info 'rec=%',rec;
				for i in 1..array_length(keys, 1) loop
					--KEY格式. rebate_id+grads_id+api_id+game_type
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

						 /*
							raise info '玩家数:%,盈亏:%,交易量:%,梯度.有效玩家:%,盈亏:%,交易量:%'
							,player_num,profit_amount,effective_trade_amount
							,valid_player_num,total_profit,valid_value;
						  */
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
								param=agent_id||'=>'||subkeys[1]||col_aplit||subkeys[2]||col_aplit||player_num||col_aplit||profit_amount||col_aplit||effective_trade_amount||col_aplit||rec.username;
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

COMMENT ON FUNCTION gamebox_rebate_agent_check(
gradshash hstore
,agenthash hstore
,start_time TIMESTAMP
,end_time TIMESTAMP
)
 IS 'Lins-返佣-计算各个代理适用的返佣梯度';
--SELECT * FROM gamebox_rakeback_calculator();

/**
* 分摊费用与返佣统计
* @author Lins
* @date 2015.11.13
* 参数1.返佣主表键值
* 参数2.开始时间
* 参数3.结束时间
* 参数4.行分隔符
* 参数5.列分隔符
* 返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
*/
drop function if exists gamebox_rebate_expense_gather(int,hstore,TIMESTAMP,TIMESTAMP,text,text);
create or replace function gamebox_rebate_expense_gather(
bill_id int,rakebackhash hstore
,start_time TIMESTAMP,end_time TIMESTAMP
,row_split text,col_split text) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	mhash hstore;
	param text:='';
	user_id text:='';
	money float:=0.00;
	loss FLOAT:=0.00;
	eff_transaction FLOAT:=0.00;
	agent_id INT;
	agent_name TEXT:='';
BEGIN

		SELECT gamebox_expense_gather(start_time,end_time,row_split,col_split) INTO hash;
		--raise info '%',hash;

	  --统计各代理返佣.
		FOR rec IN
			SELECT p.player_id,u.owner_id,a.username
			,p.rebate_total,p.effective_transaction,p.profit_loss
			FROM
			(
				SELECT player_id,sum(rebate_total) rebate_total
				,sum(effective_transaction) effective_transaction
				,sum(profit_loss) profit_loss
				FROM rebate_api
				WHERE rebate_bill_id=bill_id
				GROUP BY player_id
			) p,sys_user u,sys_user a
			WHERE p.player_id=u.id AND u.owner_id=a.id
			AND u.user_type='24' and a.user_type='23'

		LOOP

			user_id=rec.player_id::text;
			agent_id=rec.owner_id;
			agent_name=rec.username;
			money=rec.rebate_total;
			loss=rec.profit_loss;
			eff_transaction=rec.effective_transaction;
			IF isexists(hash,user_id) THEN
				param=hash->user_id;
				param=param||row_split||'rebate'||col_split||money::text;
				param=param||row_split||'profit_loss'||col_split||loss::text;
				param=param||row_split||'effective_transaction'||col_split||eff_transaction::text;
				param=param||row_split||'agent_name'||col_split||agent_name;
				param=param||row_split||'agent_id'||col_split||agent_id::text;
			ELSE
				param='rebate'||col_split||money::text;
				param=param||row_split||'profit_loss'||col_split||loss::text;
				param=param||row_split||'effective_transaction'||col_split||eff_transaction::text;
				param=param||row_split||'agent_name'||col_split||agent_name;
				param=param||row_split||'agent_id'||col_split||agent_id::text;
			END IF;

			select user_id||'=>'||param into mhash;
			IF hash is null THEN
				hash=mhash;
			ELSE
				hash=hash||mhash;
			END IF;
		END LOOP;
		raise info '统计当前周期内各代理的各种费用信息.完成';
		RETURN hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_expense_gather(
bill_id int,rakebackhash hstore,startTime TIMESTAMP
,endTime TIMESTAMP,row_split_char text,col_split_char text)
 IS 'Lins-返佣-分摊费用与返佣统计';

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
--drop function if EXISTS gamebox_rebate_calculator(hstore,hstore,hstore,json);
--create or replace function gamebox_rebate_calculator(gradshash hstore,checkhash hstore,mainhash hstore,rec json) returns FLOAT as $$
drop function if EXISTS gamebox_rebate_calculator(hstore,hstore,hstore,INT,INT,INT,TEXT,FLOAT);
create or replace function gamebox_rebate_calculator(
rebate_grads_map hstore
,agent_check_map hstore
,operation_occupy_map hstore
,agent_id INT
,player_id INT
,api_id INT
,game_type TEXT
,profit_amount FLOAT
) returns FLOAT as $$
DECLARE
	keys text[];
	subkeys text[];
	keyname text:='';
	--临时
	val text:='';
	vals text[];
	--临时Hstore
	hash hstore;

	rebate_value float:=0.00;--返佣值.
	ratio float:=0.00;--占成
	max_rebate float:=0.00;--最大返佣上限

	rebate_id text;	--梯度ID.
	api TEXT;--API
	agent text;--代理ID
	player text;--玩家
	operation_occupy float:=0.00;--运营商API占成.

	col_split TEXT:='_';
BEGIN
		player=(player_id::TEXT);
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
				keyname=player||col_split||api||col_split||game_type;
				operation_occupy=(operation_occupy_map->keyname)::FLOAT;
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
,operation_occupy_map hstore
,agent_id INT
,player_id INT
,api_id INT
,game_type TEXT
,profit_amount FLOAT
)IS 'Lins-返佣-计算';

/*
* 各种API返佣方案.
* @author Lins
* @date 2015.11.11
*/
drop function IF exists gamebox_rebate_set();
drop function IF exists gamebox_rebate_api_grads();
create or replace function gamebox_rebate_api_grads() returns hstore as $$
DECLARE
	rec record;
	param text:='';
	gradshash hstore;
	tmphash hstore;
	keyname text:='';
	val text:='';
	val2 text:='';
BEGIN
	for rec in
	SELECT
		DISTINCT
		m.id, --返佣主案ID
		m.name,
		s.id as grads_id, --返佣梯度ID
		d.api_id,
		d.game_type,
		d.ratio, --API占成比例
		m.valid_value,--有效交易量
		s.total_profit,--有效盈利总额
		s.max_rebate,--返佣上限
		s.valid_player_num--有效玩家数
		--,d.id
	FROM
		rebate_set m,
		rebate_grads s,
		rebate_grads_api d
	WHERE
    m.id=s.rebate_id AND m.status='1'
		AND s.id = d.rebate_grads_id

		order by m.id,d.api_id,d.game_type,m.valid_value desc,s.total_profit desc,s.valid_player_num desc

   loop
		--判断主方案是否存在.
		--键值格式:ID+GRADSID+API+GAMETYPE
			keyname=	rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text;
		  --keyname=	rec.id::text||col_split_char||rec.grads_id::text||col_split_char||rec.api_id::text||col_split_char||rec.game_type::text;
			--val:=row_to_json(row(5,6,7,8,9));
		  val:=row_to_json(rec);
			--raise info 'rec=%',val;

			val:=replace(val,',','\|');
			val:=replace(val,'\:null\,','\:-1\,');
			--raise info 'rec2=%',val;
			--raise info '============%,%',keyname,gradshash?keyname;
			--raise info 'count:%',array_length(akeys(gradshash), 1);
			if (gradshash?keyname) is null OR (gradshash?keyname) =false THEN
				--raise info '创建KEY:%',val;
				--select keyname||'=>'||val into tmphash;
        --gradshash=hash||tmphash;
					if gradshash is null then
						select keyname||'=>'||val into gradshash;
					ELSE
						select keyname||'=>'||val into tmphash;
						gradshash=gradshash||tmphash;
					end IF;
	      -- raise info 'gradsHash=%',gradshash->keyname;
			else
				val2=gradshash->keyname;
				--raise info '原值=%',gradshash->keyname;
	      select keyname||'=>'||val||'^&^'||val2 into tmphash;
				--select keyname||'=>'||val||row_split_char||val2 into tmphash;
				gradshash=gradshash||tmphash;
				--raise info '新值=%',gradshash->keyname;
			end if;
			--raise info '============';
	end loop;
	raise info 'gamebox_rebate_set.键的数量：%',array_length(akeys(gradshash),1);
    --raise info '键值：%',akeys(gradshash);
    --raise info '值：%',avals(gradshash);
	--raise info '%',gradshash;
	return gradshash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_api_grads() IS 'Lins-返佣-返佣API梯度';
--SELECT * FROM gamebox_rebate_set('^&^','^');

/*
* 创建站点游戏临时视图.用完就删除
* @author Lins
* @date 2015.11.17
* @参数1: dblink 连接字符串
* @参数2：视图名称
* @参数3: 站点ID.
* @参数4：操作.C.创建.D.删除
* 调用方式：select * from gamebox_site_game('host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres','vsite_game',1);
*/
drop function if exists gamebox_site_game(text,text,int);
drop function if exists gamebox_site_game(text,text,int,text);
create or replace function gamebox_site_game(url text,vname text,site_id INT,OP TEXT) returns void as $$
DECLARE
	num int:=0;
BEGIN
	select count(*) from pg_views where viewname=''||vname||'' into num;
	--raise info 'num:%',num;
  IF num>0 AND (OP='D' OR OP='C') THEN
		execute 'drop view '||vname;
	END IF;
	IF OP='C' THEN
  EXECUTE
	'create or replace view '||vname||'
	 as select * from dblink('''||url||''',
	''select id,game_id,api_id,game_type,api_type_id
		from site_game where site_id='||site_id||''')
	  as p(id int4,game_id int4,api_id int4,game_type VARCHAR
		,api_type_id int4)';
  END IF;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_site_game(url text,vname text,site_id INT,OP TEXT)
 IS 'Lins-返佣-游戏API临时视图';
--select * from gamebox_site_game('host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres','v_site_game',1,'C');


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
*/
create or replace function gamebox_sys_param(paramType text) returns hstore as $$
DECLARE
	param text:='';
	hash hstore;
	rec record;
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
	return hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_sys_param(paramType text) IS 'Lins-返佣-系统各种参数萃取';
--select * from gamebox_sys_param('apportionSetting');

/*
* 把字符串转为hstore.
* @author Lins
* @date 2015.11.10
* 返回hstore类型数据.
*/
create or replace function strToHash(param text) returns hstore as $$
DECLARE
	hash hstore;
BEGIN
	--进行字符串转换.
			--raise info 'param:%',param;
			param=replace(param,'|',',');
			param=replace(param,':','=>');
			param=replace(param,'{','');
			param=replace(param,'}','');
			select param into hash;
			return hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION strToHash(param text) IS 'Lins-把字符串转为Hash';
--select * from strToHash('{"id":104|"rakeback_id":"52"|"valid_value":1000|"max_rakeback":200}');
--select * from strToHash('{"id":43|"grads_id":56|"api_id":1|"game_type":"01"|"ratio":3.00|"max_rakeback":1|"valid_value":1|"name":"lorne1"|"audit_num":4}');


/*
* 根据返佣周期统计各个API,各个玩家的返佣数据.
* @author Lins
* @date 2015.11.10
* @参数1:返佣周期名称.
* @参数2:返佣周期开始时间(yyyy-mm-dd)
* @参数3:返佣周期结束时间(yyyy-mm-dd)
	返回为空.
* 调用例子:
* select * from gamebox_rebate('2015-11第二期','2015-01-08','2015-11-14');
*/
drop function if exists gamebox_rebate(text,text,text,text,int);
drop function if exists gamebox_rebate(text,text,text,text);
create or replace function gamebox_rebate(name text,startTime text,endTime text,url text) returns void as $$
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
	SELECT gamebox_rebate_bill(name,stTime,edTime,rebate_bill_id,'I') INTO rebate_bill_id;
  raise info '返佣rebate_bill.ID=%',rebate_bill_id;
	--先统计每个代理的有效交易量、有效玩家、盈亏总额.
  raise info '计算各玩家API返佣';
	perform gamebox_rebate_api(rebate_bill_id,stTime,edTime,gradshash,checkhash,mainhash);

  raise info '收集各玩家的分摊费用';
	select gamebox_rebate_expense_gather(rebate_bill_id,rakebackhash
	,stTime,edTime,row_split,col_split) into hash;

	raise info '统计各玩家返佣';
  perform gamebox_rebate_player(syshash,hash,rakebackhash,rebate_bill_id,row_split,col_split);

	raise info '开始统计代理返佣';
	--perform gamebox_rebate_agent(checkhash,syshash,hash,rebate_bill_id,row_split_char,col_split_char);
	perform gamebox_rebate_agent(rebate_bill_id);

  raise info '更新返佣总表';
	perform gamebox_rebate_bill(name,stTime,edTime,rebate_bill_id,'U');
	--删除临时视图表.
	perform gamebox_site_game(url,vname,sid,'D');

	--异常处理
	EXCEPTION
	WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS a1 = MESSAGE_TEXT,a2 = PG_EXCEPTION_DETAIL,a3 = PG_EXCEPTION_HINT;
		raise EXCEPTION '异常:%,%,%',a1,a2,a3;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate(periodName text,startTime text,endTime text,url text)
 IS 'Lins-返佣-代理返佣计算入口';

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
			--select gamebox_rebate_calculator(gradshash,checkhash,mainhash,row_to_json(rec)) into rebate_value;
			select gamebox_rebate_calculator(gradshash,checkhash,mainhash,rec.owner_id
			,rec.id,rec.api_id,rec.game_type,rec.profit_amount) into rebate_value;
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
create or replace function gamebox_rebate_player(
syshash hstore
,expense_map hstore
,rakeback_map hstore
,bill_id INT
,row_split text
,col_split text
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
)
IS 'Lins-返佣-各玩家返佣统计';

/**
*/
drop function if exists gamebox_rebate_agent(INT);
create or replace function gamebox_rebate_agent(bill_id INT) returns void as $$
DECLARE
BEGIN
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

   raise info '开始统计代理返佣.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_agent(INT)
IS 'Lins-返佣-代理返佣计算';

/*
* 返佣插入与更新数据.
* @author Lins
* @date 2015.12.2
* @参数1:周期数.
* @参数2:返佣周期开始时间(yyyy-mm-dd)
* @参数3:返佣周期结束时间(yyyy-mm-dd)
* @参数4:返佣键值
* @参数5:操作类型.I:新增.U:更新.
*/
DROP FUNCTION IF EXISTS gamebox_rebate_bill(TEXT,TIMESTAMP,TIMESTAMP,INT,TEXT);
create or replace function gamebox_rebate_bill(
name TEXT,start_time TIMESTAMP,end_time TIMESTAMP
,INOUT bill_id INT,op TEXT)
 returns INT as $$
DECLARE
	rec record;
	pending_pay text:='pending_pay';
	key_id INT;
BEGIN
	IF op='I' THEN
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
	RETURN;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_bill(
name TEXT,start_time TIMESTAMP,end_time TIMESTAMP
,bill_id INT,op TEXT)
IS 'Lins-返佣-返佣周期主表';



/**
* 分摊费用
* @author Lins
* @date 2015.11.13
* 参数1.开始时间
* 参数2.结束时间
* 参数3.行分隔符
* 参数4.列分隔符
* 返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
*/
drop function if exists gamebox_expense_gather(TIMESTAMP,TIMESTAMP,text,text);
create or replace function gamebox_expense_gather(
start_time TIMESTAMP,end_time TIMESTAMP
,row_split text,col_split text) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	mhash hstore;
	param text:='';
	user_id text:='';
	money float:=0.00;
BEGIN
		FOR rec IN
			select player_id,fund_type,sum(transaction_money) as transaction_money
			from player_transaction
			where fund_type in ('backwater','favourable','recommend','refund_fee')
			and status='success'
			and create_time>=start_time and create_time<end_time
			group by player_id,fund_type
		 LOOP
			user_id=rec.player_id::text;
			money=rec.transaction_money;
			IF isexists(hash,user_id) THEN
				param=hash->user_id;
				--param=param||'^&^'||rec.fund_type||'^'||money::text;
				param=param||row_split||rec.fund_type||col_split||money::text;
			ELSE
				param=rec.fund_type||col_split||money::text;
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
start_time TIMESTAMP,end_time TIMESTAMP
,row_split text,col_split text)
IS 'Lins-分摊费用';

/*
select * from gamebox_rebate(
'2015-11第二期','2015-01-08','2015-12-14'
,'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres');

*/

--select * from gamebox_rebate_bill('2015-11第二期','2015-01-08','2015-12-14',-1,'I');
