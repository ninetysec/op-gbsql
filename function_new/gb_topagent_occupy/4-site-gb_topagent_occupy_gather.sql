DROP FUNCTION IF EXISTS gb_topagent_occupy_gather( TEXT, INT, INT);
CREATE OR REPLACE FUNCTION gb_topagent_occupy_gather(
  p_occupy_bill_no TEXT,
  p_occupy_year   INT,
  p_occupy_month   INT
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Laser  创建此函数: 总代占成账单-总代汇总
--v1.01  2017/08/21  Laser  适应多级代理返佣调整

*/
--费用类型(以player_transaction为准): backwater, favorable, recommend, refund_fee, rebate 佣金, poundage 存取款手续费
DECLARE

  --v1.01  2017/08/21  Leisure
  h_apportion_setting hstore;
  --n_refund_fee_ratio FLOAT := 0.00;
  n_favorable_ratio FLOAT := 0.00;
  n_rakeback_ratio   FLOAT := 0.00;
  n_rebate_ratio     FLOAT := 0.00;
  v_period VARCHAR(7);

BEGIN

  --v1.01  2017/08/21  Leisure
  SELECT gamebox_sys_param('apportionSetting') INTO h_apportion_setting;

  --n_refund_fee_ratio = h_apportion_setting->'topagent.poundage.percent';
  n_favorable_ratio = h_apportion_setting->'topagent.preferential.percent';
  n_rakeback_ratio   = h_apportion_setting->'topagent.rakeback.percent';
  n_rebate_ratio     = h_apportion_setting->'topagent.rebate.percent';

  v_period = to_char( to_date( p_occupy_year::TEXT||'-'||p_occupy_month::TEXT, 'YYYY-MM'), 'YYYY-MM');

  --插入总代API占成表
  --v1.01  2017/08/21  Leisure
  INSERT INTO topagent_occupy ( occupy_bill_no, occupy_year, occupy_month, topagent_id, topagent_name, profit_amount, operation_occupy, topagent_occupy,
      favorable, favorable_ratio, rakeback, rakeback_ratio, rebate, rebate_ratio, apportion_value)
  SELECT p_occupy_bill_no, p_occupy_year, p_occupy_month, ut.topagent_id, ut.topagent_name,
      COALESCE(profit_amount, 0),
      COALESCE(operation_occupy, 0),
      COALESCE(topagent_occupy, 0),
      --COALESCE(poundage, 0),
      COALESCE(favorable, 0),
      n_favorable_ratio,
      --COALESCE(recommend, 0),
      --COALESCE(refund_fee, 0),
      COALESCE(rakeback, 0),
      n_rakeback_ratio,
      COALESCE(rebate, 0),
      n_rebate_ratio,
      --COALESCE(apportion_ratio, 0),
      --( COALESCE(poundage, 0) + COALESCE(favorable, 0) + COALESCE(recommend, 0) + COALESCE(refund_fee, 0) +
      --  COALESCE(rakeback, 0) + COALESCE(rebate, 0) ) * COALESCE(apportion_ratio, 0)/100
      COALESCE(favorable, 0) * n_favorable_ratio/100 + COALESCE(rakeback, 0) * n_rakeback_ratio/100 +
      COALESCE(rebate, 0) * n_rebate_ratio/100
   FROM
  (
    SELECT id topagent_id, username topagent_name FROM sys_user WHERE user_type='22'
  ) ut
  LEFT JOIN
  (
    SELECT topagent_id,
           SUM(profit_amount)    profit_amount,
           SUM(operation_occupy) operation_occupy,
           SUM(occupy_value)     topagent_occupy,
           MAX(occupy_ratio)     apportion_ratio
      FROM topagent_occupy_api
     WHERE occupy_bill_no = p_occupy_bill_no
     GROUP BY topagent_id
  ) toi
  ON ut.topagent_id = toi.topagent_id
  --v1.01  2017/08/21  Leisure
  LEFT JOIN
  (
    SELECT su.owner_id                           AS topagent_id,
           SUM(favorable_amount)                 AS favorable,
           SUM(rakeback_amount)                  AS rakeback,
           SUM(rebate_self + rebate_sun)         AS rebate
      FROM rebate_agent ra, rebate_bill rb, sys_user su
     WHERE ra.rebate_bill_id = rb.id
       AND rb.period = v_period
       AND ra.agent_id = su.id
       AND su.user_type = '23'
     GROUP BY su.owner_id
  ) ar
  ON ut.topagent_id = ar.topagent_id
   WHERE (toi.topagent_id IS NOT NULL OR ar.topagent_id IS NOT NULL)
  ;
  /*--v1.01  2017/08/21  Leisure
  LEFT JOIN
  (
    SELECT topagent_id,
           SUM(fee_amount)       poundage,
           SUM(favorable_amount) favorable,
           SUM(other_amount)     recommend,
           0 refund_fee,
           SUM(rakeback_amount)  rakeback,
           SUM(rebate_amount)    rebate
      FROM agent_rebate
     WHERE rebate_year  = p_occupy_year
       AND rebate_month = p_occupy_month
     GROUP BY topagent_id
  ) ar
  ON ut.topagent_id = ar.topagent_id
  ;
  */

  RETURN 0;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_topagent_occupy_gather( p_occupy_bill_no TEXT, p_occupy_year INT, p_occupy_month INT)
IS 'Leisure-总代占成账单-总代汇总';
