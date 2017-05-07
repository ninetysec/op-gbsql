CREATE OR REPLACE FUNCTION "f_agent_rebate"(stat_month text, p_start_time text, p_end_time text, api_type_relation_json text,p_com_url text)

  RETURNS "pg_catalog"."varchar" AS $BODY$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2017/03/03  younger   创建此函数: 返佣结算账单-入口

  -- stat_month 统计月份

  -- p_start_time 统计开始时间

  -- p_end_time 统计结束时间

  -- api_type_relation_json API返佣排序

	--生成JSON串语句：

	--select array_to_json(array_agg(row_to_json(t))) from (select api_id, api_type_id,rebate_order_num from api_type_relation order by rebate_order_num ) t

	--运行函数

	--select f_agent_rebate('2017-02','2017-01-31 16:00:00','2017-02-28 16:00:00','','host=192.168.0.88 port=5432 dbname=gb-companies user=gb-companies password=postgres')

	--select f_agent_rebate('2017-02','2017-01-31 16:00:00','2017-02-28 16:00:00','','host=postgres-boss port=5432 dbname=gb-companies user=gb-companies password=postgres');

*/

DECLARE



	t_start_time 	TIMESTAMP;--查询开始时间

	t_end_time 	TIMESTAMP;--查询结束时间

	t_start_date DATE;

	t_end_date DATE;

	last_rebate_month VARCHAR;

  need_history_count BOOLEAN :=false;--是否需要累计

  p_year INT :=0; --统计年

  p_month INT :=0;--统计月

  p_last_year INT :=0;--上期统计年

  p_last_month INT :=0;--上期统计月

  rebateStatus VARCHAR;--佣统状态

	deposit_radio numeric :=0;--存款率

	withdraw_radio numeric :=0;--取款率

	agentRecord RECORD;--代理行记录

	apiRelationRecord RECORD;--API关系记录

	apiRebateRecord RECORD;--API返佣记录

	agentrebateid INT;--代理返佣ID

	agentgradsid INT;--代理满足的梯度ID

	validValue INT;--有效值

	apiJson VARCHAR;--API JSON串

	apiId int; --API临时ID

	apiTypeId int;--API类型临时ID

	zpc numeric(20,2) :=0; --总派彩

	feeAmount numeric(20,2) :=0;--当期行政费用

	apiGradsRec RECORD;--API派彩记录

	remainFeeAmount numeric(20,2) :=0;--剩余费用

	remainPayout numeric(20,2) :=0;--剩作派彩

	totalFee numeric(20,2) :=0;--代理总费用

	idx int := 0 ;--序号

	rebateOrderNum int;--API返佣排序号

	unsettled RECORD;--数据库连接

	temp_sql VARCHAR;--临时SQL

	maxrebate numeric(20,2);--最大上限

	agentRebateCur refcursor := NULL;



BEGIN

	if stat_month is null or stat_month = '' THEN

		raise notice '统计月分为空';

		RETURN '统计月分为空';

	end if;

	if (api_type_relation_json is null or api_type_relation_json = '') and (p_com_url is null or p_com_url = '') THEN

		raise notice 'API返佣顺序数据为空';

		RETURN 'API返佣顺序数据为空';

	end if;

	if api_type_relation_json is null or api_type_relation_json = '' THEN

		raise notice 'API返佣顺序数据为空,从URL获取';

		temp_sql = 'select array_to_json(array_agg(row_to_json(t))) from (select api_id, api_type_id,rebate_order_num from api_type_relation order by rebate_order_num ) t';

		for unsettled in

			SELECT * from dblink(p_com_url,temp_sql) as unsettled_temp(apiJson VARCHAR)

		loop

			api_type_relation_json = unsettled.apiJson;

		end loop;

	end if;

	raise notice 'api_type_relation_json： %', api_type_relation_json;

	--拆分统计年月

  SELECT substring(stat_month from 1 for 4) INTO p_year;

  SELECT substring(stat_month from 6 for 7) INTO p_month;

	--上月

	select to_char(to_date(stat_month,'yyyy-mm')+ interval '-1 months','yyyy-mm') into last_rebate_month;

	--拆分上期统计年月

	if last_rebate_month is not null and last_rebate_month <> '' then

		SELECT substring(last_rebate_month from 1 for 4) INTO p_last_year;

		SELECT substring(last_rebate_month from 6 for 7) INTO p_last_month;

	end if;

	--转换时间格式

	t_start_time = p_start_time::TIMESTAMP;

	t_end_time = p_end_time::TIMESTAMP;

	--统计查询条件年月日

	select to_date(stat_month||'-01','yyyy-mm-dd') into t_start_date;

	select to_date(to_char(t_start_date+ interval '1 months','yyyy-mm-dd'),'yyyy-mm-dd') into t_end_date;

	raise notice 't_start_date %', t_start_date;

	raise notice 't_end_date %', t_end_date;



  --1、判断统计月份是否存在，有存在，先删除



		DELETE FROM agent_rebate WHERE rebate_year=p_year and rebate_month=p_month;

		DELETE FROM agent_rebate_player where rebate_year=p_year and rebate_month=p_month;

		DELETE FROM agent_rebate_grads where rebate_year=p_year and rebate_month=p_month;





	--2、计算代理的承担费用（即生成agent_rebate_player）

		SELECT CASE WHEN param_value is NULL THEN default_value ELSE param_value end FROM sys_param WHERE param_type = 'rebateSetting' and param_code='settlement.deposit.fee' INTO deposit_radio;

		SELECT CASE WHEN param_value is NULL THEN default_value ELSE param_value end FROM sys_param WHERE param_type = 'rebateSetting' and param_code='settlement.withdraw.fee' INTO withdraw_radio;

		--插入代理返佣_玩家明细表

		insert into agent_rebate_player(

			rebate_year,rebate_month,topagent_id,topagentusername,agent_id,agentusername,user_id,username,deposit_amount,deposit_radio,withdraw_amount,withdraw_radio,rakeback_amount,favorable_amount,recommend_amount

		)

		SELECT p_year,p_month,d.id topagent_id,d.username topagentusername,c.id agent_id,c.username agentusername,player_id user_id,b.username username,

		(SELECT sum(COALESCE(transaction_money,0)) from player_transaction pt where pt.player_id = a.player_id and pt.transaction_type='deposit' and pt.status = 'success' and completion_time>=t_start_time and completion_time<t_end_time) deposit_amount,

		COALESCE(deposit_radio,0),

		(SELECT sum(COALESCE(-transaction_money,0)) from player_transaction pt where pt.player_id = a.player_id and pt.transaction_type='withdrawals' and pt.status = 'success' and completion_time>=t_start_time and completion_time<t_end_time) withdraw_amount,

		COALESCE(withdraw_radio,0),

		(SELECT sum(COALESCE(transaction_money,0)) from player_transaction pt where pt.player_id = a.player_id and pt.transaction_type='backwater' and pt.status = 'success' and completion_time>=t_start_time and completion_time<t_end_time) rakeback_amount,

		(SELECT sum(COALESCE(transaction_money,0)) from player_transaction pt where pt.player_id = a.player_id and pt.transaction_type='favorable' and pt.status = 'success' and completion_time>=t_start_time and completion_time<t_end_time) favorable_amount,

				(SELECT sum(COALESCE(transaction_money,0)) from player_transaction pt where pt.player_id = a.player_id and pt.transaction_type='recommend' and pt.status = 'success' and completion_time>=t_start_time and completion_time<t_end_time) recommend_amount

		 from (select player_id from player_transaction where transaction_type!='transfers'  and completion_time>= t_start_time and completion_time < t_end_time group by player_id) a left join sys_user b

		on a.player_id = b.id left join sys_user c on b.owner_id = c.id left join sys_user d on c.owner_id = d.id;





	--3、每个代理生成一条主表数据

		FOR agentRecord in

			SELECT * from sys_user where user_type='23' and status in('1','3')

		LOOP

			--是否需要累计

			select rebate_status from agent_rebate where rebate_year = p_last_year and rebate_month = p_last_month and agent_id=agentRecord.id into rebateStatus;

			if rebateStatus='0' or rebateStatus='1' THEN

				need_history_count = true;

			end if;



			--获取代理返佣方案

			select rebate_id from user_agent_rebate uar where uar.user_id = agentRecord.id INTO agentrebateid;

			select valid_value from rebate_set where id = agentrebateid into validValue;



			--获取代理满足的佣金梯度

			SELECT  id FROM rebate_grads WHERE rebate_id=agentrebateid AND total_profit <= (SELECT -sum(profit_loss) FROM operate_player WHERE agent_id = agentRecord.id and static_date>=t_start_date and static_date < t_end_date )

				AND  valid_player_num <= (select count(1) from (select player_id,sum(transaction_volume) tradevalue from operate_player where static_date>=t_start_date and static_date < t_end_date and agent_id=agentRecord.id  group by player_id) ta where ta.tradevalue>validValue)  order by valid_player_num desc limit 1 INTO agentgradsid;

			--获取最大上限金额

			SELECT  max_rebate FROM rebate_grads WHERE rebate_id=agentrebateid AND total_profit <= (SELECT -sum(profit_loss) FROM operate_player WHERE agent_id = agentRecord.id and static_date>=t_start_date and static_date < t_end_date )

				AND  valid_player_num <= (select count(1) from (select player_id,sum(transaction_volume) tradevalue from operate_player where static_date>=t_start_date and static_date < t_end_date and agent_id=agentRecord.id  group by player_id) ta where ta.tradevalue>validValue)  order by valid_player_num desc limit 1 INTO maxrebate;

				--raise notice 'max_rebate %',agentgradsid;

			--批量插入数据

			insert INTO agent_rebate(rebate_year,rebate_month,start_time,end_time,topagent_id,topagentusername,agent_id,agentusername,effective_player_amount,

				effective_player_num,payout_amount_history,payout_amount,effective_amount_history,effective_amount,fee_amount_history,favorable_amount_history,

				rakeback_amount_history,other_amount_history,fee_amount,favorable_amount,rakeback_amount,other_amount,rebate_amount,rebate_amount_actual,rebate_status,create_time

			)

			select rebate_year,rebate_month,t_start_time,t_end_time,topagent_id,topagentusername,agent_id,agentusername,

			--有效玩家的有效投注额

			COALESCE(validValue,0),

			--有效玩家数

			COALESCE((select count(1) from (select player_id,sum(effective_transaction) effAmount from operate_player where static_date>=t_start_date and static_date < t_end_date and agent_id = agentRecord.id GROUP BY player_id) a where a.effAmount>=validValue),0) effective_player_num,

			--累积派彩

			COALESCE((CASE WHEN need_history_count THEN

				(select (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) from agent_rebate where agent_id = agentRecord.id and rebate_year = p_last_year and rebate_month = p_last_month)

				ELSE 0 END),0) payout_amount_history,

			--当期派彩、

			COALESCE((select -sum(COALESCE(profit_loss,0)) from operate_agent oa where oa.agent_id = agentRecord.id and oa.static_date>=t_start_date and oa.static_date<t_end_date),0) payout_amount,

			--累积有效投注额、

			COALESCE((CASE WHEN need_history_count THEN (

					(select (COALESCE(effective_amount_history,0)+COALESCE(effective_amount,0)) from agent_rebate where agent_id = agentRecord.id and rebate_year = p_last_year and rebate_month = p_last_month)

				) ELSE 0 END),0) effective_amount_history,

			--当期有效投注额、

			COALESCE((select sum(COALESCE(effective_transaction,0)) from operate_agent oa where oa.agent_id = agentRecord.id and oa.static_date>=t_start_date and oa.static_date<t_end_date),0) effective_amount,

			--累积行政费用(上一期的累积费用+上一期当期费用)

			COALESCE((CASE WHEN need_history_count THEN

					(select (COALESCE(fee_amount_history,0)+COALESCE(fee_amount,0)) history_fee from agent_rebate where rebate_year = p_last_year and rebate_month = p_last_month and agent_id=agentRecord.id)

				ELSE 0 END),0) fee_amount_history,

			--累积存款优惠

			COALESCE((CASE WHEN need_history_count THEN

					(select (COALESCE(favorable_amount_history,0)+COALESCE(favorable_amount,0)) history_favorable from agent_rebate where rebate_year = p_last_year and rebate_month = p_last_month and agent_id=agentRecord.id)

				ELSE 0 END),0) favorable_amount_history,

			--累积返水优惠

			COALESCE((CASE WHEN need_history_count THEN

					(select (COALESCE(rakeback_amount_history,0)+COALESCE(rakeback_amount,0)) history_rakeback from agent_rebate where rebate_year = p_last_year and rebate_month = p_last_month and agent_id=agentRecord.id)

				ELSE 0 END),0) rakeback_amount_history,

			--累积其他费用

			COALESCE((CASE WHEN need_history_count THEN

					(select (COALESCE(other_amount_history,0)+COALESCE(other_amount,0)) from agent_rebate where rebate_year = p_last_year and rebate_month = p_last_month and agent_id=agentRecord.id)

				ELSE 0 END),0) other_amount_history,

			(sum(COALESCE(deposit_amount,0)*(COALESCE(arp.deposit_radio,0)/100))+sum(COALESCE(withdraw_amount,0)*(COALESCE(arp.withdraw_radio,0)/100))) fee_amount,

			sum(COALESCE(favorable_amount,0)) favorable_amount,

			sum(COALESCE(rakeback_amount,0)) rakeback_amount,

			sum(COALESCE(recommend_amount,0)) other_amount,

			0 rebate_amount,	 	--返佣金额

			0 rebate_amount_actual,	 	--已返佣金额

			'0' rebate_status,		--返佣状态

			now()	--创建时间

			from agent_rebate_player arp where rebate_year =p_year and rebate_month = p_month and agent_id = agentRecord.id  group BY topagent_id,topagentusername,agent_id,agentusername,rebate_year,rebate_month;



		--4、计算代理各api的总派彩(即生成agent_rebate_grads)

		--当期派彩，从player_game_order直接统计

		--累积派彩，需要看下上一期的返佣账单的状态是否需要累积，需要累积的话，等于上一期的累积派彩+上一期的当期派彩



			insert into agent_rebate_grads(

			rebate_year,rebate_month,topagent_id,topagentusername,agent_id,agentusername,api_id,api_type_id,payout_amount_history,payout_amount,radio

		)

		select p_year,p_month,topagent_id,topagent_name,agent_id,agent_name,api_id,api_type_id,

			COALESCE((CASE WHEN need_history_count THEN (

				select (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) from agent_rebate_grads arg where rebate_year = p_last_year and rebate_month = p_last_month and agent_id=oa.agent_id and arg.api_id=oa.api_id and arg.api_type_id = oa.api_type_id

			) ELSE 0 END),0) payout_amount_history ,

			SUM(-COALESCE(profit_loss,0)) payout_amount,

			COALESCE((SELECT ratio FROM rebate_grads_api WHERE rebate_grads_id = agentgradsid AND api_id=oa.api_id AND api_type_id=oa.api_type_id),0) radio

			from operate_player oa where static_date>=t_start_date and static_date < t_end_date and agent_id=agentRecord.id group by topagent_id,topagent_name,agent_id,agent_name,api_id,api_type_id;





			temp_sql='select * from agent_rebate where rebate_year ='|| p_year ||' and rebate_month ='|| p_month ||' and agent_id ='|| agentRecord.id;

			--raise notice 'temp_sql： %',temp_sql;

			open agentRebateCur for execute temp_sql;

			FETCH agentRebateCur INTO apiRebateRecord;

			if apiRebateRecord is null THEN

				close agentRebateCur;

				CONTINUE;

			end if;





			--初始数据

				feeAmount = 0;

				remainFeeAmount = 0;

				remainPayout = 0;

				remainPayout = 0;

				totalFee = 0;

				idx = 0;



				feeAmount = COALESCE(apiRebateRecord.fee_amount,0)+COALESCE(apiRebateRecord.fee_amount_history,0)+COALESCE(apiRebateRecord.favorable_amount,0)+COALESCE(apiRebateRecord.rakeback_amount,0)+COALESCE(apiRebateRecord.other_amount,0)+COALESCE(apiRebateRecord.favorable_amount_history,0)+COALESCE(apiRebateRecord.rakeback_amount_history,0)+COALESCE(apiRebateRecord.other_amount_history,0);

				--raise notice '代理的承担费用feeAmount为 %', feeAmount;



				for apiJson in

						select json_array_elements(api_type_relation_json::json)

				loop

						select apiJson::json->>'api_id' into apiId;

						select apiJson::json->>'api_type_id' into apiTypeId;

						select apiJson::json->>'rebate_order_num' into rebateOrderNum;

						--raise notice 'apiId % apiTypeId %', apiId,apiTypeId;

						for apiGradsRec in

								select * from agent_rebate_grads where rebate_year = p_year and rebate_month = p_month and radio is not null and radio>0 and agent_id = apiRebateRecord.agent_id

						loop

								if apiId = apiGradsRec.api_id and apiTypeId = apiGradsRec.api_type_id THEN

										if idx >0 THEN

											feeAmount =remainFeeAmount;--承担费用

										ELSEIF idx =0 THEN

											remainFeeAmount = feeAmount;

										end if;

										zpc = apiGradsRec.payout_amount_history + apiGradsRec.payout_amount;--当前api总派彩

										--如果总派彩大于０，即需要扣掉代理承担费用，反之剩余派彩等于总派彩

										if zpc >= 0 THEN

											remainFeeAmount = zpc - feeAmount;

											--如果剩余费用小于０，则剩余派彩为０,剩余承担费用也是０，反之等于总派彩－当前承担费用

											if remainFeeAmount <0 THEN

													remainPayout =0;

													remainFeeAmount=-remainFeeAmount;

											ELSE

													remainPayout = remainFeeAmount;

													remainFeeAmount=0;

											end if;

										ELSE

											remainPayout = zpc;

										end if;

										totalFee = totalFee +  (remainPayout * apiGradsRec.radio)/100;

										update agent_rebate_grads set expense_amount = feeAmount,rebate_order_num = rebateOrderNum,remain_expense_amount=remainFeeAmount,remain_payout_amount=remainPayout  where id = apiGradsRec.id;

										idx = idx +1;

								end if;

						END loop;		--循环API

				END loop;--循环排序的API

				--raise notice '总费用为 % ，剩余承担费用为 %， 所以代理 % 的最终返佣费用为 %', totalFee,remainFeeAmount,apiRebateRecord.agentusername,totalFee - remainFeeAmount;

				if remainFeeAmount>0 THEN

					totalFee = totalFee - remainFeeAmount;

				end if;

				if maxrebate is not null and totalFee >= maxrebate THEN

						totalFee = maxrebate;

				end if;

				if totalFee = 0 THEN

					UPDATE agent_rebate set rebate_amount = totalFee,rebate_status='1' where id = apiRebateRecord.id;

				ELSE

					UPDATE agent_rebate set rebate_amount = totalFee where id = apiRebateRecord.id;

				end if;

			--关闭游标

			close agentRebateCur;



		end LOOP;



		--5、计算代理可获返佣

		--按返佣顺序列出api_type的各返佣比例

		--根据各api的总派彩计算游戏费用

		--各游戏费用×返佣比例相加，即为代理返佣费用

		/*

		for apiRebateRecord in

				select * from agent_rebate where rebate_year = p_year and rebate_month = p_month

		loop



		end loop;--循环代理返佣

		*/



  return '成功';

END;



$BODY$

  LANGUAGE 'plpgsql' VOLATILE COST 100

;



COMMENT ON FUNCTION "f_agent_rebate"(stat_month text, p_start_time text, p_end_time text, api_type_relation_json text,p_com_url text) IS 'younger-返佣结算账单-入口';