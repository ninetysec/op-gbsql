DROP FUNCTION IF EXISTS gb_rebate_agent(INT, TIMESTAMP, TIMESTAMP, TEXT);
DROP FUNCTION IF EXISTS gb_rebate_agent(INT, TEXT, TIMESTAMP, TIMESTAMP, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_agent(
  p_bill_id   INT,
  p_period    TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP,
  p_settle_flag   TEXT
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2016/10/08  Laser  创建此函数: 返佣结算账单.代理返佣
--v1.10  2017/07/31  Laser  增加多级代理返佣支持
--v1.11  2017/09/03  Laser  取费用比率时，增加空值判断
--v1.12  2017/11/17  Laser  增加按梯度计算费用比率功能
--v1.13  2017/11/20  Laser  改由period来确定上期

*/
DECLARE

  --v1.13  2017/11/20  Laser
  --d_last_start_time TIMESTAMP;
  v_last_period     TEXT;

  n_deposit_ratio   FLOAT := 0;
  n_withdraw_ratio  FLOAT := 0;
  n_rakeback_ratio  FLOAT := 0;
  n_favorable_ratio FLOAT := 0;
  n_other_ratio     FLOAT := 0;

  h_param_array  hstore;

BEGIN

  --v1.11  2017/09/03  Laser
  SELECT string_agg(hstore(param_code, param_value)::TEXT, ',')::hstore
    FROM ( SELECT param_code, CASE param_value WHEN NULL THEN '0' WHEN '' THEN '0' ELSE param_value END
           FROM sys_param WHERE ( param_type = 'apportionSetting' OR param_type = 'rebateSetting') AND active = TRUE ORDER BY 1
         ) sp
    INTO h_param_array;

  n_deposit_ratio := COALESCE(h_param_array ->'settlement.deposit.fee', '0')::FLOAT;
  n_withdraw_ratio := COALESCE(h_param_array ->'settlement.withdraw.fee', '0')::FLOAT;
  n_rakeback_ratio := COALESCE(h_param_array ->'agent.rakeback.percent', '0')::FLOAT;
  n_favorable_ratio := COALESCE(h_param_array ->'agent.preferential.percent', '0')::FLOAT;
  n_other_ratio := COALESCE(h_param_array ->'agent.other.percent', '0')::FLOAT;

  --v1.13  2017/11/20  Laser
  --d_last_start_time := p_start_time + '1 day' + '-1 month' + '-1 day'; -- 加一天防止是月末日期，再取上个月。
  v_last_period := to_char( to_timestamp (p_period, 'YYYY-MM') - interval '1mon', 'YYYY-MM');

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
             n_deposit_ratio AS deposit_ratio,
             (SUM(deposit_amount) * n_deposit_ratio/100)::numeric(20,2) AS deposit_fee,

             SUM(withdraw_amount) AS withdraw_amount,
             n_withdraw_ratio AS withdraw_ratio,
             (SUM(withdraw_amount)*n_withdraw_ratio/100)::numeric(20,2) AS withdraw_fee,

             SUM(rakeback_amount) AS rakeback_amount,
             n_rakeback_ratio AS rakeback_ratio,
             --v1.12  2017/11/17  Laser
             --(SUM(rakeback_amount) * n_rakeback_ratio/100)::numeric(20,2) AS rakeback_fee,

             SUM(favorable_amount) AS favorable_amount,
             n_favorable_ratio AS favorable_ratio,
             --(SUM(favorable_amount) * n_favorable_ratio/100)::numeric(20,2) AS favorable_fee,

             SUM(other_amount) AS other_amount,
             n_other_ratio AS other_ratio
             --(SUM(other_amount) * n_other_ratio/100)::numeric(20,2) AS other_fee

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
       --v1.13  2017/11/20  Laser
       --WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE start_time = d_last_start_time)
       WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE period = v_last_period)
         AND settlement_state = 'next_lssuing'
    ),

    rai AS
    (
      SELECT ua.agent_id, ua.agent_name, ua.agent_rank, ua.parent_id, ua.parent_array, ua.rebate_set_id,
             raa.rebate_grads_id, raa.max_rebate, raa.effective_player, raa.effective_transaction, raa.profit_loss, raa.rebate_parent,
             raa.effective_self, raa.profit_self,
             raa.rebate_self, rah.rebate_self_history, raa.rebate_sun, rah.rebate_sun_history,
             rpf.deposit_amount, rpf.deposit_ratio, rpf.deposit_fee,
             rpf.withdraw_amount, rpf.withdraw_ratio, rpf.withdraw_fee,
             --v1.12  2017/11/17  Laser
             --rpf.rakeback_amount, rpf.rakeback_ratio, rpf.rakeback_fee,
             --rpf.favorable_amount, rpf.favorable_ratio, rpf.favorable_fee,
             --rpf.other_amount, rpf.other_ratio, rpf.other_fee,
             rpf.rakeback_amount, COALESCE(rg.rakeback_ratio, rpf.rakeback_ratio) rakeback_ratio, (rpf.rakeback_amount * COALESCE(rg.rakeback_ratio, rpf.rakeback_ratio)/100 )::numeric(20,2) rakeback_fee,
             rpf.favorable_amount, COALESCE(rg.favorable_ratio, rpf.favorable_ratio) favorable_ratio, (rpf.favorable_amount * COALESCE(rg.favorable_ratio, rpf.favorable_ratio)/100 )::numeric(20,2) favorable_fee,
             rpf.other_amount, COALESCE(rg.other_ratio, rpf.other_ratio) other_ratio, (rpf.other_amount * COALESCE(rg.other_ratio, rpf.other_ratio)/100 )::numeric(20,2) other_fee,
             --v1.12  2017/11/17  Laser
             --rpf.deposit_fee + rpf.withdraw_fee + rpf.rakeback_fee + rpf.favorable_fee + rpf.other_fee AS fee_amount,
             rpf.deposit_fee + rpf.withdraw_fee + (rpf.rakeback_amount * COALESCE(rg.rakeback_ratio, rpf.rakeback_ratio))::numeric(20,2)
             + (rpf.favorable_amount * COALESCE(rg.favorable_ratio, rpf.favorable_ratio))::numeric(20,2) + (rpf.other_amount * COALESCE(rg.other_ratio, rpf.other_ratio))::numeric(20,2) AS fee_amount,
             rah.fee_history
        FROM ua
            LEFT JOIN
          raa ON ua.agent_id = raa.agent_id
            LEFT JOIN
          rebate_grads rg ON raa.rebate_grads_id = rg.id
            LEFT JOIN
          rpf ON ua.agent_id = rpf.agent_id
            LEFT JOIN
          rah ON ua.agent_id = rah.agent_id
    )

    INSERT INTO rebate_agent ( rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
        rebate_grads_id, max_rebate, effective_player, effective_transaction, profit_loss, rebate_parent, effective_self, profit_self,
        rebate_self, rebate_self_history, rebate_sun, rebate_sun_history, deposit_amount, deposit_ratio, deposit_fee,
        withdraw_amount, withdraw_ratio, withdraw_fee, rakeback_amount, rakeback_ratio, rakeback_fee,
        favorable_amount, favorable_ratio, favorable_fee, other_amount, other_ratio, other_fee, fee_amount, fee_history,
        rebate_total, rebate_actual, settlement_state
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
           rebate_grads_id, max_rebate, COALESCE(effective_player, 0), COALESCE(effective_transaction, 0), COALESCE(profit_loss, 0), COALESCE(rebate_parent, 0), COALESCE(effective_self, 0), COALESCE(profit_self, 0),
           COALESCE(rebate_self, 0), COALESCE(rebate_self_history, 0), COALESCE(rebate_sun, 0), COALESCE(rebate_sun_history, 0), COALESCE(deposit_amount, 0), COALESCE(deposit_ratio, 0), COALESCE(deposit_fee, 0),
           COALESCE(withdraw_amount, 0), COALESCE(withdraw_ratio, 0), COALESCE(withdraw_fee, 0), COALESCE(rakeback_amount, 0), COALESCE(rakeback_ratio, 0), COALESCE(rakeback_fee, 0),
           COALESCE(favorable_amount, 0), COALESCE(favorable_ratio, 0), COALESCE(favorable_fee, 0), COALESCE(other_amount, 0), COALESCE(other_ratio, 0), COALESCE(other_fee, 0), COALESCE(fee_amount, 0), COALESCE(fee_history, 0),
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
             n_deposit_ratio AS deposit_ratio,
             (SUM(deposit_amount) * n_deposit_ratio/100)::numeric(20,2) AS deposit_fee,

             SUM(withdraw_amount) AS withdraw_amount,
             n_withdraw_ratio AS withdraw_ratio,
             (SUM(withdraw_amount)*n_withdraw_ratio/100)::numeric(20,2) AS withdraw_fee,

             SUM(rakeback_amount) AS rakeback_amount,
             n_rakeback_ratio AS rakeback_ratio,
             --v1.12  2017/11/17  Laser
             --(SUM(rakeback_amount) * n_rakeback_ratio/100)::numeric(20,2) AS rakeback_fee,

             SUM(favorable_amount) AS favorable_amount,
             n_favorable_ratio AS favorable_ratio,
             --v1.12  2017/11/17  Laser
             --(SUM(favorable_amount) * n_favorable_ratio/100)::numeric(20,2) AS favorable_fee,

             SUM(other_amount) AS other_amount,
             n_other_ratio AS other_ratio
             --v1.12  2017/11/17  Laser
             --(SUM(other_amount) * n_other_ratio/100)::numeric(20,2) AS other_fee

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
        FROM rebate_agent --上期费用不要用nosettled表
        --v1.13  2017/11/20  Laser
        --WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE start_time = d_last_start_time)
        WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE period = v_last_period)
         AND settlement_state = 'next_lssuing'
    ),

    rai AS
    (
      SELECT ua.agent_id, ua.agent_name, ua.agent_rank, ua.parent_id, ua.parent_array, ua.rebate_set_id,
             raa.rebate_grads_id, raa.max_rebate, raa.effective_player, raa.effective_transaction, raa.profit_loss, raa.rebate_parent,
             raa.effective_self, raa.profit_self,
             raa.rebate_self, rah.rebate_self_history, raa.rebate_sun, rah.rebate_sun_history,
             rpf.deposit_amount, rpf.deposit_ratio, rpf.deposit_fee,
             rpf.withdraw_amount, rpf.withdraw_ratio, rpf.withdraw_fee,
             --v1.12  2017/11/17  Laser
             --rpf.rakeback_amount, rpf.rakeback_ratio, rpf.rakeback_fee,
             --rpf.favorable_amount, rpf.favorable_ratio, rpf.favorable_fee,
             --rpf.other_amount, rpf.other_ratio, rpf.other_fee,
             rpf.rakeback_amount, COALESCE(rg.rakeback_ratio, rpf.rakeback_ratio) rakeback_ratio, (rpf.rakeback_amount * COALESCE(rg.rakeback_ratio, rpf.rakeback_ratio)/100 )::numeric(20,2) rakeback_fee,
             rpf.favorable_amount, COALESCE(rg.favorable_ratio, rpf.favorable_ratio) favorable_ratio, (rpf.favorable_amount * COALESCE(rg.favorable_ratio, rpf.favorable_ratio)/100 )::numeric(20,2) favorable_fee,
             rpf.other_amount, COALESCE(rg.other_ratio, rpf.other_ratio) other_ratio, (rpf.other_amount * COALESCE(rg.other_ratio, rpf.other_ratio)/100 )::numeric(20,2) other_fee,
             --v1.12  2017/11/17  Laser
             --rpf.deposit_fee + rpf.withdraw_fee + rpf.rakeback_fee + rpf.favorable_fee + rpf.other_fee AS fee_amount,
             rpf.deposit_fee + rpf.withdraw_fee + (rpf.rakeback_amount * COALESCE(rg.rakeback_ratio, rpf.rakeback_ratio))::numeric(20,2)
             + (rpf.favorable_amount * COALESCE(rg.favorable_ratio, rpf.favorable_ratio))::numeric(20,2) + (rpf.other_amount * COALESCE(rg.other_ratio, rpf.other_ratio))::numeric(20,2) AS fee_amount,
             rah.fee_history
        FROM ua
            LEFT JOIN
          raa ON ua.agent_id = raa.agent_id
            LEFT JOIN
          rebate_grads rg ON raa.rebate_grads_id = rg.id
            LEFT JOIN
          rpf ON ua.agent_id = rpf.agent_id
            LEFT JOIN
          rah ON ua.agent_id = rah.agent_id
    )

    INSERT INTO rebate_agent_nosettled ( rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
        rebate_grads_id, max_rebate, effective_player, effective_transaction, profit_loss, rebate_parent, effective_self, profit_self,
        rebate_self, rebate_self_history, rebate_sun, rebate_sun_history, deposit_amount, deposit_ratio, deposit_fee,
        withdraw_amount, withdraw_ratio, withdraw_fee, rakeback_amount, rakeback_ratio, rakeback_fee,
        favorable_amount, favorable_ratio, favorable_fee, other_amount, other_ratio, other_fee, fee_amount, fee_history,
        rebate_total
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
           rebate_grads_id, max_rebate, COALESCE(effective_player, 0), COALESCE(effective_transaction, 0), COALESCE(profit_loss, 0), COALESCE(rebate_parent, 0), COALESCE(effective_self, 0), COALESCE(profit_self, 0),
           COALESCE(rebate_self, 0), COALESCE(rebate_self_history, 0), COALESCE(rebate_sun, 0), COALESCE(rebate_sun_history, 0), COALESCE(deposit_amount, 0), COALESCE(deposit_ratio, 0), COALESCE(deposit_fee, 0),
           COALESCE(withdraw_amount, 0), COALESCE(withdraw_ratio, 0), COALESCE(withdraw_fee, 0), COALESCE(rakeback_amount, 0), COALESCE(rakeback_ratio, 0), COALESCE(rakeback_fee, 0),
           COALESCE(favorable_amount, 0), COALESCE(favorable_ratio, 0), COALESCE(favorable_fee, 0), COALESCE(other_amount, 0), COALESCE(other_ratio, 0), COALESCE(other_fee, 0), COALESCE(fee_amount, 0), COALESCE(fee_history, 0),
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
COMMENT ON FUNCTION gb_rebate_agent(p_bill_id INT, p_period TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_settle_flag TEXT)
IS 'Laser-返佣结算账单.代理返佣';
