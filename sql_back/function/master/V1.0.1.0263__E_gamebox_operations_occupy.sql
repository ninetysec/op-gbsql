-- auto gen by Lins 2015-12-15 07:48:10

/*
* 根据统计周期算出运营商的占成.
* @参数1.包网方案信息
* @参数2.开始时间
* @参数3.结束时间
* @参数4.占成类别.category: AGENT、TOPAGENT、SITE指明各种占成类型统计
* @参数5. 指明统计时KEY的细度.1.站点.2.代理或总代.3.玩家.4.玩家+API,5.API.默认是2.
*/
drop function if EXISTS gamebox_operations_occupy(hstore[],TIMESTAMP,TIMESTAMP,TEXT,INT);
create or replace function gamebox_operations_occupy(hashs hstore[],start_time TIMESTAMP,end_time TIMESTAMP,category TEXT,key_type INT)
returns hstore as $$
DECLARE
	hash hstore;
	rec record;
	cur refcursor;
	amount FLOAT:=0.00;
	temp_amount FLOAT:=0.00;
	keyname TEXT:='';
	col_split TEXT:='_';
BEGIN
	--计算占成
		select gamebox_operation_occupy(start_time,end_time,category) INTO cur;
		FETCH cur into rec;
		WHILE FOUND LOOP
			keyname=rec.owner_id::TEXT;
			IF key_type=3 THEN
				keyname=(rec.id::TEXT);
			ELSIF key_type=4 THEN
				keyname=(rec.id::TEXT);
				keyname=keyname||col_split||(rec.api_id::TEXT);
				keyname=keyname||col_split||(rec.game_type::TEXT);
			ELSIF key_type=5 THEN
				keyname=rec.api_id::TEXT;
				keyname=keyname||col_split||(rec.game_type::TEXT);
			END IF;

			amount=0.00;
			temp_amount=0.00;
			select gamebox_operations_occupy_calculate(hashs[2],row_to_json(rec),category) INTO amount;
		  --raise info 'keyname=%,api=%,%,amount=%',keyname,rec.api_id,rec.game_type,amount;
			IF hash is NULL THEN
				SELECT keyname||'=>'||amount INTO hash;
			ELSEIF isexists(hash,keyname) THEN
				temp_amount=(hash->keyname)::float;
				--raise info 'temp:%',temp_amount;
				amount=amount+temp_amount;
				hash=hash||(select (keyname||'=>'||amount)::hstore);
			ELSE
				hash=hash||(select (keyname||'=>'||amount)::hstore);
			END IF;
      --raise info 'keyname=%,amount=%',keyname,amount;
			FETCH cur INTO rec;
		END LOOP;
		CLOSE cur;
	return hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operations_occupy(hashs hstore[],start_time TIMESTAMP
,end_time TIMESTAMP,category TEXT,key_type INT)
IS 'Lins-运营商占成-统计周期内运营商的占成';


/*
* 根据周期与统计类型查询各API的下单相关信息.
* @author Lins
* @date 2015.12.1
*/
drop function IF EXISTS gamebox_operation_occupy(TIMESTAMP,TIMESTAMP,TEXT);
create or replace function gamebox_operation_occupy(start_time TIMESTAMP,end_time TIMESTAMP,category TEXT) RETURNS refcursor as $$
DECLARE
	cur refcursor;
BEGIN
	IF category='AGENT' THEN
		--代理
    OPEN cur FOR
           SELECT
            u.owner_id,
						u.id,
            o.api_id,
            o.game_type,
						count(DISTINCT o.player_id) player_num,
						COALESCE(sum(-o.profit_amount),0.00) as profit_amount,
            COALESCE(sum(o.effective_trade_amount),0.00) AS effective_trade_amount
            from player_game_order o,sys_user u
	          where
            o.create_time>=start_time and o.create_time<end_time
            and o.player_id=u.id
            group by u.owner_id,u.id,o.api_id,o.game_type
					  order by u.owner_id;

	ELSEIF category='TOPAGENT' THEN
		--总代.
    OPEN cur FOR
           SELECT
            a.owner_id,--代理的总代
						u.id,
            o.api_id,
            o.game_type,
						count(DISTINCT o.player_id) player_num,
						COALESCE(sum(-o.profit_amount),0.00) as profit_amount,
            COALESCE(sum(o.effective_trade_amount),0.00) AS effective_trade_amount
            from player_game_order o,sys_user u,sys_user a
	          where
            o.create_time>=start_time and o.create_time<end_time
						and o.player_id=u.id
						and u.user_type='24' --TYPE 为玩家
						and u.owner_id=a.id --代理
					  and a.user_type='23' --TYPE 为代理
            group by a.owner_id,u.id,o.api_id,o.game_type
					  order by a.owner_id	;
	ELSE
	--站点统计
	   OPEN cur FOR
           SELECT
            o.api_id,
            o.game_type,
						count(DISTINCT o.player_id) player_num,
						COALESCE(sum(-o.profit_amount),0.00) as profit_amount,
            COALESCE(sum(o.effective_trade_amount),0.00) AS effective_trade_amount
            from player_game_order o
	          where o.create_time>=start_time and o.create_time<end_time
            group by o.api_id,o.game_type;

	END IF;
	RETURN cur;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy(
start_time TIMESTAMP,end_time TIMESTAMP,category TEXT)
 IS 'Lins-运营商占成-API的下单信息';

/*
* 根据统计周期算出运营商的占成-入口.
* @参数1.运营库dblink URL.
* @参数2.开始时间
* @参数3.结束时间
* @参数4.占成类别.category: AGENT、TOPAGENT、SITE指明各种占成类型统计
*/
drop function if EXISTS gamebox_operations_occupy(TEXT,TIMESTAMP,TIMESTAMP,TEXT,INT);

create or replace function gamebox_operations_occupy(url text,start_time TIMESTAMP,end_time TIMESTAMP,category TEXT,key_type INT)
returns hstore as $$
DECLARE
	sid int;
	is_max BOOLEAN:=TRUE;
	hash hstore;
	hashs hstore[];
	vname text:='v_site_game';
	tmp int:=0;
BEGIN
  --取得当前站点.
	select gamebox_current_site() INTO sid;
	--取得当前站点的游戏列表.
  --perform gamebox_site_game(url,vname,sid,'C');
	--取得当前站点的包网方案
	select gamebox_operations_occupy(url,sid,start_time,end_time,category,is_max,key_type) into hash;
	raise info '%',hash;
	--删除临时视图表.
	--perform gamebox_site_game(url,vname,sid,'D');
	return hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operations_occupy(
url text,start_time TIMESTAMP
,end_time TIMESTAMP,category TEXT,key_type INT)
IS 'Lins-运营商占成-入口';

--测试
/*
select gamebox_operations_occupy('host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'2015-1-01'::TIMESTAMP,'2015-12-01'::TIMESTAMP,'TOPAGENT',4);

select gamebox_operations_occupy('host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'2015-1-01'::TIMESTAMP,'2015-12-01'::TIMESTAMP,'AGENT',3);

*/