-- auto gen by Lins 2015-12-15 05:44:05
/*
* 账务(站长、总代).
* @author:Lins
* @date:2015-12-14
* 参数1.运营商库.dblink格式URL
* 参数2.站点库.dblink格式URL(多库,以分隔符分开)
* 参数3.开始时间
* 参数4.结束时间
* 参数5.分隔符.
* 参数6.账务类别.1:站长,2:总代
*/
drop function if exists gamebox_station_bill(TEXT,TEXT,TEXT,TEXT,TEXT,INT);
create or replace function gamebox_station_bill(
main_url TEXT
,master_urls TEXT
,start_times TEXT
,end_times TEXT
,split TEXT
,flag INT
)
returns TEXT as $$
DECLARE
	dblink_urls TEXT[];
	start_time TEXT[];
	end_time TEXT[];
BEGIN
	--start_time='2015-01-01';
	--end_time='2015-12-30';
	IF ltrim(rtrim(main_url))='' THEN
		raise info '1-运营商URL为空';
		RETURN '1-运营商URL为空';
	ELSEIF ltrim(rtrim(master_urls))='' THEN
		raise info '1-站点库URL为空';
		RETURN '1-站点库URL为空';
	ELSEIF ltrim(rtrim(split))='' THEN
		raise info '1-分隔符为空';
		RETURN '1-分隔符为空';
  END IF;
	dblink_urls:=regexp_split_to_array(master_urls,split);
	start_time:=regexp_split_to_array(start_times,split);
	end_time:=regexp_split_to_array(end_times,split);
	IF array_length(dblink_urls, 1)>0
		AND array_length(dblink_urls, 1)=array_length(start_time, 1)
		AND array_length(dblink_urls, 1)=array_length(end_time, 1)
	THEN
		perform dblink_close_all();
		perform gamebox_collect_site_infor(main_url);
		FOR i IN 1..array_length(dblink_urls, 1) LOOP
			perform gamebox_station_bill(main_url,dblink_urls[i],start_time[i],end_time[i],flag);
		END LOOP;
	ELSE
		raise info '1-参数格式或者数量不一致';
		RETURN '1-参数格式或者数量不一致';
	END IF;
	RETURN '0';
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill(
main_url TEXT
,master_urls TEXT
,split TEXT
,start_time TEXT
,end_time TEXT
,flag INT
) IS 'Lins-账务(站长、总代)-入口';



/*
* 账务(站长、总代).
* @author:Lins
* @date:2015-12-14
* 参数1.运营商库.dblink格式URL
* 参数2.站点库.dblink格式URL
* 参数3.开始时间
* 参数4.结束时间
* 参数5.账务类别.1:站长,2:总代
*/
drop function if exists gamebox_station_bill(TEXT,TEXT,TEXT,TEXT,INT);
create or replace function gamebox_station_bill(
main_url TEXT
,master_url TEXT
,start_time TEXT
,end_time TEXT
,flag INT
)
returns TEXT as $$
DECLARE
	rec record;
	cnum INT;

	category TEXT:='API';
	keys TEXT[];
	sub_keys TEXT[];
	sub_key TEXT:='';
	col_split TEXT:='_';
	num_map hstore;

	maps hstore[];
	sys_map hstore;
	api_map hstore;
	expense_map hstore;
	dict_map hstore;
	param TEXT:='';
	sid INT;--站点ID.
	val FLOAT;
	date_time TIMESTAMP;
	c_year INT;
	c_month INT;

	player_num INT;
	bill_id INT;
	rtn TEXT;
	bill_no TEXT;--账务流水号
BEGIN
	IF ltrim(rtrim(master_url))='' THEN
		RAISE EXCEPTION '-1,站点库URL为空';
	END IF;
	perform dblink_close_all();
	perform dblink_connect('master', master_url);

	select * from dblink('master','select * from gamebox_sys_param(''apportionSetting'')') as p(h hstore) INTO sys_map;
	raise info 'sys_map:%',sys_map;
	sid=(sys_map->'site_id')::INT;
  SELECT gamebox_site_map(sid) INTO dict_map;
	date_time=end_time::TIMESTAMP;

	select extract(year from date_time) INTO c_year;
	select extract(month from date_time) INTO c_month;
	dict_map=(SELECT ('year=>'||c_year)::hstore)||dict_map;
	dict_map=(SELECT ('month=>'||c_month)::hstore)||dict_map;

	select date_time + interval '-1 month' INTO date_time;
	select extract(year from date_time) INTO c_year;
	select extract(month from date_time) INTO c_month;
	dict_map=(SELECT ('bill_year=>'||c_year)::hstore)||dict_map;
	dict_map=(SELECT ('bill_month=>'||c_month)::hstore)||dict_map;

	select put(sys_map,'backwater_percent',sys_map->'topagent.rakeback.percent') into sys_map;
	select put(sys_map,'refund_fee_percent',sys_map->'topagent.poundage.percent') into sys_map;
	select put(sys_map,'favorable_percent',sys_map->'topagent.preferential.percent') into sys_map;
	select put(sys_map,'rebate_percent',sys_map->'topagent.rebate.percent') into sys_map;

	raise info 'dict_map:%',dict_map;

	--删除重复运行记录.
	DELETE FROM station_bill_other where station_bill_id IN (SELECT id FROM station_bill where site_id=sid and bill_year=c_year and bill_month=c_month);
	DELETE FROM station_profit_loss where station_bill_id IN (SELECT id FROM station_bill where site_id=sid and bill_year=c_year and bill_month=c_month);
	DELETE FROM station_bill where site_id=sid and bill_year=c_year and bill_month=c_month;

	select put(dict_map,'bill_type',flag::TEXT) into dict_map;--站长账务
	--select put(dict_map,'bill_type',flag::TEXT) into dict_map;--总代账务
	IF flag=2 THEN--计算总代账务
		--调用产生账单流水号,注入正确值.
		SELECT gamebox_generate_order_no('B',sid::TEXT,'04','master') INTO bill_no;
		raise info '账务流水号:%',bill_no;
		select put(dict_map,'bill_no',bill_no) into dict_map;--账单流水号
		select gamebox_station_bill_top(sys_map,dict_map,'master',main_url,start_time,end_time) INTO rtn;
	ELSEIF flag=1 THEN	--计算站长账务
		SELECT gamebox_generate_order_no('B',sid::TEXT,'03','master') INTO bill_no;
		raise info '账务流水号:%',bill_no;
		select put(dict_map,'bill_no',bill_no) into dict_map;--账单流水号
		select gamebox_station_bill_master(sys_map,dict_map,'master',main_url,start_time,end_time) INTO rtn;
	END IF;
	--关闭连接
	perform dblink_disconnect('master');
	RETURN '0';
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill(
main_url TEXT
,master_url TEXT
,start_time TEXT
,end_time TEXT
,flag INT
) IS 'Lins-账务(站长、总代)-入口';



/*
* Lins-站点账务.其它费用.
* @author:Lins
* @date:2015-12-14
* 参数1.其它费用map
*/
drop function if exists gamebox_station_bill_other(hstore);
create or replace function gamebox_station_bill_other(
map hstore
)
returns void as $$
DECLARE
	bill_id INT;
	payable FLOAT;
	code TEXT;
	actual FLOAT;
	grads FLOAT;
	way TEXT;
	value FLOAT;
	limit_value FLOAT;
	name TEXT;
	fee FLOAT;
	apportion FLOAT;
BEGIN
	bill_id=(map->'bill_id')::INT;
	payable=(map->'payable')::FLOAT;
	code=(map->'code')::TEXT;
	actual=(map->'actual')::FLOAT;
	grads=(map->'grads')::FLOAT;
	way=(map->'way')::TEXT;
	value=(map->'value')::FLOAT;
	limit_value=(map->'limit')::FLOAT;
	name=(map->'name')::TEXT;
	fee=(map->'fee')::FLOAT;
	apportion=(map->'apportion')::FLOAT;

	payable=COALESCE(payable,0);
	code=COALESCE(code,'');
	actual=COALESCE(actual,0);
	grads=COALESCE(grads,0);
	way=COALESCE(way,'');
	value=COALESCE(value,0);
	limit_value=COALESCE(limit_value,0);
	name=COALESCE(name,'');
	fee=COALESCE(fee,0);
	apportion=COALESCE(apportion,0);
	--raise info 'I-Way=%',way;
	INSERT INTO station_bill_other(
		station_bill_id
		,amount_payable
		,project_code
		,amount_actual
		,favourable_grads
		,favourable_way
		,favourable_value
		,favourable_limit
		,operate_user_name
		,fee
		,apportion_proportion
	) VALUES(
		bill_id
		,payable
		,code
		,actual
		,grads
		,way
		,value
		,limit_value
		,name
		,fee
		,apportion
	);
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_other(
map hstore
) IS 'Lins-站点账务.其它费用';



drop function if exists gamebox_station_bill_other(hstore,hstore,INT);
create or replace function gamebox_station_bill_other(
cost_map hstore
,sys_map hstore
,bill_id INT
)
returns FLOAT as $$
DECLARE
	map hstore;
	expense_category TEXT[]:=array['backwater','refund_fee','favorable','rebate'];
	category TEXT:='';
	value FLOAT;
	amount FLOAT:=0.00;--费用总和.
BEGIN
	FOR j IN 1..array_length(expense_category, 1) LOOP
		category=expense_category[j];
		value=(cost_map->category)::FLOAT;
		IF value is null THEN
			CONTINUE;
		END IF;
		map=null;
		amount=amount+COALESCE((cost_map->(category||'_apportion'))::FLOAT,0.00);
		select put(map,'bill_id',bill_id::TEXT) into map;
		select put(map,'payable',cost_map->(category||'_apportion')) into map;
		select put(map,'actual',cost_map->(category||'_apportion')) into map;
		select put(map,'apportion',sys_map->(category||'_percent')) into map;
		select put(map,'code',category) into map;
		perform gamebox_station_bill_other(map);
	END LOOP;
	RETURN amount;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_other(
cost_map hstore
,sys_map hstore
,bill_id INT
) IS 'Lins-站点账务.其它费用';


/*
* Lins-站点账务-API.
* @author:Lins
* @date:2015-12-14
* 参数1.各项值map
*/
drop function if exists gamebox_station_bill_top(hstore,hstore,TEXT,TEXT,TEXT,TEXT);
create or replace function gamebox_station_bill_top(
sys_map hstore
,dict_map hstore
,url_name TEXT
,main_url TEXT
,start_time TEXT
,end_time TEXT
)
returns TEXT as $$
DECLARE
	maps hstore[];
	api_map hstore;
	expense_map hstore;
	cost_map hstore;


	api_id INT;
	game_type TEXT;
	profit_loss FLOAT;
	occupy_proportion FLOAT;
	amount_payable FLOAT;

	bill_id INT;

	id INT;
	name TEXT;
	val TEXT;
	vals TEXT[];
	sval TEXT[];
	keys TEXT[];

	map hstore;
	expense_category TEXT[]:=array['backwater','refund_fee','favorable','rebate'];
	category TEXT:='';
	value FLOAT;
	h_keys TEXT[]:=array['-1'];--记录已存在ID.
	amount FLOAT:=0.00;--应付总额
	expense FLOAT:=0.00;--分摊费用.

	sys_config hstore;
	sp TEXT:='@';
	rs TEXT:='\~';
	cs TEXT:='\^';
	rs_a TEXT:='';
	cs_a TEXT:='';
	sp_a TEXT:='';
BEGIN
	--取得系统变量
	select sys_config() INTO sys_config;
	sp=sys_config->'sp_split';
	rs=sys_config->'row_split';
	cs=sys_config->'col_split';
	sp_a=sys_config->'sp_split_a';
	rs_a=sys_config->'row_split_a';
	cs_a=sys_config->'col_split_a';
	rs_a='\^&\^';
	cs_a='\^';

	raise info 'sp:%,rs:%,cs:%,sp_a:%,rs_a:%,cs_a:%',sp,rs,cs,sp_a,rs_a,cs_a;
	select * from dblink(url_name
	,'select * from gamebox_occupy_map('''||main_url||''','''||start_time||''','''||end_time||''')'
	) as p(h hstore[]) INTO maps;
	IF array_length(maps, 1)<2 THEN
		RETURN '1.站点库返回总代信息有误';
	END IF;
	api_map=maps[1];
	expense_map=maps[2];
	--raise info '%',api_map;
	--raise info '%',expense_map;
	--格式：id=>name@api^game^val^retio^loss^&^api^game^val^retio^loss
	keys=akeys(api_map);
	IF array_length(keys,1)>0 THEN
		FOR i IN 1..array_length(keys,1) LOOP
			val=api_map->keys[i];
			vals=regexp_split_to_array(val,sp);
			IF array_length(vals,1)=2 THEN
				name=vals[1];
				select put(dict_map,'topagent_id',keys[i]) into dict_map;
				select put(dict_map,'topagent_name',name) into dict_map;
				select put(dict_map,'op','I') into dict_map;

				--准备station_bill.
				amount=0.00;
				select gamebox_station_bill(dict_map) INTO bill_id;
				--API盈亏
				--vals[2].值格式:api^game^val^retio^loss^&^api^game^val^retio^loss
				vals=regexp_split_to_array(vals[2],rs_a);
				IF array_length(vals, 1)>0 THEN
					FOR k IN 1..array_length(vals, 1) LOOP
						--vals[k].值格式:api^game^val^retio^loss
						sval=regexp_split_to_array(vals[k],cs_a);
						IF array_length(sval, 1)>=4 THEN
							map=null;
							select put(map,'api_id',sval[1]) into map;--API
							select put(map,'game_type',sval[2]) into map;--API二级分类
							select put(map,'amount_payable',sval[3]) into map;--应付金额
							select put(map,'occupy_proportion',sval[4]) into map;--占成比例
							select put(map,'profit_loss',sval[5]) into map;--盈亏总和
							select put(map,'bill_id',bill_id::TEXT) into map;
							amount=amount+COALESCE(sval[3]::FLOAT,0.00);
							perform gamebox_station_profit_loss(map);
							--raise info 'New profit_loss';
						END IF;
					END LOOP;
				END IF;
				--其它费用.
				expense=0.00;
				IF exist(expense_map,keys[i]) THEN
					h_keys=array_append(h_keys, keys[i]);
					val=expense_map->keys[i];
					val=replace(val,rs,',');
					val=replace(val,cs,'=>');
					select val INTO cost_map;
					--raise info 'cost_map=%',cost_map;
					select gamebox_station_bill_other(cost_map,sys_map,bill_id) INTO expense;
				END IF;
				--更新账务.
				amount=amount-expense;
				select put(dict_map,'bill_id',bill_id::TEXT) into dict_map;
				select put(dict_map,'op','U') into dict_map;
				select put(dict_map,'amount',amount::TEXT) into dict_map;
				select gamebox_station_bill(dict_map) INTO bill_id;
			END IF;
		END LOOP;
	END IF;

	--处理特殊其它费用
	keys=akeys(expense_map);

	IF array_length(keys, 1)>0 THEN
		FOR i IN 1..array_length(keys, 1)
		LOOP
			IF h_keys@>array[keys[i]]=false THEN--判断是否已经记账
					val=expense_map->keys[i];
					val=replace(val,rs,',');
					val=replace(val,cs,'=>');
					select val INTO cost_map;

					--准备station_bill.
					name=cost_map->'user_name';
					select put(dict_map,'topagent_id',keys[i]) INTO dict_map;
					select put(dict_map,'topagent_name',name) INTO dict_map;
					select put(dict_map,'op','I') INTO dict_map;

					select gamebox_station_bill(dict_map) INTO bill_id;
					--其它费用
					select gamebox_station_bill_other(cost_map,sys_map,bill_id) INTO expense;

					--更新账务.
					select put(dict_map,'bill_id',bill_id::TEXT) INTO dict_map;
					select put(dict_map,'op','U') INTO dict_map;
					select put(dict_map,'amount',(-expense)::TEXT) into dict_map;
					select gamebox_station_bill(dict_map) INTO bill_id;

			END IF;
		END LOOP;
	END IF;
	RETURN '0';
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_top(
sys_map hstore
,dict_map hstore
,url_name TEXT
,main_url TEXT
,start_time TEXT
,end_time TEXT
) IS 'Lins-站点账务-API';

/*
* Lins-站点账务-API.
* @author:Lins
* @date:2015-12-14
* 参数1.各项值map
*/
drop function if exists gamebox_station_profit_loss(hstore);
create or replace function gamebox_station_profit_loss(
map hstore
)
returns void as $$
DECLARE
	api_id INT;
	game_type TEXT;
	profit_loss FLOAT;
	occupy_proportion FLOAT;
	amount_payable FLOAT;
	bill_id INT;
BEGIN
	api_id=(map->'api_id')::INT;
	game_type=(map->'game_type')::TEXT;
	profit_loss=(map->'profit_loss')::FLOAT;
	occupy_proportion=(map->'occupy_proportion')::FLOAT;
	amount_payable=(map->'amount_payable')::FLOAT;
	bill_id=(map->'bill_id')::INT;

	INSERT INTO station_profit_loss(
  station_bill_id
  ,api_id
  ,profit_loss
  ,amount_payable
  ,game_type
  ,occupy_proportion
	) VALUES(
		bill_id
		,api_id
		,profit_loss
		,amount_payable
		,game_type
		,occupy_proportion
	);
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_profit_loss(
map hstore
) IS 'Lins-站点账务-API';


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
DROP FUNCTION IF EXISTS gamebox_station_bill(hstore);
create or replace function gamebox_station_bill(
dict_map hstore
) returns INT as $$
DECLARE
	rec record;
	bill_id INT;
	s_id INT;
	s_name TEXT;
	c_id INT;
	c_name TEXT;
	m_id INT;
	m_name TEXT;
	c_year INT;
	c_month INT;
	bill_type TEXT;
	bill_no TEXT;
	topagent_id INT:=0;
	topagent_name TEXT:='';
	amount FLOAT:=0.00;--应付金额
	op TEXT;
BEGIN
	s_id=(dict_map->'site_id')::INT;
	c_id=(dict_map->'center_id')::INT;
	m_id=(dict_map->'master_id')::INT;
	s_name=COALESCE((dict_map->'site_name')::TEXT,'');
	c_name=COALESCE((dict_map->'center_name')::TEXT,'');
	m_name=COALESCE((dict_map->'master_name')::TEXT,'');
	c_year=(dict_map->'year')::INT;
	c_month=(dict_map->'month')::INT;
	bill_no=(dict_map->'bill_no')::TEXT;
	bill_type=(dict_map->'bill_type')::TEXT;
	IF bill_type='2' THEN
		topagent_id=(dict_map->'topagent_id')::INT;
		topagent_name=COALESCE((dict_map->'topagent_name')::TEXT,'');
	END IF;
	op=(dict_map->'op')::TEXT;
	IF op='I' THEN
		INSERT INTO station_bill
		(
		 center_id
		--,center_name
		,master_id
		,master_name
		,site_id
		,site_name
		,bill_num
		,amount_payable
		,bill_year
		,bill_month
		,amount_actual
		,create_time
		,topagent_id
		,topagent_name
		,bill_type
		) VALUES(
			c_id
			--,c_name
			,m_id
			,m_name
			,s_id
			,s_name
			,bill_no
			,0
			,c_year
			,c_month
			,0
			,now()
			,topagent_id
			,topagent_name
			,bill_type
		);
		SELECT currval(pg_get_serial_sequence('station_bill', 'id')) into bill_id;
		raise info 'station_bill.完成.键值:%',bill_id;
	ELSEIF op='U' THEN
		bill_id=(dict_map->'bill_id')::INT;
		amount=(dict_map->'amount')::FLOAT;
		UPDATE station_bill SET amount_payable=amount,amount_actual=amount WHERE id=bill_id;
	END IF;
	RETURN bill_id;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill(
dict_map hstore
) IS 'Lins-站点账务-账务汇总';



/*
* Lins-站点账务-API.
* @author:Lins
* @date:2015-12-14
* 参数1.各项值map
*/
drop function if exists gamebox_station_bill_master(hstore,hstore,TEXT,TEXT,TEXT,TEXT);
create or replace function gamebox_station_bill_master(
sys_map hstore
,dict_map hstore
,url_name TEXT
,main_url TEXT
,start_time TEXT
,end_time TEXT
)
returns TEXT as $$
DECLARE
	net_maps hstore[];
	api_id INT;
	api TEXT;
	game_type TEXT;
	profit_loss FLOAT;
	occupy_proportion FLOAT;
	amount_payable FLOAT;

	bill_id INT;
	bill_year INT;
	bill_month INT;

	id INT;
	name TEXT;
	val TEXT;
	vals TEXT[];
	sval TEXT[];
	keys TEXT[];
	key_name TEXT:='';

	map hstore;
	cost_map hstore;

	category TEXT:='';
	value FLOAT;
	h_keys TEXT[]:=array['-1'];--记录已存在ID.
	amount FLOAT:=0.00;--应付总额
	expense FLOAT:=0.00;--分摊费用.
	limit_values FLOAT[];--梯度数组
	retios FLOAT[];--占成数组

	is_max boolean:=false;
	sid INT;--站点ID.
	cur refcursor;
	rec record;
	trade_amount FLOAT:=0.00;
	profilt_amount FLOAT:=0.00;
	occupy FLOAT:=0.00;--API占成
	assume BOOLEAN:=false;--是否盈亏共担.
	fee FLOAT:=0.00;--费用.
	no_bill FLOAT:=0.00;--上期未结金额
  maintenance_charges FLOAT:=0.00;--维护费
	ensure_consume FLOAT:=0.00;--保底消费
	reduction_maintenance_fee FLOAT:=0.00;--减免维护费
	return_profit FLOAT:=0.00;--返盈利

	net_map hstore;--包网方案
	occupy_map hstore;--API占成梯度map
	assume_map hstore;--盈亏共担map.
	charge_map hstore;--维护费用map.
	favorable_map hstore;--优惠map
	code TEXT:='';--项目代码
	sys_config hstore;

	sp TEXT:='@';
	rs TEXT:='\~';
	cs TEXT:='\^';
	rs_a TEXT:='';
	cs_a TEXT:='';
	sp_a TEXT:='';
BEGIN
	--取得系统变量
	select sys_config() INTO sys_config;
	sp=sys_config->'sp_split';
	rs=sys_config->'row_split';
	cs=sys_config->'col_split';
	sp_a=sys_config->'sp_split_a';
	rs_a=sys_config->'row_split_a';
	cs_a=sys_config->'col_split_a';
	rs_a='\^&\^';
	cs_a='\^';

	raise info 'sp:%,rs:%,cs:%,sp_a:%,rs_a:%,cs_a:%',sp,rs,cs,sp_a,rs_a,cs_a;

	--取得当前站点的包网方案
	sid=sys_map->'site_id';
	select * from dblink(main_url,'select gamebox_contract('||sid||','||is_max||')') as a(hash hstore[]) INTO net_maps;
	--raise info 'maps:%',net_maps;
	raise info '包网方案:%',net_maps[1];
	raise info '占成方案:%',net_maps[2];
	raise info '盈亏共担:%',net_maps[3];
	raise info '维护费:%',net_maps[4];
	raise info '优惠方案:%',net_maps[5];
	net_map=net_maps[1];
	occupy_map=net_maps[2];
	assume_map=net_maps[3];
	charge_map=net_maps[4];
	favorable_map=net_maps[5];

	amount=0.00;
	select put(dict_map,'op','I') into dict_map;
	--准备station_bill.
	select gamebox_station_bill(dict_map) INTO bill_id;

	--每个API的占成
	select gamebox_operation_occupy_api(url_name,start_time,end_time) INTO cur;
	FETCH cur into rec;
	WHILE FOUND LOOP
		api=rec.api_id::TEXT;
		game_type=rec.game_type;
		profilt_amount=rec.profit_amount;
		trade_amount=rec.trade_amount;
		assume=COALESCE((assume_map->api)::BOOLEAN,FALSE);
		key_name=api||'_'||game_type;
		val=COALESCE((occupy_map->key_name)::TEXT,'');
		IF val!='' THEN
			SELECT gamebox_operation_occupy_to_array(val,2) INTO limit_values;
			SELECT gamebox_operation_occupy_to_array(val,3) INTO retios;
			SELECT gamebox_operation_occupy_calculate(limit_values,retios,profilt_amount,assume) INTO occupy;
			raise info 'api:%,game_type:%,计税金额:%,占成:%',api,game_type,profilt_amount,occupy;
			select put(map,'api_id',api) into map;--API
			select put(map,'game_type',game_type) into map;--API二级分类
			select put(map,'amount_payable',occupy::TEXT) into map;--应付金额
			select put(map,'occupy_proportion','0') into map;--占成比例
			select put(map,'profit_loss',profilt_amount::TEXT) into map;--盈亏总和
			select put(map,'bill_id',bill_id::TEXT) into map;
			--新增各API占成金额
			perform gamebox_station_profit_loss(map);

			--盈亏不共担时,占成金额为负时，计0
			IF assume=FALSE AND occupy<0 THEN
				occupy=0;
			END IF;
			--累计占成金额
			amount=amount+COALESCE(occupy,0.00);
		END IF;
		FETCH cur INTO rec;
	END LOOP;
	CLOSE cur;
	--计算其它费用.
	raise info '占成总额:%',amount;
	select put(map,'bill_id',bill_id::TEXT) into map;
	select put(map,'payable','0') into map;
	select put(map,'actual','0') into map;
	select put(map,'apportion','0') into map;
	bill_month=(dict_map->'bill_month')::INT;
	bill_year=(dict_map->'bill_year')::INT;

	raise info 'bill_month:%',bill_month;
	raise info 'bill_year:%',bill_year;
	--上期未结费用.
	code='pending';
	select gamebox_station_no_bill(sid,bill_year,bill_month,'2') INTO no_bill;
	select put(map,'payable',no_bill::TEXT) into map;
	select put(map,'actual',no_bill::TEXT) into map;
	select put(map,'apportion','0') into map;
	select put(map,'code',code) into map;
	perform gamebox_station_bill_other(map);

	select put(map,'payable','0') into map;--复位
	select put(map,'actual','0') into map;--复位
	select put(map,'apportion','0') into map;--复位
	--维护费
	maintenance_charges=COALESCE((net_map->'maintenance_charges')::FLOAT,0.00);
	code='maintenance_charges';
	select put(map,'code',code) into map;
	select put(map,'fee',maintenance_charges::TEXT) into map;
  perform gamebox_station_bill_other(map);

	--保底费用
	ensure_consume=COALESCE((net_map->'ensure_consume')::FLOAT,0.00);
	code='ensure_consume';
	select put(map,'code',code) into map;
	select put(map,'fee',ensure_consume::TEXT) into map;
  perform gamebox_station_bill_other(map);

	select put(map,'fee','0.00') into map;--复位
	--减免维护费
	code='reduction_maintenance_fee';
	select put(map,'code',code) into map;
	SELECT gamebox_operation_favorable_calculate(charge_map,amount) INTO cost_map;
	reduction_maintenance_fee=COALESCE((cost_map->'value')::FLOAT,0.00);
	map=map||cost_map;
	perform gamebox_station_bill_other(map);

	--返盈利
	code='return_profit';
	select put(map,'code',code) into map;
	SELECT gamebox_operation_favorable_calculate(favorable_map,amount) INTO cost_map;
	return_profit=COALESCE((cost_map->'value')::FLOAT,0.00);
	map=map||cost_map;
	perform gamebox_station_bill_other(map);

	IF amount<ensure_consume THEN--运营商API占成小于保底消费
		amount=ensure_consume;
	END IF;
	--站长付给运营商账务：
	--API占成(或保底费)+维护费-返盈利-减免维护费+上期未结
	fee=amount+maintenance_charges-return_profit-reduction_maintenance_fee+no_bill;
	raise info '站长付给运营商账务:%',fee;
	--更新账务.
	select put(dict_map,'bill_id',bill_id::TEXT) INTO dict_map;
	select put(dict_map,'op','U') INTO dict_map;
	select put(dict_map,'amount',fee::TEXT) into dict_map;
	select gamebox_station_bill(dict_map) INTO bill_id;

	RETURN '0';
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_station_bill_master(
sys_map hstore
,dict_map hstore
,url_name TEXT
,main_url TEXT
,start_time TEXT
,end_time TEXT
) IS 'Lins-站点账务-API';


/*
* Lins-运营商占成计算.
* @author:Lins
* @date:2015-12-14
* 参数1.梯度限值.
* 参数2.占成值.参数1与参数2长度一样
* 参数3.盈亏额
* 参数4.盈亏共担
*/
drop function if exists gamebox_operation_occupy_calculate(FLOAT[],FLOAT[],FLOAT,BOOLEAN);
create or replace function gamebox_operation_occupy_calculate(
limit_values FLOAT[]
,retios FLOAT[]
,amount FLOAT
,assume BOOLEAN
)
returns FLOAT as $$
DECLARE
	val FLOAT;
	pre_value FLOAT:=0.00;
	occupy FLOAT:=0.00;
	cal_amount FLOAT:=0.00;
	o_val FLOAT;
	c_val FLOAT;--当前上线值.
	retio FLOAT;--当前占成比例.
BEGIN
	val=amount;
	IF assume AND val<0 THEN
		amount=-amount;
	ELSEIF assume=false AND val<0 THEN
		raise info '盈亏不共担,计税金额为负时,占成计0';
		RETURN 0.00;--盈亏不共担,计税金额为负时,占成计0.
	END IF;
	raise info '计税金额:%',amount;
	IF array_length(limit_values, 1)=array_length(retios, 1) THEN
		FOR i IN 1..array_length(limit_values, 1) LOOP
			--raise info 'limit_values:%',limit_values[1:1][1]::FLOAT;
			IF amount<0 THEN
				exit;
			END IF;
			c_val=limit_values[i];
			--盈亏共担 且 计税金额为负 且 当前梯度为负
			IF assume AND val<0 AND c_val<0 THEN
				c_val=-c_val;
			END IF;
			retio=retios[i];
			cal_amount=c_val-pre_value;
			amount=amount-cal_amount;
			IF amount<0 THEN
				o_val=(amount+cal_amount)*retio/100;
				raise info '梯度范围:%~%,计税额:%,比例:%,税额:%',pre_value,c_val,(amount+cal_amount),retio||'%',o_val;
				occupy=occupy+o_val;
				exit;
			ELSE
				o_val=cal_amount*retio/100;
				raise info '梯度范围:%~%,计税额:%,比例:%,税额:%',pre_value,c_val,cal_amount,retio||'%',o_val;
				occupy=occupy+o_val;
				pre_value=c_val;
			END IF;
		END LOOP;
	END IF;
	raise info '计税金额:%,税额:%',val,occupy;
	RETURN occupy;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_calculate(
limit_values FLOAT[]
,retios FLOAT[]
,amount FLOAT
,assume BOOLEAN
) IS 'Lins-运营商占成计算';

/*
* Lins-包网方案-梯度转数组.
* @author:Lins
* @date:2015-12-14
* 参数1.梯度信息.
*/
drop function if exists gamebox_operation_occupy_to_array(TEXT,INT);
create or replace function gamebox_operation_occupy_to_array(
val TEXT
,subscript INT
)
returns FLOAT[] as $$
DECLARE
	vals TEXT[];
	subs TEXT[];
	cs TEXT='_';
	rs TEXT='\^&\^';
	limit_values FLOAT[];
	--retios FLOAT[];
BEGIN
	--val=map->key;
	--0_100_2^&^100_200_1^&^200_300_1^&^300_400_1^&^400_500_2
	IF val is not null THEN
		vals=regexp_split_to_array(val,rs);
		raise info 'vals=%',vals;
		IF vals is not null AND array_length(vals, 1)>0 THEN
			FOR i IN 1..array_length(vals, 1) LOOP
				subs=regexp_split_to_array(vals[i],cs);
				IF subs is not null AND array_length(subs, 1)=3 THEN
					IF limit_values is null THEN
						limit_values=array[subs[subscript]::FLOAT];
						--retios=array[subs[3]::FLOAT];
					ELSE
						limit_values=array_append(limit_values, subs[subscript]::FLOAT);
						--retios=array_append(retios, subs[3]::FLOAT);
					END IF;
				END IF;
			END LOOP;
		END IF;
	END IF;
	RETURN limit_values;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_to_array(
val TEXT
,subscript INT
) IS 'Lins-包网方案-梯度转数组';

/*
* Lins-站点账务-API游标.
* @author Lins
* @date 2015.12.2
* @参数1:站点库Dblink.
* @参数2:周期开始时间(yyyy-mm-dd HH24:mm:ss)
* @参数3:周期结束时间(yyyy-mm-dd HH24:mm:ss)
*/
DROP FUNCTION IF EXISTS gamebox_operation_occupy_api(TEXT,TEXT,TEXT);
create or replace function gamebox_operation_occupy_api(
url TEXT
,start_time TEXT
,end_time TEXT
) returns refcursor as $$
DECLARE
	cur refcursor;
BEGIN
    OPEN cur FOR  SELECT * FROM dblink('host=192.168.0.88 dbname=gamebox-master user=postgres password=postgres','
		SELECT o.api_id,o.game_type,
		COALESCE(sum(-o.profit_amount),0.00) as profit_amount,
		COALESCE(sum(o.effective_trade_amount),0.00) AS trade_amount
		from player_game_order o where
		o.create_time>='''||start_time||'''
		and o.create_time<'''||end_time||'''
		group by o.api_id,o.game_type ')
		as p(api_id INT,game_type VARCHAR,profit_amount NUMERIC,trade_amount NUMERIC);
	return cur;
END;
$$ language plpgsql;

comment ON function gamebox_operation_occupy_api(
conn_name TEXT
,start_time TEXT
,end_time TEXT
) IS 'Lins-站点账务-API游标';

/*
* 生成流水号
* @author: Lins
* @date:2015.12.22
* 参数1.交易类型:B或T
* 参数2.站点code
* 参数3.流水号类型
* 参数4.Dblink URL
*/
DROP FUNCTION if exists gamebox_generate_order_no(TEXT,TEXT,TEXT,TEXT);
create or replace function gamebox_generate_order_no(
trans_type TEXT
,site_code TEXT
,order_type TEXT
,url TEXT
) returns TEXT as $$
DECLARE
	order_no TEXT:='';
BEGIN
	SELECT INTO order_no seq FROM dblink(url,'select gamebox_generate_order_no(
  '''||trans_type||''','''||site_code||''' ,'''||order_type||''')') as p(seq TEXT);
	RETURN order_no;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_generate_order_no
(
trans_type TEXT
,site_code TEXT
,order_type TEXT
,url TEXT
) IS 'Lins-生成流水号';


/*
* 上期未结金额
* @author: Lins
* @date:2015.12.22
* 参数1.站点ID
* 参数2.账务年份
* 参数3.账务月份
* 参数4.账务类型
*/
DROP FUNCTION if exists gamebox_station_no_bill(INT,INT,INT,TEXT);
create or replace function gamebox_station_no_bill(
site_id INT
,bill_year INT
,bill_month INT
,bill_type TEXT
) returns FLOAT as $$
DECLARE
	amount FLOAT:=0.00;
BEGIN
	EXECUTE 'SELECT amount_actual FROM station_bill
					WHERE site_id=$1
					AND bill_year=$2
					AND bill_month=$3
					AND bill_type=$4
					AND amount_actual<0 '
	USING site_id,bill_year,bill_month,bill_type
	INTO amount;
	IF amount is null THEN
		amount=0.00;
	END IF;
	RETURN amount;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_station_no_bill(
site_id INT
,bill_year INT
,bill_month INT
,bill_type TEXT
) IS 'Lins-站点账务-上期未结金额';


/*
* Lins-运营商优惠计算.
* @author:Lins
* @date:2015-12-14
* 参数1.优惠梯度.
* 参数2.占成额
*/
drop function if exists gamebox_operation_favorable_calculate(hstore,FLOAT);
create or replace function gamebox_operation_favorable_calculate(
favorable_map hstore
,amount FLOAT
)returns hstore as $$
DECLARE
	val TEXT;
	keys TEXT[];
	key_name TEXT;
	favourable_grads TEXT:='';--优惠满足梯度
	favourable_way TEXT:='';--优惠方式(1:固定,2:比例)
	favourable_value TEXT:='';--优惠值
	favourable_limit TEXT:='';--优惠上限
	map hstore;
BEGIN
	IF favorable_map is null OR amount<=0 THEN
		SELECT put(map,'grads','0') INTO map;
		SELECT put(map,'limit','0') INTO map;
		SELECT put(map,'value','0') INTO map;
		SELECT put(map,'way','0') INTO map;
	ELSE
		keys=akeys(favorable_map);
		FOR i IN REVERSE array_length(keys, 1)..1 LOOP

			IF amount>(keys[i]::FLOAT) THEN
				key_name=keys[i];
				exit;
			END IF;
		END LOOP;
		val=favorable_map->key_name;
		--val格式:梯度下限_梯度上限_优惠类型_优惠方式_优惠值_优惠上限
		keys=regexp_split_to_array(val,'_');
		--raise info 'vals:%',keys;
		IF array_length(keys, 1)=6 THEN
				favourable_grads=COALESCE(keys[2],'0');--梯度值
				favourable_way=COALESCE(keys[4],'1');--优惠方式(1:固定,2:比例)
				favourable_value=COALESCE(keys[5],'0');--优惠值
				favourable_limit=COALESCE(keys[6],'0');--上限
				IF favourable_way='2' THEN--比例
					favourable_value=(amount*(favourable_value::FLOAT)/100)::TEXT;
				END IF;
				IF favourable_limit::FLOAT>0 AND favourable_value::FLOAT>favourable_limit::FLOAT THEN--超过上限
					favourable_value=favourable_limit;
				END IF;
				--raise info 'way=%',favourable_way;
				SELECT put(map,'grads',favourable_grads) INTO map;
				SELECT put(map,'limit',favourable_limit) INTO map;
				SELECT put(map,'value',favourable_value) INTO map;
				SELECT put(map,'way',favourable_way) INTO map;
		END IF;
	END IF;
	IF map is null THEN
		SELECT put(map,'grads','0') INTO map;
		SELECT put(map,'limit','0') INTO map;
		SELECT put(map,'value','0') INTO map;
		SELECT put(map,'way','0') INTO map;
	END IF;
	RETURN map;
END
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_favorable_calculate(
favorable_map hstore
,amount FLOAT
) IS 'Lins-运营商优惠计算';
/*

SELECT gamebox_station_no_bill(1,2015,12,'1');

SELECT gamebox_generate_order_no('B','1','04','host=192.168.0.88 dbname=gamebox-master user=postgres password=postgres');

SELECT gamebox_operation_occupy_calculate(array[-100,-300,-700,-1000],array[1.3,2.1,2.8,3.3],-839,TRUE);

SELECT gamebox_operation_occupy_calculate(array[-100,-300,-700,-1000],array[3.3,2.8,2.1,1.3],-839,FALSE);

SELECT gamebox_operation_occupy_calculate(array[100,300,700,1000],array[3.3,2.8,2.1,1.3],839,TRUE);

SELECT gamebox_operation_occupy_to_array('0_100_2^&^100_200_1^&^200_300_1^&^300_400_1^&^400_500_2');

--测试收集站点玩家数.

--站长账务
SELECT * FROM gamebox_station_bill(
'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'host=192.168.0.88 dbname=gamebox-master user=postgres password=postgres'
,'2015-01-01','2015-12-31','\|',1);

--总代账务
SELECT * FROM gamebox_station_bill(
'host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres'
,'host=192.168.0.88 dbname=gamebox-master user=postgres password=postgres'
,'2015-01-01','2015-12-31',2);

*/