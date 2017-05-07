/*
* 根据返水周期统计各个API,各个玩家的返水数据.
* @author Lins
* @date 2015.11.10
* @参数1:返水周期名称.
* @参数2:返水周期开始时间(yyyy-mm-dd)
* @参数3:返水周期结束时间(yyyy-mm-dd)
	返回为空.
* 调用例子:
* select * from gamebox_backwater('2015-11第二期','2015-01-08','2015-11-14');
*/
--drop function gamebox_backwater(text,text,text,text,int);
create or replace function gamebox_backwater(periodName text,startTime text,endTime text,url text,sid int) returns void as $$
DECLARE
	rec record;
	cnum int:=0;
  gradshash hstore;
	agenthash hstore;
	effvolume FLOAT;
	keyId int;
	tmp int;
	a1 text;
	a2 text;
	a3 text;
	stTime TIMESTAMP;
	edTime TIMESTAMP;
	pending_lssuing text:='pending_lssuing';
	pending_pay text:='pending_pay';
	vname text:='v_site_game';
BEGIN
	raise info '开始统计( % )的返水,周期( %-% )',periodName,startTime,endTime;
	raise info '创建站点游戏视图';
	--url='host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres';
  perform gamebox_site_game(url,vname,sid);
	--取得当前返水梯度设置信息.
  select gamebox_rakeback_set() into gradshash;
  select gamebox_agent_rakeback() into agenthash;
	stTime=startTime::TIMESTAMP;
	edTime=endTime::TIMESTAMP;
	--先插入返水总记录并取得键值.
	INSERT INTO settlement_backwater
  (
	settlement_name,start_time,end_time
	,player_count,backwater_total,create_time,lssuing_state
  )
  VALUES(
   periodName,stTime,edTime
	 ,0,0,now(),pending_pay
  );
  SELECT currval(pg_get_serial_sequence('settlement_backwater', 'id')) into keyId;
	raise info '返水总表的键值:%',keyId;

	--收集每个API下每个玩家的返水.
  raise info '收集每个API下每个玩家的返水';
	FOR rec IN
   select p.player_id userid,u.username,u.owner_id,p.api_id,p.game_type_parent,p.game_type,p.effective_trade_amount ,up.rakeback_id,up.rank_id from
          (
            SELECT
            po.player_id,
            g.api_id,
            g.game_type,
	    g.game_type_parent,
            sum(po.effective_trade_amount) AS effective_trade_amount
           FROM player_game_order po,v_site_game g
	   where po.game_id=g.id
	   and po.create_time>=stTime and po.create_time<edTime
           GROUP BY po.player_id,g.api_id,g.game_type,g.game_type_parent
           order by po.player_id,g.api_id,g.game_type_parent,g.game_type
          ) p left join user_player up on p.player_id=up.id,sys_user u where p.player_id=u.id
				order by p.effective_trade_amount desc

    LOOP
			select gamebox_rakeback_calculator(gradshash,agenthash,row_to_json(rec)) into effvolume;
			raise info '玩家:%,有效交易量:%,返水:%',rec.username,rec.effective_trade_amount,effvolume;
			raise info '梯度:%,api:%,game_type:%',rec.rakeback_id,rec.api_id,rec.game_type;
			--新增玩家返水:有返水才新增.
		  IF effvolume>0 THEN
				INSERT INTO settlement_backwater_detail(
				settlement_backwater_id,player_id,api_id
				,game_type_parent,game_type,backwater
				) VALUES(
				 keyId,rec.userId,rec.api_id
				 ,rec.game_type_parent,rec.game_type,effvolume
				);
			 SELECT currval(pg_get_serial_sequence('settlement_backwater_detail', 'id')) into tmp;
			 raise info '各API玩家返水键值:%',tmp;
			END IF;

		END LOOP;
	  raise info '收集每个API下每个玩家的返水.完成';

    --更新返水总表.
    raise info '更新返水总表';
		FOR rec in select settlement_backwater_id,count(player_id) cl,sum(backwater) sl
			from settlement_backwater_detail where settlement_backwater_id=keyId group by settlement_backwater_id
		LOOP
			--raise info '玩家数:%,返水总额:%',rec.cl,rec.sl;
			update settlement_backwater set player_count=rec.cl,backwater_total=rec.sl where id=keyId;
		END LOOP;
		raise info '更新返水总表.完成';

		--统计返水周期每个玩家返水
		raise info '统计返水周期每个玩家返水';
		INSERT INTO settlement_backwater_player(
			settlement_backwater_id,player_id,username
			,rank_id,rank_name,risk_marker,backwater_total,settlement_state
		)
		select keyId,u.id,u.username,p.rank_id,r.rank_name,r.risk_marker,s.backwater,pending_lssuing from (
    select player_id,sum(backwater) backwater from settlement_backwater_detail where settlement_backwater_id=keyId group by player_id) s,
    sys_user u,user_player p,player_rank r
    where s.player_id=u.id and s.player_id=p.id and p.rank_id=r.id;
    --SELECT currval(pg_get_serial_sequence('settlement_backwater_player', 'id')) into tmp;
		--raise info '玩家返水键值:%',tmp;

	raise info '统计返水周期每个玩家返水.完成';
		--删除临时视图表.
		select count(*) from pg_views where viewname=''||vname||'' into tmp;
		raise info 'tmp:%',tmp;
		if tmp>0 THEN
			execute 'drop view '||vname;
		END IF;
   --EXCEPTION WHEN unique_violation THEN
	 EXCEPTION
	 WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS a1 = MESSAGE_TEXT,
                          a2 = PG_EXCEPTION_DETAIL,
                          a3 = PG_EXCEPTION_HINT;
			raise EXCEPTION '异常:%,%,%',a1,a2,a3;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_backwater(periodName text,startTime text,endTime text,url text,sid int) IS '返水-玩家返水计算入口-Lins';
--select * from gamebox_backwater('','');