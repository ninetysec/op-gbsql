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
--drop function gamebox_rebate(text,text,text);
create or replace function gamebox_rebate(periodName text,startTime text,endTime text,url text,sid int) returns void as $$
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
	--临时
	hash hstore;
	mhash hstore;

	--返佣值
	rebate_value FLOAT;

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
	row_split_char text:='^&^';
	col_split_char text:='^';

	vname text:='v_site_game';
BEGIN
	stTime=startTime::TIMESTAMP;
	edTime=endTime::TIMESTAMP;
	raise info '开始统计( % )的返佣,周期( %-% )',periodName,startTime,endTime;
	raise info '创建站点游戏视图';
	--url='host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres';
  perform gamebox_site_game(url,vname,sid);
	--取得系统关于各种承担比例参数.
	select gamebox_sys_param('apportionSetting') into syshash;
	--取得当前返佣梯度设置信息.
  select gamebox_rebate_set() into gradshash;
	--取得代理返佣方案
  select gamebox_agent_rebate() into agenthash;
  --判断各个代理满足的返佣梯度.
	select gamebox_rebate_agent_check(gradshash,agenthash) into checkhash;
	--raise info 'keys:%',checkhash;

	--先插入返水总记录并取得键值.
  raise info '返佣settlement_rebate总表新增记录';
	INSERT INTO settlement_rebate
  (
	 settlement_name,start_time,end_time
	,agent_count,agent_lssuing_count,agent_reject_count
  ,rebate_total,rebate_actual,last_operate_time
  ,create_time,lssuing_state
  )
  VALUES(
   periodName,stTime,edTime
	 ,0,0,0,0,0,now(),
   now(),pending_pay
  );
  SELECT currval(pg_get_serial_sequence('settlement_rebate', 'id')) into keyId;
	raise info '返佣settlement_rebate总表新增记录.完成.键值:%',keyId;
	--先统计每个代理的有效交易量、有效玩家、盈亏总额.
   raise info '计算各API各代理的盈亏总和';
			FOR rec IN
            SELECT
            u.owner_id,
            g.api_id,
            g.game_type,
	          g.game_type_parent,
						count(DISTINCT o.player_id) player_num,
						sum(-o.profit_amount) as profit_amount,
            sum(o.effective_trade_amount) AS effective_trade_amount
            from player_game_order o,v_site_game g,sys_user u
	          where
            o.create_time>=stTime and o.create_time<edTime and
            o.game_id=g.id and o.player_id=u.id
            group by u.owner_id,g.api_id,g.game_type,g.game_type_parent
					  order by u.owner_id
			LOOP
			--检查当前代理是否满足返佣梯度.
			IF isexists(checkhash, (rec.owner_id)::text)=false THEN
				CONTINUE;
			END IF;
			--取得各API各分类佣金总和
			select gamebox_rebate_calculator(gradshash,checkhash,mainhash,row_to_json(rec)) into rebate_value;
			--raise info '各API各分类佣金总和:代理:%,有效交易量:%,返佣:%',rec.owner_id,rec.effective_trade_amount,rebate_value;
			--新增各API代理返佣:目前返佣不分正负都新增.
		  --IF rebate_value>0 THEN
			 INSERT INTO settlement_rebate_detail(
				settlement_rebate_id,player_id,api_id
				,game_type_parent,game_type,rebate_total
				) VALUES(
				 keyId,rec.owner_id,rec.api_id
				 ,rec.game_type_parent,rec.game_type,rebate_value
				);
			 SELECT currval(pg_get_serial_sequence('settlement_rebate_detail', 'id')) into tmp;
			 raise info '各API代理返佣表键值:%',tmp;
			--END IF;
		END LOOP;
    raise info '计算各API各代理的盈亏总和.完成';

	  raise info '统计当前周期内各代理的各种费用信息';
		--统计当前周期内各代理的各种费用信息.
		select gamebox_expense_gather(keyId,stTime,edTime,row_split_char,col_split_char) into hash;

		 --开始统计代理返佣.
		raise info '开始统计代理返佣';
	  perform gamebox_expense(checkhash,syshash,hash,keyId,row_split_char,col_split_char);

		--更新返佣总表.
    raise info '更新返佣总表';
		FOR rec in
				select settlement_rabate_id,count(agent_id) agent_num,sum(backwater) rebate_total from settlement_rebate_agent where settlement_rabate_id=keyId
        GROUP BY settlement_rabate_id
		LOOP
			UPDATE settlement_rebate SET agent_count=rec.agent_num,rebate_total=rec.rebate_total where id=rec.settlement_rabate_id;
		END LOOP;
		raise info '代理返佣处理成功';
		--删除临时视图表.
		select count(*) from pg_views where viewname=''||vname||'' into tmp;
		raise info 'tmp:%',tmp;
		if tmp>0 THEN
			execute 'drop view '||vname;
		END IF;

		--异常处理
	 EXCEPTION
	 WHEN OTHERS THEN
	 GET STACKED DIAGNOSTICS a1 = MESSAGE_TEXT,a2 = PG_EXCEPTION_DETAIL,a3 = PG_EXCEPTION_HINT;
			raise EXCEPTION '异常:%,%,%',a1,a2,a3;
END;
$$ language plpgsql;

--select * from gamebox_rebate('2015-11第二期','2015-01-08','2015-11-14');
COMMENT ON FUNCTION gamebox_rebate(periodName text,startTime text,endTime text,url text,sid int) IS '返佣-代理返佣计算入口-Lins';