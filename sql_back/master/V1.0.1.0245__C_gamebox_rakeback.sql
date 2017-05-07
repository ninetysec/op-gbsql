/*
* 返水API梯度.
* @author: Lins
* @date:2015.11.10
*/

drop function if exists gamebox_rakeback_api_grads();
create or replace function gamebox_rakeback_api_grads() returns hstore as $$
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
		m.id,
		s.id as grads_id,
		d.api_id,
		d.game_type,
		COALESCE(d.ratio,0) ratio,
		COALESCE(s.max_rakeback,0) max_rakeback,
		COALESCE(s.valid_value,0) valid_value,
		m.name,
		COALESCE(m.audit_num,0) audit_num
	FROM
		rakeback_grads s,
		rakeback_grads_api d,
		rakeback_set m
	WHERE
		s.id = d.rakeback_grads_id AND
		s.rakeback_id = m.id AND m.status='1'
		order by m.id,d.api_id,d.game_type,s.valid_value desc
   loop
		--判断主方案是否存在.
		--键值格式:ID+GRADSID+API+GAMETYPE
		  keyname=	rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text;
			--val:=row_to_json(row(5,6,7,8,9));
		  val:=row_to_json(rec);
			val:=replace(val,',','\|');
			val:=replace(val,'null','-1');
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
				gradshash=gradshash||tmphash;
				--raise info '新值=%',gradshash->keyname;
			end if;
			--raise info '============';
	end loop;
		--raise info '键的数量：%',array_length(akeys(gradshash),1);
    --raise info '键值：%',akeys(gradshash);
    --raise info '值：%',avals(gradshash);
	return gradshash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_grads()
 IS 'Lins-返水-API梯度';
--SELECT * FROM gamebox_rakeback_set();

/*
* 返水计算
* @author Lins
* @date 2015.11.10
	返回float类型，返水值.
*/
drop function if exists gamebox_rakeback_calculator(hstore,hstore,json);
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
		--raise info 'gradshash=%',gradshash;
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
			end if;
			if back_water_id is null THEN
				--raise exception '%:玩家未设置返水梯度,代理也未设置',rec->>'username';
				raise info '%:玩家未设置返水梯度,代理也未设置',rec->>'username';
				return 0;
			end if;
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
						raise info '玩家信息.ID:%,API:%,GAMETYPE:%,有效交易量:%,梯度.有效交易量:%,上限:%,比例:%,返水:%'
							,rec->>'player_id',api,gameType,effective_trade_amount,valid_value,max_back_water,ratio,back_water_value;
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
COMMENT ON FUNCTION gamebox_rakeback_calculator(
gradshash hstore,agenthash hstore,rec json)
 IS 'Lins-返水-返水计算';
--SELECT * FROM gamebox_rakeback_calculator();

/*
* 代理默认返水方案.
* @author Lins
* @date 2015-11-10
* 返回hstore类型
*/
--drop function gamebox_agent_rakeback();
create or replace function gamebox_agent_rakeback() returns hstore as $$
DECLARE
	hash hstore;
	rec record;
	param text:='';
BEGIN
	for rec in
		select a.user_id,a.rakeback_id from user_agent_rakeback a,sys_user u where a.user_id=u.id and u.user_type='22'
    loop
			param=param||rec.user_id||'=>'||rec.rakeback_id||',';
	end loop;
	if length(param)>0 THEN
		param=substring(param,1,length(param)-1);
	end IF;
	--raise info '结果:%',param;
	select param::hstore into hash;
	--测试引用值.
  --raise info '4:%',hash->'3';
	return hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_agent_rakeback()
 IS 'Lins-返水-代理默认梯度方案';
--SELECT gamebox_agent_rakeback();

/*
* 根据返水周期统计各个API,各个玩家的返水数据.
* @author Lins
* @date 2015.11.10
* @参数1:返水期数.
* @参数2:返水周期开始时间(yyyy-mm-dd HH:mm:ss)
* @参数3:返水周期结束时间(yyyy-mm-dd HH:mm:ss)
* @参数4:运营商库的dblink 格式数据
* @参数5:当前站点ID
	返回为空.
* 调用例子:
*
 select * from gamebox_rakeback('2015-11第二期','2015-01-08','2015-11-14'
,'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres');

*/
drop function IF EXISTS gamebox_rakeback(text,text,text,text);
create or replace function gamebox_rakeback(
name text,startTime text,endTime text
,url text) returns void as $$
DECLARE
  gradshash hstore;
	agenthash hstore;
	a1 text;
	a2 text;
	a3 text;
	stTime TIMESTAMP;
	edTime TIMESTAMP;
	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
	vname text:='v_site_game';
	bill_id INT:=-1;
	sid INT;
BEGIN
	raise info '开始统计( % )的返水,周期( %-% )',name,startTime,endTime;
	raise info '创建站点游戏视图';
	--url='host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres';
	select gamebox_current_site() INTO sid;
  perform gamebox_site_game(url,vname,sid,'C');
	--取得当前返水梯度设置信息.
  select gamebox_rakeback_api_grads() into gradshash;
  select gamebox_agent_rakeback() into agenthash;
	stTime=startTime::TIMESTAMP;
	edTime=endTime::TIMESTAMP;
	raise info '返水总表数据预新增.';
	select gamebox_rakeback_bill(name,stTime,edTime,bill_id,'I') INTO bill_id;
	--收集每个API下每个玩家的返水.
  raise info '统计玩家API返水';
	perform gamebox_rakeback_api(bill_id,stTime,edTime,gradshash,agenthash);
	raise info '统计玩家API返水.完成';

	raise info '统计玩家返水';
  perform gamebox_rakeback_player(bill_id);
	raise info '统计玩家返水.完成';

  raise info '更新返水总表';
	perform gamebox_rakeback_bill(name,stTime,edTime,bill_id,'U');

	--删除临时视图表.
	perform gamebox_site_game(url,vname,sid,'D');

  --EXCEPTION WHEN unique_violation THEN
	EXCEPTION
	WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS a1 = MESSAGE_TEXT,
                          a2 = PG_EXCEPTION_DETAIL,
                          a3 = PG_EXCEPTION_HINT;
	raise EXCEPTION '异常:%,%,%',a1,a2,a3;

END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback(
name text,startTime text,endTime text
,url text) IS 'Lins-返水-玩家返水入口';
--select * from gamebox_backwater('','');

/*
* 返水插入与更新数据.
* @author Lins
* @date 2015.12.2
* @参数1:周期数.
* @参数2:返水周期开始时间(yyyy-mm-dd)
* @参数3:返水周期结束时间(yyyy-mm-dd)
* @参数4:返水键值
* @参数5:操作类型.I:新增.U:更新.
*/
DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT,TIMESTAMP,TIMESTAMP,INT,TEXT);
create or replace function gamebox_rakeback_bill(
name TEXT,start_time TIMESTAMP,end_time TIMESTAMP
,INOUT bill_id INT,op TEXT)
 returns INT as $$
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
	rec record;
BEGIN
	IF op='I' THEN
	--先插入返水总记录并取得键值.
		INSERT INTO rakeback_bill
		(
		 period,start_time,end_time
		,player_count,rakeback_total,create_time,lssuing_state
		)
		VALUES(
		 name,start_time,end_time
		 ,0,0,now(),pending_pay
		);
		SELECT currval(pg_get_serial_sequence('rakeback_bill', 'id')) into bill_id;
	ELSE

		FOR rec in select rakeback_bill_id,count(player_id) cl,sum(rakeback) sl
			from rakeback_api where rakeback_bill_id=bill_id group by rakeback_bill_id
		LOOP
			--raise info '玩家数:%,返水总额:%',rec.cl,rec.sl;
			update rakeback_bill set player_count=rec.cl,rakeback_total=rec.sl where id=bill_id;
		END LOOP;
	END IF;
	raise info 'rakeback_bill.完成.键值:%',bill_id;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_bill(
name TEXT,start_time TIMESTAMP,end_time TIMESTAMP
,bill_id INT,op TEXT) IS 'Lins-返水-返水周期主表';


/*
* 各玩家返水.
* @author Lins
* @date 2015.12.2
* @参数1:返水键值
*/
DROP FUNCTION IF EXISTS gamebox_rakeback_player(INT);
create or replace function gamebox_rakeback_player(bill_id INT)
 returns void as $$
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
BEGIN
		INSERT INTO rakeback_player(
			rakeback_bill_id,player_id,username
			,rank_id,rank_name,risk_marker,rakeback_total,settlement_state
		)
		select bill_id,u.id,u.username
		,p.rank_id,r.rank_name,r.risk_marker
		,s.rakeback,pending_lssuing
		from
		(
			select player_id,sum(rakeback) rakeback
			from rakeback_api
			where rakeback_bill_id=bill_id
			group by player_id
		) s,sys_user u,user_player p,player_rank r
    where s.player_id=u.id
		and s.player_id=p.id
		and p.rank_id=r.id;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_player(bill_id INT)
IS 'Lins-返水-各玩家返水';

/*
* 各玩家API返水.
* @author Lins
* @date 2015.12.2
* @参数1:返水键值
* @参数2:开始时间
* @参数3:结束时间
* @参数4:返水梯度
* @参数5:各代理设置的梯度ID.
*/
DROP FUNCTION IF EXISTS gamebox_rakeback_api(INT,TIMESTAMP,TIMESTAMP,hstore,hstore);
create or replace function gamebox_rakeback_api(
bill_id INT,start_time TIMESTAMP,end_time TIMESTAMP
,gradshash hstore,agenthash hstore)
 returns void as $$
DECLARE
	rakeback FLOAT:=0.00;
	tmp INT:=0;
	rec record;
BEGIN
	FOR rec IN
		select p.player_id userid,u.username,u.owner_id
		,p.api_id,p.api_type_id,p.game_type
		,p.effective_trade_amount,up.rakeback_id,up.rank_id
		,p.profit_amount
		from
		(
			SELECT po.player_id,g.api_id,g.game_type,
	    g.api_type_id,sum(COALESCE(po.effective_trade_amount,0.00)) AS effective_trade_amount
			,sum(COALESCE(po.profit_amount,0.00)) AS profit_amount
      FROM player_game_order po,v_site_game g
			where po.game_id=g.id
			and po.create_time>=start_time and po.create_time<end_time
      GROUP BY po.player_id,g.api_id,g.game_type,g.api_type_id
      --order by po.player_id,g.api_id,g.api_type_id,g.game_type
		) p left join user_player up
		on p.player_id=up.id,sys_user u
		where p.player_id=u.id
		--order by p.effective_trade_amount desc

    LOOP

			select gamebox_rakeback_calculator(gradshash,agenthash,row_to_json(rec)) into rakeback;
			raise info '玩家:%,有效交易量:%,返水:%',rec.username,rec.effective_trade_amount,rakeback;
			raise info '梯度:%,api:%,game_type:%',rec.rakeback_id,rec.api_id,rec.game_type;
			--新增玩家返水:有返水才新增.
		  IF rakeback>0 THEN
				INSERT INTO rakeback_api(
				rakeback_bill_id,player_id,api_id
				,api_type_id,game_type,rakeback,effective_transaction,profit_loss
				) VALUES(
				 bill_id,rec.userId,rec.api_id
				 ,rec.api_type_id,rec.game_type,rakeback,rec.effective_trade_amount,rec.profit_amount
				);
			 SELECT currval(pg_get_serial_sequence('rakeback_api', 'id')) into tmp;
			 raise info '各API玩家返水键值:%',tmp;
			END IF;
		END LOOP;
	  raise info '收集每个API下每个玩家的返水.完成';

END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api(
bill_id INT,start_time TIMESTAMP,end_time TIMESTAMP
,gradshash hstore,agenthash hstore)
IS 'Lins-返水-各玩家API返水';




/*
* 玩家[API]返水.
* @author Lins
* @date 2015.12.2
* @参数1:开始时间
* @参数2:结束时间
* @参数3:返水梯度
* @参数4:各代理设置的梯度ID.
* @参数5:类型.API或PLAYER,区别在于KEY值不同.
* @参数6:站点游戏表临时视图.
*/
DROP FUNCTION IF EXISTS gamebox_rakeback_api_map(TIMESTAMP,TIMESTAMP,hstore,hstore,TEXT,TEXT);
create or replace function gamebox_rakeback_api_map(
start_time TIMESTAMP,end_time TIMESTAMP
,gradshash hstore,agenthash hstore,category TEXT,vname TEXT)
 returns hstore as $$
DECLARE
	hash hstore;--玩家API或玩家返水.
	rakeback FLOAT:=0.00;
	val FLOAT:=0.00;
	key TEXT:='';
	col_split TEXT:='_';
	rec record;
	param TEXT:='';
BEGIN
	SELECT '-1=>-1' INTO hash;
	FOR rec IN EXECUTE '
		select p.player_id,u.owner_id
		,p.api_id,p.api_type_id,p.game_type
		,p.effective_trade_amount,up.rakeback_id
		from
		(
			SELECT po.player_id,g.api_id,g.game_type,
	    g.api_type_id,sum(po.effective_trade_amount) AS effective_trade_amount
      FROM player_game_order po,'||vname||' g
			where po.game_id=g.id
			and po.create_time>=$1 and po.create_time<$2
      GROUP BY po.player_id,g.api_id,g.game_type,g.api_type_id
		) p left join user_player up
		on p.player_id=up.id,sys_user u
		where p.player_id=u.id
		'
		USING start_time,end_time
	LOOP
			--raise info '用户:%,梯度:%,api:%,game_type:%',rec.player_id,rec.rakeback_id,rec.api_id,rec.game_type;
			select gamebox_rakeback_calculator(gradshash,agenthash,row_to_json(rec)) into rakeback;
			--raise info '玩家:%,有效交易量:%,返水:%',rec.username,rec.effective_trade_amount,rakeback;
			IF category='API' THEN
				key=rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
				param=key||'=>'||rakeback;
				hash=(SELECT param::hstore)||hash;
			ELSE
				key=rec.player_id;
				param=key||'=>'||rakeback;
				IF isexists(hash,key) THEN
					val=(hash->key)::FLOAT;
					val=val+rakeback;
					param=key||'=>'||val;
				END IF;
				hash=(SELECT param::hstore)||hash;
			END IF;
	END LOOP;
	raise info '%',hash;
	RETURN hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_map(
start_time TIMESTAMP,end_time TIMESTAMP
,gradshash hstore,agenthash hstore,category TEXT,vname TEXT)
IS 'Lins-返水-玩家[API]返水-返佣调用';


/*
* 玩家[API]返水.
* @author Lins
* @date 2015.12.3
* @参数1:返水周期开始时间(yyyy-mm-dd HH:mm:ss)
* @参数2:返水周期结束时间(yyyy-mm-dd HH:mm:ss)
* @参数3:运营商库的dblink 格式数据
* @参数4:类型.API或PLAYER,区别在于KEY值不同.
* 调用例子:
* select * from gamebox_rakeback_map('2015-01-08','2015-11-14'
,'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'PLAYER');
*/
drop function IF EXISTS gamebox_rakeback_map(TIMESTAMP,TIMESTAMP,text,text);
create or replace function gamebox_rakeback_map(
startTime TIMESTAMP,endTime TIMESTAMP
,url TEXT,category TEXT) returns hstore as $$
DECLARE
  gradshash hstore;
	agenthash hstore;
	hash hstore;
	vname text:='v_site_game';
	sid INT:=-1;
BEGIN

	select gamebox_current_site() INTO sid;
  perform gamebox_site_game(url,vname,sid,'C');
	--取得当前返水梯度设置信息.
  select gamebox_rakeback_api_grads() into gradshash;
  select gamebox_agent_rakeback() into agenthash;
  raise info '统计玩家API返水';
	SELECT gamebox_rakeback_api_map(startTime,endTime,gradshash,agenthash,category,vname) INTO hash;
	raise info '统计玩家API返水.完成';
	--删除临时视图表.
	perform gamebox_site_game(url,vname,sid,'D');
	RETURN hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_map(
startTime TIMESTAMP,endTime TIMESTAMP
,url TEXT,category TEXT) IS 'Lins-返水-玩家入口-返佣调用';

/*
 select * from gamebox_rakeback_map('2015-01-08'::TIMESTAMP,'2015-12-18'::TIMESTAMP
,'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'API');

 select * from gamebox_rakeback('2015-11第二期','2015-01-08','2015-11-14'
,'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres');

*/