-- auto gen by cherry 2017-09-20 21:11:33
DROP FUNCTION IF EXISTS f_agent_rebate(p_stat_month text, p_start_time text, p_end_time text, p_api_type_order_json text, p_com_url text);
CREATE OR REPLACE FUNCTION f_agent_rebate(p_stat_month text, p_start_time text, p_end_time text, p_api_type_order_json text, p_com_url text)
  RETURNS varchar AS $BODY$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/03/03  younger  创建此函数: 返佣结算账单-入口
--v1.10  2017/03/30  Leisure  修复上月无相应gametype数据时本期无法累加等bug
--v1.11  2017/06/05  Leisure  修复重跑会删除已结记录的bug，改由operate_agent统计
--v1.12  2017/07/26  Leisure  增加状态码，("4", "挂账")，累积的条件由0、1改为4

  -- p_stat_month 统计月份
  -- p_start_time 统计开始时间
  -- p_end_time 统计结束时间
  -- p_api_type_order_json API返佣排序
  --生成JSON串语句：
  --SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT api_id, api_type_id, rebate_order_num FROM api_type_relation ORDER BY rebate_order_num ) t
  --运行函数
  --SELECT f_agent_rebate('2017-02','2017-01-31 16:00:00','2017-02-28 16:00:00','','url');

  --rebate_status: ("0", "未处理"), ("1", "未达到门坎"), ("2", "清除"), ("3", "已结算"), ("4", "挂账");
*/
DECLARE

  t_start_time   TIMESTAMP;--查询开始时间
  t_end_time   TIMESTAMP;--查询结束时间
  t_start_date DATE;
  v_last_rebate_month VARCHAR;
  t_end_date DATE;
  b_need_history_count BOOLEAN :=false;--是否需要累计
  n_year INT :=0; --统计年
  n_month INT :=0;--统计月
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
  n_remain_fee numeric(20,2) :=0;--剩余费用
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

    PERFORM dblink_connect_u('mainsite', p_com_url);
    FOR unsettled IN
      SELECT * FROM dblink('mainsite', v_temp_sql) as unsettled_temp(v_api_json VARCHAR)
    LOOP
      p_api_type_order_json = unsettled.v_api_json;
    END LOOP;
    perform dblink_disconnect('mainsite');
  END IF;

  --raise notice 'p_api_type_order_json： %', p_api_type_order_json;

  --拆分统计年月
  --SELECT substring(p_stat_month FROM 1 FOR 4) INTO n_year;
  --SELECT substring(p_stat_month FROM 6 FOR 7) INTO n_month;
  n_year = substr(p_stat_month, 1, 4);
  n_month = substr(p_stat_month, 6, 2);

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
  --v1.11  2017/06/05  Leisure
  --DELETE FROM agent_rebate_player WHERE rebate_year=n_year AND rebate_month=n_month;
  --DELETE FROM agent_rebate_grads WHERE rebate_year=n_year AND rebate_month=n_month;
  --DELETE FROM agent_rebate WHERE rebate_year=n_year AND rebate_month=n_month;

  --仅删除未进行任何操作的数据
  --rebate_status: ("0", "未处理"), ("1", "未达到门坎"), ("2", "清除"), ("3", "已结算"), ("4", "挂账");
  DELETE FROM agent_rebate_player WHERE rebate_year=n_year AND rebate_month=n_month AND agent_id IN (SELECT agent_id FROM agent_rebate WHERE rebate_year=n_year AND rebate_month=n_month AND rebate_status in('0','1'));
  DELETE FROM agent_rebate_grads WHERE rebate_year=n_year AND rebate_month=n_month AND agent_id IN (SELECT agent_id FROM agent_rebate WHERE rebate_year=n_year AND rebate_month=n_month AND rebate_status in('0','1'));
  DELETE FROM agent_rebate WHERE rebate_year=n_year AND rebate_month=n_month AND rebate_status IN ('0','1');

--2、计算代理的承担费用（即生成agent_rebate_player）
  --SELECT CASE WHEN param_value is NULL THEN default_value ELSE param_value END FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.deposit.fee' INTO n_deposit_radio;
  --SELECT CASE WHEN param_value is NULL THEN default_value ELSE param_value END FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.withdraw.fee' INTO n_withdraw_radio;
  SELECT COALESCE(param_value, default_value) FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.deposit.fee' INTO n_deposit_radio;
  SELECT COALESCE(param_value, default_value) FROM sys_param WHERE param_type = 'rebateSetting' AND param_code='settlement.withdraw.fee' INTO n_withdraw_radio;

  --插入代理返佣_玩家费用表
  INSERT INTO agent_rebate_player (
    rebate_year,rebate_month,topagent_id,topagentusername,agent_id,agentusername,user_id,username,deposit_amount,
    deposit_radio,withdraw_amount,withdraw_radio,rakeback_amount,favorable_amount,recommend_amount
  )
  SELECT n_year,n_month,d.id topagent_id,d.username topagentusername,c.id agent_id,c.username agentusername,player_id user_id,b.username username,
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
    SELECT * FROM sys_user WHERE user_type='23' AND status IN ('1','3') AND id not IN (SELECT agent_id FROM agent_rebate WHERE rebate_year=n_year AND rebate_month=n_month)
  LOOP

    --是否需要累计
    --v1.12  2017/07/26  Leisure
    SELECT rebate_status FROM agent_rebate WHERE rebate_year = v_last_year AND rebate_month = v_last_month AND agent_id=rec_agent.id INTO v_rebate_status;
    --IF v_rebate_status='1' or v_rebate_status='4' THEN
    IF v_rebate_status='4' THEN
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
           --当期派彩
           COALESCE((SELECT -sum(COALESCE(profit_loss,0)) FROM operate_agent oa WHERE oa.agent_id = rec_agent.id AND oa.static_date>=t_start_date AND oa.static_date<t_end_date),0) payout_amount,
           --累积有效投注额
           COALESCE((CASE WHEN b_need_history_count THEN (
               (SELECT (COALESCE(effective_amount_history,0)+COALESCE(effective_amount,0)) FROM agent_rebate WHERE agent_id = rec_agent.id AND rebate_year = v_last_year AND rebate_month = v_last_month)
             ) ELSE 0 END),0) effective_amount_history,
           --当期有效投注额
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
     WHERE rebate_year = n_year
       AND rebate_month = n_month
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
    SELECT n_year,n_month,topagent_id,topagent_name,agent_id,agent_name,api_id,api_type_id,
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
    SELECT n_year, n_month,
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
          FROM operate_agent --v1.01  2017/06/05  Leisure
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

    v_temp_sql='SELECT * FROM agent_rebate WHERE rebate_status IN (''0'', ''1'') AND rebate_year ='|| n_year ||' AND rebate_month ='|| n_month ||' AND agent_id ='|| rec_agent.id;
    --raise notice 'v_temp_sql： %',v_temp_sql;
    open cur_agent_rebate FOR execute v_temp_sql;
    FETCH cur_agent_rebate INTO rec_api_rebate;
    IF rec_api_rebate is null THEN
      close cur_agent_rebate;
      CONTINUE;
    END IF;

    --初始数据
    n_fee_amount = 0;
    n_remain_fee = 0;
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
            SELECT * FROM agent_rebate_grads WHERE rebate_year = n_year AND rebate_month = n_month AND radio is not null AND radio>0 AND agent_id = rec_api_rebate.agent_id
        LOOP
            IF n_api_id = rec_api_grads.api_id AND n_api_type_id = rec_api_grads.api_type_id THEN
                IF idx > 0 THEN
                  n_fee_amount = n_remain_fee;--承担费用
                ELSEIF idx = 0 THEN
                  n_remain_fee = n_fee_amount;
                END IF;
                n_payout_total = rec_api_grads.payout_amount_history + rec_api_grads.payout_amount;--当前api总派彩
                --如果总派彩大于０，即需要扣掉代理承担费用，反之剩余派彩等于总派彩
                IF n_payout_total >= 0 THEN
                  n_remain_fee = n_payout_total - n_fee_amount;
                  --如果剩余费用小于０，则剩余派彩为０,剩余承担费用也是０，反之等于总派彩－当前承担费用
                  IF n_remain_fee < 0 THEN
                    n_remain_payout = 0;
                    n_remain_fee=-n_remain_fee;
                  ELSE
                    n_remain_payout = n_remain_fee;
                    n_remain_fee = 0;
                  END IF;
                ELSE
                  n_remain_payout = n_payout_total;
                END IF;

                update agent_rebate_grads set expense_amount = n_fee_amount,rebate_order_num = n_rebate_order_num,remain_expense_amount=n_remain_fee,remain_payout_amount=n_remain_payout  WHERE id = rec_api_grads.id;
                n_fee_total = n_fee_total + n_remain_payout * rec_api_grads.radio/100;
                idx = idx + 1;
            END IF;
        END LOOP;    --循环API
    END LOOP;--循环排序的API
    --raise notice '总费用为 % ，剩余承担费用为 %， 所以代理 % 的最终返佣费用为 %', n_fee_total,n_remain_fee,rec_api_rebate.agentusername,n_fee_total - n_remain_fee;
    IF n_remain_fee>0 THEN
      n_fee_total = n_fee_total - n_remain_fee;
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


drop function IF EXISTS gamebox_collect_site_infor(text, int);
create or replace function gamebox_collect_site_infor(
  hostinfo   text,
  site_id   int
) returns json as $$
declare
  rec record;
BEGIN
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-收集站点相关信
--v1.10  2017/07/01  Leisure  修改DBLINK的连接方式
*/
  --v1.10  2017/07/01  Leisure
  perform dblink_connect_u('mainsite', hostinfo);

  SELECT into rec * FROM
  dblink (
    'mainsite',  -- hostinfo, --v1.01  2017/07/01  Leisure
    'SELECT * from v_sys_site_info WHERE siteid='||site_id||''
  ) AS s (
    siteid     int4,    --站点ID
    sitename   VARCHAR,    --站点名称
    masterid   int4,    --站长ID
    mastername   VARCHAR,    --站长名称
    usertype   VARCHAR,    --用户类型
    subsyscode   VARCHAR,
    operationid int4,    --运营商ID
    operationname     VARCHAR,    --运营商名称
    operationusertype   VARCHAR,
    operationsubsyscode VARCHAR
  );

  perform dblink_disconnect('mainsite');

  IF FOUND THEN
    return row_to_json(rec);
  ELSE
    return (SELECT '{"siteid": -1}'::json);
  END IF;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_collect_site_infor(hostinfo text,site_id int)
IS 'Lins-经营报表-收集站点相关信息';


DROP FUNCTION IF EXISTS gamebox_operations_player(TEXT, TEXT, TEXT, JSON);
CREATE OR REPLACE FUNCTION gamebox_operations_player(
  start_time   TEXT,
  end_time   TEXT,
  curday     TEXT,
  rec     JSON
) RETURNS text AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-玩家报表
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.03  2016/06/13  Leisure  is_profit_loss=false的记录也需要统计by acheng
--v1.04  2016/06/27  Leisure  统计时间由bet_time改为payout_time --by acheng
--v1.05  2016/07/08  Leisure  优化输出日志
--v1.05  2016/10/05  Leisure  撤销v1.03的修改 by kitty
--v1.06  2017/02/05  Leisure  删除is_profit_loss = TRUE条件
*/
DECLARE
  rtn     text:='';
  n_count    INT:=0;
  site_id   INT;
  master_id   INT;
  center_id   INT;
  site_name   TEXT:='';
  master_name TEXT:='';
  center_name TEXT:='';
  d_static_date DATE; --v1.02  2016/05/31
BEGIN
  --v1.02  2016/05/31  Leisure
  d_static_date := to_date(curday, 'YYYY-MM-DD');

  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
  --delete from operate_player WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
  delete from operate_player WHERE static_date = d_static_date;

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice '本次删除记录数 %', n_count;
  rtn = rtn||'|执行完毕,删除记录数: '||n_count||' 条||';

  --开始执行玩家经营报表信息收集
  site_id   = COALESCE((rec->>'siteid')::INT, -1);
  site_name  = COALESCE(rec->>'sitename', '');
  master_id  = COALESCE((rec->>'masterid')::INT, -1);
  master_name  = COALESCE(rec->>'mastername', '');
  center_id  = COALESCE((rec->>'operationid')::INT, -1);
  center_name  = COALESCE(rec->>'operationname', '');

  raise info '开始日期:%, 结束日期:%', start_time, end_time;
  INSERT INTO operate_player(
    center_id, center_name, master_id, master_name,
    site_id, site_name, topagent_id, topagent_name,
    agent_id, agent_name, player_id, player_name,
    api_id, api_type_id, game_type,
    --static_time, create_time, --v1.02  2016/05/31  Leisure
    static_date, static_time, static_time_end, create_time,
    transaction_order, transaction_volume, effective_transaction, profit_loss
    ) SELECT
        center_id, center_name, master_id, master_name,
        site_id, site_name, u.topagent_id, u.topagent_name,
        u.agent_id, u.agent_name, u.id, u.username,
        p.api_id, p.api_type_id, p.game_type,
        --now(), now(), --v1.02  2016/05/31  Leisure
        d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
        p.transaction_order, p.transaction_volume, p.effective_transaction, p.profit_loss
        FROM (SELECT
                player_id, api_id, api_type_id, game_type,
                COUNT(order_no)                as transaction_order,
                SUM(COALESCE(single_amount, 0.00))      as transaction_volume,
                SUM(COALESCE(profit_amount, 0.00))      as profit_loss,
                SUM(COALESCE(effective_trade_amount, 0.00)) as effective_transaction
               FROM player_game_order
              --WHERE bet_time >= start_time::TIMESTAMP
              --  AND bet_time < end_time::TIMESTAMP
              WHERE payout_time >= start_time::TIMESTAMP
                AND payout_time < end_time::TIMESTAMP
                AND order_state = 'settle'
                --v1.06  2017/02/05  Leisure
                --AND is_profit_loss = TRUE --v1.03  2016/06/13  Leisure
              GROUP BY player_id, api_id, api_type_id, game_type
              ) p, v_sys_user_tier u
  WHERE p.player_id = u.id;

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice '本次插入数据量 %', n_count;
  rtn = rtn||'|执行完毕,新增记录数: '||n_count||' 条||';

  return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-玩家报表';


DROP FUNCTION IF EXISTS gamebox_operations_statement(text,int,text,text,text);
CREATE OR REPLACE FUNCTION gamebox_operations_statement(
  mainhost   text,
  sid     int,
  curday   text, --v1.01  2016/05/31  Leisure
  start_time   text,
  end_time   text
) RETURNS TEXT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-入口
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
--v1.02  2016/07/08  Leisure  优化输出日志
*/
DECLARE
  --curday   TEXT;
  rtn   text:='';
  tmp   text:='';
  rec   json;
  red   record;
  vname   text:='vp_site_game';
  cnum   int:=0;
BEGIN
  --v1.01  2016/05/31  Leisure
  --设置当前日期.
  --SELECT CURRENT_DATE::TEXT into curday;

  --raise notice 'ip:%',hostinfo;
  if mainhost is null or rtrim(ltrim(mainhost)) = '' THEN
    return '运营商库信息没有设置';
  end if;

  --收集当前所有运营站点相关信息.
  SELECT gamebox_collect_site_infor(mainhost, sid) into rec;
  IF rec->>'siteid' = '-1' THEN
    rtn = '运营商库中不存在当前站点的相关信息,请确保此站点是否合法.';
    raise info '%', rtn;
    return rtn;
  END IF;

  rtn = rtn || (rec->>'siteid');
  --拆分所有站点数据库信息.
  rtn = rtn||chr(13)||chr(10)||'        ┣1.正在收集玩家下单信息';
  SELECT gamebox_operations_player(start_time, end_time, curday, rec) into tmp;
  rtn = rtn||'||'||tmp;
  --raise info '%.收集完毕',i;

  --处理另外一些报表信息收集

  --统一执行代理以上的经营报表
  --执行代理经营报表
  rtn = rtn||chr(13)||chr(10)||'        ┣2.正在执行代理经营报表';
  --SELECT gamebox_operations_agent(curday, rec) into tmp; --v1.01  2016/05/31  Leisure
  SELECT gamebox_operations_agent(start_time, end_time, curday, rec) into tmp;
  rtn = rtn||'||'||tmp;
  --执行总代经营报表
  rtn = rtn||chr(13)||chr(10)||'        ┣3.正在执行总代经营报表';
  --SELECT gamebox_operations_topagent(curday, rec) into tmp; --v1.01  2016/05/31  Leisure
  SELECT gamebox_operations_topagent(start_time, end_time, curday, rec) into tmp;
  rtn = rtn||'||'||tmp;

  return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, sid int, curday text, start_time text, end_time text)
IS 'Lins-经营报表-入口';


DROP FUNCTION IF EXISTS gb_rakeback_recount(TEXT, TEXT, TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_rakeback_recount(
  p_comp_url  TEXT,
  p_period   TEXT,
  p_start_time   TEXT,
  p_end_time   TEXT,
  p_settle_flag   TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/06/26  Leisure  创建此函数: 返水结算账单.返水补差
--v1.01  2017/07/18  Leisure  增加更新API反水表，更新返水发放、拒绝人数
--v1.02  2017/07/26  Leisure  更改ON CONFLICT的写法，方便理解，rakeback_total从player表统计
--v1.03  2017/07/28  Leisure  更改rakeback_player、rakeback_api的更新条件，只要重结后rakeback_pending>=0的都允许重结
--v1.04  2017/09/18  Leisure  修正某些情况下rakeback_bill.lssuing_state统计错误的问题

  返回值说明：0成功，1警告，2错误
*/
DECLARE

  t_start_time   TIMESTAMP;
  t_end_time   TIMESTAMP;
  n_sid  INT;
  n_return_code INT := 0;

  --rec_rb.id INT;
  --rec_rbn.id INT;

  rec_rb  RECORD;
  rec_rbn RECORD;

  n_player_count         INT := 0;
  n_player_lssuing_count INT := 0;
  n_player_reject_count  INT := 0;
  n_rakeback_total     FLOAT := 0;

  v_lssuing_state varchar(32);

  v_remark varchar(50) := '';
  v_sql text;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  t_start_time = clock_timestamp()::timestamp(0);

  perform gb_rakeback(p_period, p_start_time, p_end_time, 'N');

  BEGIN

    SELECT *
      INTO rec_rb
      FROM rakeback_bill WHERE start_time = p_start_time::TIMESTAMP;

    IF NOT FOUND THEN
      RAISE NOTICE '本期返水未结算，不能执行返水补差操作！';
      RETURN 2;
    END IF;

    SELECT *
      INTO rec_rbn
      FROM rakeback_bill_nosettled WHERE start_time = p_start_time::TIMESTAMP;

    IF NOT FOUND THEN
      RAISE NOTICE '本期返水补差账单未生成，不能执行返水补差操作！';
      RETURN 2;
    END IF;

  EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE '本期返水账单异常，任务失败！';
    RETURN 2;
  END;

  IF rec_rb.player_count = rec_rbn.player_count AND rec_rb.rakeback_total = rec_rbn.rakeback_total THEN
    RAISE NOTICE '返水人数、总额无变化，不需要返水补差！';
    v_remark = '返水人数、总额无变化，不需要返水补差！';
  ELSE

    --更新返水结算账单
    --更新API反水表
    --v1.03  2017/07/28  Leisure
    /*
    DELETE FROM rakeback_api ra
     WHERE rakeback_bill_id = rec_rb.id
       AND EXISTS (SELECT 1
                     FROM rakeback_api_nosettled
                    WHERE rakeback_bill_nosettled_id = rec_rbn.id
                      AND player_id = ra.player_id
                      AND api_id = ra.api_id
                      AND game_type = ra.game_type
                      AND rakeback > ra.rakeback);
    */

    --rakeback_player的条件必须和下面更新Player反水表的一样
    DELETE FROM rakeback_api ra
     WHERE rakeback_bill_id = rec_rb.id
       AND EXISTS (SELECT 1
                     FROM rakeback_api_nosettled
                    WHERE rakeback_bill_nosettled_id = rec_rbn.id
                      AND player_id = ra.player_id
                      AND api_id = ra.api_id
                      AND game_type = ra.game_type
                      AND rakeback <> ra.rakeback)
       AND EXISTS (SELECT 1
                     FROM rakeback_player rp RIGHT JOIN rakeback_player_nosettled rpn
                       ON rp.rakeback_bill_id = rec_rb.id AND rpn.rakeback_bill_nosettled_id = rec_rbn.id AND rp.player_id=rpn.player_id
                    WHERE rpn.rakeback_total <> COALESCE(rp.rakeback_total, 0)
                      AND rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) >= 0 --最终得到的返水未结值不能小于0
                      AND rpn.player_id = ra.player_id
                  );

    INSERT INTO rakeback_api (
        rakeback_bill_id, player_id, api_id, game_type, effective_transaction, profit_loss, rakeback, api_type_id, audit_num, rakeback_limit)
    SELECT rec_rb.id, player_id, api_id, game_type, effective_transaction, profit_loss, rakeback, api_type_id, audit_num, rakeback_limit
      FROM rakeback_api_nosettled
     WHERE rakeback_bill_nosettled_id = rec_rbn.id
    --v1.02  2017/07/26  Leisure
    --ON CONFLICT ON CONSTRAINT rakeback_api_rpag_uc
    ON CONFLICT (rakeback_bill_id, player_id, api_id, game_type)
    DO NOTHING;

    --更新Player反水表
    WITH rpn AS (
      SELECT * FROM rakeback_player_nosettled WHERE rakeback_bill_nosettled_id = rec_rbn.id
    ),
    rp AS (
      SELECT * FROM rakeback_player WHERE rakeback_bill_id = rec_rb.id
    ),
    rpj AS (
      SELECT
          rpn.*,
          COALESCE(rp.rakeback_paid, 0) rakeback_paid, --已付返水
          rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) rakeback_pending --返水差额 +此前未结
        FROM rpn
        LEFT JOIN rp ON rpn.player_id = rp.player_id
       --v1.03  2017/07/28  Leisure
       --WHERE rpn.rakeback_total > COALESCE(rp.rakeback_total, 0)
       WHERE rpn.rakeback_total <> COALESCE(rp.rakeback_total, 0)
         AND rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) >= 0 --最终得到的返水未结值不能小于0
    )
    --SELECT * FROM rpj
    INSERT INTO rakeback_player (
        rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker, settlement_state, remark,
        agent_id, top_agent_id, audit_num, rakeback_total, rakeback_actual, rakeback_paid, rakeback_pending
    )
    SELECT rec_rb.id, player_id, username, rank_id, rank_name, risk_marker, 'pending_lssuing', '返水补差',
           agent_id, top_agent_id, audit_num, rakeback_total, rakeback_pending, rakeback_paid, rakeback_pending
      FROM rpj
     --WHERE rakeback_total <> 0
    --v1.02  2017/07/26  Leisure
    --ON CONFLICT ON CONSTRAINT rakeback_player_rp_uc
    ON CONFLICT (rakeback_bill_id, player_id)
    DO UPDATE SET rakeback_total   = excluded.rakeback_total,
                  rakeback_actual  = excluded.rakeback_pending,
                  rakeback_pending = excluded.rakeback_pending,
                  settlement_state = 'pending_lssuing',
                  remark = COALESCE(rakeback_player.remark, '返水补差');

    --v1.01  2017/07/18  Leisure
    --返水发放、拒绝人数
    SELECT COUNT(player_id),
           SUM( CASE settlement_state WHEN 'lssuing' THEN 1 ELSE 0 END),
           SUM( CASE settlement_state WHEN 'reject_lssuing' THEN 1 ELSE 0 END),
           SUM( rakeback_total) --v1.02  2017/07/26
      INTO n_player_count,
           n_player_lssuing_count,
           n_player_reject_count,
           n_rakeback_total
      FROM rakeback_player
     WHERE rakeback_bill_id = rec_rb.id;

    --v1.04  2017/09/18  Leisure
    v_lssuing_state := 'part_pay';
    IF n_player_lssuing_count + n_player_reject_count = 0 THEN
      v_lssuing_state := 'pending_pay';
    ELSEIF n_player_count = n_player_lssuing_count + n_player_reject_count THEN
      v_lssuing_state := 'all_pay';
    END IF;

    --更新返水总表
    UPDATE rakeback_bill rb
       SET player_count = n_player_count,
           player_lssuing_count = n_player_lssuing_count,
           player_reject_count = n_player_reject_count,
           rakeback_total = n_rakeback_total, --v1.02  2017/07/26
           rakeback_pending = n_rakeback_total - rb.rakeback_total + rb.rakeback_pending,
           --v1.04  2017/09/18  Leisure
           --lssuing_state = CASE rb.lssuing_state WHEN 'pending_pay' THEN 'pending_pay' ELSE 'part_pay' END
           lssuing_state = v_lssuing_state
      FROM ( SELECT * FROM rakeback_bill_nosettled rbni WHERE rbni.id = rec_rbn.id ) rbn
     WHERE rb.id = rec_rb.id
       AND rb.rakeback_total <> rbn.rakeback_total;
  END IF;

  t_end_time = clock_timestamp()::timestamp(0);

  SELECT gamebox_current_site() INTO n_sid;

  --perform dblink_close_all();
  --perform dblink_connect('master',  p_comp_url);
  v_sql = 'SELECT * from gb_task_infomation_site( ''' || n_sid || ''', ''gb_rakeback_recount'', ''返水补差'', ''' || p_period || ''', ''1'', ''' ||
           t_start_time || ''', ''' || t_end_time || ''', ''' || v_remark || ''')';
  RAISE INFO '%', v_sql;

  IF 'mainsite' IN ( SELECT unnest(dblink_get_connections()) ) THEN
    PERFORM dblink_disconnect('mainsite');
  END IF;

  PERFORM dblink_connect_u('mainsite', p_comp_url);

  SELECT t.return_code
    INTO n_return_code
    FROM
    dblink ('mainsite',
            v_sql
           ) AS t(return_code INT);
  --perform dblink_disconnect('master');

  PERFORM dblink_disconnect('mainsite');
  --PERFORM dblink_close('mainsite');

  IF n_return_code <> 0 THEN
    RAISE INFO '任务记录未成功写入远端表';
  END IF;

RETURN 0;

EXCEPTION
  WHEN QUERY_CANCELED THEN
    RETURN 2;
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    RETURN 2;
END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_recount( p_comp_url  TEXT, p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Leisure-返水结算账单.返水补差';


DROP FUNCTION IF EXISTS gb_rebate(text, text, text, text);
CREATE OR REPLACE FUNCTION gb_rebate (
  p_period   text,
  p_start_time   text,
  p_end_time   text,
  p_settle_flag   text
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure   创建此函数: 返佣结算账单-入口（新）
--v1.10  2017/07/31  Leisure   增加多级代理返佣支持
--v1.11  2017/07/31  Leisure   改用返佣周期判重

*/
DECLARE

  t_start_time   TIMESTAMP;
  t_end_time   TIMESTAMP;

  n_rebate_bill_id INT:=-1; --返佣主表键值
  n_bill_count   INT :=0;

  n_sid       INT;--站点ID

  redo_status BOOLEAN:=false; --重跑标志，默认不允许重跑

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN
  t_start_time = p_start_time::TIMESTAMP;
  t_end_time = p_end_time::TIMESTAMP;

  IF p_settle_flag = 'Y' THEN
    SELECT COUNT(*)
     INTO n_bill_count
      FROM rebate_bill rb
     WHERE (rb.period = p_period OR rb."start_time" = t_start_time) --v1.11  2017/07/31  Leisure
       AND rb.lssuing_state <> 'pending_pay';

    IF n_bill_count = 0 THEN
      DELETE FROM rebate_agent_api ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period OR "start_time" = t_start_time);
      DELETE FROM rebate_player_fee rp WHERE rp.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period OR "start_time" = t_start_time);
      DELETE FROM rebate_agent ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period OR "start_time" = t_start_time);
      DELETE FROM rebate_bill rb WHERE "id" IN (SELECT "id" FROM rebate_bill WHERE period = p_period OR "start_time" = t_start_time);
    ELSE
      raise notice '已生成本期返佣账单，无需重新生成。';
      RETURN 1;
    END IF;
  ELSEIF p_settle_flag = 'N' THEN
    TRUNCATE TABLE rebate_agent_api_nosettled;
    TRUNCATE TABLE rebate_player_fee_nosettled;
    TRUNCATE TABLE rebate_agent_nosettled;
    TRUNCATE TABLE rebate_bill_nosettled;
  END IF;

  raise notice '开始统计第( % )期的返佣【%】, 周期( % - % )', p_period, p_settle_flag, p_start_time, p_end_time;

  raise notice '返佣rebate_bill新增记录';
  SELECT gb_rebate_bill(n_rebate_bill_id, p_period, t_start_time, t_end_time, 'I', p_settle_flag) INTO n_rebate_bill_id;

  raise notice '统计代理API返佣信息';
  perform gb_rebate_agent_api(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);

  raise notice '统计玩家费用';
  perform gb_rebate_player_fee(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);

  raise notice '统计代理返佣';
  perform gb_rebate_agent(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);

  raise notice '更新返佣总表';
  perform gb_rebate_bill(n_rebate_bill_id, p_period, t_start_time, t_end_time, 'U', p_settle_flag);

  RETURN 0;

EXCEPTION
  WHEN QUERY_CANCELED THEN
    RETURN 2;
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    RETURN 2;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate(p_period text, p_start_time text, p_end_time text, p_settle_flag text)
IS 'Leisure-返佣结算账单-入口（新）';


DROP FUNCTION IF EXISTS gb_rebate_agent(INT, TIMESTAMP, TIMESTAMP, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_agent(
  p_bill_id   INT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP,
  p_settle_flag   TEXT
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单.代理返佣
--v1.10  2017/07/31  Leisure  增加多级代理返佣支持
--v1.11  2017/09/03  Leisure  取费用比率时，增加空值判断

*/
DECLARE

  d_last_start_time TIMESTAMP;

  n_deposit_radio   FLOAT := 0;
  n_withdraw_radio  FLOAT := 0;
  n_rakeback_radio  FLOAT := 0;
  n_favorable_radio FLOAT := 0;
  n_other_radio     FLOAT := 0;

  h_param_array  hstore;

BEGIN

  --v1.11  2017/09/03  Leisure
  SELECT string_agg(hstore(param_code, param_value)::TEXT, ',')::hstore
  FROM ( SELECT param_code, CASE param_value WHEN NULL THEN '0' WHEN '' THEN '0' ELSE param_value END
           FROM sys_param WHERE ( param_type = 'apportionSetting' OR param_type = 'rebateSetting') AND active = TRUE ORDER BY 1
         ) sp
    INTO h_param_array;

  n_deposit_radio := COALESCE(h_param_array ->'settlement.deposit.fee', '0')::FLOAT;
  n_withdraw_radio := COALESCE(h_param_array ->'settlement.withdraw.fee', '0')::FLOAT;
  n_rakeback_radio := COALESCE(h_param_array ->'agent.rakeback.percent', '0')::FLOAT;
  n_favorable_radio := COALESCE(h_param_array ->'agent.preferential.percent', '0')::FLOAT;
  n_other_radio := COALESCE(h_param_array ->'agent.other.percent', '0')::FLOAT;

  d_last_start_time := p_start_time + '1 day' + '-1 month' + '-1 day'; -- 加一天防止是月末日期，再取上个月。

  raise notice 'gb_rebate_agent.BEGIN: %', clock_timestamp();

  IF p_settle_flag = 'Y' THEN

    WITH
    ua AS --代理信息
    (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, uar.rebate_id rebate_set_id
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               LEFT JOIN user_agent_rebate uar ON ua.id = uar.user_id
       WHERE su.status IN ('1', '2', '3')
    ),

    raa AS --本期返佣信息
    (
      SELECT agent_id,
             MIN(rebate_grads_id) rebate_grads_id,
             MIN(max_rebate) max_rebate,
             MIN(effective_player) effective_player,
             SUM(effective_transaction) effective_transaction,
             SUM(profit_loss) profit_loss,
             SUM(rebate_parent) rebate_parent,
             SUM(effective_self) effective_self,
             SUM(profit_self) profit_self,
             SUM(rebate_self)::numeric(20,2) rebate_self,
             SUM(rebate_sun)::numeric(20,2) rebate_sun
        FROM rebate_agent_api
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rpf AS --分摊费用
    (
      SELECT agent_id,
             SUM(deposit_amount) AS deposit_amount,
             n_deposit_radio AS deposit_radio,
             (SUM(deposit_amount) * n_deposit_radio/100)::numeric(20,2) AS deposit_fee,

             SUM(withdraw_amount) AS withdraw_amount,
             n_withdraw_radio AS withdraw_radio,
             (SUM(withdraw_amount)*n_withdraw_radio/100)::numeric(20,2) AS withdraw_fee,

             SUM(rakeback_amount) AS rakeback_amount,
             n_rakeback_radio AS rakeback_radio,
             (SUM(rakeback_amount) * n_rakeback_radio/100)::numeric(20,2) AS rakeback_fee,

             SUM(favorable_amount) AS favorable_amount,
             n_favorable_radio AS favorable_radio,
             (SUM(favorable_amount) * n_favorable_radio/100)::numeric(20,2) AS favorable_fee,

             SUM(other_amount) AS other_amount,
             n_other_radio AS other_radio,
             (SUM(other_amount) * n_other_radio/100)::numeric(20,2) AS other_fee

        FROM rebate_player_fee
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rah AS --上期返佣信息
    (
      SELECT agent_id,
             rebate_self + rebate_self_history AS rebate_self_history,
             rebate_sun + rebate_sun_history AS rebate_sun_history,
             fee_amount + fee_history AS fee_history
        FROM rebate_agent
       WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE start_time = d_last_start_time)
         AND settlement_state = 'next_lssuing'
    ),

    rai AS
    (
      SELECT ua.agent_id, ua.agent_name, ua.agent_rank, ua.parent_id, ua.parent_array, ua.rebate_set_id,
             raa.rebate_grads_id, raa.max_rebate, raa.effective_player, raa.effective_transaction, raa.profit_loss, raa.rebate_parent,
             raa.effective_self, raa.profit_self,
             raa.rebate_self, rah.rebate_self_history, raa.rebate_sun, rah.rebate_sun_history,
             rpf.deposit_amount, rpf.deposit_radio, rpf.deposit_fee,
             rpf.withdraw_amount, rpf.withdraw_radio, rpf.withdraw_fee, rpf.rakeback_amount, rpf.rakeback_radio, rpf.rakeback_fee,
             rpf.favorable_amount, rpf.favorable_radio, rpf.favorable_fee, rpf.other_amount, rpf.other_radio, rpf.other_fee,
             rpf.deposit_fee + rpf.withdraw_fee + rpf.rakeback_fee + rpf.favorable_fee + rpf.other_fee AS fee_amount,
             rah.fee_history
        FROM ua
            LEFT JOIN
          raa ON ua.agent_id = raa.agent_id
            LEFT JOIN
          rpf ON ua.agent_id = rpf.agent_id
            LEFT JOIN
          rah ON ua.agent_id = rah.agent_id
    )

    INSERT INTO rebate_agent ( rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
        rebate_grads_id, max_rebate, effective_player, effective_transaction, profit_loss, rebate_parent, effective_self, profit_self,
        rebate_self, rebate_self_history, rebate_sun, rebate_sun_history, deposit_amount, deposit_radio, deposit_fee,
        withdraw_amount, withdraw_radio, withdraw_fee, rakeback_amount, rakeback_radio, rakeback_fee,
        favorable_amount, favorable_radio, favorable_fee, other_amount, other_radio, other_fee, fee_amount, fee_history,
        rebate_total, rebate_actual, settlement_state
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
           rebate_grads_id, max_rebate, COALESCE(effective_player, 0), COALESCE(effective_transaction, 0), COALESCE(profit_loss, 0), COALESCE(rebate_parent, 0), COALESCE(effective_self, 0), COALESCE(profit_self, 0),
           COALESCE(rebate_self, 0), COALESCE(rebate_self_history, 0), COALESCE(rebate_sun, 0), COALESCE(rebate_sun_history, 0), COALESCE(deposit_amount, 0), COALESCE(deposit_radio, 0), COALESCE(deposit_fee, 0),
           COALESCE(withdraw_amount, 0), COALESCE(withdraw_radio, 0), COALESCE(withdraw_fee, 0), COALESCE(rakeback_amount, 0), COALESCE(rakeback_radio, 0), COALESCE(rakeback_fee, 0),
           COALESCE(favorable_amount, 0), COALESCE(favorable_radio, 0), COALESCE(favorable_fee, 0), COALESCE(other_amount, 0), COALESCE(other_radio, 0), COALESCE(other_fee, 0), COALESCE(fee_amount, 0), COALESCE(fee_history, 0),
           COALESCE(rebate_self, 0) + COALESCE(rebate_self_history , 0)
           + COALESCE(rebate_sun , 0) + COALESCE(rebate_sun_history , 0) - COALESCE(fee_amount , 0) - COALESCE(fee_history, 0) AS rebate_total,
           0 AS rebate_actual,
           'pending_lssuing'
      FROM rai
     WHERE ( COALESCE(effective_transaction, 0) <> 0 OR COALESCE(profit_loss, 0) <> 0 OR
             COALESCE(rebate_self, 0) <> 0 OR COALESCE(rebate_self_history , 0) <> 0 OR COALESCE(rebate_sun , 0) <> 0 OR
             COALESCE(rebate_sun_history , 0) <> 0 OR COALESCE(fee_amount , 0) <> 0 OR COALESCE(fee_history, 0) <> 0
           );


  ELSEIF p_settle_flag = 'N' THEN

    WITH
    ua AS --代理信息
    (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, uar.rebate_id rebate_set_id
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               LEFT JOIN user_agent_rebate uar ON ua.id = uar.user_id
       WHERE su.status IN ('1', '2', '3')
    ),

    raa AS --本期返佣信息
    (
      SELECT agent_id,
             MIN(rebate_grads_id) rebate_grads_id,
             MIN(max_rebate) max_rebate,
             MIN(effective_player) effective_player,
             SUM(effective_transaction) effective_transaction,
             SUM(profit_loss) profit_loss,
             SUM(rebate_parent) rebate_parent,
             SUM(effective_self) effective_self,
             SUM(profit_self) profit_self,
             SUM(rebate_self)::numeric(20,2) rebate_self,
             SUM(rebate_sun)::numeric(20,2) rebate_sun
        FROM rebate_agent_api_nosettled
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rpf AS --分摊费用
    (
      SELECT agent_id,
             SUM(deposit_amount) AS deposit_amount,
             n_deposit_radio AS deposit_radio,
             (SUM(deposit_amount) * n_deposit_radio/100)::numeric(20,2) AS deposit_fee,

             SUM(withdraw_amount) AS withdraw_amount,
             n_withdraw_radio AS withdraw_radio,
             (SUM(withdraw_amount)*n_withdraw_radio/100)::numeric(20,2) AS withdraw_fee,

             SUM(rakeback_amount) AS rakeback_amount,
             n_rakeback_radio AS rakeback_radio,
             (SUM(rakeback_amount) * n_rakeback_radio/100)::numeric(20,2) AS rakeback_fee,

             SUM(favorable_amount) AS favorable_amount,
             n_favorable_radio AS favorable_radio,
             (SUM(favorable_amount) * n_favorable_radio/100)::numeric(20,2) AS favorable_fee,

             SUM(other_amount) AS other_amount,
             n_other_radio AS other_radio,
             (SUM(other_amount) * n_other_radio/100)::numeric(20,2) AS other_fee

        FROM rebate_player_fee_nosettled
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rah AS --上期返佣信息
    (
      SELECT agent_id,
             rebate_self + rebate_self_history AS rebate_self_history,
             rebate_sun + rebate_sun_history AS rebate_sun_history,
             fee_amount + fee_history AS fee_history
        FROM rebate_agent
       WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE start_time = d_last_start_time)
         AND settlement_state = 'next_lssuing'
    ),

    rai AS
    (
      SELECT ua.agent_id, ua.agent_name, ua.agent_rank, ua.parent_id, ua.parent_array, ua.rebate_set_id,
             raa.rebate_grads_id, raa.max_rebate, raa.effective_player, raa.effective_transaction, raa.profit_loss, raa.rebate_parent,
             raa.effective_self, raa.profit_self,
             raa.rebate_self, rah.rebate_self_history, raa.rebate_sun, rah.rebate_sun_history,
             rpf.deposit_amount, rpf.deposit_radio, rpf.deposit_fee,
             rpf.withdraw_amount, rpf.withdraw_radio, rpf.withdraw_fee, rpf.rakeback_amount, rpf.rakeback_radio, rpf.rakeback_fee,
             rpf.favorable_amount, rpf.favorable_radio, rpf.favorable_fee, rpf.other_amount, rpf.other_radio, rpf.other_fee,
             rpf.deposit_fee + rpf.withdraw_fee + rpf.rakeback_fee + rpf.favorable_fee + rpf.other_fee AS fee_amount,
             rah.fee_history
        FROM ua
            LEFT JOIN
          raa ON ua.agent_id = raa.agent_id
            LEFT JOIN
          rpf ON ua.agent_id = rpf.agent_id
            LEFT JOIN
          rah ON ua.agent_id = rah.agent_id
    )

    INSERT INTO rebate_agent_nosettled ( rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
        rebate_grads_id, max_rebate, effective_player, effective_transaction, profit_loss, rebate_parent, effective_self, profit_self,
        rebate_self, rebate_self_history, rebate_sun, rebate_sun_history, deposit_amount, deposit_radio, deposit_fee,
        withdraw_amount, withdraw_radio, withdraw_fee, rakeback_amount, rakeback_radio, rakeback_fee,
        favorable_amount, favorable_radio, favorable_fee, other_amount, other_radio, other_fee, fee_amount, fee_history,
        rebate_total
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
           rebate_grads_id, max_rebate, COALESCE(effective_player, 0), COALESCE(effective_transaction, 0), COALESCE(profit_loss, 0), COALESCE(rebate_parent, 0), COALESCE(effective_self, 0), COALESCE(profit_self, 0),
           COALESCE(rebate_self, 0), COALESCE(rebate_self_history, 0), COALESCE(rebate_sun, 0), COALESCE(rebate_sun_history, 0), COALESCE(deposit_amount, 0), COALESCE(deposit_radio, 0), COALESCE(deposit_fee, 0),
           COALESCE(withdraw_amount, 0), COALESCE(withdraw_radio, 0), COALESCE(withdraw_fee, 0), COALESCE(rakeback_amount, 0), COALESCE(rakeback_radio, 0), COALESCE(rakeback_fee, 0),
           COALESCE(favorable_amount, 0), COALESCE(favorable_radio, 0), COALESCE(favorable_fee, 0), COALESCE(other_amount, 0), COALESCE(other_radio, 0), COALESCE(other_fee, 0), COALESCE(fee_amount, 0), COALESCE(fee_history, 0),
           COALESCE(rebate_self, 0) + COALESCE(rebate_self_history , 0)
           + COALESCE(rebate_sun , 0) + COALESCE(rebate_sun_history , 0) - COALESCE(fee_amount , 0) - COALESCE(fee_history, 0) AS rebate_total
      FROM rai
     WHERE ( COALESCE(effective_transaction, 0) <> 0 OR COALESCE(profit_loss, 0) <> 0 OR
             COALESCE(rebate_self, 0) <> 0 OR COALESCE(rebate_self_history , 0) <> 0 OR COALESCE(rebate_sun , 0) <> 0 OR
             COALESCE(rebate_sun_history , 0) <> 0 OR COALESCE(fee_amount , 0) <> 0 OR COALESCE(fee_history, 0) <> 0
           );

  END IF;

  raise notice 'gb_rebate_agent.END: %', clock_timestamp();

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent(p_bill_id INT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_settle_flag TEXT)
IS 'Leisure-返佣结算账单.代理返佣';


DROP FUNCTION IF EXISTS gb_rebate_agent(INT, TIMESTAMP, TIMESTAMP, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_agent(
  p_bill_id   INT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP,
  p_settle_flag   TEXT
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单.代理返佣
--v1.10  2017/07/31  Leisure  增加多级代理返佣支持
--v1.11  2017/09/03  Leisure  取费用比率时，增加空值判断

*/
DECLARE

  d_last_start_time TIMESTAMP;

  n_deposit_radio   FLOAT := 0;
  n_withdraw_radio  FLOAT := 0;
  n_rakeback_radio  FLOAT := 0;
  n_favorable_radio FLOAT := 0;
  n_other_radio     FLOAT := 0;

  h_param_array  hstore;

BEGIN

  --v1.11  2017/09/03  Leisure
  SELECT string_agg(hstore(param_code, param_value)::TEXT, ',')::hstore
  FROM ( SELECT param_code, CASE param_value WHEN NULL THEN '0' WHEN '' THEN '0' ELSE param_value END
           FROM sys_param WHERE ( param_type = 'apportionSetting' OR param_type = 'rebateSetting') AND active = TRUE ORDER BY 1
         ) sp
    INTO h_param_array;

  n_deposit_radio := COALESCE(h_param_array ->'settlement.deposit.fee', '0')::FLOAT;
  n_withdraw_radio := COALESCE(h_param_array ->'settlement.withdraw.fee', '0')::FLOAT;
  n_rakeback_radio := COALESCE(h_param_array ->'agent.rakeback.percent', '0')::FLOAT;
  n_favorable_radio := COALESCE(h_param_array ->'agent.preferential.percent', '0')::FLOAT;
  n_other_radio := COALESCE(h_param_array ->'agent.other.percent', '0')::FLOAT;

  d_last_start_time := p_start_time + '1 day' + '-1 month' + '-1 day'; -- 加一天防止是月末日期，再取上个月。

  raise notice 'gb_rebate_agent.BEGIN: %', clock_timestamp();

  IF p_settle_flag = 'Y' THEN

    WITH
    ua AS --代理信息
    (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, uar.rebate_id rebate_set_id
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               LEFT JOIN user_agent_rebate uar ON ua.id = uar.user_id
       WHERE su.status IN ('1', '2', '3')
    ),

    raa AS --本期返佣信息
    (
      SELECT agent_id,
             MIN(rebate_grads_id) rebate_grads_id,
             MIN(max_rebate) max_rebate,
             MIN(effective_player) effective_player,
             SUM(effective_transaction) effective_transaction,
             SUM(profit_loss) profit_loss,
             SUM(rebate_parent) rebate_parent,
             SUM(effective_self) effective_self,
             SUM(profit_self) profit_self,
             SUM(rebate_self)::numeric(20,2) rebate_self,
             SUM(rebate_sun)::numeric(20,2) rebate_sun
        FROM rebate_agent_api
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rpf AS --分摊费用
    (
      SELECT agent_id,
             SUM(deposit_amount) AS deposit_amount,
             n_deposit_radio AS deposit_radio,
             (SUM(deposit_amount) * n_deposit_radio/100)::numeric(20,2) AS deposit_fee,

             SUM(withdraw_amount) AS withdraw_amount,
             n_withdraw_radio AS withdraw_radio,
             (SUM(withdraw_amount)*n_withdraw_radio/100)::numeric(20,2) AS withdraw_fee,

             SUM(rakeback_amount) AS rakeback_amount,
             n_rakeback_radio AS rakeback_radio,
             (SUM(rakeback_amount) * n_rakeback_radio/100)::numeric(20,2) AS rakeback_fee,

             SUM(favorable_amount) AS favorable_amount,
             n_favorable_radio AS favorable_radio,
             (SUM(favorable_amount) * n_favorable_radio/100)::numeric(20,2) AS favorable_fee,

             SUM(other_amount) AS other_amount,
             n_other_radio AS other_radio,
             (SUM(other_amount) * n_other_radio/100)::numeric(20,2) AS other_fee

        FROM rebate_player_fee
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rah AS --上期返佣信息
    (
      SELECT agent_id,
             rebate_self + rebate_self_history AS rebate_self_history,
             rebate_sun + rebate_sun_history AS rebate_sun_history,
             fee_amount + fee_history AS fee_history
        FROM rebate_agent
       WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE start_time = d_last_start_time)
         AND settlement_state = 'next_lssuing'
    ),

    rai AS
    (
      SELECT ua.agent_id, ua.agent_name, ua.agent_rank, ua.parent_id, ua.parent_array, ua.rebate_set_id,
             raa.rebate_grads_id, raa.max_rebate, raa.effective_player, raa.effective_transaction, raa.profit_loss, raa.rebate_parent,
             raa.effective_self, raa.profit_self,
             raa.rebate_self, rah.rebate_self_history, raa.rebate_sun, rah.rebate_sun_history,
             rpf.deposit_amount, rpf.deposit_radio, rpf.deposit_fee,
             rpf.withdraw_amount, rpf.withdraw_radio, rpf.withdraw_fee, rpf.rakeback_amount, rpf.rakeback_radio, rpf.rakeback_fee,
             rpf.favorable_amount, rpf.favorable_radio, rpf.favorable_fee, rpf.other_amount, rpf.other_radio, rpf.other_fee,
             rpf.deposit_fee + rpf.withdraw_fee + rpf.rakeback_fee + rpf.favorable_fee + rpf.other_fee AS fee_amount,
             rah.fee_history
        FROM ua
            LEFT JOIN
          raa ON ua.agent_id = raa.agent_id
            LEFT JOIN
          rpf ON ua.agent_id = rpf.agent_id
            LEFT JOIN
          rah ON ua.agent_id = rah.agent_id
    )

    INSERT INTO rebate_agent ( rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
        rebate_grads_id, max_rebate, effective_player, effective_transaction, profit_loss, rebate_parent, effective_self, profit_self,
        rebate_self, rebate_self_history, rebate_sun, rebate_sun_history, deposit_amount, deposit_radio, deposit_fee,
        withdraw_amount, withdraw_radio, withdraw_fee, rakeback_amount, rakeback_radio, rakeback_fee,
        favorable_amount, favorable_radio, favorable_fee, other_amount, other_radio, other_fee, fee_amount, fee_history,
        rebate_total, rebate_actual, settlement_state
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
           rebate_grads_id, max_rebate, COALESCE(effective_player, 0), COALESCE(effective_transaction, 0), COALESCE(profit_loss, 0), COALESCE(rebate_parent, 0), COALESCE(effective_self, 0), COALESCE(profit_self, 0),
           COALESCE(rebate_self, 0), COALESCE(rebate_self_history, 0), COALESCE(rebate_sun, 0), COALESCE(rebate_sun_history, 0), COALESCE(deposit_amount, 0), COALESCE(deposit_radio, 0), COALESCE(deposit_fee, 0),
           COALESCE(withdraw_amount, 0), COALESCE(withdraw_radio, 0), COALESCE(withdraw_fee, 0), COALESCE(rakeback_amount, 0), COALESCE(rakeback_radio, 0), COALESCE(rakeback_fee, 0),
           COALESCE(favorable_amount, 0), COALESCE(favorable_radio, 0), COALESCE(favorable_fee, 0), COALESCE(other_amount, 0), COALESCE(other_radio, 0), COALESCE(other_fee, 0), COALESCE(fee_amount, 0), COALESCE(fee_history, 0),
           COALESCE(rebate_self, 0) + COALESCE(rebate_self_history , 0)
           + COALESCE(rebate_sun , 0) + COALESCE(rebate_sun_history , 0) - COALESCE(fee_amount , 0) - COALESCE(fee_history, 0) AS rebate_total,
           0 AS rebate_actual,
           'pending_lssuing'
      FROM rai
     WHERE ( COALESCE(effective_transaction, 0) <> 0 OR COALESCE(profit_loss, 0) <> 0 OR
             COALESCE(rebate_self, 0) <> 0 OR COALESCE(rebate_self_history , 0) <> 0 OR COALESCE(rebate_sun , 0) <> 0 OR
             COALESCE(rebate_sun_history , 0) <> 0 OR COALESCE(fee_amount , 0) <> 0 OR COALESCE(fee_history, 0) <> 0
           );


  ELSEIF p_settle_flag = 'N' THEN

    WITH
    ua AS --代理信息
    (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, uar.rebate_id rebate_set_id
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               LEFT JOIN user_agent_rebate uar ON ua.id = uar.user_id
       WHERE su.status IN ('1', '2', '3')
    ),

    raa AS --本期返佣信息
    (
      SELECT agent_id,
             MIN(rebate_grads_id) rebate_grads_id,
             MIN(max_rebate) max_rebate,
             MIN(effective_player) effective_player,
             SUM(effective_transaction) effective_transaction,
             SUM(profit_loss) profit_loss,
             SUM(rebate_parent) rebate_parent,
             SUM(effective_self) effective_self,
             SUM(profit_self) profit_self,
             SUM(rebate_self)::numeric(20,2) rebate_self,
             SUM(rebate_sun)::numeric(20,2) rebate_sun
        FROM rebate_agent_api_nosettled
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rpf AS --分摊费用
    (
      SELECT agent_id,
             SUM(deposit_amount) AS deposit_amount,
             n_deposit_radio AS deposit_radio,
             (SUM(deposit_amount) * n_deposit_radio/100)::numeric(20,2) AS deposit_fee,

             SUM(withdraw_amount) AS withdraw_amount,
             n_withdraw_radio AS withdraw_radio,
             (SUM(withdraw_amount)*n_withdraw_radio/100)::numeric(20,2) AS withdraw_fee,

             SUM(rakeback_amount) AS rakeback_amount,
             n_rakeback_radio AS rakeback_radio,
             (SUM(rakeback_amount) * n_rakeback_radio/100)::numeric(20,2) AS rakeback_fee,

             SUM(favorable_amount) AS favorable_amount,
             n_favorable_radio AS favorable_radio,
             (SUM(favorable_amount) * n_favorable_radio/100)::numeric(20,2) AS favorable_fee,

             SUM(other_amount) AS other_amount,
             n_other_radio AS other_radio,
             (SUM(other_amount) * n_other_radio/100)::numeric(20,2) AS other_fee

        FROM rebate_player_fee_nosettled
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rah AS --上期返佣信息
    (
      SELECT agent_id,
             rebate_self + rebate_self_history AS rebate_self_history,
             rebate_sun + rebate_sun_history AS rebate_sun_history,
             fee_amount + fee_history AS fee_history
        FROM rebate_agent
       WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE start_time = d_last_start_time)
         AND settlement_state = 'next_lssuing'
    ),

    rai AS
    (
      SELECT ua.agent_id, ua.agent_name, ua.agent_rank, ua.parent_id, ua.parent_array, ua.rebate_set_id,
             raa.rebate_grads_id, raa.max_rebate, raa.effective_player, raa.effective_transaction, raa.profit_loss, raa.rebate_parent,
             raa.effective_self, raa.profit_self,
             raa.rebate_self, rah.rebate_self_history, raa.rebate_sun, rah.rebate_sun_history,
             rpf.deposit_amount, rpf.deposit_radio, rpf.deposit_fee,
             rpf.withdraw_amount, rpf.withdraw_radio, rpf.withdraw_fee, rpf.rakeback_amount, rpf.rakeback_radio, rpf.rakeback_fee,
             rpf.favorable_amount, rpf.favorable_radio, rpf.favorable_fee, rpf.other_amount, rpf.other_radio, rpf.other_fee,
             rpf.deposit_fee + rpf.withdraw_fee + rpf.rakeback_fee + rpf.favorable_fee + rpf.other_fee AS fee_amount,
             rah.fee_history
        FROM ua
            LEFT JOIN
          raa ON ua.agent_id = raa.agent_id
            LEFT JOIN
          rpf ON ua.agent_id = rpf.agent_id
            LEFT JOIN
          rah ON ua.agent_id = rah.agent_id
    )

    INSERT INTO rebate_agent_nosettled ( rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
        rebate_grads_id, max_rebate, effective_player, effective_transaction, profit_loss, rebate_parent, effective_self, profit_self,
        rebate_self, rebate_self_history, rebate_sun, rebate_sun_history, deposit_amount, deposit_radio, deposit_fee,
        withdraw_amount, withdraw_radio, withdraw_fee, rakeback_amount, rakeback_radio, rakeback_fee,
        favorable_amount, favorable_radio, favorable_fee, other_amount, other_radio, other_fee, fee_amount, fee_history,
        rebate_total
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
           rebate_grads_id, max_rebate, COALESCE(effective_player, 0), COALESCE(effective_transaction, 0), COALESCE(profit_loss, 0), COALESCE(rebate_parent, 0), COALESCE(effective_self, 0), COALESCE(profit_self, 0),
           COALESCE(rebate_self, 0), COALESCE(rebate_self_history, 0), COALESCE(rebate_sun, 0), COALESCE(rebate_sun_history, 0), COALESCE(deposit_amount, 0), COALESCE(deposit_radio, 0), COALESCE(deposit_fee, 0),
           COALESCE(withdraw_amount, 0), COALESCE(withdraw_radio, 0), COALESCE(withdraw_fee, 0), COALESCE(rakeback_amount, 0), COALESCE(rakeback_radio, 0), COALESCE(rakeback_fee, 0),
           COALESCE(favorable_amount, 0), COALESCE(favorable_radio, 0), COALESCE(favorable_fee, 0), COALESCE(other_amount, 0), COALESCE(other_radio, 0), COALESCE(other_fee, 0), COALESCE(fee_amount, 0), COALESCE(fee_history, 0),
           COALESCE(rebate_self, 0) + COALESCE(rebate_self_history , 0)
           + COALESCE(rebate_sun , 0) + COALESCE(rebate_sun_history , 0) - COALESCE(fee_amount , 0) - COALESCE(fee_history, 0) AS rebate_total
      FROM rai
     WHERE ( COALESCE(effective_transaction, 0) <> 0 OR COALESCE(profit_loss, 0) <> 0 OR
             COALESCE(rebate_self, 0) <> 0 OR COALESCE(rebate_self_history , 0) <> 0 OR COALESCE(rebate_sun , 0) <> 0 OR
             COALESCE(rebate_sun_history , 0) <> 0 OR COALESCE(fee_amount , 0) <> 0 OR COALESCE(fee_history, 0) <> 0
           );

  END IF;

  raise notice 'gb_rebate_agent.END: %', clock_timestamp();

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent(p_bill_id INT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_settle_flag TEXT)
IS 'Leisure-返佣结算账单.代理返佣';


DROP FUNCTION IF EXISTS gb_rebate_agent_api(INT, TIMESTAMP, TIMESTAMP, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_agent_api(
  p_bill_id   INT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP,
  p_settle_flag   TEXT
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单.代理API返佣
--v1.00  2017/07/31  Leisure  增加多级代理返佣支持

*/
DECLARE

BEGIN

  raise notice 'gb_rebate_agent_api.BEGIN: %', clock_timestamp();

  IF p_settle_flag = 'Y' THEN

    --生成代理API返佣表数据
    WITH
    a_grad --得到返佣梯度
    AS (
      SELECT ouur.*, rg.id rebate_grads_id, rg.total_profit, rg.valid_player_num, rg.max_rebate
      FROM
      (
        SELECT oa.*, rs.id rebate_set_id, rgs.id rebate_grads_set_id, rgs.valid_value,
               ( SELECT COUNT(1)
                   FROM (
                          SELECT player_id
                            FROM operate_player
                           WHERE static_time >= p_start_time
                             AND static_time_end <= p_end_time
                             AND agent_id = ANY(oa.agent_array)
                           GROUP BY player_id
                          HAVING SUM(effective_transaction) >= rgs.valid_value
                        ) t
               ) effective_player  --获得有效玩家数
        FROM
        (
          SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, array_agg( DISTINCT uas.id) agent_array,
                 SUM(oas.effective_transaction) effective_transaction,
                 -SUM(oas.profit_loss) profit_loss
            FROM user_agent ua
                   INNER JOIN
                 sys_user su ON su.user_type = '23' AND ua.id = su.id
                   INNER JOIN
                 user_agent uas ON ua.id = uas.id OR ARRAY[ua.id] <@ uas.parent_array --获得ua下面所有代理，包括自己
                   RIGHT JOIN
                 operate_agent oas ON oas.agent_id = uas.id
           WHERE oas.static_time >= p_start_time
             AND oas.static_time_end <= p_end_time
           GROUP BY ua.agent_rank, ua.id, su.username, ua.parent_id
           ORDER BY ua.agent_rank DESC, ua.id, su.username, ua.parent_id
          ) oa
          LEFT JOIN user_agent_rebate uar ON oa.agent_id = uar.user_id
          LEFT JOIN rebate_set rs ON uar.rebate_id = rs.id
          LEFT JOIN rebate_grads_set rgs ON rs.rebate_grads_set_id = rgs.id
      ) ouur
        LEFT JOIN rebate_grads rg ON rg.id = ( SELECT rg.id AS grads_id   --返佣梯度ID
                                                 FROM rebate_grads rg
                                                WHERE rg.rebate_grads_set_id = ouur.rebate_grads_set_id
                                                  AND ouur.profit_loss >= rg.total_profit --实际盈亏 >= 梯度盈亏
                                                  AND ouur.effective_player >= rg.valid_player_num --有效玩家数 >= 梯度玩家数
                                                ORDER BY rg.total_profit DESC, rg.valid_player_num DESC
                                                LIMIT 1
                                              )
    ),
    oat --得到各API各游戏有效交易量和返佣比率
    AS (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, array_agg( DISTINCT uas.id) agent_array, oas.api_id, oas.game_type,
             SUM(oas.effective_transaction) effective_transaction,
             -SUM(oas.profit_loss) profit_loss
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               INNER JOIN
             user_agent uas ON ua.id = uas.id OR ARRAY[ua.id] <@ uas.parent_array
               RIGHT JOIN
             operate_agent oas ON oas.agent_id = uas.id
       WHERE oas.static_time >= p_start_time
         AND oas.static_time_end <= p_end_time
       GROUP BY ua.agent_rank, ua.id, su.username, ua.parent_id, oas.api_id, oas.game_type
       --ORDER BY ua.agent_rank DESC, ua.id, su.username, ua.parent_id, oas.api_id, oas.game_type
    ),
    rat AS (
      SELECT a_grad.agent_id,
             a_grad.agent_name,
             a_grad.agent_rank,
             a_grad.parent_id,
             a_grad.parent_array,
             a_grad.rebate_set_id,
             a_grad.rebate_grads_set_id,
             a_grad.rebate_grads_id,
             a_grad.effective_player,
             a_grad.max_rebate,
             oat.api_id,
             oat.game_type,
             oat.agent_array,
             oat.effective_transaction,
             oat.profit_loss,
             rga.ratio rebate_ratio
        FROM oat
               INNER JOIN
             a_grad ON oat.agent_id = a_grad.agent_id
               LEFT JOIN
             rebate_grads_api rga ON rga.id = ( SELECT id
                                                  FROM rebate_grads_api
                                                 WHERE rebate_grads_id = a_grad.rebate_grads_id
                                                   AND rebate_set_id = a_grad.rebate_set_id
                                                   AND api_id = oat.api_id
                                                   AND game_type = oat.game_type
                                              )
    ),
    rats --得到自身有效交易量、盈亏
    AS (
    SELECT rat.*,
           rga.ratio parent_ratio,
           oa.effective_transaction effective_self,
           oa.profit_loss profit_self
      FROM rat
             LEFT JOIN
           user_agent_rebate uar ON rat.parent_id = uar.user_id AND rat.agent_rank > 1 -- 一级代理不需要计算上级抽佣！！！！否则会关联出多个总代方案！！！！
             LEFT JOIN
           rebate_grads_api rga ON rga.rebate_grads_id = rat.rebate_grads_id
                               AND rga.rebate_set_id = uar.rebate_id
                               AND rga.api_id = rat.api_id
                               AND rga.game_type = rat.game_type
             LEFT JOIN
           (
             SELECT agent_id, api_id, game_type, SUM(effective_transaction) effective_transaction, -SUM(profit_loss) profit_loss
              FROM operate_agent
             WHERE static_time >= p_start_time
               AND static_time_end <= p_end_time
             GROUP BY agent_id, api_id, game_type
           ) oa ON rat.agent_id = oa.agent_id AND rat.api_id = oa.api_id AND rat.game_type= oa.game_type
    )
    INSERT INTO rebate_agent_api (
           rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, rebate_set_id, rebate_grads_id, max_rebate, effective_player,
           api_id, game_type, agent_array, effective_transaction, profit_loss, rebate_ratio, parent_ratio,
           rebate_parent, effective_self, profit_self, rebate_self
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, rebate_set_id, rebate_grads_id, max_rebate, effective_player,
           api_id, game_type, agent_array, effective_transaction, profit_loss, rebate_ratio, parent_ratio,
           profit_loss * (parent_ratio-rebate_ratio)/100 rebate_parent,
         effective_self, profit_self,
         profit_self * rebate_ratio/100 rebate_self
    FROM rats;

    --更新字段: 下级代理贡献佣金
    UPDATE rebate_agent_api raa
       SET rebate_sun = COALESCE(raa2.rebate_parent, 0)
      FROM
      ( SELECT * FROM rebate_agent_api WHERE rebate_bill_id = p_bill_id
      ) raa1
      LEFT JOIN
      ( SELECT parent_id, api_id, game_type, SUM(rebate_parent) rebate_parent
          FROM rebate_agent_api
         WHERE rebate_bill_id = p_bill_id
         GROUP BY parent_id, api_id, game_type
      ) raa2
      ON raa1.agent_id = raa2.parent_id
        AND raa1.api_id = raa2.api_id
        AND raa1.game_type = raa2.game_type
     WHERE raa.rebate_bill_id = p_bill_id
       AND raa.agent_id = raa1.agent_id
       AND raa.api_id = raa1.api_id
       AND raa.game_type = raa1.game_type;


  ELSEIF p_settle_flag = 'N' THEN

    --生成代理API返佣表数据
    WITH
    a_grad --得到返佣梯度
    AS (
      SELECT ouur.*, rg.id rebate_grads_id, rg.total_profit, rg.valid_player_num, rg.max_rebate
      FROM
      (
        SELECT oa.*, rs.id rebate_set_id, rgs.id rebate_grads_set_id, rgs.valid_value,
               ( SELECT COUNT(1)
                   FROM (
                          SELECT player_id
                            FROM operate_player
                           WHERE static_time >= p_start_time
                             AND static_time_end <= p_end_time
                             AND agent_id = ANY(oa.agent_array)
                           GROUP BY player_id
                          HAVING SUM(effective_transaction) >= rgs.valid_value
                        ) t
               ) effective_player  --获得有效玩家数
        FROM
        (
          SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, array_agg( DISTINCT uas.id) agent_array,
                 SUM(oas.effective_transaction) effective_transaction,
                 -SUM(oas.profit_loss) profit_loss
            FROM user_agent ua
                   INNER JOIN
                 sys_user su ON su.user_type = '23' AND ua.id = su.id
                   INNER JOIN
                 user_agent uas ON ua.id = uas.id OR ARRAY[ua.id] <@ uas.parent_array --获得ua下面所有代理，包括自己
                   RIGHT JOIN
                 operate_agent oas ON oas.agent_id = uas.id
           WHERE oas.static_time >= p_start_time
             AND oas.static_time_end <= p_end_time
           GROUP BY ua.agent_rank, ua.id, su.username, ua.parent_id
           ORDER BY ua.agent_rank DESC, ua.id, su.username, ua.parent_id
          ) oa
          LEFT JOIN user_agent_rebate uar ON oa.agent_id = uar.user_id
          LEFT JOIN rebate_set rs ON uar.rebate_id = rs.id
          LEFT JOIN rebate_grads_set rgs ON rs.rebate_grads_set_id = rgs.id
      ) ouur
        LEFT JOIN rebate_grads rg ON rg.id = ( SELECT rg.id AS grads_id   --返佣梯度ID
                                                 FROM rebate_grads rg
                                                WHERE rg.rebate_grads_set_id = ouur.rebate_grads_set_id
                                                  AND ouur.profit_loss >= rg.total_profit --实际盈亏 >= 梯度盈亏
                                                  AND ouur.effective_player >= rg.valid_player_num --有效玩家数 >= 梯度玩家数
                                                ORDER BY rg.total_profit DESC, rg.valid_player_num DESC
                                                LIMIT 1
                                              )
    ),
    oat --得到各API各游戏有效交易量和返佣比率
    AS (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, array_agg( DISTINCT uas.id) agent_array, oas.api_id, oas.game_type,
             SUM(oas.effective_transaction) effective_transaction,
             -SUM(oas.profit_loss) profit_loss
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               INNER JOIN
             user_agent uas ON ua.id = uas.id OR ARRAY[ua.id] <@ uas.parent_array
               RIGHT JOIN
             operate_agent oas ON oas.agent_id = uas.id
       WHERE oas.static_time >= p_start_time
         AND oas.static_time_end <= p_end_time
       GROUP BY ua.agent_rank, ua.id, su.username, ua.parent_id, oas.api_id, oas.game_type
       --ORDER BY ua.agent_rank DESC, ua.id, su.username, ua.parent_id, oas.api_id, oas.game_type
    ),
    rat AS (
      SELECT a_grad.agent_id,
             a_grad.agent_name,
             a_grad.agent_rank,
             a_grad.parent_id,
             a_grad.parent_array,
             a_grad.rebate_set_id,
             a_grad.rebate_grads_set_id,
             a_grad.rebate_grads_id,
             a_grad.effective_player,
             a_grad.max_rebate,
             oat.api_id,
             oat.game_type,
             oat.agent_array,
             oat.effective_transaction,
             oat.profit_loss,
             rga.ratio rebate_ratio
        FROM oat
               INNER JOIN
             a_grad ON oat.agent_id = a_grad.agent_id
               LEFT JOIN
             rebate_grads_api rga ON rga.id = ( SELECT id
                                                  FROM rebate_grads_api
                                                 WHERE rebate_grads_id = a_grad.rebate_grads_id
                                                   AND rebate_set_id = a_grad.rebate_set_id
                                                   AND api_id = oat.api_id
                                                   AND game_type = oat.game_type
                                              )
    ),
    rats --得到自身有效交易量、盈亏
    AS (
    SELECT rat.*,
           rga.ratio parent_ratio,
           oa.effective_transaction effective_self,
           oa.profit_loss profit_self
      FROM rat
             LEFT JOIN
           user_agent_rebate uar ON rat.parent_id = uar.user_id AND rat.agent_rank > 1 -- 一级代理不需要计算上级抽佣！！！！否则会关联出多个总代方案！！！！
             LEFT JOIN
           rebate_grads_api rga ON rga.rebate_grads_id = rat.rebate_grads_id
                               AND rga.rebate_set_id = uar.rebate_id
                               AND rga.api_id = rat.api_id
                               AND rga.game_type = rat.game_type
             LEFT JOIN
           (
             SELECT agent_id, api_id, game_type, SUM(effective_transaction) effective_transaction, -SUM(profit_loss) profit_loss
              FROM operate_agent
             WHERE static_time >= p_start_time
               AND static_time_end <= p_end_time
             GROUP BY agent_id, api_id, game_type
           ) oa ON rat.agent_id = oa.agent_id AND rat.api_id = oa.api_id AND rat.game_type= oa.game_type
    )
    INSERT INTO rebate_agent_api_nosettled (
           rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, rebate_set_id, rebate_grads_id, max_rebate, effective_player,
           api_id, game_type, agent_array, effective_transaction, profit_loss, rebate_ratio, parent_ratio,
           rebate_parent, effective_self, profit_self, rebate_self
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, rebate_set_id, rebate_grads_id, max_rebate, effective_player,
           api_id, game_type, agent_array, effective_transaction, profit_loss, rebate_ratio, parent_ratio,
           profit_loss * (parent_ratio-rebate_ratio)/100 rebate_parent,
         effective_self, profit_self,
         profit_self * rebate_ratio/100 rebate_self
    FROM rats;

    --更新字段: 下级代理贡献佣金
    UPDATE rebate_agent_api_nosettled raa
       SET rebate_sun = COALESCE(raa2.rebate_parent, 0)
      FROM
      ( SELECT * FROM rebate_agent_api_nosettled WHERE rebate_bill_id = p_bill_id
      ) raa1
      LEFT JOIN
      ( SELECT parent_id, api_id, game_type, SUM(rebate_parent) rebate_parent
          FROM rebate_agent_api_nosettled
         WHERE rebate_bill_id = p_bill_id
         GROUP BY parent_id, api_id, game_type
      ) raa2
      ON raa1.agent_id = raa2.parent_id
        AND raa1.api_id = raa2.api_id
        AND raa1.game_type = raa2.game_type
     WHERE raa.rebate_bill_id = p_bill_id
       AND raa.agent_id = raa1.agent_id
       AND raa.api_id = raa1.api_id
       AND raa.game_type = raa1.game_type;

  END IF;

  raise notice 'gb_rebate_agent_api.END: %', clock_timestamp();

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent_api(p_bill_id INT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_settle_flag TEXT)
IS 'Leisure-返佣结算账单.代理API返佣';

DROP FUNCTION IF EXISTS gamebox_operations_player(TEXT, TEXT, TEXT, JSON);
CREATE OR REPLACE FUNCTION gamebox_operations_player(
  start_time   TEXT,
  end_time   TEXT,
  curday     TEXT,
  rec     JSON
) RETURNS text AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-玩家报表
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.03  2016/06/13  Leisure  is_profit_loss=false的记录也需要统计by acheng
--v1.04  2016/06/27  Leisure  统计时间由bet_time改为payout_time --by acheng
--v1.05  2016/07/08  Leisure  优化输出日志
--v1.05  2016/10/05  Leisure  撤销v1.03的修改 by kitty
--v1.06  2017/02/05  Leisure  删除is_profit_loss = TRUE条件
--v1.07  2016/09/18  Leisure  增加彩金字段统计
*/
DECLARE
  rtn     text:='';
  n_count    INT:=0;
  site_id   INT;
  master_id   INT;
  center_id   INT;
  site_name   TEXT:='';
  master_name TEXT:='';
  center_name TEXT:='';
  d_static_date DATE; --v1.02  2016/05/31
BEGIN
  --v1.02  2016/05/31  Leisure
  d_static_date := to_date(curday, 'YYYY-MM-DD');

  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
  --delete from operate_player WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
  delete from operate_player WHERE static_date = d_static_date;

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice '本次删除记录数 %', n_count;
  rtn = rtn||'|执行完毕,删除记录数: '||n_count||' 条||';

  --开始执行玩家经营报表信息收集
  site_id   = COALESCE((rec->>'siteid')::INT, -1);
  site_name  = COALESCE(rec->>'sitename', '');
  master_id  = COALESCE((rec->>'masterid')::INT, -1);
  master_name  = COALESCE(rec->>'mastername', '');
  center_id  = COALESCE((rec->>'operationid')::INT, -1);
  center_name  = COALESCE(rec->>'operationname', '');

  raise info '开始日期:%, 结束日期:%', start_time, end_time;
  INSERT INTO operate_player(
    center_id, center_name, master_id, master_name,
    site_id, site_name, topagent_id, topagent_name,
    agent_id, agent_name, player_id, player_name,
    api_id, api_type_id, game_type,
    --static_time, create_time, --v1.02  2016/05/31  Leisure
    static_date, static_time, static_time_end, create_time,
    transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  ) SELECT
      center_id, center_name, master_id, master_name,
      site_id, site_name, u.topagent_id, u.topagent_name,
      u.agent_id, u.agent_name, u.id, u.username,
      p.api_id, p.api_type_id, p.game_type,
      --now(), now(), --v1.02  2016/05/31  Leisure
      d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
      p.transaction_order, p.transaction_volume, p.effective_transaction,
      p.profit_loss, p.winning_amount, p.contribution_amount
      FROM (SELECT
              player_id, api_id, api_type_id, game_type,
              COUNT(order_no)                as transaction_order,
              COALESCE(SUM(single_amount), 0.00)      as transaction_volume,
              COALESCE(SUM(profit_amount), 0.00)      as profit_loss,
              COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
              COALESCE(SUM(winning_amount), 0.00) as winning_amount,
              COALESCE(SUM(contribution_amount), 0.00) as contribution_amount
             FROM player_game_order
            --WHERE bet_time >= start_time::TIMESTAMP
            --  AND bet_time < end_time::TIMESTAMP
            WHERE payout_time >= start_time::TIMESTAMP
              AND payout_time < end_time::TIMESTAMP
              AND order_state = 'settle'
              --v1.06  2017/02/05  Leisure
              --AND is_profit_loss = TRUE --v1.03  2016/06/13  Leisure
            GROUP BY player_id, api_id, api_type_id, game_type
            ) p, v_sys_user_tier u
  WHERE p.player_id = u.id;

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice '本次插入数据量 %', n_count;
  rtn = rtn||'|执行完毕,新增记录数: '||n_count||' 条||';

  return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-玩家报表';


drop function IF EXISTS gamebox_operations_agent(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_agent(
  start_time   TEXT,
  end_time   TEXT,
  curday   TEXT,
  rec   JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-代理报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.02  2016/06/13  Leisure  修正一处bug
--v1.03  2016/07/08  Leisure  优化输出日志
--v1.04  2016/09/18  Leisure  增加彩金字段统计
*/
DECLARE
  rtn     text:='';
  v_COUNT    int4:=0;
  s_id     INT;
  m_id     INT;
  c_id     INT;
  s_name     TEXT:='';
  m_name     TEXT:='';
  c_name     TEXT:='';
  d_static_date DATE; --v1.01  2016/05/31
BEGIN
  --v1.01  2016/05/31  Leisure
  d_static_date := to_date(curday, 'YYYY-MM-DD');

  --清除当天的统计信息，保证每天只作一次统计信息
  --raise info '清除当天的统计信息，保证每天只作一次统计信息';
  rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
  --delete from operate_agent WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
  delete from operate_agent WHERE static_date = d_static_date;

  GET DIAGNOSTICS v_COUNT = ROW_COUNT;
  raise notice '本次删除记录数 %', v_COUNT;
  rtn = rtn||'|执行完毕,删除记录数: '||v_COUNT||' 条||';

  --开始执行代理经营报表信息收集
  rtn = rtn||'|开始执行'||curday||'代理经营报表||';

  s_id   = COALESCE((rec->>'siteid')::INT,-1);
  s_name   = COALESCE(rec->>'sitename','');
  m_id   = COALESCE((rec->>'masterid')::INT,-1);
  m_name   = COALESCE(rec->>'mastername','');
  c_id   = COALESCE((rec->>'operationid')::INT,-1);
  c_name   = COALESCE(rec->>'operationname','');
  --执行代理统计
  INSERT INTO operate_agent(
    center_id, center_name, master_id, master_name,
    site_id, site_name, topagent_id, topagent_name,
    agent_id, agent_name, api_id, api_type_id, game_type,
    --static_time, create_time, --v1.01  2016/05/31  Leisure
    static_date, static_time, static_time_end, create_time,
    player_num, transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  ) SELECT
      c_id, c_name, m_id, m_name,
      s_id, s_name, topagent_id, topagent_name,
      agent_id, agent_name, api_id, api_type_id, game_type,
      --now(), now(), --v1.01  2016/05/31  Leisure
      --t_static_time, now(), --v1.02  2016/06/13  Leisure
      d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
      COUNT(DISTINCT player_id)             as player_num,
      COALESCE(SUM (transaction_order), 0)       as transaction_order,
      COALESCE(SUM (transaction_volume), 0.00)     as transaction_volume,
      COALESCE(SUM (effective_transaction), 0.00)   as effective_transaction,
      COALESCE(SUM (profit_loss), 0.00)         as profit_loss,
      COALESCE(SUM(winning_amount), 0.00) as winning_amount,
      COALESCE(SUM(contribution_amount), 0.00) as contribution_amount
    FROM operate_player
   --WHERE to_char(static_time,  'YYYY-MM-dd') = curday
   WHERE static_date = d_static_date --v1.01  2016/05/31  Leisure
   GROUP BY topagent_id, topagent_name, agent_id, agent_name, api_id, api_type_id, game_type;

  GET DIAGNOSTICS v_COUNT = ROW_COUNT;
  raise notice '本次插入数据量 %', v_COUNT;
  rtn = rtn||'|执行完毕,新增记录数: '||v_COUNT||' 条||';

  return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_agent(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-代理报表';


drop function IF EXISTS gamebox_operations_topagent(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_topagent(
  start_time   TEXT,
  end_time   TEXT,
  curday   TEXT,
  rec   JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-总代报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.02  2016/07/08  Leisure  优化输出日志
--v1.03  2016/09/18  Leisure  增加彩金字段统计
*/
DECLARE
  rtn     text:='';
  v_COUNT    int4:=0;
  s_id     INT;
  m_id     INT;
  c_id     INT;
  s_name     TEXT:='';
  m_name     TEXT:='';
  c_name     TEXT:='';
  d_static_date DATE; --v1.01  2016/05/31
BEGIN
  --v1.01  2016/05/31  Leisure
  d_static_date := to_date(curday, 'YYYY-MM-DD');
  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
  --DELETE FROM operate_topagent WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
  DELETE FROM operate_topagent WHERE static_date = d_static_date;
  GET DIAGNOSTICS v_COUNT = ROW_COUNT;
  raise notice '本次删除记录数 %', v_COUNT;
  rtn = rtn||'|执行完毕,删除记录数: '||v_COUNT||' 条||';
  --开始执行总代经营报表信息收集
  rtn = rtn||'|开始执行'||curday||'总代经营报表||';

  s_id   = COALESCE((rec->>'siteid')::INT, -1);
  s_name   = COALESCE(rec->>'sitename', '');
  m_id   = COALESCE((rec->>'masterid')::INT, -1);
  m_name   = COALESCE(rec->>'mastername', '');
  c_id   = COALESCE((rec->>'operationid')::INT, -1);
  c_name   = COALESCE(rec->>'operationname', '');

  INSERT INTO operate_topagent(
    center_id, center_name, master_id, master_name,
    site_id, site_name, topagent_id, topagent_name,
    api_id, api_type_id, game_type,
    --static_time, create_time, --v1.01  2016/05/31  Leisure
    static_date, static_time, static_time_end, create_time,
    player_num, transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  ) SELECT
      c_id, c_name, m_id, m_name,
      s_id, s_name, topagent_id, topagent_name,
      api_id, api_type_id, game_type,
      --now(), now(), --v1.01  2016/05/31  Leisure
      d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
      SUM (player_num)                as player_num,
      COALESCE(SUM (transaction_order), 0)       as transaction_order,
      COALESCE(SUM (transaction_volume), 0.00)     as transaction_volume,
      COALESCE(SUM (effective_transaction), 0.00)   as effective_transaction,
      COALESCE(SUM (profit_loss), 0.00)         as profit_loss,
      COALESCE(SUM(winning_amount), 0.00) as winning_amount,
      COALESCE(SUM(contribution_amount), 0.00) as contribution_amount
    FROM operate_agent
   --WHERE to_char(static_time,  'YYYY-MM-dd') = curday
   WHERE static_date = d_static_date --v1.01  2016/05/31  Leisure
   GROUP BY topagent_id, topagent_name, api_id, api_type_id, game_type;

  GET DIAGNOSTICS v_COUNT = ROW_COUNT;
  raise notice '本次插入数据量 %',  v_COUNT;
    rtn = rtn||'|执行完毕,新增记录数: '||v_COUNT||' 条||';

  return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_topagent(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-总代报表';


drop function if exists gamebox_operations_site(TEXT);
create or replace function gamebox_operations_site(
  curday text
) returns SETOF record as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-站点报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
--v1.02  2016/09/18  Leisure  增加彩金字段统计
*/
DECLARE
  rec record;
  d_static_date DATE; --v1.01  2016/05/31
BEGIN
  --v1.01  2016/05/31  Leisure
  d_static_date := to_date(curday, 'YYYY-MM-DD');

  FOR rec IN
      SELECT site_id, api_id, game_type, api_type_id,
         SUM (player_num)       as players_num,
         SUM (transaction_order)     as transaction_order,
         SUM (transaction_volume)   as transaction_volume,
         SUM (effective_transaction)   as effective_transaction_volume,
         SUM (profit_loss)       as transaction_profit_loss,
         SUM(winning_amount) as winning_amount,
         SUM(contribution_amount) as contribution_amount
        FROM operate_topagent
       --WHERE to_char(static_time, 'YYYY-MM-dd') = curday
       WHERE static_date = d_static_date
       GROUP BY site_id,api_id,game_type,api_type_id
  LOOP
    RETURN NEXT rec;
  END LOOP;

END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_site(curday TEXT)
IS 'Lins-经营报表-站点报表';