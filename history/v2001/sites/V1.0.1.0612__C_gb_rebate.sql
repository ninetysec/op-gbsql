-- auto gen by george 2017-11-29 15:42:56
DROP FUNCTION IF EXISTS gb_rebate(text, text, text, text);

CREATE OR REPLACE FUNCTION gb_rebate (

  p_period   text,

  p_start_time   text,

  p_end_time   text,

  p_settle_flag   text

) RETURNS INT AS $$

/*版本更新说明

  版本   时间        作者    内容

--v1.00  2016/10/08  Laser  创建此函数: 返佣结算账单-入口（新）

--v1.10  2017/07/31  Laser  增加多级代理返佣支持

--v1.11  2017/07/31  Laser  改用返佣周期判重

--v1.12  2017/11/20  Laser  改由period来确定上期



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

     WHERE (rb.period = p_period OR rb."start_time" = t_start_time) --v1.11  2017/07/31  Laser

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

  --v1.12  2017/11/20  Laser

  --perform gb_rebate_agent(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);

  perform gb_rebate_agent(n_rebate_bill_id, p_period, t_start_time, t_end_time, p_settle_flag);



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

IS 'Laser-返佣结算账单-入口（新）';





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

             rpf.deposit_fee + rpf.withdraw_fee + (rpf.rakeback_amount * COALESCE(rg.rakeback_ratio, rpf.rakeback_ratio)/100)::numeric(20,2)

             + (rpf.favorable_amount * COALESCE(rg.favorable_ratio, rpf.favorable_ratio)/100)::numeric(20,2)

             + (rpf.other_amount * COALESCE(rg.other_ratio, rpf.other_ratio)/100)::numeric(20,2) AS fee_amount,

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

             rpf.deposit_fee + rpf.withdraw_fee + (rpf.rakeback_amount * COALESCE(rg.rakeback_ratio, rpf.rakeback_ratio)/100)::numeric(20,2)

             + (rpf.favorable_amount * COALESCE(rg.favorable_ratio, rpf.favorable_ratio)/100)::numeric(20,2)

             + (rpf.other_amount * COALESCE(rg.other_ratio, rpf.other_ratio)/100)::numeric(20,2) AS fee_amount,

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





DROP FUNCTION IF EXISTS gb_data_archive_pgo(TEXT, TIMESTAMP, TIMESTAMP);

DROP FUNCTION IF EXISTS gb_data_archive_pgo(TEXT, TIMESTAMP, TIMESTAMP, INT);

CREATE OR REPLACE FUNCTION gb_data_archive_pgo(

  p_archive_month  TEXT,

  p_start_time   TIMESTAMP,

  p_end_time   TIMESTAMP,

  p_limit_days INT

) RETURNS INT AS $$

/*版本更新说明

  版本   时间        作者    内容

--v1.00  2017/02/20  Laser   创建此函数:数据归档-pgo

--v2.00  2017/10/05  Laser   新增pgo未稽核表，允许归档所有已结算数据

--v2.10  2017/11/21  Laser   改为通用的归档函数



*/

DECLARE



  d_archive_month DATE;

  v_table_names   VARCHAR;



BEGIN



  d_archive_month := to_date(p_archive_month, 'YYYY-MM');



  v_table_names = 'player_game_order';



  IF d_archive_month >= '2017-08-01' THEN --8月新增detail表

     v_table_names = 'player_game_order,player_game_order_detail';

  END IF;



  perform gb_data_archive( v_table_names, 'payout_time', 'order_state IN (''settle'', ''cancel'')', p_archive_month, p_start_time, p_end_time, p_limit_days);



  RETURN 0;



END;



$$ language plpgsql;

COMMENT ON FUNCTION gb_data_archive_pgo(d_archive_month TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_limit_days INT)

IS 'Laser-数据归档-pgo';





DROP FUNCTION IF EXISTS gb_data_archive(TEXT, TEXT, TEXT, TEXT, TIMESTAMP, TIMESTAMP, INT);

CREATE OR REPLACE FUNCTION gb_data_archive(

  p_table_names    TEXT,

  p_time_column    TEXT,

  p_condition      TEXT,

  p_archive_month  TEXT,

  p_start_time   TIMESTAMP,

  p_end_time   TIMESTAMP,

  p_limit_days INT

) RETURNS INT AS $$

/*版本更新说明

  版本   时间        作者    内容

--v1.00  2017/11/21  Laser   创建此函数:数据归档-通用

*/

DECLARE



  d_archive_month DATE;

  v_target_name    VARCHAR;

  arr_table_name  VARCHAR[];

  v_condition  TEXT;

  v_source_name VARCHAR;

  n_rel_count   INT;

  n_count  INT;



BEGIN



  d_archive_month := to_date(p_archive_month, 'YYYY-MM');



  IF now() - p_end_time < (p_limit_days || ' days')::interval THEN

    RAISE INFO '距离当前日期小于 % 天，不能进行归档！', p_limit_days;

    RETURN 1;

  END IF;



  arr_table_name = regexp_split_to_array( replace(p_table_names, ' ', ''), ',');



  IF length(p_condition) > 0 THEN

    v_condition = ' AND (' ||  p_condition || ')';

  END IF;



  v_target_name = '';

  FOR v_source_name IN SELECT unnest(arr_table_name)

  LOOP



    IF d_archive_month < '2016-10-01' THEN

      v_target_name = v_source_name || '_bak_20161001';

    ELSE

      v_target_name = v_source_name || '_bak_' || to_char(d_archive_month, 'YYYYMM');

    END IF;



    SELECT COUNT(*)

      INTO n_rel_count

      FROM pg_catalog.pg_class c

           LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace

     WHERE c.relname = v_target_name

       AND pg_catalog.pg_table_is_visible(c.oid);



    IF n_rel_count = 0 THEN

      EXECUTE 'CREATE TABLE ' || v_target_name || ' ( LIKE '|| v_source_name || ' INCLUDING COMMENTS )';

    END IF;



    EXECUTE 'WITH t AS ' ||

            '( DELETE FROM ' || v_source_name || ' pgo '||

            '   WHERE '|| p_time_column ||' >= ''' || p_start_time::TEXT || '''' ||

            '     AND '|| p_time_column ||' < ''' || p_end_time::TEXT || ''' ' ||

            v_condition ||

            '   RETURNING * ) ' ||

            'INSERT INTO ' || v_target_name || ' SELECT * FROM t';



    GET DIAGNOSTICS n_count = ROW_COUNT;

    RAISE NOTICE '% 本次归档记录数 %', v_target_name, n_count;



    EXECUTE 'SELECT COUNT(*) FROM ( SELECT * FROM ' || v_target_name || ' LIMIT 1) t'

    INTO n_count;



    IF n_count = 0 THEN

      EXECUTE 'DROP TABLE ' || v_target_name;

      RAISE NOTICE '% 记录数为0, 已删除', v_target_name;

    END IF;



  END LOOP;



  RETURN 0;



END;



$$ language plpgsql;

COMMENT ON FUNCTION gb_data_archive(p_table_names TEXT, p_time_column TEXT, p_condition TEXT, d_archive_month TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_limit_days INT)

IS 'Laser-数据归档-通用';