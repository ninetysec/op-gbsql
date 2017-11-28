-- auto gen by fly 2016-01-06 16:53:40

--玩家层级信息
drop view if EXISTS v_sys_user_tier;
create or REPLACE view v_sys_user_tier as
select p.id,p.username
		,r.id rank_id,r.rank_name,r.rank_code,r.risk_marker,
		a.id agent_id,a.username agent_name,
		t.id topagent_id,t.username topagent_name
from sys_user a,sys_user p,sys_user t
,user_player up,player_rank r
where
a.id=p.owner_id
and a.owner_id=t.id
and a.user_type='23'
and p.user_type='24'
and t.user_type='22'
and p.id=up.id
and p.status='1'
and up.rank_id=r.id
order by p.id;
COMMENT ON VIEW "v_sys_user_tier" IS '玩家层级信息-Lins';

/*
* 根据返水周期统计各个API,各个玩家的返水数据.
* @author Lins
* @date 2015.11.10
* @参数1:返水期数.
* @参数2:返水周期开始时间(yyyy-mm-dd HH:mm:ss)
* @参数3:返水周期结束时间(yyyy-mm-dd HH:mm:ss)
* @参数4:运营商库的dblink 格式数据
* @参数5:出账标示:Y.已出账,N.未出账
	返回为空.
* 调用例子:
*
 select * from gamebox_rakeback('2015-11第二期','2015-01-08','2015-11-14'
,'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 ,'N');

*/
--删除上期函数.
drop function IF EXISTS gamebox_rakeback(text,text,text,text);
drop function IF EXISTS gamebox_rakeback(TEXT,TEXT,TEXT,TEXT,TEXT);
create or replace function gamebox_rakeback(
name text,startTime text,endTime text
,url text,flag TEXT) returns void as $$
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
	select gamebox_rakeback_bill(name,stTime,edTime,bill_id,'I',flag) INTO bill_id;
	--收集每个API下每个玩家的返水.
  raise info '统计玩家API返水';
	perform gamebox_rakeback_api(bill_id,stTime,edTime,gradshash,agenthash,flag);
	raise info '统计玩家API返水.完成';

	raise info '统计玩家返水';
  perform gamebox_rakeback_player(bill_id,flag);
	raise info '统计玩家返水.完成';

  raise info '更新返水总表';
	perform gamebox_rakeback_bill(name,stTime,edTime,bill_id,'U',flag);

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
,url text,flag TEXT) IS 'Lins-返水-玩家返水入口';



/*
* 返水插入与更新数据.
* @author Lins
* @date 2015.12.2
* @参数1:周期数.
* @参数2:返水周期开始时间(yyyy-mm-dd)
* @参数3:返水周期结束时间(yyyy-mm-dd)
* @参数4:返水键值
* @参数5:操作类型.I:新增.U:更新.
* @参数6:出账标示:Y.已出账,N.未出账
*/
--删除上期函数
DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT,TIMESTAMP,TIMESTAMP,INT,TEXT);
DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT,TIMESTAMP,TIMESTAMP,INT,TEXT,TEXT);
create or replace function gamebox_rakeback_bill(
name TEXT,start_time TIMESTAMP,end_time TIMESTAMP
,INOUT bill_id INT,op TEXT,flag TEXT)
 returns INT as $$
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
	rec record;
BEGIN
	IF flag='Y' THEN--已出账
		IF op='I' THEN
		--先插入返水总记录并取得键值.
			INSERT INTO rakeback_bill
			(
			 period,start_time,end_time,
			 player_count,player_lssuing_count,player_reject_count,rakeback_total,rakeback_actual,
			 create_time,lssuing_state
			) VALUES(
			 name,start_time,end_time,
			 0,0,0,0,0,
			 now(),pending_pay
			);
			SELECT currval(pg_get_serial_sequence('rakeback_bill', 'id')) into bill_id;
		ELSE

			FOR rec in
				select rakeback_bill_id,count(player_id) cl,sum(rakeback) sl
				from rakeback_api
				where rakeback_bill_id=bill_id group by rakeback_bill_id
			LOOP
				update rakeback_bill set player_count=rec.cl,rakeback_total=rec.sl where id=bill_id;
			END LOOP;
		END IF;
	ELSEIF flag='N' THEN--未出账
		IF op='I' THEN
		--先插入返水总记录并取得键值.
			INSERT INTO rakeback_bill_nosettled
			(
			 start_time,end_time,rakeback_total,create_time
			) VALUES(
			 start_time,end_time,0,now()
			);
			SELECT currval(pg_get_serial_sequence('rakeback_bill_nosettled', 'id')) into bill_id;
		ELSE

			FOR rec in
				select rakeback_bill_nosettled_id,count(player_id) cl,sum(rakeback) sl
				from rakeback_api_nosettled
				where rakeback_bill_nosettled_id=bill_id group by rakeback_bill_nosettled_id
			LOOP
				update rakeback_bill_nosettled set rakeback_total=rec.sl where id=bill_id;
			END LOOP;
		END IF;
	END IF;
	raise info 'rakeback_bill.完成.键值:%',bill_id;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_bill(
name TEXT,start_time TIMESTAMP,end_time TIMESTAMP
,bill_id INT,op TEXT,flag TEXT) IS 'Lins-返水-返水周期主表';


/*
* 各玩家API返水.
* @author Lins
* @date 2015.12.2
* @参数1:返水键值
* @参数2:开始时间
* @参数3:结束时间
* @参数4:返水梯度
* @参数5:各代理设置的梯度ID.
* @参数6:出账标示:Y.已出账,N.未出账
*/
--删除上期函数
DROP FUNCTION IF EXISTS gamebox_rakeback_api(INT,TIMESTAMP,TIMESTAMP,hstore,hstore);
DROP FUNCTION IF EXISTS gamebox_rakeback_api(INT,TIMESTAMP,TIMESTAMP,hstore,hstore,TEXT);
create or replace function gamebox_rakeback_api(
bill_id INT,start_time TIMESTAMP,end_time TIMESTAMP
,gradshash hstore,agenthash hstore,flag TEXT)
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

		) p left join user_player up
		on p.player_id=up.id,sys_user u
		where p.player_id=u.id

    LOOP
			select gamebox_rakeback_calculator(gradshash,agenthash,row_to_json(rec)) into rakeback;
			raise info '玩家:%,有效交易量:%,返水:%',rec.username,rec.effective_trade_amount,rakeback;
			raise info '梯度:%,api:%,game_type:%',rec.rakeback_id,rec.api_id,rec.game_type;
			--新增玩家返水:有返水才新增.
		  IF rakeback>0 THEN
				IF flag='Y' THEN
					INSERT INTO rakeback_api(
					rakeback_bill_id,player_id,api_id
					,api_type_id,game_type,rakeback,effective_transaction,profit_loss
					) VALUES(
					 bill_id,rec.userId,rec.api_id
					 ,rec.api_type_id,rec.game_type,rakeback,rec.effective_trade_amount,rec.profit_amount
					);
				 SELECT currval(pg_get_serial_sequence('rakeback_api', 'id')) into tmp;
				ELSEIF flag='N' THEN
					INSERT INTO rakeback_api_nosettled(
						rakeback_bill_nosettled_id,player_id,api_id
						,api_type_id,game_type,rakeback,effective_transaction,profit_loss
					) VALUES(
						 bill_id,rec.userId,rec.api_id
						 ,rec.api_type_id,rec.game_type,rakeback,rec.effective_trade_amount,rec.profit_amount
					);
				 SELECT currval(pg_get_serial_sequence('rakeback_api_nosettled', 'id')) into tmp;
				END IF;
				raise info '各API玩家返水键值:%',tmp;
			END IF;
		END LOOP;
	  raise info '收集每个API下每个玩家的返水.完成';
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api(
bill_id INT,start_time TIMESTAMP,end_time TIMESTAMP
,gradshash hstore,agenthash hstore,flag TEXT)
IS 'Lins-返水-各玩家API返水';


/*
* 各玩家返水.
* @author Lins
* @date 2015.12.2
* @参数1:返水键值
* @参数2:出账标示:Y.已出账,N.未出账
*/
--删除上期函数
DROP FUNCTION IF EXISTS gamebox_rakeback_player(INT);
DROP FUNCTION IF EXISTS gamebox_rakeback_player(INT,TEXT);
create or replace function gamebox_rakeback_player(bill_id INT,flag TEXT)
 returns void as $$
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
BEGIN
		IF flag='Y' THEN--已出账
			INSERT INTO rakeback_player(
				rakeback_bill_id,player_id,username
				,rank_id,rank_name,risk_marker,rakeback_total,settlement_state
				,agent_id,top_agent_id
			)
			select bill_id,u.id,u.username
			,u.rank_id,u.rank_name,u.risk_marker
			,s.rakeback,pending_lssuing
			,u.agent_id,u.topagent_id
			from
			(
				select player_id,sum(rakeback) rakeback
				from rakeback_api
				where rakeback_bill_id=bill_id
				group by player_id
			) s,v_sys_user_tier u
			where s.player_id=u.id;

		ELSEIF flag='N' THEN--未出账
			INSERT INTO rakeback_player_nosettled(
				rakeback_bill_nosettled_id,player_id,username
				,rank_id,rank_name,risk_marker,rakeback_total
				,top_agent_id,agent_id
			)
			select bill_id,u.id,u.username
			,u.rank_id,u.rank_name,u.risk_marker
			,s.rakeback,u.topagent_id,u.agent_id
			from
			(
				select player_id,sum(rakeback) rakeback
				from rakeback_api_nosettled
				where rakeback_bill_nosettled_id=bill_id
				group by player_id
			) s,v_sys_user_tier u
			where s.player_id=u.id;
		END IF;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_player(bill_id INT,flag TEXT)
IS 'Lins-返水-各玩家返水';


/*
* 玩家[API]返水.
* @author Lins
* @date 2015.12.2
* @参数1:开始时间
* @参数2:结束时间
* @参数3:返水梯度
* @参数4:各代理设置的梯度ID.
* @参数5:类型.API或PLAYER,区别在于KEY值不同.
				 另外GAME_TYPE 区别在于统计的维度不同.
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
	sql TEXT:='';
BEGIN
	SELECT '-1=>-1' INTO hash;
	IF category='GAME_TYPE' THEN
		sql='select p.api_id
			,p.game_type
			,p.player_num
			,p.effective_trade_amount
			,up.rakeback_id
			from
			(
				SELECT g.api_id
				,g.game_type
				,sum(distinct po.player_id) as player_num
				,sum(po.effective_trade_amount) AS effective_trade_amount
				FROM player_game_order po,'||vname||' g
				where po.game_id=g.id
				and po.create_time>=$1 and po.create_time<$2
				GROUP BY g.api_id,g.game_type
			) p left join user_player up
			on p.player_id=up.id ';
	ELSE
		sql='select p.player_id,u.owner_id
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
			where p.player_id=u.id ';
	END IF;
	FOR rec IN EXECUTE sql USING start_time,end_time
	LOOP
			--raise info '用户:%,梯度:%,api:%,game_type:%',rec.player_id,rec.rakeback_id,rec.api_id,rec.game_type;
			select gamebox_rakeback_calculator(gradshash,agenthash,row_to_json(rec)) into rakeback;
			--raise info '玩家:%,有效交易量:%,返水:%',rec.username,rec.effective_trade_amount,rakeback;

		  IF category='GAME_TYPE' THEN
				key=rec.api_id||col_split||rec.game_type;
				param=key||'=>'||rakeback||col_split||rec.player_num;
				hash=(SELECT param::hstore)||hash;
			ELSEIF category='API' THEN
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
--测试返水已出账
 select * from gamebox_rakeback('2015-11第二期','2015-01-08','2015-11-14'
,'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 ,'Y');

--测试返水未出账
 select * from gamebox_rakeback('2015-11第二期','2015-01-08','2015-11-14'
,'host=192.168.0.88 port=5432 dbname=gamebox-mainsite user=postgres password=postgres'
 ,'N');

*/
