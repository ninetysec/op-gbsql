-- auto gen by cherry 2017-06-05 21:28:14
DROP FUNCTION IF EXISTS "f_agent_rebate"(p_stat_month text, p_start_time text, p_end_time text, p_api_type_relation_json text, p_com_url text);

CREATE OR REPLACE FUNCTION "f_agent_rebate"(p_stat_month text, p_start_time text, p_end_time text, p_api_type_relation_json text, p_com_url text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/03/03  younger   创建此函数: 返佣结算账单-入口
  -- p_stat_month 统计月份
  -- p_start_time 统计开始时间
  -- p_end_time 统计结束时间
  -- p_api_type_relation_json API返佣排序
  --生成JSON串语句：
  --SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT api_id, api_type_id,rebate_order_num FROM api_type_relation ORDER BY rebate_order_num ) t
  --运行函数
  --SELECT f_agent_rebate('2017-02','2017-01-31 16:00:00','2017-02-28 16:00:00','','host=192.168.0.88 port=5432 dbname=gb-companies user=gb-companies password=postgres')
  --SELECT f_agent_rebate('2017-02','2017-01-31 16:00:00','2017-02-28 16:00:00','','host=postgres-boss port=5432 dbname=gb-companies user=gb-companies password=postgres');
*/
DECLARE

  t_start_time   TIMESTAMP;--查询开始时间
  t_end_time   TIMESTAMP;--查询结束时间
  t_start_date DATE;
  t_end_date DATE;
  v_last_rebate_month VARCHAR;
  b_need_history_count BOOLEAN :=false;--是否需要累计
  p_year INT :=0; --统计年
  p_month INT :=0;--统计月
  p_last_year INT :=0;--上期统计年
  p_last_month INT :=0;--上期统计月
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
    raise notice '统计月分为空';
    RETURN '统计月分为空';
  END IF;

  IF (p_api_type_relation_json is null or p_api_type_relation_json = '') AND (p_com_url is null or p_com_url = '') THEN
    raise notice 'API返佣顺序数据为空';
    RETURN 'API返佣顺序数据为空';
  END IF;

  IF p_api_type_relation_json is null or p_api_type_relation_json = '' THEN
    raise notice 'API返佣顺序数据为空,从URL获取';
    v_temp_sql = 'SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT api_id, api_type_id,rebate_order_num FROM api_type_relation ORDER BY rebate_order_num ) t';
    FOR unsettled IN
      SELECT * FROM dblink(p_com_url,v_temp_sql) as unsettled_temp(v_api_json VARCHAR)
    LOOP
      p_api_type_relation_json = unsettled.v_api_json;
    END LOOP;
  END IF;

  raise notice 'p_api_type_relation_json： %', p_api_type_relation_json;

  --拆分统计年月
  --SELECT substring(p_stat_month FROM 1 FOR 4) INTO p_year;
  --SELECT substring(p_stat_month FROM 6 FOR 7) INTO p_month;
  p_year = substr(p_stat_month, 1, 4);
  p_month = substr(p_stat_month, 6, 2);

  --上月
  --SELECT to_char(to_date(p_stat_month,'yyyy-mm')+ interval '-1 months','yyyy-mm') INTO v_last_rebate_month;
  v_last_rebate_month = to_date(p_stat_month,'yyyy-mm')+ interval '-1 month';
  --拆分上期统计年月
  IF v_last_rebate_month is not null AND v_last_rebate_month <> '' then
    --SELECT substring(v_last_rebate_month FROM 1 FOR 4) INTO p_last_year;
    --SELECT substring(v_last_rebate_month FROM 6 FOR 7) INTO p_last_month;
    p_last_year = substr(v_last_rebate_month, 1, 4);
    p_last_month = substr(v_last_rebate_month, 6, 2);
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
    DELETE FROM agent_rebate_player WHERE rebate_year=p_year AND rebate_month=p_month AND agent_id in (SELECT agent_id FROM agent_rebate WHERE rebate_year=p_year AND rebate_month=p_month AND rebate_status in('0','1'));
    DELETE FROM agent_rebate_grads WHERE rebate_year=p_year AND rebate_month=p_month AND agent_id in (SELECT agent_id FROM agent_rebate WHERE rebate_year=p_year AND rebate_month=p_month AND rebate_status in('0','1'));
    DELETE FROM agent_rebate WHERE rebate_year=p_year AND rebate_month=p_month AND rebate_status in('0','1');

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
    SELECT p_year,p_month,d.id topagent_id,d.username topagentusername,c.id agent_id,c.username agentusername,player_id user_id,b.username username,
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
      SELECT * FROM sys_user WHERE user_type='23' AND status IN ('1','3') AND id not IN (SELECT agent_id FROM agent_rebate WHERE rebate_year=p_year AND rebate_month=p_month)
    LOOP

      --是否需要累计
      SELECT rebate_status FROM agent_rebate WHERE rebate_year = p_last_year AND rebate_month = p_last_month AND agent_id=rec_agent.id INTO v_rebate_status;
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
              (SELECT (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) FROM agent_rebate WHERE agent_id = rec_agent.id AND rebate_year = p_last_year AND rebate_month = p_last_month)
              ELSE 0 END),0) payout_amount_history,
            --当期派彩、
            COALESCE((SELECT -sum(COALESCE(profit_loss,0)) FROM operate_agent oa WHERE oa.agent_id = rec_agent.id AND oa.static_date>=t_start_date AND oa.static_date<t_end_date),0) payout_amount,
            --累积有效投注额、
            COALESCE((CASE WHEN b_need_history_count THEN (
                (SELECT (COALESCE(effective_amount_history,0)+COALESCE(effective_amount,0)) FROM agent_rebate WHERE agent_id = rec_agent.id AND rebate_year = p_last_year AND rebate_month = p_last_month)
              ) ELSE 0 END),0) effective_amount_history,
            --当期有效投注额、
            COALESCE((SELECT sum(COALESCE(effective_transaction,0)) FROM operate_agent oa WHERE oa.agent_id = rec_agent.id AND oa.static_date>=t_start_date AND oa.static_date<t_end_date),0) effective_amount,
            --累积行政费用(上一期的累积费用+上一期当期费用)
            COALESCE((CASE WHEN b_need_history_count THEN
                (SELECT (COALESCE(fee_amount_history,0)+COALESCE(fee_amount,0)) history_fee FROM agent_rebate WHERE rebate_year = p_last_year AND rebate_month = p_last_month AND agent_id=rec_agent.id)
              ELSE 0 END),0) fee_amount_history,
            --累积存款优惠
            COALESCE((CASE WHEN b_need_history_count THEN
                (SELECT (COALESCE(favorable_amount_history,0)+COALESCE(favorable_amount,0)) history_favorable FROM agent_rebate WHERE rebate_year = p_last_year AND rebate_month = p_last_month AND agent_id=rec_agent.id)
              ELSE 0 END),0) favorable_amount_history,
            --累积返水优惠
            COALESCE((CASE WHEN b_need_history_count THEN
                (SELECT (COALESCE(rakeback_amount_history,0)+COALESCE(rakeback_amount,0)) history_rakeback FROM agent_rebate WHERE rebate_year = p_last_year AND rebate_month = p_last_month AND agent_id=rec_agent.id)
              ELSE 0 END),0) rakeback_amount_history,
            --累积其他费用
            COALESCE((CASE WHEN b_need_history_count THEN
                (SELECT (COALESCE(other_amount_history,0)+COALESCE(other_amount,0)) FROM agent_rebate WHERE rebate_year = p_last_year AND rebate_month = p_last_month AND agent_id=rec_agent.id)
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
      WHERE rebate_year = p_year
        AND rebate_month = p_month
        AND agent_id = rec_agent.id
      GROUP BY topagent_id,topagentusername,agent_id,agentusername,rebate_year,rebate_month;

    --4、计算代理各api的总派彩(即生成agent_rebate_grads)
    --当期派彩，从player_game_order直接统计
    --累积派彩，需要看下上一期的返佣账单的状态是否需要累积，需要累积的话，等于上一期的累积派彩+上一期的当期派彩
    /*
    INSERT INTO agent_rebate_grads(
      rebate_year,rebate_month,topagent_id,topagentusername,agent_id,agentusername,api_id,api_type_id,payout_amount_history,payout_amount,radio
    )
    SELECT p_year,p_month,topagent_id,topagent_name,agent_id,agent_name,api_id,api_type_id,
           COALESCE(
            (CASE
             WHEN b_need_history_count THEN
             (SELECT (COALESCE(payout_amount_history,0)+COALESCE(payout_amount,0)) FROM agent_rebate_grads arg WHERE rebate_year = p_last_year AND rebate_month = p_last_month AND agent_id=oa.agent_id AND arg.api_id=oa.api_id AND arg.api_type_id = oa.api_type_id
             )
             ELSE 0 END),0) payout_amount_history ,
      SUM(-COALESCE(profit_loss,0)) payout_amount,
      COALESCE((SELECT ratio FROM rebate_grads_api WHERE rebate_grads_id = n_agent_grads_id AND api_id=oa.api_id AND api_type_id=oa.api_type_id),0) radio
      FROM operate_player oa WHERE static_date>=t_start_date AND static_date < t_end_date AND agent_id=rec_agent.id GROUP BY topagent_id,topagent_name,agent_id,agent_name,api_id,api_type_id;
    */
    INSERT INTO agent_rebate_grads (
      rebate_year, rebate_month, agent_id, agentusername, topagent_id, topagentusername, api_id, api_type_id, payout_amount_history, payout_amount, radio
    )
    SELECT p_year, p_month,
           arg.agent_id, ua.username agent_name, ut.id topagent_id, ut.username topagent_name,
           arg.api_id, arg.api_type_id, arg.payout_amount_history, arg.payout_amount, rga.ratio
      FROM
    (SELECT COALESCE(op.agent_id, argi.agent_id) agent_id,
            COALESCE(op.api_id, argi.api_id) api_id,
            COALESCE(op.api_type_id, argi.api_type_id) api_type_id,
            COALESCE(payout_amount_history, 0) payout_amount_history,
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
     WHERE rebate_year = p_last_year AND rebate_month = p_last_month AND agent_id = rec_agent.id
    ) argi
    ON argi.agent_id=op.agent_id AND argi.api_id=op.api_id AND argi.api_type_id = op.api_type_id
    ) arg
    LEFT JOIN rebate_grads_api rga ON rebate_grads_id = n_agent_grads_id AND arg.api_id=rga.api_id AND arg.api_type_id = rga.api_type_id
    LEFT JOIN sys_user ua ON arg.agent_id = ua."id" AND ua.user_type = '23'
    LEFT JOIN sys_user ut ON ua.owner_id = ut."id" AND ut.user_type = '22'
    ;

      v_temp_sql='SELECT * FROM agent_rebate WHERE rebate_year ='|| p_year ||' AND rebate_month ='|| p_month ||' AND agent_id ='|| rec_agent.id;
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
            SELECT json_array_elements(p_api_type_relation_json::json)
        LOOP
            SELECT v_api_json::json->>'api_id' INTO n_api_id;
            SELECT v_api_json::json->>'api_type_id' INTO n_api_type_id;
            SELECT v_api_json::json->>'rebate_order_num' INTO n_rebate_order_num;
            --raise notice 'n_api_id % n_api_type_id %', n_api_id,n_api_type_id;
            FOR rec_api_grads IN
                SELECT * FROM agent_rebate_grads WHERE rebate_year = p_year AND rebate_month = p_month AND radio is not null AND radio>0 AND agent_id = rec_api_rebate.agent_id
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

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "f_agent_rebate"(p_stat_month text, p_start_time text, p_end_time text, p_api_type_relation_json text, p_com_url text) IS 'younger-返佣结算账单-入口';