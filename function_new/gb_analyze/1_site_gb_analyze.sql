drop function if exists gb_analyze(DATE, TIMESTAMP, TIMESTAMP);
create or replace function gb_analyze(
  p_stat_date   DATE,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) RETURNS INT as $$
/*版本更新说明
  版本   时间        作者   内容
--v1.00  2016/12/10  Laser  创建此函数: 经营分析-玩家
--v1.01  2016/12/19  Laser  取款改为实际取款。存取款改由存取款表获取
--v1.02  2017/01/19  Laser  删除条件“是否盈亏”
--v1.04  2018/07/01  steffan 存取款取自交易表，投注取自玩家游戏下单表 , 玩家更改代理线后，代理信息不会变
*/
DECLARE
  rec   record;
  gs_id   INT;
  n_count   INT;
  n_count_player   INT;

BEGIN

  raise info '清除 % 号统计数据...', p_stat_date;
  DELETE FROM analyze_player WHERE static_date = p_stat_date;
  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice 'analyze_player 本次删除记录数 %', n_count;

  raise info '统计 % 号经营数据.START', p_stat_date;

  /*代理信息从交易中取，不从sys_user查询，注释掉.
  WITH up AS
  (
    SELECT su."id" player_id,
           su.username user_name,
           ua."id" agent_id,
           ua.username agent_name,
           ut."id" topagent_id,
           ut.username topagent_name,
           su.register_site,
           su.create_time >= p_start_time AND su.create_time < p_end_time is_new_player
      FROM sys_user su
      LEFT JOIN  sys_user ua ON ua.user_type= '23' AND su.owner_id = ua."id"
      LEFT JOIN  sys_user ut ON ut.user_type= '22' AND ua.owner_id = ut."id"
     WHERE su.user_type = '24'
  ),

  pr AS (
          --存款
           SELECT player_id,
                  --'deposit' AS transaction_type,
                  COUNT(id) deposit_count,
                  SUM(recharge_amount) deposit_amount
             FROM player_recharge
            WHERE recharge_status IN ('2', '5')
              AND create_time >= p_start_time AND create_time < p_end_time
            GROUP BY player_id
  ),

  pw AS (
           --取款
           SELECT player_id,
                  --'withdrawal' AS transaction_type,
                  COUNT(id) withdraw_count,
                  --v1.03  2017/10/17  Laser --SUM(withdraw_actual_amount)
                  SUM(withdraw_amount) withdraw_amount
             FROM player_withdraw
            WHERE withdraw_type IN ('manual_deposit', 'first', 'normal')
              AND withdraw_status = '4'
              AND create_time >= p_start_time AND create_time < p_end_time
            GROUP BY player_id
  ),

  pgo AS (
    SELECT player_id,
           COUNT(id) transaction_order,
           SUM(single_amount) transaction_volume,
           SUM(effective_trade_amount) effective_amount,
           SUM(profit_amount) payout_amount
      FROM player_game_order
     WHERE order_state = 'settle'
       --v1.02  2017/01/19  Laser
       --AND is_profit_loss = TRUE
       AND payout_time >= p_start_time
       AND payout_time < p_end_time
     GROUP BY player_id
  )

  INSERT INTO analyze_player (
      player_id,
      user_name,
      agent_id,
      agent_name,
      topagent_id,
      topagent_name,
      promote_link,
      is_new_player,
      deposit_amount,
      deposit_count,
      withdraw_amount,
      withdraw_count,
      transaction_order,
      transaction_volume,
      effective_amount,
      payout_amount,
      static_date,
      static_time,
      static_time_end
  )
  SELECT up.*, pr.deposit_amount, pr.deposit_count, pw.withdraw_amount, pw.withdraw_count,
         pgo.transaction_order, pgo.transaction_volume, pgo.effective_amount, pgo.payout_amount,
         p_stat_date, p_start_time, p_end_time
    FROM up
    LEFT JOIN pr ON up.player_id = pr.player_id
    LEFT JOIN pw ON up.player_id = pw.player_id
    LEFT JOIN pgo ON up.player_id = pgo.player_id;
*/

 --存取款改为player_transaction交易表，内有存款时的代理信息
  WITH pr AS (
          --存款
           SELECT player_id,
                  user_name user_name,
                  agent_id agent_id,
                  agent_username agent_name,
                  topagent_id topagent_id,
                  topagent_username topagent_name,
                  COUNT(id) deposit_count,
                  SUM(transaction_money) deposit_amount,
                  0 withdraw_amount,
                  0 withdraw_count,
                  0 transaction_order,
                  0 transaction_volume,
                  0 effective_amount,
                  0 payout_amount
             FROM player_transaction
            WHERE status = 'success'
              AND transaction_type = 'deposit'
              AND completion_time >= p_start_time AND completion_time < p_end_time
            GROUP BY player_id,user_name,agent_id,agent_name,topagent_id,topagent_name
  ),

  pw AS (
           --取款
           SELECT player_id,
                  user_name user_name,
                  agent_id agent_id,
                  agent_username agent_name,
                  topagent_id topagent_id,
                  topagent_username topagent_name,
                  0 deposit_count,
                  0 deposit_amount,
                  COUNT(id) withdraw_count,
                  SUM(transaction_money) withdraw_amount,
                  0 transaction_order,
                  0 transaction_volume,
                  0 effective_amount,
                  0 payout_amount
             FROM player_transaction
            WHERE  status = 'success'
              AND transaction_type = 'withdrawals'
              AND completion_time >= p_start_time AND completion_time < p_end_time
            GROUP BY player_id,user_name,agent_id,agent_name,topagent_id,topagent_name
  ),

  pgo AS (
    SELECT player_id,
           username user_name,
           agentid agent_id,
           agentusername agent_name,
           topagentid topagent_id,
           topagentusername topagent_name,
           0 deposit_count,
           0 deposit_amount,
           0 withdraw_count,
           0 withdraw_amount,
           COUNT(id) transaction_order,
           SUM(single_amount) transaction_volume,
           SUM(effective_trade_amount) effective_amount,
           SUM(profit_amount) payout_amount
      FROM player_game_order
     WHERE order_state = 'settle'
       --v1.02  2017/01/19  Laser
       --AND is_profit_loss = TRUE
       AND payout_time >= p_start_time
       AND payout_time < p_end_time
     GROUP BY player_id,user_name,agent_id,agent_name,topagent_id,topagent_name
  ),

  -- 玩家的存款，取款，投注分别是三条数据，聚合成一条后插入analyze_player
  prwgo AS (
    SELECT player_id,
           username user_name,
           agentid agent_id,
           agentusername agent_name,
           topagentid topagent_id,
           topagentusername topagent_name,
           sum(deposit_count),
           sum(deposit_amount),
           sum(withdraw_count),
           sum(withdraw_amount),
           sum(transaction_order),
           sum(transaction_volume),
           sum(effective_amount),
           sum(payout_amount)
      FROM
           ( SELECT * FROM pr union all SELECT * FROM pw union all SELECT * FROM pgo ) rwo

     GROUP BY player_id,user_name,agent_id,agent_name,topagent_id,topagent_name
  )

  --插入analyze_player，
  INSERT INTO analyze_player (
      player_id,
      user_name,
      agent_id,
      agent_name,
      topagent_id,
      topagent_name,
      promote_link,
      is_new_player,
      deposit_amount,
      deposit_count,
      withdraw_amount,
      withdraw_count,
      transaction_order,
      transaction_volume,
      effective_amount,
      payout_amount,
      static_date,
      static_time,
      static_time_end
  )
  SELECT su.id,
         prwgo.user_name,
         prwgo.agent_id,
         prwgo.agent_name,
         prwgo.topagent_id,
         prwgo.topagent_name,
         su.register_site,
         su.create_time >= p_start_time AND su.create_time < p_end_time is_new_player,
         prwgo.deposit_amount,
         prwgo.deposit_count,
         prwgo.withdraw_amount,
         prwgo.withdraw_count,
         prwgo.transaction_order,
         prwgo.transaction_volume,
         prwgo.effective_amount,
         prwgo.payout_amount,
         prwgo.static_date,
         prwgo.static_time,
         prwgo.static_time_end
    FROM sys_user su
         LEFT JOIN
         prwgo ON su.id = prwgo.player_id
   WHERE su.user_type = '24';


  GET DIAGNOSTICS n_count_player = ROW_COUNT;
  raise notice 'analyze_player新增统计记录数 %', n_count_player;

  raise info 'analyze_agent 清除 % 号统计数据...', p_stat_date;
  DELETE FROM analyze_agent WHERE static_date = p_stat_date;
  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice 'analyze_agent 本次删除记录数 %', n_count;

  raise info '统计 % 号经营数据.END', p_stat_date;

  INSERT INTO analyze_agent (
      agent_id,
      agent_name,
      topagent_id,
      topagent_name,
      new_player_num,
      new_player_num_deposit,
      new_player_num_withdraw,
      new_player_deposit_count,
      new_player_withdraw_count,
      new_player_deposit_amount,
      new_player_withdraw_amount,
      player_num_deposit,
      player_num_withdraw,
      deposit_amount,
      withdraw_amount,
      transaction_order,
      transaction_volume,
      effective_amount,
      rebate_amount,
      payout_amount,
      static_date,
      static_time,
      static_time_end
  )
  SELECT
      ap.agent_id,
      ap.agent_name,
      ap.topagent_id,
      ap.topagent_name,
      apn.new_player_num,
      apn.new_player_num_deposit,
      apn.new_player_num_withdraw,
      apn.new_player_deposit_count,
      apn.new_player_withdraw_count,
      apn.new_player_deposit_amount,
      apn.new_player_withdraw_amount,
      ap.player_num_deposit,
      ap.player_num_withdraw,
      ap.deposit_amount,
      ap.withdraw_amount,
      ap.transaction_order,
      ap.transaction_volume,
      ap.effective_amount,
      ra.rebate_amount,
      ap.payout_amount,
      p_stat_date,
      p_start_time,
      p_end_time
    FROM
     ( SELECT
          agent_id,
          agent_name,
          topagent_id,
          topagent_name,
          SUM(sign(deposit_amount)) player_num_deposit,
          SUM(sign(withdraw_amount)) player_num_withdraw,
          SUM(deposit_amount) deposit_amount,
          SUM(withdraw_amount) withdraw_amount,
          SUM(transaction_order) transaction_order,
          SUM(transaction_volume) transaction_volume,
          SUM(effective_amount) effective_amount,
          SUM(payout_amount) payout_amount
       FROM analyze_player
      WHERE static_date = p_stat_date
      GROUP BY agent_id, agent_name, topagent_id, topagent_name
    ) ap
    LEFT JOIN

    ( SELECT
          agent_id,
          SUM (is_new_player::INT) new_player_num,
          SUM(sign(deposit_count)) new_player_num_deposit,
          SUM(sign(withdraw_count)) new_player_num_withdraw,
          SUM(deposit_count) new_player_deposit_count,
          SUM(withdraw_count) new_player_withdraw_count,
          SUM(deposit_amount) new_player_deposit_amount,
          SUM(withdraw_amount) new_player_withdraw_amount
       FROM analyze_player
      WHERE is_new_player = TRUE
        AND static_date = p_stat_date
      GROUP BY agent_id, agent_name, topagent_id, topagent_name
    ) apn
    ON ap.agent_id = apn.agent_id
    LEFT JOIN

    ( SELECT agent_id,
            COALESCE(SUM(ra.rebate_actual), 0.00) rebate_amount
       FROM rebate_agent ra
      WHERE ra.settlement_time >= p_start_time AND ra.settlement_time < p_end_time
        AND ra.settlement_state = 'lssuing'
      GROUP BY agent_id
    ) ra
    ON ap.agent_id = ra.agent_id;

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice 'analyze_agent新增记录数 %', n_count;

  raise info 'analyze_agent_domain 清除 % 号统计数据...', p_stat_date;
  DELETE FROM analyze_agent_domain WHERE static_date = p_stat_date;
  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice 'analyze_agent_domain 本次删除记录数 %', n_count;

  raise info '统计 % 号经营数据.END', p_stat_date;

  INSERT INTO analyze_agent_domain (
      promote_link,
      agent_id,
      agent_name,
      topagent_id,
      topagent_name,
      new_player_num,
      new_player_num_deposit,
      new_player_num_withdraw,
      new_player_deposit_count,
      new_player_withdraw_count,
      new_player_deposit_amount,
      new_player_withdraw_amount,
      player_num_deposit,
      player_num_withdraw,
      deposit_amount,
      withdraw_amount,
      transaction_order,
      transaction_volume,
      effective_amount,
      --rebate_amount,
      payout_amount,
      static_date,
      static_time,
      static_time_end
  )
  SELECT
      ap.promote_link,
      ap.agent_id,
      ap.agent_name,
      ap.topagent_id,
      ap.topagent_name,
      apn.new_player_num,
      apn.new_player_num_deposit,
      apn.new_player_num_withdraw,
      apn.new_player_deposit_count,
      apn.new_player_withdraw_count,
      apn.new_player_deposit_amount,
      apn.new_player_withdraw_amount,
      ap.player_num_deposit,
      ap.player_num_withdraw,
      ap.deposit_amount,
      ap.withdraw_amount,
      ap.transaction_order,
      ap.transaction_volume,
      ap.effective_amount,
      --ra.rebate_amount,
      ap.payout_amount,
      p_stat_date,
      p_start_time,
      p_end_time
    FROM
    ( SELECT
          promote_link,
          agent_id,
          agent_name,
          topagent_id,
          topagent_name,
          SUM(sign(deposit_amount)) player_num_deposit,
          SUM(sign(withdraw_amount)) player_num_withdraw,
          SUM(deposit_amount) deposit_amount,
          SUM(withdraw_amount) withdraw_amount,
          SUM(transaction_order) transaction_order,
          SUM(transaction_volume) transaction_volume,
          SUM(effective_amount) effective_amount,
          SUM(payout_amount) payout_amount
       FROM analyze_player
      WHERE static_date = p_stat_date
      GROUP BY promote_link, agent_id, agent_name, topagent_id, topagent_name
    ) ap
    LEFT JOIN

    ( SELECT
          promote_link,
          agent_id,
          SUM (is_new_player::INT) new_player_num,
          SUM(sign(deposit_count)) new_player_num_deposit,
          SUM(sign(withdraw_count)) new_player_num_withdraw,
          SUM(deposit_count) new_player_deposit_count,
          SUM(withdraw_count) new_player_withdraw_count,
          SUM(deposit_amount) new_player_deposit_amount,
          SUM(withdraw_amount) new_player_withdraw_amount
       FROM analyze_player
      WHERE is_new_player = TRUE
        AND static_date = p_stat_date
      GROUP BY promote_link, agent_id, agent_name, topagent_id, topagent_name
    ) apn
    ON ap.agent_id = apn.agent_id AND ap.promote_link = apn.promote_link;

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice 'analyze_agent_domain新增记录数 %', n_count;

  RETURN n_count_player;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_analyze(p_stat_date DATE, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Laser-经营分析-玩家';
