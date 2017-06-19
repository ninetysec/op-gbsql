DROP FUNCTION IF EXISTS f_agent_rebate(p_stat_month text, p_start_time text, p_end_time text, p_api_type_order_json text, p_com_url text);
CREATE OR REPLACE FUNCTION f_agent_rebate(p_stat_month text, p_start_time text, p_end_time text, p_api_type_order_json text, p_com_url text)
  RETURNS pg_catalog.varchar AS $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/03/03  younger  创建此函数: 返佣结算账单-入口
--v1.10  2017/03/30  Leisure  修复上月无响应gametype数据时本期无法累加等bug
  -- p_stat_month 统计月份
  -- p_start_time 统计开始时间
  -- p_end_time 统计结束时间
  -- p_api_type_order_json API返佣排序
  --生成JSON串语句：
  --SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT api_id, api_type_id, rebate_order_num FROM api_type_relation ORDER BY rebate_order_num ) t
  --运行函数
  --SELECT f_agent_rebate('2017-02','2017-01-31 16:00:00','2017-02-28 16:00:00','','url');
*/
DECLARE

  t_start_time   TIMESTAMP;--查询开始时间
  t_end_time   TIMESTAMP;--查询结束时间
  t_start_date DATE;
  t_end_date DATE;
  v_last_rebate_month VARCHAR;
  b_need_history_count BOOLEAN :=false;--是否需要累计
  v_year INT :=0; --统计年
  v_month INT :=0;--统计月
  v_last_year INT :=0;--上期统计年
  v_last_month INT :=0;--上期统计月
  v_rebate_status VARCHAR;--佣统状态
  n_deposit_radio numeric :=0;--存款率
  n_withdraw_radio numeric :=0;--取款率
  rec_agent RECORD;--代理行记录
  rec_api_relation RECORD;--API关系记录
  rec_api_rebate RECORD;--API返佣记录
  n_agent_rebate_id INT;--代理返佣ID
  n_agent_grads_id INT;--代理满足的梯度ID
  n_valid_value INT;--有效值
  v_api_json VARCHAR;--API JSON串
  n_api_id int; --API临时ID
  n_api_type_id int;--API类型临时ID
  n_payout_total numeric(20,2) :=0; --总派彩
  n_fee_amount numeric(20,2) :=0;--当期行政费用
  rec_api_grads RECORD;--API派彩记录
  n_remainn_fee_amount numeric(20,2) :=0;--剩余费用
  n_remain_payout numeric(20,2) :=0;--剩作派彩
  n_fee_total numeric(20,2) :=0;--代理总费用
  idx int := 0 ;--序号
  n_rebate_order_num int;--API返佣排序号
  unsettled RECORD;--数据库连接
  v_temp_sql VARCHAR;--临时SQL
  n_rebate_max numeric(20,2);--最大上限
  cur_agent_rebate refcursor := NULL;

BEGIN
  IF p_stat_month is null or p_stat_month = '' THEN
    raise notice '统计年月为空';
    RETURN '统计年月为空';
  END IF;

  IF (p_api_type_order_json is null or p_api_type_order_json = '') AND (p_com_url is null or p_com_url = '') THEN
    raise notice 'API返佣顺序数据为空';
    RETURN 'API返佣顺序数据为空';
  END IF;

  IF p_api_type_order_json is null or p_api_type_order_json = '' THEN
    raise notice 'API返佣顺序数据为空,从URL获取';
    v_temp_sql = 'SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT api_id, api_type_id,rebate_order_num FROM api_type_relation ORDER BY rebate_order_num ) t';
    FOR unsettled IN
      SELECT * FROM dblink(p_com_url,v_temp_sql) as unsettled_temp(v_api_json VARCHAR)
    LOOP
      p_api_type_order_json = unsettled.v_api_json;
    END LOOP;
  END IF;

  --raise notice 'p_api_type_order_json： %', p_api_type_order_json;

  --拆分统计年月
  --SELECT substring(p_stat_month FROM 1 FOR 4) INTO v_year;
  --SELECT substring(p_stat_month FROM 6 FOR 7) INTO v_month;
  v_year = substr(p_stat_month, 1, 4);
  v_month = substr(p_stat_month, 6, 2);

  --上月
  --SELECT to_char(to_date(p_stat_month,'yyyy-mm')+ interval '-1 months','yyyy-mm') INTO v_last_rebate_month;
  v_last_rebate_month = to_date(p_stat_month,'yyyy-mm')+ interval '-1 month';
  --拆分上期统计年月
  IF v_last_rebate_month is not null AND v_last_rebate_month <> '' then
    --SELECT substring(v_last_rebate_month FROM 1 FOR 4) INTO v_last_year;
    --SELECT substring(v_last_rebate_month FROM 6 FOR 7) INTO v_last_month;
    v_last_year = substr(v_last_rebate_month, 1, 4);
    v_last_month = substr(v_last_rebate_month, 6, 2);
  END IF;

  --转换时间格式
  t_start_time = p_start_time::TIMESTAMP;
  t_end_time = p_end_time::TIMESTAMP;

  --统计查询条件年月日
  --SELECT to_date(p_stat_month||'-01','yyyy-mm-dd') INTO t_start_date;
  --SELECT to_date(to_char(t_start_date+ interval '1 months','yyyy-mm-dd'),'yyyy-mm-dd') INTO t_end_date;
  t_start_date = to_date(p_stat_month, 'YYYY-MM');
  t_end_date = t_start_date + interval '1 month';

  raise notice 't_start_date %', t_start_date;
  raise notice 't_end_date %', t_end_date;

  --1、判断统计月份是否存在，有存在，先删除
    DELETE FROM agent_rebate_player WHERE rebate_year=v_year AND rebate_month=v_month;
    DELETE FROM agent_rebate_grads WHERE rebate_year=v_year AND rebate_month=v_month;
    DELETE FROM agent_rebate WHERE rebate_year=v_year AND rebate_month=v_month;

  --2、计算代理的承担费用（即生成agent_rebate_player）
    --SELECT CASE WHEN param_value is NULL THEN default_value ELSE param_value END FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.deposit.fee' INTO n_deposit_radio;
    --SELECT CASE WHEN param_value is NULL THEN default_value ELSE param_value END FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.withdraw.fee' INTO n_withdraw_radio;
    SELECT COALESCE(param_value, default_value) FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.deposit.fee' INTO n_deposit_radio;
    SELECT COALESCE(param_value, default_value) FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.withdraw.fee' INTO n_withdraw_radio;

    --插入代理返佣_玩家明细表
    INSERT INTO agent_rebate_player (
      rebate_year,rebate_month,topagent_id,topagentusername,agent_id,agentusername,user_id,username,deposit_amount,
      deposit_radio,withdraw_amount,withdraw_radio,rakeback_amount,favorable_amount,recommend_amount
    )
    SELECT v_year,v_month,d.id topagent_id,d.username topagentusername,c.id agent_id,c.username agentusername,player_id user_id,b.username username,
           (SELECT COALESCE(sum(transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='deposit' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) deposit_amount,
           COALESCE(n_deposit_radio,0) deposit_radio,
           (SELECT COALESCE(sum(-transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='withdrawals' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) withdraw_amount,
           COALESCE(n_withdraw_radio,0) withdraw_radio,
           (SELECT COALESCE(sum(transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='backwater' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) rakeback_amount,
           (SELECT COALESCE(sum(transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='favorable' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) favorable_amount,
           (SELECT COALESCE(sum(transaction_money),0) FROM player_transaction pt WHERE pt.player_id = a.player_id AND pt.transaction_type='recommend' AND pt.status = 'success' AND completion_time>=t_start_time AND completion_time<t_end_time) recommend_amount
      FROM
           (SELECT player_id FROM player_transaction WHERE transaction_type<>'transfers'  AND completion_time>= t_start_time AND completion_time < t_end_time GROUP BY player_id) a
           LEFT JOIN sys_user b ON a.player_id = b.id
           LEFT JOIN sys_user c on b.owner_id = c.id
           LEFT JOIN sys_user d on c.owner_id = d.id;

  --3、每个代理生成一条主表数据
    FOR rec_agent IN
      SELECT * FROM sys_user WHERE user_type='23' AND status IN ('1','3') AND id not IN (SELECT agent_id FROM agent_rebate WHERE rebate_year=v_year AND rebate_month=v_month)
    LOOP

      --是否需要累计
      SELECT rebate_status FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id INTO v_rebate_status;
      IF v_rebate_status='0' or v_rebate_status='1' THEN
        b_need_history_count = true;
      ELSE
        b_need_history_count = false;
      END IF;

      --获取代理返佣方案
      SELECT rebate_id FROM user_agent_rebate uar WHERE uar.user_id = rec_agent.id INTO n_agent_rebate_id;
      SELECT valid_value FROM rebate_set WHERE id = n_agent_rebate_id INTO n_valid_value;

      --获取代理满足的佣金梯度、返佣上限
      SELECT id, max_rebate
        INTO n_agent_grads_id, n_rebate_max
        FROM rebate_grads
       WHERE rebate_id=n_agent_rebate_id
         AND total_profit <= (SELECT -sum(profit_loss) FROM operate_player WHERE agent_id = rec_agent.id AND static_date>=t_start_date AND static_date < t_end_date )
         AND valid_player_num <= (SELECT count(1) FROM (SELECT player_id,sum(transaction_volume) tradevalue FROM operate_player WHERE static_date>=t_start_date AND static_date < t_end_date AND agent_id=rec_agent.id  GROUP BY player_id) ta WHERE ta.tradevalue>=n_valid_value)
       ORDER BY total_profit desc, valid_player_num desc limit 1;

      --批量插入数据
      INSERT INTO agent_rebate(
        rebate_year,rebate_month,start_time,end_time,topagent_id,topagentusername,agent_id,agentusername,effective_player_amount,effective_player_num,
        payout_amount_history,payout_amount,effective_amount_history,effective_amount,fee_amount_history,favorable_amount_history,rakeback_amount_history,
        other_amount_history,fee_amount,favorable_amount,rakeback_amount,other_amount,rebate_amount,rebate_amount_actual,rebate_status,create_time
      )
      SELECT rebate_year,rebate_month,t_start_time,t_end_time,topagent_id,topagentusername,agent_id,agentusername,
            --有效玩家的有效投注额
            COALESCE(n_valid_value,0),
            --有效玩家数
            COALESCE((SELECT count(1) FROM (SELECT player_id,sum(effective_transaction) effAmount FROM operate_player WHERE static_date>=t_start_date AND static_date < t_end_date AND agent_id = rec_agent.id GROUP BY player_id) a WHERE a.effAmount>=n_valid_value),0) effective_player_num,
            --累积派彩
            COALESCE((CASE WHEN b_need_history_count THEN
              (SELECT (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) FROM agent_rebate WHERE agent_id = rec_agent.id AND rebate_year = v_last_year AND rebate_month = v_last_month)
              ELSE 0 END),0) payout_amount_history,
            --当期派彩、
            COALESCE((SELECT -sum(COALESCE(profit_loss,0)) FROM operate_agent oa WHERE oa.agent_id = rec_agent.id AND oa.static_date>=t_start_date AND oa.static_date<t_end_date),0) payout_amount,
            --累积有效投注额、
            COALESCE((CASE WHEN b_need_history_count THEN (
                (SELECT (COALESCE(effective_amount_history,0)+COALESCE(effective_amount,0)) FROM agent_rebate WHERE agent_id = rec_agent.id AND rebate_year = v_last_year AND rebate_month = v_last_month)
              ) ELSE 0 END),0) effective_amount_history,
            --当期有效投注额、
            COALESCE((SELECT sum(COALESCE(effective_transaction,0)) FROM operate_agent oa WHERE oa.agent_id = rec_agent.id AND oa.static_date>=t_start_date AND oa.static_date<t_end_date),0) effective_amount,
            --累积行政费用(上一期的累积费用+上一期当期费用)
            COALESCE((CASE WHEN b_need_history_count THEN
                (SELECT (COALESCE(fee_amount_history,0)+COALESCE(fee_amount,0)) history_fee FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id)
              ELSE 0 END),0) fee_amount_history,
            --累积存款优惠
            COALESCE((CASE WHEN b_need_history_count THEN
                (SELECT (COALESCE(favorable_amount_history,0)+COALESCE(favorable_amount,0)) history_favorable FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id)
              ELSE 0 END),0) favorable_amount_history,
            --累积返水优惠
            COALESCE((CASE WHEN b_need_history_count THEN
                (SELECT (COALESCE(rakeback_amount_history,0)+COALESCE(rakeback_amount,0)) history_rakeback FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id)
              ELSE 0 END),0) rakeback_amount_history,
            --累积其他费用
            COALESCE((CASE WHEN b_need_history_count THEN
                (SELECT (COALESCE(other_amount_history,0)+COALESCE(other_amount,0)) FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id)
              ELSE 0 END),0) other_amount_history,
            (sum(COALESCE(deposit_amount,0)*(COALESCE(arp.deposit_radio,0)/100))+sum(COALESCE(withdraw_amount,0)*(COALESCE(arp.withdraw_radio,0)/100))) fee_amount,
            sum(COALESCE(favorable_amount,0)) favorable_amount,
            sum(COALESCE(rakeback_amount,0)) rakeback_amount,
            sum(COALESCE(recommend_amount,0)) other_amount,
            0 rebate_amount,     --返佣金额
            0 rebate_amount_actual,     --已返佣金额
            '0' rebate_status,    --返佣状态
            now()  --创建时间
       FROM agent_rebate_player arp
      WHERE rebate_year = v_year
        AND rebate_month = v_month
        AND agent_id = rec_agent.id
      GROUP BY topagent_id,topagentusername,agent_id,agentusername,rebate_year,rebate_month;

    --4、计算代理各api的总派彩(即生成agent_rebate_grads)
    --当期派彩，从player_game_order直接统计
    --累积派彩，需要看下上一期的返佣账单的状态是否需要累积，需要累积的话，等于上一期的累积派彩+上一期的当期派彩
    /*
		--v1.10  2017/03/30  Leisure
    INSERT INTO agent_rebate_grads(
      rebate_year,rebate_month,topagent_id,topagentusername,agent_id,agentusername,api_id,api_type_id,payout_amount_history,payout_amount,radio
    )
    SELECT v_year,v_month,topagent_id,topagent_name,agent_id,agent_name,api_id,api_type_id,
           COALESCE(
            (CASE
             WHEN b_need_history_count THEN
             (SELECT (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) FROM agent_rebate_grads arg WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=oa.agent_id AND arg.api_id=oa.api_id AND arg.api_type_id = oa.api_type_id
             )
             ELSE 0 END),0) payout_amount_history ,
      SUM(-COALESCE(profit_loss,0)) payout_amount,
      COALESCE((SELECT ratio FROM rebate_grads_api WHERE rebate_grads_id = n_agent_grads_id AND api_id=oa.api_id AND api_type_id=oa.api_type_id),0) radio
      FROM operate_player oa WHERE static_date>=t_start_date AND static_date < t_end_date AND agent_id=rec_agent.id GROUP BY topagent_id,topagent_name,agent_id,agent_name,api_id,api_type_id;
    */
    INSERT INTO agent_rebate_grads (
      rebate_year, rebate_month, agent_id, agentusername, topagent_id, topagentusername, api_id, api_type_id, payout_amount_history, payout_amount, radio
    )
    SELECT v_year, v_month,
           arg.agent_id, ua.username agent_name, ut.id topagent_id, ut.username topagent_name,
           arg.api_id, arg.api_type_id, arg.payout_amount_history, arg.payout_amount, rga.ratio
      FROM
      (
      SELECT COALESCE(op.agent_id, argi.agent_id) agent_id,
             COALESCE(op.api_id, argi.api_id) api_id,
             COALESCE(op.api_type_id, argi.api_type_id) api_type_id,
             CASE WHEN b_need_history_count THEN COALESCE(payout_amount_history, 0) ELSE 0 END payout_amount_history,
             COALESCE(payout_amount, 0) payout_amount
        FROM
        (
        SELECT agent_id, api_id, api_type_id ,
                SUM(-COALESCE(profit_loss,0)) payout_amount
          FROM operate_player
         WHERE static_date >= t_start_date AND static_date < t_end_date AND agent_id= rec_agent.id
         GROUP BY agent_id, api_id, api_type_id
        ) op
          FULL JOIN
        (
        SELECT agent_id, api_id, api_type_id,
               (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) payout_amount_history
          FROM agent_rebate_grads
         WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id = rec_agent.id
        ) argi
        ON argi.agent_id=op.agent_id AND argi.api_id=op.api_id AND argi.api_type_id = op.api_type_id
        ) arg
        LEFT JOIN rebate_grads_api rga ON rebate_grads_id = n_agent_grads_id AND arg.api_id=rga.api_id AND arg.api_type_id = rga.api_type_id
        LEFT JOIN sys_user ua ON arg.agent_id = ua."id" AND ua.user_type = '23'
        LEFT JOIN sys_user ut ON ua.owner_id = ut."id" AND ut.user_type = '22'
    ;

      v_temp_sql='SELECT * FROM agent_rebate WHERE rebate_year ='|| v_year ||' AND rebate_month ='|| v_month ||' AND agent_id ='|| rec_agent.id;
      --raise notice 'v_temp_sql： %',v_temp_sql;
      open cur_agent_rebate FOR execute v_temp_sql;
      FETCH cur_agent_rebate INTO rec_api_rebate;
      IF rec_api_rebate is null THEN
        close cur_agent_rebate;
        CONTINUE;
      END IF;

      --初始数据
        n_fee_amount = 0;
        n_remainn_fee_amount = 0;
        n_remain_payout = 0;
        n_fee_total = 0;
        idx = 0;

        n_fee_amount = COALESCE(rec_api_rebate.fee_amount,0)+COALESCE(rec_api_rebate.fee_amount_history,0)+COALESCE(rec_api_rebate.favorable_amount,0)+COALESCE(rec_api_rebate.rakeback_amount,0)+COALESCE(rec_api_rebate.other_amount,0)+COALESCE(rec_api_rebate.favorable_amount_history,0)+COALESCE(rec_api_rebate.rakeback_amount_history,0)+COALESCE(rec_api_rebate.other_amount_history,0);
        --raise notice '代理的承担费用n_fee_amount为 %', n_fee_amount;

        FOR v_api_json IN
            SELECT json_array_elements(p_api_type_order_json::json)
        LOOP
            SELECT v_api_json::json->>'api_id' INTO n_api_id;
            SELECT v_api_json::json->>'api_type_id' INTO n_api_type_id;
            SELECT v_api_json::json->>'rebate_order_num' INTO n_rebate_order_num;
            --raise notice 'n_api_id % n_api_type_id %', n_api_id,n_api_type_id;
            FOR rec_api_grads IN
                SELECT * FROM agent_rebate_grads WHERE rebate_year = v_year AND rebate_month = v_month AND radio is not null AND radio>0 AND agent_id = rec_api_rebate.agent_id
            LOOP
                IF n_api_id = rec_api_grads.api_id AND n_api_type_id = rec_api_grads.api_type_id THEN
                    IF idx > 0 THEN
                      n_fee_amount =n_remainn_fee_amount;--承担费用
                    ELSEIF idx = 0 THEN
                      n_remainn_fee_amount = n_fee_amount;
                    END IF;
                    n_payout_total = rec_api_grads.payout_amount_history + rec_api_grads.payout_amount;--当前api总派彩
                    --如果总派彩大于０，即需要扣掉代理承担费用，反之剩余派彩等于总派彩
                    IF n_payout_total >= 0 THEN
                      n_remainn_fee_amount = n_payout_total - n_fee_amount;
                      --如果剩余费用小于０，则剩余派彩为０,剩余承担费用也是０，反之等于总派彩－当前承担费用
                      IF n_remainn_fee_amount < 0 THEN
                        n_remain_payout = 0;
                        n_remainn_fee_amount=-n_remainn_fee_amount;
                      ELSE
                        n_remain_payout = n_remainn_fee_amount;
                        n_remainn_fee_amount = 0;
                      END IF;
                    ELSE
                      n_remain_payout = n_payout_total;
                    END IF;
                    n_fee_total = n_fee_total + n_remain_payout * rec_api_grads.radio/100;
                    update agent_rebate_grads set expense_amount = n_fee_amount,rebate_order_num = n_rebate_order_num,remain_expense_amount=n_remainn_fee_amount,remain_payout_amount=n_remain_payout  WHERE id = rec_api_grads.id;
                    idx = idx + 1;
                END IF;
            END LOOP;    --循环API
        END LOOP;--循环排序的API
        --raise notice '总费用为 % ，剩余承担费用为 %， 所以代理 % 的最终返佣费用为 %', n_fee_total,n_remainn_fee_amount,rec_api_rebate.agentusername,n_fee_total - n_remainn_fee_amount;
        IF n_remainn_fee_amount>0 THEN
          n_fee_total = n_fee_total - n_remainn_fee_amount;
        END IF;
        IF n_rebate_max is not null AND n_fee_total >= n_rebate_max THEN
            n_fee_total = n_rebate_max;
        END IF;
        IF n_fee_total = 0 THEN
          UPDATE agent_rebate set rebate_amount = n_fee_total,rebate_status='1' WHERE id = rec_api_rebate.id;
        ELSE
          UPDATE agent_rebate set rebate_amount = n_fee_total WHERE id = rec_api_rebate.id;
        END IF;
      --关闭游标
      CLOSE cur_agent_rebate;

    END LOOP;

  return '成功';
END;

$BODY$ LANGUAGE 'plpgsql';
COMMENT ON FUNCTION f_agent_rebate(p_stat_month text, p_start_time text, p_end_time text, p_api_type_order_json text, p_com_url text)
IS 'younger-返佣结算账单-入口';

/**
 * 根据返佣周期统计各个API返佣数据.
 * @author 	Leisure
 * @date 	  2016.10.10
 * @param 	p_period 		  返佣周期名称.
 * @param 	p_start_time  返佣周期开始时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	p_end_time 	  返佣周期结束时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	p_comp_url 		运营商库的dblink 格式数据(host=192.168.0.88 dbname=gamebox-companies user=gamebox-companies password=postgres)
 * @param 	p_settle_flag 出账标志:Y-已出账, N-未出账
**/
drop function if exists gb_rebate_bill(text, text, text, text, text);
create or replace function gb_rebate_bill(
	p_period 	text,
	p_start_time 	text,
	p_end_time 	text,
	p_comp_url 	text,
	p_settle_flag 	text
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/10/08  Leisure   创建此函数: 返佣结算账单-入口
*/
DECLARE

	t_start_time 	TIMESTAMP;
	t_end_time 	TIMESTAMP;

	n_rebate_bill_id INT:=-1; --返佣主表键值.
	n_bill_count 	INT :=0;

	n_sid 			INT;--站点ID.
	b_is_max 		BOOLEAN := true;
	h_net_schema_map 	hstore[];-- 包网方案map

	redo_status BOOLEAN:=false; --重跑标志，默认不允许重跑

BEGIN
	t_start_time = p_start_time::TIMESTAMP;
	t_end_time = p_end_time::TIMESTAMP;

	IF p_settle_flag = 'Y' THEN
		SELECT COUNT("id")
		 INTO n_bill_count
			FROM rebate_bill rb
		 WHERE rb.period = p_period
			 AND rb."start_time" = t_start_time
			 AND rb."end_time" = t_end_time
			 AND rb.lssuing_state <> 'pending_pay';

		IF n_bill_count = 0 THEN
			--DELETE FROM rebate_api ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			--DELETE FROM rebate_player rp WHERE rp.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rebate_agent_api ra WHERE settle_flag = 'Y' AND ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rebate_agent ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rebate_bill rb WHERE "id" IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
		ELSE
			raise info '已生成本期返佣账单，无需重新生成。';
			RETURN;
		END IF;
	END IF;

	raise info '开始统计第( % )期的返佣,周期( % - % )', p_period, p_start_time, p_end_time;

	--先插入返佣总记录并取得键值.
	raise info '返佣rebate_bill新增记录';
	SELECT gamebox_rebate_bill(p_period, t_start_time, t_end_time, n_rebate_bill_id, 'I', p_settle_flag) INTO n_rebate_bill_id;

	SELECT gamebox_current_site() INTO n_sid;

	raise info '取得包网方案';
	SELECT * FROM dblink(p_comp_url, 'SELECT gamebox_contract('||n_sid||', '||b_is_max||')') as a(hash hstore[]) INTO h_net_schema_map;

	raise info '统计代理API返佣信息';
	perform gb_rebate_agent_api(n_rebate_bill_id, p_settle_flag, t_start_time, t_end_time, h_net_schema_map);

	raise info '统计代理返佣';
	perform gb_rebate_agent(n_rebate_bill_id, p_settle_flag, t_start_time, t_end_time);

	raise info '更新返佣总表';
	perform gamebox_rebate_bill(p_period, t_start_time, t_end_time, n_rebate_bill_id, 'U', p_settle_flag);

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_bill(p_period text, p_start_time text, p_end_time text, p_comp_url text, p_settle_flag text)
IS 'Leisure-返佣结算账单-入口';

/**
 * 根据返佣周期统计各个API返佣数据.
 * @author 	Leisure
 * @date 	  2016.10.10
 * @param 	p_bill_id 		返佣结算账单主表ID.
 * @param 	p_settle_flag 出账标志:Y-已出账, N-未出账
 * @param 	p_start_time  返佣周期开始时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	p_end_time 	  返佣周期结束时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	p_net_maps 		包网方案map
**/
DROP FUNCTION IF EXISTS gb_rebate_agent_api(INT, TEXT, TIMESTAMP, TIMESTAMP, hstore[]);
CREATE OR REPLACE FUNCTION gb_rebate_agent_api(
	p_bill_id 	INT,
	p_settle_flag 	TEXT,
	p_start_time 	TIMESTAMP,
	p_end_time 	TIMESTAMP,
	p_net_maps 	hstore[]
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单.代理API返佣
--v1.01  2016/10/15  Leisure  对于不返佣的情况，依然计算其交易额和盈亏
--v1.02  2016/10/17  Leisure  改用变量代替record，并增加初始化操作
--v1.03  2016/10/25  Leisure  修正梯度判断，由“>”改为“>=”
--v1.04  2017/01/15  Leisure  修正一处bug，原来代理名称可能显示错误
--v1.05  2017/01/30  Leisure  修改返佣逻辑，数据来源改为经营报表
*/
DECLARE

	h_occupy_map 	hstore;		-- API占成梯度map
	--h_assume_map 	hstore;		-- 盈亏共担map

	--h_sys_config 	hstore;
	--sp 			TEXT:='@';
	--rs 			TEXT:='\~';
	--cs 			TEXT:='\^';
	b_meet_or_not 	BOOLEAN; --是否达到返佣条件

	n_rebate_set_id 	INT;
	v_rebate_set_name 	TEXT:='';
	n_valid_value 		FLOAT:=0.00;

	v_key_name 				TEXT:='';
	COL_SPLIT 			TEXT:='_';

	--cur_agt 	refcursor;
	--cur_api 	refcursor;
	rec_agt 	record;
	rec_api 	record;
	--rec_grad 	record;
	n_grad_id 	INT;
	--rec_grad_api 	record;
	n_grad_api_id 	INT;
	n_rebate_ratio 	FLOAT := 0.00;

	n_agent_id 	INT;
	v_agent_name 	TEXT;
	--n_topagent_id  INT;
	n_api_id 		INT;
	v_game_type 	TEXT;

	n_profit_amount 			FLOAT:=0.00;--盈亏总和
	n_effective_transaction 	FLOAT:=0.00;--有效交易量

	n_row_count 	INT :=0;
	n_effective_player_num INT :=0;

	n_operation_occupy_retio FLOAT:=0.00;--运营商占成比例
	n_operation_occupy_value 	FLOAT:=0.00;--运营商API占成金额
	n_rebate_value 	FLOAT:=0.00;--代理API返佣金额

BEGIN
	--取得系统变量
	--SELECT sys_config() INTO h_sys_config;
	--sp = h_sys_config->'sp_split';
	--rs = h_sys_config->'row_split';
	--cs = h_sys_config->'col_split';

	--取得运营商占成、盈亏共担map
	h_occupy_map = p_net_maps[2];
	--h_assume_map = p_net_maps[3];

	--代理循环
	/* --v1.05  2017/01/30
	FOR rec_agt IN
		SELECT ua."id"									as agent_id,
		       ua.username							as agent_name,
		       --ut."id"									as topagent_id,
		       --ut.username							as topagent_name,
		       COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
		       COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount
		    FROM player_game_order pgo
		    LEFT JOIN sys_user su ON pgo.player_id = su."id"
		    LEFT JOIN sys_user ua ON su.owner_id = ua.id
		    --LEFT JOIN sys_user ut ON ua.owner_id = ut.id
		 WHERE pgo.order_state = 'settle'
		   AND pgo.is_profit_loss = TRUE
		   AND pgo.payout_time >= p_start_time
		   AND pgo.payout_time < p_end_time
		   AND su.user_type = '24'
		   AND ua.user_type = '23'
		   --AND ut.user_type = '22'
		 GROUP BY ua."id", ua.username
		 ORDER BY ua."id"
	LOOP
	*/
	/*
	SELECT gb_rebate_agent_cursor(p_settle_flag, p_start_time, p_end_time) INTO cur_agt;
	FETCH cur_agt INTO rec_agt;
	WHILE FOUND
	LOOP
	*/
	FOR rec_agt IN
		SELECT agent_id, agent_name, SUM(effective_transaction) effective_transaction, -SUM(profit_loss) profit_amount
		  FROM operate_agent
		 WHERE static_time >= p_start_time
		   AND static_time_end <= p_end_time
		 GROUP BY agent_id, agent_name
		 ORDER BY agent_id, agent_name
	LOOP
		--重新初始化变量
		b_meet_or_not = TRUE;
		n_agent_id = rec_agt.agent_id;
		v_agent_name = rec_agt.agent_name; --v_agent_name; --v1.04  2017/01/15  Leisure
		--n_topagent_id = rec_agt.topagent_id;
		n_effective_transaction = rec_agt.effective_transaction;
		n_profit_amount = rec_agt.profit_amount;

		/*
		IF n_profit_amount <= 0 THEN
			RAISE INFO '代理ID: %, 名称: % ，盈利为负，不返佣！', n_agent_id, v_agent_name;
			--v1.01  2016/10/15  Leisure
			--CONTINUE;
		END IF;
		*/

		--取得代理返佣方案
		SELECT ua.rebate_id, rs.name, rs.valid_value
		  INTO n_rebate_set_id, v_rebate_set_name, n_valid_value
		  FROM user_agent_rebate ua, rebate_set rs
		 WHERE ua.user_id = n_agent_id
		   AND rs.status = '1'
		   AND rs.id = ua.rebate_id;

		GET DIAGNOSTICS n_row_count = ROW_COUNT;
		IF n_row_count = 0 THEN
			RAISE INFO '代理ID: %, 名称: %，未设置返佣方案！', n_agent_id, v_agent_name;
			--v1.01  2016/10/15  Leisure
			--CONTINUE;
			b_meet_or_not = FALSE;
		ELSE
			--计算梯度有效玩家数
			--v1.05  2017/01/30
			--SELECT gamebox_valid_player_num(p_start_time, p_end_time, n_agent_id, n_valid_value) INTO n_effective_player_num;
			SELECT gb_valid_player_num(p_start_time, p_end_time, n_agent_id, n_valid_value) INTO n_effective_player_num;

			IF n_effective_transaction < n_valid_value THEN
				RAISE INFO '代理ID: % 名称: %, 有效交易量: % ；返佣方案ID: %, 名称: %, 有效交易量: % ，未达到有效交易量！',
				           n_agent_id, v_agent_name, n_effective_transaction,
				           n_rebate_set_id, v_rebate_set_name, n_valid_value;
				--v1.01  2016/10/15  Leisure
				--CONTINUE;
				b_meet_or_not = FALSE;
			ELSE
				--取得返佣梯度
				SELECT rg.id AS grads_id   --返佣梯度ID
				       --rg.total_profit,     --有效盈利总额
				       --rg.max_rebate,       --返佣上限
				       --rg.valid_player_num  --有效玩家数
				  FROM rebate_grads 	rg
				 WHERE rg.rebate_id = n_rebate_set_id
				   --v10.3  2016/10/25  Leisure
				   AND n_profit_amount >= rg.total_profit --实际盈亏 >= 梯度盈亏
				   AND n_effective_player_num >= rg.valid_player_num --有效玩家数 >= 梯度玩家数
				 ORDER BY rg.total_profit DESC, rg.valid_player_num DESC
				 LIMIT 1
				  --INTO rec_grad;
				  INTO n_grad_id;

				GET DIAGNOSTICS n_row_count = ROW_COUNT;
				IF n_row_count = 0 THEN
					RAISE INFO '代理ID: %, 名称: %, 返佣方案ID: %, 名称: %, 未达到返佣梯度！',
					           n_agent_id, v_agent_name, n_rebate_set_id, v_rebate_set_name;
					--v1.01  2016/10/15  Leisure
					--CONTINUE;
					b_meet_or_not = FALSE;
				END IF; --返佣梯度
			END IF; --有效交易量
		END IF; --返佣方案

		--代理api循环
		/* --v1.05  2017/01/30
		FOR rec_api IN
			SELECT pgo.api_id,
			       pgo.game_type,
			       COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
			       COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount
			    FROM player_game_order pgo
			    LEFT JOIN sys_user su ON pgo.player_id = su."id"
			    LEFT JOIN sys_user ua ON su.owner_id = ua.id
			 WHERE pgo.order_state = 'settle'
			   AND pgo.is_profit_loss = TRUE
			   AND pgo.payout_time >= p_start_time
			   AND pgo.payout_time < p_end_time
			   AND su.user_type = '24'
			   AND ua.user_type = '23'
			   AND ua."id" = n_agent_id
			 GROUP BY pgo.api_id, pgo.game_type
			 ORDER BY pgo.api_id, pgo.game_type
		LOOP
		*/
		/*
		SELECT gb_rebate_api_cursor(p_settle_flag, n_agent_id, p_start_time, p_end_time) INTO cur_api;
		FETCH cur_api INTO rec_api;
		WHILE FOUND
		LOOP
		*/
		FOR rec_api IN
			SELECT api_id, game_type, SUM(effective_transaction) effective_transaction, -SUM(profit_loss) profit_amount
			  FROM operate_agent
			 WHERE static_time >= p_start_time
			   AND static_time_end <= p_end_time
			   AND agent_id = n_agent_id
			 GROUP BY api_id, game_type
			 ORDER BY api_id, game_type
		LOOP

			--重新初始化变量
			n_api_id 			= rec_api.api_id;
			v_game_type 		= rec_api.game_type;
			n_effective_transaction 	= rec_api.effective_transaction;
			n_profit_amount 	= rec_api.profit_amount;

			n_grad_api_id = NULL;
			n_rebate_ratio = 0.00;

			n_operation_occupy_retio = 0.00;
			n_operation_occupy_value = 0.00;
			n_rebate_value = 0.00;

			IF b_meet_or_not THEN
				--取得返佣比率
				SELECT rga.id AS grads_api_id, --返佣梯度API比率ID
				       rga.ratio --API返佣比例
				  FROM rebate_grads_api rga
				 WHERE rga.rebate_grads_id = n_grad_id --rec_grad.grads_id
				   AND rga.api_id = n_api_id
				   AND rga.game_type = v_game_type
				 LIMIT 1
				  --INTO rec_grad_api;
				  INTO n_grad_api_id, n_rebate_ratio;
			END IF;

			IF n_profit_amount <= 0 THEN
				RAISE INFO '代理ID: %, 名称: %, API_ID: %, GAME_TYPE: %, 盈利为负，不返佣！', n_agent_id, v_agent_name, n_api_id, v_game_type;
				--v1.01  2016/10/15  Leisure
				--CONTINUE;
			ELSE
				--计算运营商占成
				v_key_name = n_api_id||COL_SPLIT||v_game_type;
				IF isexists(h_occupy_map, v_key_name) THEN
					n_operation_occupy_retio = (h_occupy_map->v_key_name)::float;
					n_operation_occupy_value = n_profit_amount * n_operation_occupy_retio/100;
				ELSE
					n_operation_occupy_value = 0.00;
				END IF; --是否存在占成比

				IF b_meet_or_not THEN
					--计算佣金
					n_rebate_value := n_profit_amount * (1 - n_operation_occupy_retio/100) * n_rebate_ratio/100;
				END IF;
			END IF; --盈利是否为正

			--返佣不能超过返佣上限
			--IF n_rebate_value > rec_grad.max_rebate THEN
			--	n_rebate_value = rec_grad.max_rebate;
			--END IF;

			--写入代理API佣金表
			INSERT INTO rebate_agent_api(
			    settle_flag, rebate_bill_id, agent_id, agent_name, api_id, game_type, effective_transaction, effective_player_num, profit_loss,
			    operation_retio, operation_occupy, rebate_set_id, rebate_grads_id, rebate_grads_api_id, rebate_retio, rebate_value)
			VALUES (
			    p_settle_flag, p_bill_id, n_agent_id, v_agent_name, n_api_id, v_game_type, n_effective_transaction, n_effective_player_num, n_profit_amount,
			    n_operation_occupy_retio, n_operation_occupy_value, n_rebate_set_id, n_grad_id, n_grad_api_id, n_rebate_ratio, n_rebate_value
			);

		END LOOP;
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent_api(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_net_maps hstore[])
IS 'Leisure-返佣结算账单.代理API返佣';

/**
 * 根据代理API返佣表，汇总代理返佣信息.
 * @author 	Leisure
 * @date 	  2016.10.10
 * @param 	p_bill_id 		返佣结算账单主表ID.
 * @param 	p_settle_flag 出账标志:Y-已出账, N-未出账
 * @param 	p_start_time  返佣周期开始时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	p_end_time 	  返佣周期结束时间(yyyy-mm-dd hh24:mi:ss)
**/
drop function if exists gb_rebate_agent(INT, TEXT, TIMESTAMP, TIMESTAMP);
create or replace function gb_rebate_agent(
  p_bill_id   INT,
  p_settle_flag   TEXT,
  p_start_time    TIMESTAMP,
  p_end_time    TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单-代理返佣
--v1.00  2016/10/15  Leisure  更新分摊费用计算
--v1.01  2016/11/01  Leisure  美化SQL
--v1.02  2017/02/11  Leisure  增加原始佣金（占成佣金）写入
--v1.03  2017/02/12  Leisure  调整上期未结计算SQL，旧的SQL对于历史期返佣这种非常规操作，有隐患；
                              并且如果计算完结算账单，再计算未结账单，可能存在同样问题
*/
DECLARE
  rec   record;
  c_agent_name   TEXT := '';
  c_pending_state   TEXT := 'pending_lssuing';
  n_rebate_original     FLOAT := 0.00;  -- 代理返佣（原始佣金）
  n_max_rebate  FLOAT := 0.00;  -- 返佣上限
  n_rebate_final  FLOAT := 0.00;  -- 最终佣金（佣金+上期未结-分摊费用）
  --n_player_num  INT := 0;   --有效玩家数
  n_next_lssuing   FLOAT := 0.00; --未结算佣金（往期未结）

  h_sys_apportion hstore;  --分摊比例配置信息

  n_agent_retio float := 0.00; --代理分摊比率
  n_favorable_apportion   float:=0.00;-- 优惠分摊费用
  n_recommend_apportion   float:=0.00;-- 推荐分摊费用
  n_backwater_apportion   float:=0.00;-- 返水分摊费用
  n_refund_fee_apportion   float:=0.00;-- 返手续费分摊费用
  n_apportion float:=0.00; --代理分摊总费用

BEGIN

  SELECT gamebox_sys_param('apportionSetting') INTO h_sys_apportion;

  FOR rec IN

    WITH raa AS (
      SELECT agent_id,
             MIN(rebate_grads_id) rebate_grads_id,
             SUM(effective_transaction) effective_transaction,
             MIN(effective_player_num) effective_player_num,
             SUM(profit_loss) profit_loss,
             SUM(rebate_value) rebate
        FROM rebate_agent_api
       WHERE rebate_bill_id = p_bill_id
         AND settle_flag = p_settle_flag
       GROUP BY agent_id
    ),

    pt AS (
      SELECT *
        FROM player_transaction
       WHERE status = 'success'
         AND completion_time >= p_start_time
         AND completion_time < p_end_time
    ),

    pti AS (
            --存款
             SELECT player_id,
                    'deposit' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE transaction_type = 'deposit'
                --AND (fund_type <> 'artificial_deposit' OR transaction_way = 'manual_deposit')

             UNION ALL
             --取款
             SELECT player_id,
                    'withdrawal' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE transaction_type = 'withdrawals'
                --AND (fund_type <> 'artificial_withdraw' OR transaction_way = 'manual_deposit')

             UNION ALL
             --优惠
             SELECT player_id,
                    'favorable' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE (transaction_type = 'favorable'
                     AND fund_type <> 'refund_fee'
                     AND transaction_way <> 'manual_rakeback')

             UNION ALL
             --推荐
             SELECT player_id,
                    'recommend' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE transaction_type = 'recommend'

             UNION ALL
             --返水
             SELECT player_id,
                    'backwater' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE (transaction_type = 'backwater' OR
                     (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))

             UNION ALL
             --返手续费
             SELECT player_id,
                    'refund_fee' transaction_type,
                    transaction_money
               FROM pt
              WHERE fund_type = 'refund_fee'
            ),

    pto AS (
      SELECT ua."id" AS agent_id,
             transaction_type,
             transaction_money
        FROM pti
             LEFT JOIN
             sys_user su ON pti.player_id = su."id" AND su.user_type = '24'
             LEFT JOIN
             sys_user ua ON su.owner_id = ua."id" AND ua.user_type = '23'
    ),

    ptt AS (
      SELECT agent_id,
             SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit,
             SUM(CASE transaction_type WHEN 'withdrawal' THEN transaction_money ELSE 0 END) AS withdrawal,
             SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money ELSE 0 END) AS favorable,
             SUM(CASE transaction_type WHEN 'recommend' THEN transaction_money ELSE 0 END) AS recommend,
             SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS backwater,
             SUM(CASE transaction_type WHEN 'refund_fee' THEN transaction_money ELSE 0 END) AS refund_fee
        FROM pto
       GROUP BY agent_id
    )

    SELECT COALESCE(raa.agent_id, ptt.agent_id) agent_id,
           raa.rebate_grads_id,
           COALESCE(effective_transaction, 0.00) effective_transaction,
           COALESCE(effective_player_num, 0) effective_player_num,
           COALESCE(profit_loss, 0) profit_loss,
           COALESCE(rebate, 0.00) rebate,
           COALESCE(deposit, 0.00) deposit,
           COALESCE(withdrawal, 0.00) withdrawal,
           COALESCE(favorable, 0.00) favorable,
           COALESCE(recommend, 0.00) recommend,
           COALESCE(backwater, 0.00) backwater,
           COALESCE(refund_fee, 0.00) refund_fee
      FROM raa FULL JOIN ptt ON raa.agent_id = ptt.agent_id
     ORDER BY agent_id
  LOOP

    --在循环内部，需要初始化变量
    n_rebate_original = rec.rebate;
    n_max_rebate = 0.00;
    n_next_lssuing = 0.00;

    n_favorable_apportion = 0.00;-- 优惠分摊费用
    n_recommend_apportion = 0.00;-- 推荐分摊费用
    n_backwater_apportion = 0.00;-- 返水分摊费用
    n_refund_fee_apportion = 0.00;-- 返手续费分摊费用

    --获取代理名称
    SELECT username INTO c_agent_name FROM sys_user su WHERE su.user_type = '23' AND su.id = rec.agent_id;

    --获取分摊费用
    --优惠、推荐
    IF isexists(h_sys_apportion, 'agent.preferential.percent') THEN
      n_agent_retio = (h_sys_apportion->'agent.preferential.percent')::float;  --代理分摊比例
      n_favorable_apportion = rec.favorable * n_agent_retio/100;
      n_recommend_apportion = rec.recommend * n_agent_retio/100;
    END IF;
    --返水
    IF isexists(h_sys_apportion, 'agent.rakeback.percent') THEN
      n_agent_retio = (h_sys_apportion->'agent.rakeback.percent')::float;  --代理分摊比例
      n_backwater_apportion = rec.backwater * n_agent_retio/100;
    END IF;
    --返手续费
    IF isexists(h_sys_apportion, 'agent.poundage.percent') THEN
      n_agent_retio = (h_sys_apportion->'agent.poundage.percent')::float;  --代理分摊比例
      n_refund_fee_apportion = rec.refund_fee * n_agent_retio/100;
    END IF;

    n_apportion = n_favorable_apportion + n_recommend_apportion + n_backwater_apportion + n_refund_fee_apportion;

    --如果代理本期完成返佣梯度
    IF n_rebate_original > 0 THEN

      --获得返佣上限
      SELECT max_rebate
        FROM rebate_grads
       WHERE id = rec.rebate_grads_id
        INTO n_max_rebate;

      IF n_max_rebate > 0 AND n_rebate_original > n_max_rebate THEN
        n_rebate_original = n_max_rebate;
      END IF;

      c_pending_state :='pending_lssuing';

      --如果本期满足返佣梯度，需要结算往期费用
      --v1.03  2017/02/12  Leisure
      /*
      SELECT COALESCE(SUM(rebate_actual), 0.00)
        INTO n_next_lssuing
        FROM rebate_agent rao
       WHERE rao.settlement_state = 'next_lssuing'
         AND rao.agent_id = rec.agent_id
         --AND rao.rebate_bill_id <= bill_id
         AND rao.rebate_bill_id >
           (SELECT COALESCE(MAX(rebate_bill_id), 0)
              FROM rebate_agent rai
             WHERE rai.settlement_state <> 'next_lssuing'
               AND rai.agent_id = rec.agent_id
               --AND rai.rebate_bill_id < bill_id
           );
      */

      SELECT COALESCE(SUM(rao.rebate_actual), 0.00)
        INTO n_next_lssuing
        FROM rebate_agent rao, rebate_bill rbo
       WHERE rao.rebate_bill_id = rbo.id
         AND rao.settlement_state = 'next_lssuing'
         AND rao.agent_id = rec.agent_id
         AND rbo.end_time <= p_start_time
         AND rbo.start_time >=
           (SELECT COALESCE(MAX(end_time), '1879-03-14')
              FROM rebate_agent rai, rebate_bill rbi
             WHERE rai.rebate_bill_id = rbi.id
               AND rai.settlement_state <> 'next_lssuing'
               AND rbi.end_time <= p_start_time
               AND rai.agent_id = rec.agent_id
           );

    ELSE
      c_pending_state := 'next_lssuing';
    END IF;

    n_rebate_final := n_rebate_original + n_next_lssuing - n_apportion;
    --RAISE INFO 'n_rebate_final: % n_rebate_original: % n_next_lssuing: % n_apportion: %', n_rebate_final, n_rebate_original, n_next_lssuing, n_apportion;

    IF p_settle_flag = 'Y' THEN

      INSERT INTO rebate_agent(
        rebate_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
        rakeback, rebate_total, rebate_actual, refund_fee, recommend, preferential_value, settlement_state,
        apportion, deposit_amount, withdrawal_amount, history_apportion, rebate_original
      ) VALUES (
        p_bill_id, rec.agent_id, c_agent_name, rec.effective_player_num, rec.effective_transaction, rec.profit_loss,
        rec.backwater, n_rebate_final, n_rebate_final, rec.refund_fee, rec.recommend, rec.favorable, c_pending_state,
        --rec.backwater + rec.refund_fee + rec.recommend + rec.favorable,
        n_apportion,
        rec.deposit, rec.withdrawal, n_next_lssuing, n_rebate_original --v1.02  2017/02/11  Leisure
      );
    ELSEIF p_settle_flag='N' THEN

      INSERT INTO rebate_agent_nosettled (
        rebate_bill_nosettled_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
        rakeback, rebate_total, refund_fee, recommend, preferential_value,
        apportion, deposit_amount, withdrawal_amount, history_apportion, rebate_original
      ) VALUES (
        p_bill_id, rec.agent_id, c_agent_name, rec.effective_player_num, rec.effective_transaction, rec.profit_loss,
        rec.backwater, n_rebate_final, rec.refund_fee, rec.recommend, rec.favorable,
        --rec.backwater + rec.refund_fee + rec.recommend + rec.favorable,
        n_apportion,
        rec.deposit, rec.withdrawal, n_next_lssuing, n_rebate_original --v1.02  2017/02/11  Leisure
      );

    END IF;

  END LOOP;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-返佣结算账单-代理返佣';

/**
 * 计算代理有效玩家.
 * @author 	Leisure
 * @date 	  2017.01.30
 * @param 	p_start_time    返佣周期开始时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	p_end_time 	    返佣周期结束时间(yyyy-mm-dd hh24:mi:ss)
 * @param 	p_agent_id      代理ID
 * @param 	p_valid_value 	有效交易量阈值
**/
drop function if exists gb_valid_player_num(TIMESTAMP, TIMESTAMP, INT, FLOAT);
create or replace function gb_valid_player_num(
	p_start_time 	TIMESTAMP,
	p_end_time 	TIMESTAMP,
	p_agent_id 	INT,
	p_valid_value 	FLOAT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/30  Leisure  创建此函数: 计算有效玩家数
*/
DECLARE
	player_num 	INT:=0;

BEGIN
	/*
	SELECT COUNT(1)
	  FROM (SELECT player_id, SUM(effective_trade_amount) effeTa
	         FROM player_game_order pgo LEFT JOIN sys_user su ON player_id = su."id"
	        WHERE order_state = 'settle'
	          AND is_profit_loss = TRUE
	          --v1.03  2016/10/03  Leisure
	          --AND create_time >= start_time
	          --AND create_time < end_time
	          AND payout_time >= start_time
	          AND payout_time < end_time
	          AND su.owner_id = agent_id
	        GROUP BY player_id) pn
	 WHERE pn.effeTa >= valid_value
	  INTO player_num;
	*/
	SELECT COUNT(1)
	  FROM (SELECT player_id, SUM(effective_transaction) effective_transaction
	         FROM operate_player
	        WHERE static_time >= p_start_time
	          AND static_time_end <= p_end_time
	          AND agent_id = p_agent_id
	        GROUP BY player_id) pn
	 WHERE pn.effective_transaction >= p_valid_value
	  INTO player_num;
	RETURN player_num;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_valid_player_num(p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_agent_id INT, p_valid_value FLOAT)
IS 'Leisure-计算有效玩家数';

/**
 * 根据返佣周期统计各个API,各个玩家的返佣数据.
 * @author 	Lins
 * @date 	2015.11.10
 * @param 	name 		返佣周期名称.
 * @param 	startTime 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	endTime 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	url 		运营商库的dblink 格式数据(host=192.168.0.88 dbname=gamebox-mainsite user=postgres password=postgres)
 * @param 	flag 		出账标示:Y-已出账, N-未出账
**/
drop function if exists gamebox_rebate(text, text, text, text, text);
create or replace function gamebox_rebate(
		name 		text,
		startTime 	text,
		endTime 	text,
		url 		text,
		flag 		text
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-代理返佣计算入口
--v1.01  2016/05/12  Leisure  未达返佣梯度，依然需要计算代理承担费用
*/
DECLARE
		rec 		record;   --系统设置各种承担比例.
		syshash 	hstore;   --各API的返佣设置
		gradshash 	hstore;   --各个代理的返佣设置
		agenthash 	hstore;   --运营商各API占成比例.
		mainhash 	hstore;   --存储每个代理是否满足梯度.
		checkhash 	hstore;   --各玩家返水.
		rakebackhash hstore;  --临时
		hash 		hstore;
		mhash 		hstore;   --返佣值
		rebate_value FLOAT;

		sid 	int;
		keyId 	int;
		tmp 	int;
		stTime 	TIMESTAMP;
		edTime 	TIMESTAMP;

		pending_lssuing text:='pending_lssuing';
		pending_pay 	text:='pending_pay';
		--分隔符
		row_split 	text:='^&^';
		col_split 	text:='^';

		--运营商占成参数.
		is_max 		BOOLEAN:=true;
		key_type 	int:=4;
		category 	TEXT:='AGENT';

		rebate_bill_id INT:=-1; --返佣主表键值.
		bill_count	INT :=0;
		redo_status BOOLEAN:=false;

BEGIN
		stTime = startTime::TIMESTAMP;
		edTime = endTime::TIMESTAMP;

		IF flag = 'Y' THEN
			SELECT COUNT("id")
			 INTO bill_count
				FROM rebate_bill rb
			 WHERE rb.period = name
				 AND rb."start_time" = stTime
				 AND rb."end_time" = edTime;

			IF bill_count > 0 THEN
				IF redo_status THEN
					DELETE FROM rebate_api ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
					DELETE FROM rebate_player rp WHERE rp.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
					DELETE FROM rebate_agent ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
					DELETE FROM rebate_bill rb WHERE "id" IN (SELECT "id" FROM rebate_bill WHERE period = name AND "start_time" = stTime AND "end_time" = edTime);
				ELSE
					raise info '已生成本期返佣账单，无需重新生成。';
					RETURN;
				END IF;
			END IF;
		END IF;
		raise info '开始统计第( % )期的返佣,周期( %-% )', name, startTime, endTime;
		/*
		raise info '取得玩家返水';
		SELECT gamebox_rebate_rakeback_map(stTime, edTime) INTO rakebackhash;
		*/
		--取得当前站点.
		SELECT gamebox_current_site() INTO sid;
		--取得系统关于各种承担比例参数.
		SELECT gamebox_sys_param('apportionSetting') INTO syshash;
		--取得当前返佣梯度设置信息.
		SELECT gamebox_rebate_api_grads() INTO gradshash;
		--取得代理默认返佣方案
		SELECT gamebox_rebate_agent_default_set() INTO agenthash;
		--判断各个代理满足的返佣梯度.
		raise info '判断各个代理满足的返佣梯度';
		SELECT gamebox_rebate_agent_check(gradshash, agenthash, stTime, edTime, flag) INTO checkhash;

		--IF checkhash IS NOT NULL THEN
		--COMMENT BY Leisure 2016-05-06 对于当期返佣为0的，需要计算承担费用

		--取得各API的运营商占成.
		raise info '取得运营商各API占成';
		SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type, flag) INTO mainhash;

		--先插入返佣总记录并取得键值.
		raise info '返佣rebate_bill新增记录';
		SELECT gamebox_rebate_bill(name, stTime, edTime, rebate_bill_id, 'I', flag) INTO rebate_bill_id;

		raise info '计算各玩家API返佣';
		perform gamebox_rebate_api(rebate_bill_id, stTime, edTime, gradshash, checkhash, mainhash, flag);

		raise info '收集各玩家的分摊费用';
		SELECT gamebox_rebate_expense_gather(rebate_bill_id, stTime, edTime, row_split, col_split, flag) INTO hash;

		raise info '统计各玩家返佣';
		perform gamebox_rebate_player(syshash, hash, rakebackhash, rebate_bill_id, row_split, col_split, flag);

		raise info '开始统计代理返佣';
		perform gamebox_rebate_agent(rebate_bill_id,flag, checkhash);

		raise info '更新返佣总表';
		perform gamebox_rebate_bill(name, stTime, edTime, rebate_bill_id, 'U', flag);

		--END IF;
		--EDIT BY Leisure 2016-05-06 对于当期返佣为0的，需要计算承担费用
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate(name text, startTime text, endTime text, url text, flag text)
IS 'Lins-返佣-代理返佣计算入口';

/**
 * 返佣插入与更新数据.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	name 		周期数.
 * @param 	start_time 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	end_time 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	bill_id 	返佣键值
 * @param 	op 			操作类型: I-新增, U-更新.
 * @param 	flag 		出账标示: Y-已出账, N-未出账
**/
DROP FUNCTION IF EXISTS gamebox_rebate_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rebate_bill(
	name		TEXT,
	start_time		TIMESTAMP,
	end_time		TIMESTAMP,
	INOUT bill_id		INT,
	op		TEXT,
	flag		TEXT
)
returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-返佣周期主表
--v1.01  2016/05/12  Leisure  只统计settlement_state = 'pending_lssuing'的代理账单（'next_lssuing'为下期结算，不统计）
--v1.02  2016/05/12  Leisure  本期没有代理达到返佣梯度，依然需要出账单
*/
DECLARE
	rec 		record;
	pending_pay text:='pending_pay';
	key_id 		INT;
	ra_count    INT:=0; -- rebate_agent 条数

BEGIN
	IF flag='Y' THEN 	--已出账
		IF op='I' THEN
			INSERT INTO rebate_bill (
				period, start_time, end_time,
				agent_count, agent_lssuing_count, agent_reject_count, rebate_total, rebate_actual,
				last_operate_time, create_time, lssuing_state
			) VALUES (
				name, start_time, end_time,
				0, 0, 0, 0, 0,
				now(), now(), pending_pay
			) returning id into bill_id;
			--改为returning，防止并发 Leisure 20160505
			--SELECT currval(pg_get_serial_sequence('rebate_bill', 'id')) INTO bill_id;
			raise info 'rebate_bill.完成.Y键值:%', bill_id;
		ELSE
			--v1.02
			--SELECT COUNT(1) FROM rebate_agent WHERE rebate_bill_id = bill_id INTO ra_count;
			--IF ra_count = 0 THEN
				--DELETE FROM rebate_bill WHERE id = bill_id;
			--ELSE
			  SELECT COUNT(1) FROM rebate_agent WHERE rebate_bill_id = bill_id AND settlement_state = 'pending_lssuing' INTO ra_count;
				IF ra_count = 0 THEN
					UPDATE rebate_bill SET lssuing_state = 'next_pay' WHERE id = bill_id;
				ELSE
					FOR rec in
						SELECT rebate_bill_id,
									 COUNT(DISTINCT agent_id) 	agent_num,
									 SUM(effective_transaction) 	effective_transaction,
									 SUM(profit_loss) 			profit_loss,
									 SUM(rakeback) 				rakeback,
									 SUM(rebate_total) 			rebate_total,
									 SUM(refund_fee) 				refund_fee,
									 SUM(recommend) 				recommend,
									 SUM(preferential_value) 		preferential_value,
									 SUM(apportion) 				apportion
							FROM rebate_agent
						 WHERE rebate_bill_id = bill_id
							 AND settlement_state = 'pending_lssuing'
						 GROUP BY rebate_agent.rebate_bill_id
					LOOP
						UPDATE rebate_bill
							 SET agent_count = rec.agent_num,
									 rebate_total = rec.rebate_total,
									 effective_transaction = rec.effective_transaction,
									 profit_loss = rec.profit_loss,
									 rakeback = rec.rakeback,
									 refund_fee = rec.refund_fee,
									 recommend = rec.recommend,
									 preferential_value = rec.preferential_value,
									 apportion = rec.apportion
						 WHERE id = rec.rebate_bill_id;
					END LOOP;
				END IF;
			--END IF;
		END IF;

	ELSEIF flag = 'N' THEN 	--未出账
		IF op='I' THEN
			INSERT INTO rebate_bill_nosettled (
				start_time, end_time, create_time,
				rebate_total, effective_transaction, profit_loss, refund_fee,
				recommend, preferential_value, apportion, rakeback
			) VALUES (
				start_time, end_time, now(),
				0, 0, 0, 0,
				0, 0, 0, 0
			) returning id into bill_id;
			--改为returning，防止并发 Leisure 20160505
			--SELECT currval(pg_get_serial_sequence('rebate_bill_nosettled', 'id')) INTO bill_id;
			raise info 'rebate_bill_nosettled.完成.N键值:%', bill_id;
		ELSE
			--v1.02
			--SELECT COUNT(1) FROM rebate_agent_nosettled WHERE rebate_bill_nosettled_id = bill_id INTO ra_count;
			--IF ra_count = 0 THEN
				--DELETE FROM rebate_bill_nosettled WHERE id = bill_id;
			--ELSE
				FOR rec IN
					SELECT rebate_bill_nosettled_id,
								 SUM(effective_transaction) 	effective_transaction,
								 SUM(profit_loss) 			profit_loss,
								 SUM(rakeback) 				rakeback,
								 SUM(rebate_total) 			rebate_total,
								 SUM(refund_fee) 				refund_fee,
								 SUM(recommend) 				recommend,
								 SUM(preferential_value) 		preferential_value,
								 SUM(apportion) apportion
						FROM rebate_agent_nosettled
					 WHERE rebate_bill_nosettled_id = bill_id
					 GROUP BY rebate_bill_nosettled_id
				LOOP
					UPDATE rebate_bill_nosettled
						 SET rebate_total = rec.rebate_total,
								 effective_transaction = rec.effective_transaction,
								 profit_loss = rec.profit_loss,
								 rakeback = rec.rakeback,
								 refund_fee = rec.refund_fee,
								 recommend = rec.recommend,
								 preferential_value = rec.preferential_value,
								 apportion = rec.apportion
					 WHERE id = rec.rebate_bill_nosettled_id;
				END LOOP;
				DELETE FROM rebate_bill_nosettled WHERE id <> bill_id;
			--END IF;
		END IF;

	END IF;

	RETURN;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, bill_id INT, op TEXT, flag TEXT)
IS 'Lins-返佣-返佣周期主表';

/**
 * 统计各玩家API返佣.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	bill_id 	返佣KEY.
 * @param 	start_time 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	end_time 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	gradshash 	各种费用(优惠、推荐、返手续费、返水)hash
 * @param 	mainhash 	各玩家返水hash
 * @param 	flag
**/
DROP FUNCTION IF EXISTS gamebox_rebate_api(INT, TIMESTAMP, TIMESTAMP, hstore, hstore, hstore, TEXT);
create or replace function gamebox_rebate_api(
   bill_id 		INT,
   start_time 		TIMESTAMP,
   end_time 		TIMESTAMP,
   gradshash 		hstore,
   checkhash 		hstore,
   mainhash 		hstore,
   flag 			TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-玩家API返佣
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/10/03  Leisure  统计时间由bet_time改为payout_time；
                              改用returning返回键值
*/
DECLARE
	rec 				record;
	rebate_value 		FLOAT:=0.00;--返佣.
	tmp 				int:=0;
	key_name 			TEXT:='';
	operation_occupy 	FLOAT:=0.00;
	col_split 			TEXT:='_';
	settle_state 		TEXT:='settle';

BEGIN
	raise info '计算各API各代理的盈亏总和';

	IF flag = 'N' THEN
		-- settle_state:='pending_settle';
		TRUNCATE TABLE rebate_api_nosettled;
		TRUNCATE TABLE rebate_player_nosettled;
		TRUNCATE TABLE rebate_agent_nosettled;
	END IF;

	FOR rec IN
		SELECT su.owner_id as agent_id,
		       po.player_id,
		       po.api_id,
		       po.api_type_id,
		       po.game_type,
		       po.effective_trade_amount as effective_transaction,
		       (po.profit_amount) as profit_loss
		  FROM (SELECT pgo.player_id,
		               pgo.api_id,
		               pgo.api_type_id,
		               pgo.game_type,
		               COALESCE(SUM(pgo.effective_trade_amount), 0.00) 	as effective_trade_amount,
		               COALESCE(-SUM(pgo.profit_amount), 0.00) 	as profit_amount
		          FROM player_game_order pgo
		         --v1.02  2016/10/03  Leisure
		         --WHERE pgo.bet_time >= start_time
		         --  AND pgo.bet_time < end_time
		         WHERE pgo.payout_time >= start_time
		           AND pgo.payout_time < end_time
		           AND pgo.order_state = settle_state
		           AND pgo.is_profit_loss = TRUE
		         GROUP BY pgo.player_id, pgo.api_id, pgo.api_type_id, pgo.game_type) po
		     LEFT JOIN sys_user su ON po.player_id = su."id"
		     LEFT JOIN user_player up ON po.player_id = up."id"
		     LEFT JOIN user_agent ua ON su.owner_id = ua."id"
		 WHERE su.user_type = '24'
	LOOP
   --EDIT BY Leisure 2016-05-06 对于当期返佣为0的，需要计算承担费用
   /*
   -- 检查当前代理是否满足返佣梯度.
		IF checkhash IS NULL THEN
			EXIT;
		END IF;

		IF isexists(checkhash, (rec.agent_id)::text) = false THEN
			CONTINUE;
		END IF;
  **/
		raise info '取得各API各分类佣金总和';
		key_name = rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
		operation_occupy = (mainhash->key_name)::FLOAT;
		SELECT gamebox_rebate_calculator(
			gradshash,
			checkhash,
			rec.agent_id,
			rec.api_id,
			rec.game_type,
			rec.profit_loss,
			operation_occupy
		) INTO rebate_value;

		-- 新增各API代理返佣:目前返佣不分正负都新增.
   IF flag = 'Y' THEN
			INSERT INTO rebate_api (
				rebate_bill_id, player_id, api_id, api_type_id, game_type,
				rebate_total, effective_transaction, profit_loss
			) VALUES (
				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,
				rebate_value, rec.effective_transaction, rec.profit_loss
			) RETURNING id INTO tmp;
			--v1.02  2016/10/03  Leisure
			--SELECT currval(pg_get_serial_sequence('rebate_api', 'id')) INTO tmp;
			raise info '返拥API.键值:%', tmp;
		ELSEIF flag = 'N' THEN
			INSERT INTO rebate_api_nosettled (
				rebate_bill_nosettled_id, player_id, api_id, api_type_id, game_type,
				rebate_total, effective_transaction, profit_loss
			) VALUES(
				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,
				rebate_value, rec.effective_transaction, rec.profit_loss
			) RETURNING id INTO tmp;
			--v1.02  2016/10/03  Leisure
			--SELECT currval(pg_get_serial_sequence('rebate_api_nosettled', 'id')) INTO tmp;
			raise info '返拥API.键值:%',tmp;
		END IF;

	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, gradshash hstore, checkhash hstore, mainhash hstore, flag TEXT)
IS 'Lins-返佣-玩家API返佣';

/**
 * 各玩家返佣统计
 * @author 	Lins
 * @date 	2015.11.13
 * @param 	syshash		系统参数
 * @param 	expense_map 费用Map
 * @param 	rakeback_map 返水Map
 * @param 	bill_id 	主键
 * @param 	row_split 	行分隔符
 * @param 	col_split 	列分隔符
 * @param 	flag 		Y, N
 * 返回hstore类型,以代理ID为KEY值.各种费用按一定格式组成VALUE。
**/
--drop function if exists gamebox_rebate_player(hstore, hstore, hstore, hstore, int, text, text, TEXT);
drop function if exists gamebox_rebate_player(hstore, hstore, hstore, int, text, text, TEXT);
create or replace function gamebox_rebate_player(
    syshash 		hstore,
    expense_map 	hstore,
    rakeback_map 	hstore,
    bill_id 		INT,
    row_split 		text,
    col_split 		text,
    flag 			TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-玩家返佣
--v1.01  2016/10/03  Leisure  更新分摊费用的计算，favourable统一改为favorable
--v1.02  2016/10/08  Leisure  更新分摊费用的计算，改为returning防并发
*/
DECLARE

	keys 		text[];
	keyname 	text:='';
	val 		text:='';
	--vals 		text[];

	user_id 	INT:=-1;

	mhash 		hstore;
	--param 		text:='';
	--money 		float:=0.00;

	player_num 	int:=0;					-- 玩家数
	profit_amount float:=0.00;			-- 盈亏总和
	effective_trade_amount float:=0.00;	-- 有效交易量

	agent_id 	int;
	agent_name 	text:='';

	rebate 		float:=0.00;	-- 返佣
	backwater 	float:=0.00;			-- 返水费用
	backwater_apportion 	float:=0.00;-- 返水分摊费用

	favorable 	float:=0.00;			-- 优惠费用
	recommend 	float:=0.00;			-- 推荐费用
	--artificial_depositfavorable		float:=0.00;-- 手动存入优惠

	retio 		float;			-- 占成比
	favorable_apportion 	float:=0.00;-- 优惠分摊费用
	refund_fee 	float:=0.00;			-- 返手续费费用
	refund_fee_apportion 	float:=0.00;-- 返手续费分摊费用
	apportion 	FLOAT:=0.00;	-- 分摊总费用

	deposit 		float:=0.00;	-- 存款
	--company_deposit float:=0.00;	-- 存款:公司入款
	--online_deposit	float:=0.00;	-- 存款:线上支付
	--artificial_deposit float:=0.00; -- 存款:手动存款

	withdrawal 		float:=0.00;	-- 取款
	--artificial_withdraw	float:=0.00;-- 取款:手动取款
	--player_withdraw	float:=0.00;	-- 取款:玩家取款

	--rebate_keys		text[];
	--rebate_keyname  text:='';
	--rebate_val		text:='';
	--rebate_vals 	text[];
	--rebate_hash		hstore;
	--max_rebate		float:=0.00;

	--tmp 		text:='';
	return_id 		text:='';

BEGIN
	-- raise info 'expense_map = %', expense_map;
	IF expense_map is null THEN
		RETURN;
	END IF;

	keys = akeys(expense_map);
	-- raise info '---- keys = %', keys;

	FOR i in 1..array_length(keys, 1)

	LOOP
		keyname = keys[i];

		user_id = keyname::INT;
		val = expense_map->keyname;
		--转换成hstore数据格式:key1=>value1,key2=>value2
		val = replace(val, row_split, ',');
		val = replace(val, col_split, '=>');
		--raise info 'val=%',val;
		SELECT val INTO mhash;

		--代理id
		agent_id = -1;
		IF exist(mhash, 'agent_id') THEN
			agent_id = (mhash->'agent_id')::INT;
		END IF;

		--代理名称
		agent_name = '';
		IF exist(mhash, 'agent_name') THEN
			agent_name = mhash->'agent_name';
		END IF;

		--返佣
		rebate = 0.00;
		IF exist(mhash, 'rebate') THEN
			rebate = (mhash->'rebate')::float;
		END IF;

		--backwater = 0.00;
		-- raise info 'rakeback_map = %', rakeback_map;
		/*
		IF isexists(rakeback_map, keyname) THEN
			backwater = (rakeback_map->keyname)::FLOAT;
		END IF;
		*/

		backwater = 0.00;
		IF exist(mhash, 'backwater') THEN
			backwater = (mhash->'backwater')::float;
		END IF;

		-- raise info 'backwater = %', backwater;

		refund_fee = 0.00;
		IF exist(mhash, 'refund_fee') THEN
			refund_fee = (mhash->'refund_fee')::float;
		END IF;

		favorable = 0.00;
		IF exist(mhash, 'favorable') THEN
			favorable = (mhash->'favorable')::float;
		END IF;

		recommend = 0.00;
		IF exist(mhash, 'recommend') THEN
			recommend = (mhash->'recommend')::float;
		END IF;

		/*
		artificial_depositfavorable = 0.00;
		IF exist(mhash, 'artificial_depositfavorable') THEN
			artificial_depositfavorable = (mhash->'artificial_depositfavorable')::float;
		END IF;
		favorable = favorable + artificial_depositfavorable;
		*/

		/*
		company_deposit = 0.00;
		IF exist(mhash, 'company_deposit') THEN
			company_deposit = (mhash->'company_deposit')::float;
		END IF;
		online_deposit = 0.00;
		IF exist(mhash, 'online_deposit') THEN
			online_deposit = (mhash->'online_deposit')::float;
		END IF;
		artificial_deposit = 0.00;
		IF exist(mhash, 'artificial_deposit') THEN
			artificial_deposit = (mhash->'artificial_deposit')::float;
		END IF;
		deposit = company_deposit + online_deposit + artificial_deposit;
		*/
		/*
		artificial_withdraw = 0.00;
		IF exist(mhash, 'artificial_withdraw') THEN
			artificial_withdraw = (mhash->'artificial_withdraw')::float;
		END IF;
		player_withdraw = 0.00;
		IF exist(mhash, 'player_withdraw') THEN
			player_withdraw = (mhash->'player_withdraw')::float;
		END IF;
		withdraw = artificial_withdraw + player_withdraw;
		*/

		deposit = 0.00;
		IF exist(mhash, 'deposit') THEN
			deposit = (mhash->'deposit')::float;
		END IF;

		withdrawal = 0.00;
		IF exist(mhash, 'withdrawal') THEN
			withdrawal = (mhash->'withdrawal')::float;
		END IF;

		--有效交易量
		effective_trade_amount = 0.00;
		IF exist(mhash, 'effective_transaction') THEN
			effective_trade_amount = (mhash->'effective_transaction')::float;
		END IF;

		--盈亏总和
		profit_amount = 0.00;
		IF exist(mhash, 'profit_loss') THEN
			profit_amount = (mhash->'profit_loss')::float;
		END IF;

		/*
			计算各种优惠.
			1、返水承担费用 = 赠送给体系下玩家的返水 * 代理承担比例；
			2、优惠承担费用 = 赠送给体系下玩家的优惠 * 代理承担比例；
			3、返还手续费承担费用 = 返还给体系下玩家的手续费 * 代理承担比例；
		*/
		--优惠与推荐分摊
		IF isexists(syshash, 'agent.preferential.percent') THEN
			retio = (syshash->'agent.preferential.percent')::float;
			-- raise info '优惠与推荐分摊比例:%', retio;
			favorable_apportion = (favorable + recommend) * retio / 100;
		ELSE
			favorable_apportion = 0;
		END IF;
		--返水分摊
		IF isexists(syshash, 'agent.rakeback.percent') THEN
			retio = (syshash->'agent.rakeback.percent')::float;
			-- raise info '返水分摊比例:%', retio;
			backwater_apportion = backwater * retio / 100;
		ELSE
			backwater_apportion = 0;
		END IF;
		--返手续费分摊
		IF isexists(syshash, 'agent.poundage.percent') THEN
			retio = (syshash->'agent.poundage.percent')::float;
			-- raise info '手续费优惠分摊比例:%', retio;
			refund_fee_apportion = refund_fee * retio / 100;
		ELSE
			refund_fee_apportion = 0;
		END IF;

		--分摊总费用
		apportion = backwater_apportion + refund_fee_apportion + favorable_apportion;
		-- raise info '-------- 分摊总费用 = %', apportion;

		--代理佣金 = 各API佣金总和 - 优惠 - 返水 - 返手续费.
		rebate = rebate - apportion;

		IF flag = 'Y' THEN
			INSERT INTO rebate_player(
				rebate_bill_id, agent_id, user_id,
				effective_transaction, profit_loss, rebate_total, rakeback,
				preferential_value, recommend, refund_fee, apportion,
				deposit_amount, withdrawal_amount
			) VALUES (
				bill_id, agent_id, user_id,
				effective_trade_amount, profit_amount, rebate, backwater,
				favorable, recommend, refund_fee, apportion,
				deposit, withdrawal
			) RETURNING id INTO return_id;
			--SELECT currval(pg_get_serial_sequence('rebate_player', 'id')) INTO tmp;
			-- raise info 'Y返佣代理表的键值:%', tmp;
		ELSEIF flag='N' THEN
			INSERT INTO rebate_player_nosettled (
				rebate_bill_nosettled_id, agent_id, player_id,
				effective_transaction, profit_loss, rebate_total, rakeback,
				preferential_value, recommend, refund_fee, apportion,
				deposit_amount, withdrawal_amount
			) VALUES (
				bill_id, agent_id, user_id,
				effective_trade_amount, profit_amount, rebate, backwater,
				favorable, recommend, refund_fee, apportion,
				deposit, withdrawal
			) RETURNING id INTO return_id;
			--SELECT currval(pg_get_serial_sequence('rebate_player_nosettled', 'id')) INTO tmp;

			raise info 'N返佣代理表的键值:%',return_id;
		END IF;
	END LOOP;
	raise info '开始统计代理返佣.完成';
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_player(syshash hstore, expense_map hstore, rakeback_map hstore, bill_id INT, row_split text, col_split text, flag TEXT)
IS 'Lins-返佣-玩家返佣';

/**
 * Fei-计算代理梯度的返佣上限.
 * @author 	Fei
 * @date 	2015.11.10
 * @return 	返回float类型，返水值.
**/
drop function IF EXISTS gamebox_rebate_limit(hstore);
create or replace function gamebox_rebate_limit(
	checkhash 	hstore
) returns hstore as $$
/*版本更新说明
版本   时间        作者     内容
v1.00  2015/01/01  Fei      创建此函数: 计算代理梯度的返佣上限
v1.01  2016/05/12  Leisure  修正一处小bug，keyvalue'_'改为keyvalue||'_'
*/
DECLARE
	rec 		record;
	rebate_info TEXT;
	agent_id	TEXT;
	subkeys 	TEXT[];
	limithash	hstore;
	keyname     TEXT;
   keyvalue    FLOAT:=0.0;
BEGIN
 	FOR rec IN
 		SELECT ua.user_id, rg."id", rg.rebate_id, rg.max_rebate
		  FROM rebate_grads rg
		  LEFT JOIN rebate_set rs ON rg.rebate_id = rs."id"
		  LEFT JOIN user_agent_rebate ua ON rg.rebate_id = ua.rebate_id
		 WHERE rs.status = '1'
	LOOP

		agent_id:=rec.user_id::TEXT;
		---- agent_id = 927
		rebate_info = checkhash->agent_id;
		---- rebate_info = 62_79_3_580_2080_feiagent
		subkeys = regexp_split_to_array(rebate_info, '_');
		IF subkeys[1] = rec.rebate_id::TEXT AND subkeys[2] = rec.id::TEXT THEN

			keyname:=agent_id;
	        keyvalue:=rec.max_rebate::FLOAT;
	        IF limithash IS NULL THEN
	            SELECT keyname||'=>'||keyvalue||'_'||subkeys[3] into limithash;
	        ELSE
	            limithash = (SELECT (keyname||'=>'||keyvalue||'_'||subkeys[3])::hstore)||limithash;
	        END IF;

		END IF;

	END LOOP;
	RETURN limithash;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_limit(checkhash hstore)
IS 'Fei-计算代理梯度的返佣上限.';

/**
 * Fei-计算代理返佣
 * @author  Fei
 * @param 	bill_id 	返佣ID
 * @param 	flag 		出账标识: Y-已出账, N-未出账
**/
drop function if exists gamebox_rebate_agent(INT, TEXT, hstore);
create or replace function gamebox_rebate_agent(
	bill_id	INT,
	flag		TEXT,
	checkhash	hstore
) returns void as $$
/*版本更新说明
  版本   时间        作者      内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-代理返佣计
--v1.01  2016/05/12  Leisure  对于只有费用，没有返佣的记录，settlement_state值设为next_lssuing
--v1.02  2016/05/13  Leisure  对于未结算账单，未满足返佣梯度的，不统计
--v1.03  2016/05/13  Leisure  需要将上期未结金额，写入字段中
*/
DECLARE
	rec		record;
	pending	TEXT:='pending_lssuing';
	rebate		FLOAT:=0.00;	-- 代理返佣
	max_rebate	FLOAT:=0.00;	-- 返佣上限
	limithash	hstore;			-- 返佣上限
	agent_id	TEXT;
	subkeys		TEXT[];
	subkey		TEXT;
	player_num	INT=0;
	next_lssuing_total FLOAT:=0.00; --未结算佣金

BEGIN
	IF flag = 'Y' THEN

		FOR rec IN
			SELECT p.rebate_bill_id,
				   p.agent_id,
				   u.username					agent_name,
				   --COUNT(distinct p.user_id)	effective_player,
				   SUM(p.effective_transaction)	effective_transaction,
				   SUM(p.profit_loss)			profit_loss,
				   SUM(p.rakeback)				rakeback,
				   SUM(p.rebate_total)			rebate_total,
				   SUM(p.refund_fee)			refund_fee,
				   SUM(p.recommend)				recommend,
				   SUM(p.preferential_value)	preferential_value,
				   SUM(p.apportion)				apportion,
				   SUM(p.deposit_amount)		deposit_amount,
				   SUM(p.withdrawal_amount)		withdrawal_amount
			  FROM rebate_player p, sys_user u
			 WHERE p.agent_id = u.id
			   AND p.rebate_bill_id = bill_id
			   AND u.user_type = '23'
			 GROUP BY p.rebate_bill_id, p.agent_id, u.username
		LOOP

			next_lssuing_total = 0.00; --v1.03

			--player_num = rec.effective_player;
			player_num = 0;

			agent_id:=rec.agent_id::TEXT;

			IF isexists(checkhash, agent_id) THEN
				subkey = checkhash->agent_id;
				subkeys = regexp_split_to_array(subkey, '_');
				player_num = subkeys[3]::INT;
			END IF;

			SELECT gamebox_rebate_limit(checkhash) INTO limithash;

			IF limithash is NOT null AND isexists(limithash, agent_id) THEN
				subkey = limithash->agent_id;
				subkeys = regexp_split_to_array(subkey, '_');
				max_rebate = subkeys[1];
				--player_num = subkeys[2]::INT;
			END IF;

			rebate = rec.rebate_total;
			IF max_rebate != 0.0 AND rebate > max_rebate THEN
				rebate = max_rebate;
			END IF;

			--如果代理本期完成返佣梯度
			IF checkhash IS NOT NULL AND isexists(checkhash, agent_id) THEN

				pending :='pending_lssuing';

				--如果本期满足返佣梯度，需要结算往期费用
				SELECT COALESCE(SUM(rebate_actual), 0.00)
				  INTO next_lssuing_total
				  FROM rebate_agent rao
				 WHERE rao.settlement_state = 'next_lssuing'
				   AND rao.agent_id = rec.agent_id
				   --AND rao.rebate_bill_id <= bill_id
				   AND rao.rebate_bill_id > (
				     SELECT COALESCE(MAX(rebate_bill_id), 0)
				       FROM rebate_agent rai
				      WHERE rai.settlement_state <> 'next_lssuing'
				        AND rai.agent_id = rec.agent_id
				        --AND rai.rebate_bill_id < bill_id
				   );

				rebate := rebate + next_lssuing_total;
			ELSE
				pending := 'next_lssuing';
			END IF;

			INSERT INTO rebate_agent(
				rebate_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
				rakeback, rebate_total, rebate_actual, refund_fee, recommend, preferential_value,
				settlement_state, apportion, deposit_amount, withdrawal_amount, history_apportion
			) VALUES (
				bill_id, rec.agent_id, rec.agent_name, player_num, rec.effective_transaction, rec.profit_loss,
				rec.rakeback, rebate, rebate, rec.refund_fee, rec.recommend, rec.preferential_value,
				pending, rec.apportion, rec.deposit_amount, rec.withdrawal_amount, next_lssuing_total
			);

		END LOOP;

	ELSEIF flag='N' THEN
		--v1.02 对于未结算账单，未满足返佣梯度的，不统计
		IF checkhash IS NULL THEN
			RETURN;
		END IF;
		FOR rec IN
			SELECT p.rebate_bill_nosettled_id,
				   p.agent_id,
				   u.username					agent_name,
				   --COUNT(distinct p.player_id)	effective_player,
				   SUM(p.effective_transaction)	effective_transaction,
				   SUM(p.profit_loss)			profit_loss,
				   SUM(p.rakeback)				rakeback,
				   SUM(p.rebate_total)			rebate_total,
				   SUM(p.refund_fee)			refund_fee,
				   SUM(p.recommend)				recommend,
				   SUM(p.preferential_value)	preferential_value,
				   SUM(p.apportion)				apportion,
				   SUM(p.deposit_amount)		deposit_amount,
				   SUM(p.withdrawal_amount)		withdrawal_amount
			  FROM rebate_player_nosettled p, sys_user u
			 WHERE p.agent_id = u.id
			   AND p.rebate_bill_nosettled_id = bill_id
			   AND u.user_type = '23'
			 GROUP BY p.rebate_bill_nosettled_id, p.agent_id, u.username
		LOOP

			next_lssuing_total = 0.00;

			agent_id:=rec.agent_id::TEXT;

			--v1.02 对于未结算账单，未满足返佣梯度的，不统计
			IF isexists(checkhash, agent_id) = false THEN
				CONTINUE;
			END IF;
			--player_num = rec.effective_player;
			player_num = 0;

			IF isexists(checkhash, agent_id) THEN
				subkey = checkhash->agent_id;
				subkeys = regexp_split_to_array(subkey, '_');
				player_num = subkeys[3]::INT;
			END IF;

			SELECT gamebox_rebate_limit(checkhash) INTO limithash;

			IF isexists(limithash, agent_id) THEN
				subkey = limithash->agent_id;
				subkeys = regexp_split_to_array(subkey, '_');
				max_rebate = subkeys[1];
				--player_num = subkeys[2]::INT;
			END IF;

			rebate = rec.rebate_total;
			IF max_rebate != 0.0 AND rebate > max_rebate THEN
				rebate = max_rebate;
			END IF;

			--如果代理本期完成返佣梯度
			IF checkhash IS NOT NULL AND isexists(checkhash, agent_id) THEN

				pending :='pending_lssuing';
				--如果本期满足返佣梯度，需要结算往期费用
				SELECT COALESCE(SUM(rebate_actual), 0.00)
				  INTO next_lssuing_total
				  FROM rebate_agent rao
				 WHERE rao.settlement_state = 'next_lssuing'
				   AND rao.agent_id = rec.agent_id
				   --AND rao.rebate_bill_id < bill_id
				   AND rao.rebate_bill_id > (
				     SELECT COALESCE(MAX(rebate_bill_id), 0)
				       FROM rebate_agent rai
				      WHERE rai.settlement_state <> 'next_lssuing'
                AND rai.agent_id = rec.agent_id
				        --AND rai.rebate_bill_id < bill_id
				   );

				rebate := rebate + next_lssuing_total;
			ELSE
				pending := 'next_lssuing';
			END IF;

			INSERT INTO rebate_agent_nosettled (
				rebate_bill_nosettled_id, agent_id, agent_name, effective_player, effective_transaction,
				profit_loss, rakeback, rebate_total, refund_fee, recommend, preferential_value,
				apportion, deposit_amount, withdrawal_amount, history_apportion
			) VALUES (
				bill_id, rec.agent_id, rec.agent_name, player_num, rec.effective_transaction,
				rec.profit_loss, rec.rakeback, rebate, rec.refund_fee, rec.recommend, rec.preferential_value,
				rec.apportion, rec.deposit_amount, rec.withdrawal_amount, next_lssuing_total
			);

		END LOOP;

	END IF;
raise info '代理返佣.完成';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_agent(bill_id INT, flag TEXT, checkhash hstore)
IS 'Lins-返佣-代理返佣计算';

/**
 * 计算返佣MAP-外部调用
 * @author Lins
 * @date 2015.11.13
 * @param.运营商库.dblink URL
 * @param.开始时间
 * @param.结束时间
 * @param.类别.AGENT
**/
drop function if EXISTS gamebox_rebate_map(TEXT, TEXT, TEXT, TEXT);
create or replace FUNCTION gamebox_rebate_map(
	url 		TEXT,
	start_time 	TEXT,
	end_time 	TEXT,
	category 	TEXT
) RETURNS hstore[] as $$

DECLARE
	sys_map 				hstore;--系统参数.
	rebate_grads_map 		hstore;--返佣梯度设置
	agent_map 				hstore;--代理默认方案
	agent_check_map 		hstore;--代理梯度检查
	operation_occupy_map 	hstore;--运营商占成.
	rebate_map 				hstore;--API占成.
	expense_map 			hstore;--费用分摊

	sid 		INT;--站点ID.
	stTime 		TIMESTAMP;
	edTime 		TIMESTAMP;
	is_max 		BOOLEAN:=true;
	key_type 	int:=5;	-- API
	maps 		hstore[];
	flag		TEXT:='Y';
BEGIN
	stTime=start_time::TIMESTAMP;
	edTime=end_time::TIMESTAMP;

	raise info '占成.取得当前站点ID';
	SELECT gamebox_current_site() INTO sid;

	raise info '占成.系统各种分摊比例参数';
	SELECT gamebox_sys_param('apportionSetting') INTO sys_map;

	-- raise info '返佣.梯度设置信息';
  	-- SELECT gamebox_rebate_api_grads() INTO rebate_grads_map;

	-- raise info '返佣.代理默认方案';
  	-- SELECT gamebox_rebate_agent_default_set() INTO agent_map;

  	-- raise info '返佣.代理满足的梯度';
	-- SELECT gamebox_rebate_agent_check(rebate_grads_map, agent_map, stTime, edTime, flag) INTO agent_check_map;

	-- raise info '取得运营商各API占成';
	-- SELECT gamebox_operations_occupy(url, sid, stTime, edTime, category, is_max, key_type, flag) INTO operation_occupy_map;

	-- SELECT gamebox_rebate_map(stTime, edTime, key_type, rebate_grads_map, agent_check_map, operation_occupy_map) INTO rebate_map;
	SELECT gamebox_rebate_map(stTime, edTime) INTO rebate_map;
	--统计各种费费用.
	SELECT gamebox_expense_map(stTime, edTime, sys_map) INTO expense_map;
	maps=array[rebate_map];
	maps=array_append(maps, expense_map);

	return maps;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_rebate_map(url TEXT, start_time TEXT, end_time TEXT, category TEXT)
IS 'Lins-返佣-外调';

/**
 * 统计各玩家API返佣.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	返佣KEY.
 * @param 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	各种费用(优惠、推荐、返手续费、返水)hash
 * @param 	各玩家返水hash
**/
DROP FUNCTION IF EXISTS gamebox_rebate_map(TIMESTAMP, TIMESTAMP);
create or replace function gamebox_rebate_map(
	startTime 				TIMESTAMP,
	endTime 				TIMESTAMP
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 分摊费用
--v1.01  2016/06/15  Leisure  追加返回值判空逻辑
--v1.02  2016/10/25  Leisure  改为从rebate_agent_api获取
*/
DECLARE
	rec 				record;
	rebate 				FLOAT:=0.00;--返佣.
	key_name 			TEXT;--运营商占成KEY值.
	rebate_map 			hstore;--各API返佣值.
	col_split 			TEXT:='_';
BEGIN
	FOR rec IN
		--v1.02  2016/10/25  Leisure
		--SELECT ra.api_id, ra.game_type, SUM(ra.rebate_total) rebate_total
		--  FROM rebate_api ra
		SELECT ra.api_id, ra.game_type, SUM(ra.rebate_value) rebate_total
		  FROM rebate_agent_api ra
		  LEFT JOIN rebate_bill rb ON ra.rebate_bill_id = rb."id"
		 WHERE rb.start_time >= startTime
		   AND rb.end_time <= endTime
		 GROUP BY ra.api_id, ra.game_type
		 ORDER BY ra.api_id
	LOOP
		key_name = rec.api_id||col_split||rec.game_type;
		rebate = rec.rebate_total;

		IF rebate_map is null THEN
			SELECT key_name||'=>'||rebate INTO rebate_map;
		ELSEIF exist(rebate_map, key_name) THEN
			rebate = rebate + ((rebate_map->key_name)::FLOAT);
			rebate_map = rebate_map||(SELECT (key_name||'=>'||rebate)::hstore);
		ELSE
			rebate_map = (SELECT (key_name||'=>'||rebate)::hstore)||rebate_map;
		END IF;
	END LOOP;

	RETURN coalesce(rebate_map, '');

END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_map(start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Lins-返佣-API返佣-外调';

/**
 * 统计各玩家API返佣.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	返佣KEY.
 * @param 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	各种费用(优惠、推荐、返手续费、返水)hash
 * @param 	各玩家返水hash
**/
DROP FUNCTION IF EXISTS gamebox_rebate_map(TIMESTAMP, TIMESTAMP, INT, hstore, hstore, hstore);
create or replace function gamebox_rebate_map(
	start_time 				TIMESTAMP,
	end_time 				TIMESTAMP,
	key_type 				INT,
	rebate_grads_map 		hstore,
	agent_check_map 		hstore,
	operation_occupy_map 	hstore
) returns hstore as $$
/*版本更新说明
版本   时间        作者     内容
v1.00  2015/01/01  Lins     创建此函数: 返佣-API返佣-外调
v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
*/
DECLARE
	rec 				record;
	rebate 		FLOAT:=0.00;--返佣.
	operation_occupy 	FLOAT:=0.00;--运营商占成额
	key_name 			TEXT;--运营商占成KEY值.
	rebate_map 			hstore;--各API返佣值.
	col_split 			TEXT:='_';
BEGIN
	FOR rec IN
		SELECT su.owner_id, od.*
		  FROM (SELECT pgo.player_id,
		               pgo.api_id,
		               pgo.game_type,
		               SUM(-pgo.profit_amount) 	profit_amount
		            FROM player_game_order pgo
		           WHERE pgo.bet_time >= start_time
		             AND pgo.bet_time < end_time
		             AND pgo.order_state = 'settle'
		             AND pgo.is_profit_loss = TRUE
		           GROUP BY pgo.player_id, pgo.api_id, pgo.game_type
		       ) od
		  LEFT JOIN sys_user su ON od.player_id = su."id"
		  LEFT JOIN sys_user ua ON su.owner_id = ua."id"
		 WHERE su.user_type = '24'
		   AND ua.user_type = '23'
	LOOP
		--检查当前代理是否满足返佣梯度.
		IF isexists(agent_check_map, (rec.owner_id)::text) = false THEN
			CONTINUE;
		END IF;

		raise info '取得各API各分类佣金总和';
		key_name = rec.api_id||col_split||rec.game_type;
		operation_occupy = (operation_occupy_map->key_name)::FLOAT;
		SELECT gamebox_rebate_calculator(rebate_grads_map, agent_check_map, rec.owner_id, rec.api_id, rec.game_type, rec.profit_amount, operation_occupy) INTO rebate;

		IF rebate_map is null THEN
			SELECT key_name||'=>'||rebate INTO rebate_map;
		ELSEIF exist(rebate_map, key_name) THEN
			rebate = rebate + ((rebate_map->key_name)::FLOAT);
			rebate_map = rebate_map||(SELECT (key_name||'=>'||rebate)::hstore);
		ELSE
			rebate_map = (SELECT (key_name||'=>'||rebate)::hstore)||rebate_map;
		END IF;
	END LOOP;

	RETURN rebate_map;

END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_map(start_time TIMESTAMP, end_time TIMESTAMP, key_type INT, rebate_grads_map hstore, agent_check_map hstore, operation_occupy_map hstore)
IS 'Lins-返佣-API返佣-外调';

/**
 * 分摊费用
 * @author 	Lins
 * @date 	2015.11.13
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
**/
drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP);
create or replace function gamebox_expense_gather(
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 分摊费用
--v1.01  2016/06/15  Leisure  追加返回值判空逻辑
--v1.01  2016/07/13  Leisure  next_lssuing的费用，由下期history_apportion来计算，
                              本期不计算。
*/
DECLARE
	rec 		record;
	hash 		hstore;
	mhash 		hstore;
	param 		text:='';
	money 		float:=0.00;
	key_name 	TEXT;

	player_num 	INT:=0;
	apportion 	FLOAT:=0.00;
	rakeback 	FLOAT:=0.00;
	recommend	FLOAT:=0.00;
	refund_fee 	FLOAT:=0.00;
	profit_loss FLOAT:=0.00;
	deposit 	FLOAT:=0.00;
	effe_trans 	FLOAT:=0.00;
	favorable 	FLOAT:=0.00;
	withdraw 	FLOAT:=0.00;
	rebate_tot 	FLOAT:=0.00;
	rebate_act 	FLOAT:=0.00;

BEGIN

	FOR rec IN
		SELECT SUM(ra.effective_player) 		player_num,
			   SUM(ra.apportion) 				apportion,
			   SUM(ra.rakeback) 				rakeback,
			   SUM(ra.recommend) 				recommend,
		 	   SUM(ra.refund_fee) 				refund_fee,
			   SUM(ra.profit_loss) 				profit_loss,
			   SUM(ra.deposit_amount) 			deposit,
			   SUM(ra.effective_transaction) 	effe_trans,
			   SUM(ra.preferential_value) 		favorable,
			   SUM(ra.withdrawal_amount) 		withdraw,
			   SUM(ra.rebate_total) 			rebate_total,
			   SUM(ra.rebate_actual) 			rebate_actual
		  FROM rebate_agent ra
		  LEFT JOIN rebate_bill rb ON ra.rebate_bill_id = rb."id"
		 WHERE ra.settlement_state <> 'next_lssuing' --v1.01  2016/07/13  Leisure
		   AND rb.start_time >= startTime
		   AND rb.end_time <= endTime
	 LOOP
	 	player_num 	= player_num + rec.player_num;
	 	apportion 	= apportion + rec.apportion;
	 	rakeback 	= rakeback + rec.rakeback;
	 	recommend 	= recommend + rec.recommend;
	 	refund_fee 	= refund_fee + rec.refund_fee;
	 	profit_loss = profit_loss + rec.profit_loss;
	 	deposit 	= deposit + rec.deposit;
	 	effe_trans 	= effe_trans + rec.effe_trans;
	 	favorable 	= favorable + rec.favorable;
		withdraw  	= withdraw + rec.withdraw;
		rebate_tot 	= rebate_tot + rec.rebate_total;
		rebate_act  = rebate_act + rec.rebate_actual;
	END LOOP;

	param = 'player_num=>'||player_num;
	param = param||',apportion=>'||apportion||',rakeback=>'||rakeback||',recommend=>'||recommend;
	param = param||',refund_fee=>'||refund_fee||',profit_loss=>'||profit_loss||',deposit=>'||deposit;
	param = param||',effe_trans=>'||effe_trans||',favorable=>'||favorable||',withdraw=>'||withdraw;
	param = param||',rebate_tot=>'||rebate_tot||',rebate_act=>'||rebate_act;

	SELECT param::hstore INTO hash;

	return coalesce(hash, '');
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Lins-分摊费用';

/**
 * 分摊费用
 * @author 	Lins
 * @date 	2015.11.13
 * @return 	返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
**/
drop function if exists gamebox_expense_share(hstore, hstore);
create or replace function gamebox_expense_share(
	cost_map 	hstore,
	sys_map 	hstore
) returns hstore as $$

DECLARE
	hash 		hstore;
	retio 		FLOAT:=0.00;

	backwater 				FLOAT:=0.00;
	backwater_apportion 	FLOAT:=0.00;

	favourable 				FLOAT:=0.00;
	recommend 				FLOAT:=0.00;
	artificial_depositfavorable		FLOAT:=0.00;	-- 手动存入优惠
	favourable_apportion 	FLOAT:=0.00;

	refund_fee 				FLOAT:=0.00;
	refund_fee_apportion 	FLOAT:=0.00;

	apportion 				FLOAT:=0.00;
BEGIN
	backwater = 0.00;
	IF exist(cost_map, 'backwater') THEN
		backwater = (cost_map->'backwater')::float;
	END IF;

	favourable = 0.00;
	IF exist(cost_map, 'favourable') THEN
		favourable = (cost_map->'favourable')::float;
	END IF;

	refund_fee = 0.00;
	IF exist(cost_map, 'refund_fee') THEN
		refund_fee = (cost_map->'refund_fee')::float;
	END IF;

	recommend = 0.00;
	IF exist(cost_map, 'recommend') THEN
		recommend = (cost_map->'recommend')::float;
	END IF;

	artificial_depositfavorable = 0.00;
	IF exist(cost_map, 'artificial_depositfavorable') THEN
		artificial_depositfavorable = (cost_map->'artificial_depositfavorable')::float;
	END IF;

	/*
		计算各种优惠.
		1、返水承担费用=赠送给体系下玩家的返水 * 代理承担比例；
		2、优惠承担费用=赠送给体系下玩家的优惠 * 代理承担比例；
		3、返还手续费承担费用=返还给体系下玩家的手续费 * 代理承担比例；
	*/
 	--优惠与推荐分摊
	IF isexists(sys_map, 'agent.preferential.percent') THEN
		retio = (sys_map->'agent.preferential.percent')::float;
		favourable_apportion = (favourable + recommend + artificial_depositfavorable) * retio / 100;
	ELSE
		favourable_apportion = 0;
	END IF;

 	--返水分摊
	IF isexists(sys_map, 'agent.rakeback.percent') THEN
		retio = (sys_map->'agent.rakeback.percent')::float;
		backwater_apportion = backwater * retio / 100;
	ELSE
		backwater_apportion = 0;
	END IF;

	--手续费分摊
	IF isexists(sys_map, 'agent.poundage.percent') THEN
		retio = (sys_map->'agent.poundage.percent')::float;
		refund_fee_apportion = refund_fee * retio / 100;
	ELSE
		refund_fee_apportion = 0;
	END IF;

	--分摊总费用
	apportion=backwater_apportion + refund_fee_apportion + favourable_apportion;
	SELECT 'apportion=>'||apportion INTO hash;
	return hash;
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_share(cost_map hstore, sys_map hstore)
IS 'Lins-分摊费用';

/**
 * 返佣——上期未结费用
 * @author 	Leisure
 * @date 	2016.06.09
 * @param 	p_start_time 	开始时间
 * @param 	p_end_time 	结束时间
 * @return 	返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
**/
drop function if exists gamebox_expense_leaving(TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gamebox_expense_leaving(
	p_start_time TIMESTAMP,
	p_end_time TIMESTAMP
)
  RETURNS "public"."hstore" AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/06/09  Leisure  创建此函数: 返佣——上期未结费用
--v1.01  2016/07/13  Leisure  修改上期未结统计逻辑，
                              改为统计当期结算的历史未结金额
*/
DECLARE
	leaving_map 	hstore;
	f_expense_leaving		FLOAT := 0.00;
BEGIN
--v1.01  2016/07/13  Leisure
/*
	SELECT COALESCE(SUM(rao.rebate_actual), 0.00)
		FROM rebate_agent rao, rebate_bill rb
	 WHERE rao.rebate_bill_id = rb.id
		 AND rao.settlement_state = 'next_lssuing'
		 AND rb.end_time <= p_end_time
		 AND rao.rebate_bill_id > (
			 SELECT COALESCE(MAX(rebate_bill_id), 0)
				 FROM rebate_agent rai
				WHERE rai.settlement_state <> 'next_lssuing'
					AND rai.agent_id = rao.agent_id
		 ) INTO f_expense_leaving;
*/
	SELECT COALESCE(SUM(ra.history_apportion), 0.00)
		FROM rebate_agent ra, rebate_bill rb
	 WHERE ra.rebate_bill_id = rb.id
		 AND ra.settlement_state <> 'next_lssuing'
		 AND rb.start_time >= p_end_time
		 AND rb.end_time <= p_end_time
	  INTO f_expense_leaving;

	leaving_map := (SELECT ('expense_leaving=>'||f_expense_leaving)::hstore);

	RETURN leaving_map;
END;

$$ LANGUAGE 'plpgsql';
COMMENT ON FUNCTION gamebox_expense_leaving(p_start_time timestamp, p_end_time timestamp)
IS 'Leisure-返佣——上期未结费用';

/**
 * 分摊费用
 * @author Lins
 * @date 2015.11.13
 * @param 	start_time 	开始时间
 * @param 	end_time 	结束时间
 * @return 	返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
**/
drop function if exists gamebox_expense_map(TIMESTAMP, TIMESTAMP, hstore);
create or replace function gamebox_expense_map(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	sys_map 	hstore
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-其它费用.外调
--v1.01  2016/06/09  Leisure  增加上期未结费用计算
--v1.02  2016/06/15  Leisure  调整返回值
*/
DECLARE
	cost_map 	hstore;
	share_map 	hstore;
	leaving_map		hstore; --v1.01  2016/06/29  Leisure
	sid INT;
BEGIN
	SELECT gamebox_expense_gather(start_time, end_time) INTO cost_map;

	SELECT gamebox_expense_share(cost_map, sys_map) INTO share_map;

	--v1.01  2016/06/29  Leisure
	SELECT gamebox_expense_leaving(start_time, end_time) INTO leaving_map;


	SELECT gamebox_current_site() INTO sid;
	--share_map = (SELECT ('site_id=>'||sid)::hstore)||share_map;

	--raise info 'cost_map : %, share_map : % , leaving_map, %', cost_map, share_map, leaving_map;

	RETURN (SELECT ('site_id=>'||sid)::hstore)||cost_map||share_map||leaving_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_map(start_time TIMESTAMP, end_time TIMESTAMP, sys_map hstore)
IS 'Lins-返佣-其它费用.外调';

/**
 * 分摊费用与返佣统计
 * @author 	Lins
 * @date 	2015.11.13
 * @param  	bill_id 		返佣主表键值
 * @param 	start_time 		开始时间
 * @param 	end_time		结束时间
 * @param 	row_split
 * @param 	col_split 		列分隔符
 * @return 	返回hstore类型, 以代理ID为KEY值.各种费用按一定格式组成VALUE。
**/
--drop function if exists gamebox_rebate_expense_gather(int, hstore, TIMESTAMP, TIMESTAMP, text, text);
--drop function if exists gamebox_rebate_expense_gather(int, hstore, TIMESTAMP, TIMESTAMP, text, text, text);
drop function if exists gamebox_rebate_expense_gather(INT, TIMESTAMP, TIMESTAMP, TEXT, TEXT, TEXT);
create or replace function gamebox_rebate_expense_gather(
	bill_id 		INT,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	row_split 		TEXT,
	col_split 		TEXT,
	flag 			TEXT
) returns hstore as $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返佣-分摊费用与返佣统计
--v1.01  2016/05/12  Leisure  对于有优惠而没有返佣的玩家，需要计算其最终佣金（佣金-费用）
--v1.02  2016/10/03  Leisure  分摊费用条件更新；时间由create_time改为completion_time
*/
DECLARE
	rec 		record;
	hash 		hstore;
	mhash 		hstore;
	param 		text:='';
	user_id 	text:='';
	money 		float:=0.00;
	loss 		FLOAT:=0.00;

	agent_id 	INT;
	agent_name 	TEXT:='';
	tbl 		TEXT:='rebate_api';
	tbl_id 		TEXT:='rebate_bill_id';
	sqld 		TEXT;

	eff_trans 	FLOAT:=0.00;
BEGIN

	SELECT gamebox_expense_gather(start_time, end_time, row_split, col_split) INTO hash;

	IF flag = 'N' THEN
		tbl = 'rebate_api_nosettled';
		tbl_id = 'rebate_bill_nosettled_id';
	END IF;
	/*
	sqld = 'SELECT ra.player_id,
			   su.owner_id,
			   sa.username,
			   ra.rebate_total,
			   ra.effective_transaction,
			   ra.profit_loss
		  FROM (SELECT player_id,
		  			   sum(rebate_total) 			as rebate_total,
		  			   sum(effective_transaction)  	as effective_transaction,
		  			   sum(profit_loss)  			as profit_loss
				  FROM '||tbl||'
				 WHERE '||tbl_id||'='||bill_id||'
				 GROUP BY player_id) ra,
			   sys_user su,
			   sys_user sa
		 WHERE ra.player_id = su.id
		   AND su.owner_id  = sa.id
		   AND su.user_type = ''24''
		   AND sa.user_type = ''23''';
	*/

	sqld =
	'SELECT ra.player_id,
	        su.owner_id,
	        sa.username,
	        ra.rebate_total,
	        ra.effective_transaction,
	        ra.profit_loss
	   FROM (SELECT player_id,
	                sum(rebate_total) 			as rebate_total,
	                sum(effective_transaction)  	as effective_transaction,
	                sum(profit_loss)  			as profit_loss
	           FROM (SELECT player_id,
	                        rebate_total,
	                        effective_transaction,
	                        profit_loss
	                   FROM '||tbl||'
	                  WHERE '||tbl_id||'='||bill_id||'
	                 UNION ALL
	                 SELECT player_id,
	                        0.00	as rebate_total,
	                        0.00	as effective_transaction,
	                        0.00	as profit_loss
	                   FROM player_transaction
	                  WHERE status = ''success''
	                    --v1.02  2016/10/03  Leisure
	                    --AND (fund_type in (''backwater'', ''refund_fee'', ''favourable'', ''recommend'') OR
	                    --    (fund_type = ''artificial_deposit'' AND transaction_type = ''favorable''))
	                    --AND create_time >= ''' || start_time || '''
	                    --AND create_time < ''' || end_time || '''
	                    AND transaction_type IN (''favorable'', ''recommend'', ''backwater'')
	                    AND completion_time >= ''' || start_time || '''
	                    AND completion_time < ''' || end_time || '''
	                ) rebate_union
	          GROUP BY player_id
	         ) ra,
	         sys_user su,
	         sys_user sa
	  WHERE ra.player_id = su.id
	    AND su.owner_id  = sa.id
	    AND su.user_type = ''24''
	    AND sa.user_type = ''23''';

	--统计各代理返佣.
	FOR rec IN EXECUTE sqld

	LOOP
		user_id 	= rec.player_id::text;
		agent_id 	= rec.owner_id;
		agent_name 	= rec.username;
		money 		= rec.rebate_total;
		loss 		= rec.profit_loss;
		eff_trans 	= rec.effective_transaction;

		IF isexists(hash, user_id) THEN
			param = hash->user_id;
			param = param||row_split||'rebate'||col_split||money::text;
			param = param||row_split||'profit_loss'||col_split||loss::text;
			param = param||row_split||'effective_transaction'||col_split||eff_trans::text;
			param = param||row_split||'agent_name'||col_split||agent_name;
		ELSE
			param = 'rebate'||col_split||money::text;
			param = param||row_split||'profit_loss'||col_split||loss::text;
			param = param||row_split||'effective_transaction'||col_split||eff_trans::text;
			param = param||row_split||'agent_name'||col_split||agent_name;
		END IF;
		IF position('agent_id' in param) = 0 THEN
			param = param||row_split||'agent_id'||col_split||agent_id::text;
		END IF;

		SELECT user_id||'=>'||param INTO mhash;
		IF hash is null THEN
			hash = mhash;
		ELSE
			hash = hash||mhash;
		END IF;

	END LOOP;
	raise info '统计当前周期内各代理的各种费用信息.完成';

	RETURN hash;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION gamebox_rebate_expense_gather(bill_id INT, startTime TIMESTAMP, endTime TIMESTAMP, row_split_char TEXT, col_split_char TEXT, flag TEXT)
IS 'Lins-返佣-分摊费用与返佣统计';

/**
 * 分摊费用
 * @author 	Lins
 * @date 	2015.11.13
 * @param	start_time 	开始时间
 * @param	end_time 	结束时间
 * @param	row_split 	行分隔符
 * @param	col_split 	列分隔符
 * 返回hstore类型,以玩家ID为KEY值.各种费用按一定格式组成VALUE。
**/
drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, text, text);
create or replace function gamebox_expense_gather(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	row_split 	text,
	col_split 	text
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：返佣--分摊费用
--v1.01  2016/05/12  Leisure  修正统计优惠信息的条件（返佣）
--v1.02  2016/06/06  Leisure  公司存款、线上支付增加微信、支付宝存款、支付
--v1.03  2016/10/03  Leisure  调整player_transaction金额类型的判断方法；
                              时间由create_time改为completion_time
--v1.04  2016/10/08  Leisure  更新分摊费用的计算，改为returning防并发
*/
DECLARE
	rec 		record;
	hash 		hstore;
	mhash 		hstore;
	param 		text:='';
	user_id 	text:='';
	money 		float:=0.00;

BEGIN
	/*--v1.03  2016/10/03  Leisure
		FOR rec IN
		SELECT pt.*, su.owner_id
		  FROM (SELECT player_id,
		               fund_type,
		               SUM(transaction_money) as transaction_money
		          FROM (SELECT player_id,
		                       fund_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND fund_type in ('backwater', 'refund_fee', 'artificial_deposit',
		                                     'artificial_withdraw', 'player_withdraw')
		                   AND create_time >= start_time
		                   AND create_time < end_time
		                   AND NOT (fund_type = 'artificial_deposit' AND
		                            transaction_type = 'favorable')

		                UNION ALL
		                --优惠、推荐
		                SELECT player_id,
		                       --fund_type||transaction_type,
		                       'favourable' fund_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND (fund_type = 'favourable' OR
		                        fund_type = 'recommend'  OR
		                        (fund_type = 'artificial_deposit' AND transaction_type = 'favorable'))
		                   AND create_time >= start_time
		                   AND create_time < end_time

		                UNION ALL
		                --公司存款 --v1.02  2016/06/06  Leisure
		                SELECT player_id,
		                       --fund_type||transaction_type,
		                       'company_deposit' fund_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND fund_type IN ('company_deposit','wechatpay_fast' ,'alipay_fast')
		                   AND create_time >= start_time
		                   AND create_time < end_time

		                UNION ALL
		                --线上支付 --v1.02  2016/06/06  Leisure
		                SELECT player_id,
		                       --fund_type||transaction_type,
		                       'online_deposit' fund_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND fund_type IN ('online_deposit','wechatpay_scan' ,'alipay_scan')
		                   AND create_time >= start_time
		                   AND create_time < end_time
		               ) ptu
		         GROUP BY player_id, fund_type
		       ) pt
		       LEFT JOIN
		       sys_user su ON pt.player_id = su."id"
		 WHERE su.user_type = '24'
	LOOP
	*/
	FOR rec IN
		SELECT pt.*, su.owner_id
		  FROM (SELECT player_id,
		               transaction_type,
		               SUM(transaction_money) as transaction_money
		          FROM (--存款
		                SELECT player_id,
		                       'deposit' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND transaction_type = 'deposit'
		                   AND (fund_type <> 'artificial_deposit' OR transaction_way = 'manual_deposit')
		                   AND completion_time >= start_time
		                   AND completion_time < end_time

		                UNION ALL
		                --取款
		                SELECT player_id,
		                       'withdrawal' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND transaction_type = 'withdrawals'
		                   AND (fund_type <> 'artificial_withdraw' OR transaction_way = 'manual_deposit')
		                   AND completion_time >= start_time
		                   AND completion_time < end_time

		                UNION ALL
		                --优惠
		                SELECT player_id,
		                       'favorable' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND (transaction_type = 'favorable'
		                        AND fund_type <> 'refund_fee'
		                        AND transaction_way <> 'manual_rakeback')
		                   AND completion_time >= start_time
		                   AND completion_time < end_time

		                UNION ALL
		                --推荐
		                SELECT player_id,
		                       'recommend' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND transaction_type = 'recommend'
		                   AND completion_time >= start_time
		                   AND completion_time < end_time

		                UNION ALL
		                --返水
		                SELECT player_id,
		                       'backwater' AS transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND (transaction_type = 'backwater' OR
		                        (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))
		                   AND completion_time >= start_time
		                   AND completion_time < end_time

		                UNION ALL
		                --返手续费
		                SELECT player_id,
		                       'refund_fee' transaction_type,
		                       transaction_money
		                  FROM player_transaction
		                 WHERE status = 'success'
		                   AND fund_type = 'refund_fee'
		                   AND completion_time >= start_time
		                   AND completion_time < end_time
		               ) ptu
		         GROUP BY player_id, transaction_type
		       ) pt
		       LEFT JOIN
		       sys_user su ON pt.player_id = su."id"
		 WHERE su.user_type = '24'
	LOOP
		user_id = rec.player_id::text;
		money 	= rec.transaction_money;
		IF isexists(hash, user_id) THEN
			param = hash->user_id;
			param = param||row_split||rec.transaction_type||col_split||money::text;
		ELSE
			param = rec.transaction_type||col_split||money::text;
		END IF;

		IF position('agent_id' IN param) = 0  THEN
			param = param||row_split||'agent_id'||col_split||rec.owner_id::TEXT;
		END IF;

		SELECT user_id||'=>'||param into mhash;
		IF hash is null THEN
			hash = mhash;
		ELSE
			hash = hash||mhash;
		END IF;
	END LOOP;

	return hash;
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP, row_split text, col_split text)
IS 'Lins-分摊费用';

/*
--测试返佣已出账
SELECT * FROM gamebox_rebate (
	'1',
	'2016-03-01',
	'2016-03-31',
	'host=192.168.0.88 dbname=gb-companies user=gb-companies password=postgres',
	'Y'
);

--测试返佣未出账
SELECT * FROM gamebox_rebate (
	'1',
	'2016-03-01',
	'2016-03-31',
	'host=192.168.0.88 dbname=gb-companies user=gb-companies password=postgres',
	'N'
);

SELECT * FROM gamebox_rebate_map (
	'host=192.168.0.88 dbname=gb-companies user=gb-companies password=postgres',
	'2016-03-01',
	'2016-03-31',
	'AGENT'
);
*/
