/*
* 根据占成周期统计各个API,各个总代的占成数据.
* @author Lins
* @date 2015.11.18
* @参数1:占成周期名称.
* @参数2:占成周期开始时间(yyyy-mm-dd),周期一般以月为周期.
* @参数3:占成周期结束时间(yyyy-mm-dd)
	返回为空.
* 调用例子:
* select * from gamebox_occupy('2015-11第二期','2015-01-08','2015-11-14'
	,'host=192.168.0.88 dbname=gamebox_mainsite user=postgres password=postgresql',1);
*/
--drop function gamebox_occupy(text,text,text,text,int);
create or replace function gamebox_occupy(periodName text,startTime text,endTime text,url text,sid int) returns void as $$
DECLARE
	rec record;
	--系统设置各种承担比例.
	syshash hstore;
	--各API的返佣设置
  occupyhash hstore;
	--各个代理的返佣设置
	agenthash hstore;
	--运营商各API占成比例.
	mainhash hstore;
	--存储每个总代的玩家数.
	numhash hstore;
	--临时
	hash hstore;
	mhash hstore;

	--返佣值
	occupy_value FLOAT;

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
	raise info '开始统计( % )的占成,周期( %-% )',periodName,startTime,endTime;
	raise info '创建站点游戏视图';
	--url='host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres';
  perform gamebox_site_game(url,vname,sid);
	--取得系统关于各种承担比例参数.
	select gamebox_sys_param('apportionSetting') into syshash;
	--取得当前返佣梯度设置信息.
  select gamebox_occupy_api_set() into occupyhash;
	--取得总代理返佣方案
  --select * from gamebox_agent_rebate() into agenthash;

	--先插入返水总记录并取得键值.
  raise info '占成settlement_occupy总表新增记录';
	INSERT INTO settlement_occupy
  (
	 settlement_name,start_time,end_time
	,top_agent_count,top_agent_lssuing_count,top_agent_reject_count
  ,occupy_total,occupy_actual,last_operate_time
  ,create_time,lssuing_state
  )
  VALUES(
   periodName,stTime,edTime
	 ,0,0,0,0,0,now(),
   now(),pending_pay
  );
  SELECT currval(pg_get_serial_sequence('settlement_occupy', 'id')) into keyId;
	raise info '占成settlement_occupy总表新增记录.完成.键值:%',keyId;
	--先统计每个代理的有效交易量、有效玩家、盈亏总额.
   raise info '计算各API各总代的盈亏总和';
			FOR rec IN
           SELECT
            a.owner_id,--代理的总代
            g.api_id,
            g.game_type,
	          g.game_type_parent,
						count(DISTINCT o.player_id) player_num,
						sum(-o.profit_amount) as profit_amount,
            sum(o.effective_trade_amount) AS effective_trade_amount
            from player_game_order o,v_site_game g,sys_user u,sys_user a
	          where
            o.create_time>=stTime and o.create_time<edTime
            and o.game_id=g.id
						and o.player_id=u.id
						and u.user_type='24' --TYPE 为玩家
						and u.owner_id=a.id --代理
					  and a.user_type='23' --TYPE 为代理
            group by a.owner_id,g.api_id,g.game_type,g.game_type_parent
					  order by a.owner_id
			LOOP
			--此数后续补.
			IF numhash is null THEN
				select rec.owner_id||'=>0' into numhash;
			ELSE
				select rec.owner_id||'=>0' into mhash;
				numhash=numhash||mhash;
			END IF;

			--取得各API各分类佣金总和
			select gamebox_occupy_calculator(occupyhash,mainhash,row_to_json(rec)) into occupy_value;
			--raise info '各API各分类佣金总和:代理:%,有效交易量:%,返佣:%',rec.owner_id,rec.effective_trade_amount,occupy_value;
			--新增各API代理返佣:目前返佣不分正负都新增.
		  --IF occupy_value>0 THEN
			 INSERT INTO settlement_occupy_detail(
				settlement_occupy_id,top_agent_id,api_id
				,game_type_parent,game_type,occupy_total,effective_transaction,profit_loss
				) VALUES(
				 keyId,rec.owner_id,rec.api_id
				 ,rec.game_type_parent,rec.game_type,occupy_value,rec.effective_trade_amount,rec.profit_amount
				);
			 SELECT currval(pg_get_serial_sequence('settlement_occupy_detail', 'id')) into tmp;
			 raise info '各API代理占成明细表键值:%',tmp;
			--END IF;
		END LOOP;
    raise info '计算各API各总代的盈亏总和.完成';


	  raise info '统计当前周期内各代理的各种费用信息';
		--统计当前周期内各代理的各种费用信息.
		select gamebox_occupy_expense_gather(keyId,stTime,edTime) into hash;

		 --开始统计代理返佣.
		raise info '开始统计代理占成';

	  perform gamebox_occupy_expense(numhash,syshash,hash,keyId);

		--更新返佣总表.
    raise info '更新占成总表';
		FOR rec in
				select settlement_occupy_id,count(top_agent_id) top_agent_count,sum(occupy_total) occupy_total from settlement_occupy_topagent where settlement_occupy_id=keyId
        GROUP BY settlement_occupy_id
		LOOP
			UPDATE settlement_occupy SET top_agent_count=rec.top_agent_count,occupy_total=rec.occupy_total where id=rec.settlement_occupy_id;
		END LOOP;
		raise info '总代占成处理成功';

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

COMMENT ON FUNCTION gamebox_occupy(periodName text,startTime text,endTime text,url text,sid int) IS '总代占成-统计入口-Lins';
-- select gamebox_occupy('2015-11第二期','2015-01-08','2015-11-14','host=192.168.0.88 dbname=gamebox_mainsite user=postgres password=postgresql',1);