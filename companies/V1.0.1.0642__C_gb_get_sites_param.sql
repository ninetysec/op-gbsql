-- auto gen by linsen 2018-07-06 19:11:43
-- 创建此函数: 更新站点库的系统参数 by min
DROP FUNCTION IF EXISTS gb_get_sites_param( siteid_or_status text );

CREATE OR REPLACE FUNCTION gb_get_sites_param(

	 siteid_or_status text

) returns TEXT AS $$

/*版本更新说明

  版本   时间        作者    内容

--v1.00  2018/06/20  Min    创建此函数: 更新站点库的系统参数

--v1.01  2018/06/27  Min    滤掉param_code='showpop',此参数不用同步



	入参说明

	siteid_or_status : 站点ID 或者 站点状态枚举(all_avaiable)



*/

DECLARE



	t_sql text;

	rec_ds record;

	site_url text;



	n_count int = 0; --影响行

	ins_num int = 0; --插入行

	update_num int = 0; --更新行



  text_var1 TEXT;

  text_var2 TEXT;

  text_var3 TEXT;

  text_var4 TEXT;



BEGIN



	----------------------------------初始化站点信息------------------------------------

	if siteid_or_status is null or length(siteid_or_status) = 0 then

		RETURN '参数为空';

  end if;

	perform dblink_disconnect_all();

	t_sql =  'SELECT parent_id comp_id, sys_user_id master_id, d.id site_id, d.name site_name,

            CASE idc WHEN ''A'' THEN ip ELSE remote_ip END as ip, CASE idc WHEN ''A'' THEN port ELSE remote_port END as port,

						dbname, username, password

            FROM sys_site s, sys_datasource d where s.id = d.id  ' ;



	if lower(siteid_or_status) = 'all_avaiable'  then  --全部正常站

		t_sql =  t_sql || ' and s.status = ''1'' ' ;

	else if  siteid_or_status ~ '^(0|[1-9][0-9]{0,8})$' then   ---非负整数

					t_sql =  t_sql || ' and s.id = '|| siteid_or_status  ;

      else  RETURN '参数异常';

			end if;

	end if;

	create temporary table temp_site_param(id int4,module varchar,param_type varchar,param_code varchar,param_value text,default_value text,order_num int4,

												    remark varchar,parent_code varchar,active bool,site_id int4,is_switch bool,operate varchar) on commit drop;

	----------------------------------循环站点------------------------------------

	FOR rec_ds IN EXECUTE t_sql

	LOOP

			site_url = 'host=' || rec_ds.ip || ' port=' || rec_ds.port || ' dbname=' || rec_ds.dbname || ' user=' || rec_ds.username ||

			           ' password=' ||rec_ds.password;

			RAISE INFO '正在收集 % 站点：', rec_ds.site_id;

			perform dblink_connect_u('master', site_url);

			DELETE from temp_site_param;

			INSERT into temp_site_param (id,module,param_type,param_code,param_value,default_value,order_num,remark,parent_code,active,site_id,is_switch,operate )

			 SELECT * FROM dblink('master', 'SELECT id,module,param_type,param_code,param_value,default_value,order_num,remark,parent_code,active,

			                                 site_id,is_switch,operate FROM  sys_param where sys_param.param_code=''showpop''')

                         t (id int4,module varchar,param_type varchar,param_code varchar,param_value text,default_value text,order_num int4,

												    remark varchar,parent_code varchar,active bool,site_id int4,is_switch bool,operate varchar);



				----------------------------------插入新数据------------------------------------

		  INSERT into sys_param (module,param_type,param_code,param_value,default_value,order_num,remark,parent_code,active,site_id,is_switch,operate)

			--注意处理site_id

													SELECT module,param_type,param_code,param_value,default_value,order_num,remark,parent_code,active,rec_ds.site_id,is_switch,operate

													from temp_site_param tsp where not EXISTS ( select 1 from sys_param sys_param where  1=1

																																																										and sys_param.module     = tsp.module

																																																										and sys_param.param_type = tsp.param_type

																																																										and sys_param.param_code = tsp.param_code

																																																										and sys_param.site_id    = rec_ds.site_id	);

	GET DIAGNOSTICS n_count =  ROW_COUNT;

	RAISE NOTICE '插入数据 % 条', n_count;

	ins_num = ins_num + n_count;

				----------------------------------更新变化数据------------------------------------

				update sys_param sys_param set (param_value,default_value,order_num,remark,parent_code,active,is_switch,operate) =

				( select param_value,default_value,order_num,remark,parent_code,active,is_switch,operate

				from temp_site_param tsp where  1=1

																				and sys_param.module     = tsp.module

																				and sys_param.param_type = tsp.param_type

																				and sys_param.param_code = tsp.param_code)

				where EXISTS ( select 1 from temp_site_param tsp where  1=1

																																and sys_param.module     = tsp.module

																																and sys_param.param_type = tsp.param_type

																																and sys_param.param_code = tsp.param_code

																																and sys_param.site_id    = rec_ds.site_id

																																and (   sys_param.param_value   <> tsp.param_value

																																		 or sys_param.default_value <> tsp.default_value

																																		 or sys_param.order_num     <> tsp.order_num

																																		 or sys_param.remark        <> tsp.remark

																																		 or sys_param.parent_code   <> tsp.parent_code

																																		 or sys_param.active        <> tsp.active

																																		 or sys_param.is_switch     <> tsp.is_switch

																																		 or sys_param.operate       <> tsp.operate ));



			--判断变化值param_value,default_value,order_num,remark,parent_code,active,is_switch,operate



	GET DIAGNOSTICS n_count =  ROW_COUNT;

	RAISE NOTICE '更新数据 % 条', n_count;

	update_num = update_num + n_count;

				----------------------------------关闭连接------------------------------------

	perform dblink_disconnect('master');

	end LOOP ;



 RETURN  '本次同步插入数据 '|| ins_num::text || ' 条,更新数据 ' || update_num::text || ' 条';



----------------------------------异常处理------------------------------------

	EXCEPTION

		WHEN QUERY_CANCELED THEN

			perform dblink_disconnect_all();

			RETURN '用户取消';

		WHEN OTHERS THEN

			perform dblink_disconnect_all();

			GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,

															text_var2 = PG_EXCEPTION_DETAIL,

															text_var3 = PG_EXCEPTION_HINT,

															text_var4 = PG_EXCEPTION_CONTEXT;

			RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

			RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

		RETURN '程序异常';

END;





$$ language plpgsql;

COMMENT ON FUNCTION gb_get_sites_param( text )

IS ' 更新站点库的系统参数 ';