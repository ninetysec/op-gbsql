-- auto gen by cherry 2017-09-02 10:11:05
SELECT redo_sqls($$
ALTER TABLE topagent_occupy ADD COLUMN favorable_ratio numeric(5,2) default 0;
ALTER TABLE topagent_occupy ADD COLUMN rakeback_ratio numeric(5,2) default 0;
ALTER TABLE topagent_occupy ADD COLUMN rebate_ratio numeric(5,2) default 0;
$$);

COMMENT ON COLUMN topagent_occupy.favorable_ratio IS '优惠承担比率';
COMMENT ON COLUMN topagent_occupy.rakeback_ratio IS '返水承担比率';
COMMENT ON COLUMN topagent_occupy.rebate_ratio IS '返佣承担比率';

SELECT redo_sqls($$
ALTER TABLE topagent_occupy_api RENAME COLUMN operation_retio TO operation_ratio;
ALTER TABLE topagent_occupy_api RENAME COLUMN occupy_retio TO occupy_ratio;
$$);

ALTER TABLE topagent_occupy_api ALTER COLUMN operation_ratio TYPE numeric(5,2);
ALTER TABLE topagent_occupy_api ALTER COLUMN occupy_ratio TYPE numeric(5,2);

DROP FUNCTION IF EXISTS gb_topagent_occupy( TEXT, TEXT, INT, INT);
CREATE OR REPLACE FUNCTION gb_topagent_occupy(
  p_comp_url   TEXT,
  p_occupy_bill_no TEXT,
  p_occupy_year   INT,
  p_occupy_month   INT
) returns INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Leisure  创建此函数: 总代占成账单-入口
--v1.01  2017/07/22  Leisure  增加重跑前删除旧数据功能
--v1.02  2017/08/21  Leisure  适应多级代理返佣调整

*/
DECLARE

  h_net_schema_map  hstore[];
  n_sid INT;
  b_is_max  BOOLEAN:=true;

  --rec_site_info RECORD;
  h_station_bill HSTORE;
  d_date_of_month TIMESTAMP;
  n_year     INT;
  n_month   INT;

  v_period VARCHAR(7);
  n_bill_id  INT;
  n_count_rebate INT;

BEGIN

  --v1.01  2017/07/22
  DELETE FROM topagent_occupy WHERE occupy_year = p_occupy_year AND occupy_month = p_occupy_month;
  DELETE FROM topagent_occupy_api WHERE occupy_year = p_occupy_year AND occupy_month = p_occupy_month;

  --判断返佣账单是否已生成
  --v1.02  2017/08/21  Leisure
  /*
  SELECT count(*)
    INTO n_count_rebate
    FROM agent_rebate
   WHERE rebate_year = p_occupy_year
     AND rebate_month = p_occupy_month;
  */
  v_period = to_char( to_date( p_occupy_year::TEXT||'-'||p_occupy_month::TEXT, 'YYYY-MM'), 'YYYY-MM');

  SELECT count(*)
    INTO n_count_rebate
    FROM rebate_bill
   WHERE period = v_period;

  IF n_count_rebate = 0 THEN
    RAISE EXCEPTION '2, 本期返佣账单未生成，不能生成总代占成账单！';
    --RETURN 2;
  END IF;

  IF ltrim(rtrim(p_comp_url)) = '' THEN
    RAISE EXCEPTION '2, 获取包网方案失败';
  END IF;

  SELECT gamebox_current_site() INTO n_sid;

  raise info '取得包网方案';
  perform dblink_connect_u ('mainsite', p_comp_url);
  SELECT * FROM dblink('mainsite', 'SELECT gamebox_contract('||n_sid||', '||b_is_max||')') as a(hash hstore[]) INTO h_net_schema_map;
  --关闭连接
  perform dblink_disconnect('mainsite');

  raise info '统计总代API占成信息';
  perform gb_topagent_occupy_api( p_occupy_bill_no, p_occupy_year, p_occupy_month, h_net_schema_map);

  raise info '统计总代占成';
  perform gb_topagent_occupy_gather( p_occupy_bill_no, p_occupy_year, p_occupy_month);

  RETURN 0;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_topagent_occupy( p_comp_url TEXT, p_occupy_bill_no TEXT, p_occupy_year INT, p_occupy_month INT)
IS 'Leisure-总代占成账单-站点入口(外调)';


DROP FUNCTION IF EXISTS gb_topagent_occupy_api( TEXT, INT, INT, hstore[]);
CREATE OR REPLACE FUNCTION gb_topagent_occupy_api(
  p_occupy_bill_no TEXT,
  p_occupy_year   INT,
  p_occupy_month   INT,
  p_net_maps hstore[]
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Leisure  创建此函数: 总代占成账单-API占成
*/
DECLARE

  h_occupy_map hstore;

  rec_opt RECORD; --rec_agent_rebate_grads
  t_start_date DATE;
  t_end_date DATE;

  v_key VARCHAR;
  n_operation_ratio FLOAT:=0.00; --运营商占比
  n_operation_value FLOAT := 0.00;

  n_occupy_value FLOAT:=0.00; --总代占成金额

BEGIN

  --取得运营商占成
  h_occupy_map = p_net_maps[2];

  t_start_date = '' || p_occupy_year ||'-'|| p_occupy_month  ||'-'|| '1';
  t_end_date = t_start_date + INTERVAL'1 month';

  FOR rec_opt IN
    SELECT opt.topagent_id, opt.topagent_name, opt.api_id, opt.api_type_id, opt.game_type, opt.profit_amount, COALESCE(uaa.ratio, 0) topagent_ratio
      FROM
      (
      SELECT topagent_id, topagent_name, api_id, api_type_id, game_type,
             -COALESCE(SUM(profit_loss), 0) profit_amount
        FROM operate_topagent
       WHERE static_date >= t_start_date
         AND static_date < t_end_date
       GROUP BY topagent_id, topagent_name, api_id, api_type_id, game_type
      ) opt
      LEFT JOIN user_agent_api uaa
      ON opt.topagent_id = uaa.user_id AND opt.api_id = uaa.api_id AND opt.game_type = uaa.game_type
  LOOP

    v_key = rec_opt.api_id || '_' || rec_opt.game_type;

    n_operation_ratio = 0.00;

    --盈亏为负，运营商不占成
    IF rec_opt.profit_amount > 0 THEN
      IF isexists(h_occupy_map, v_key) THEN
        n_operation_ratio = (h_occupy_map->v_key)::FLOAT;
      ELSE
        RAISE NOTICE 'api: % game_type: % 未设置运营商占成！', rec_opt.api_id, rec_opt.game_type;
      END IF;
    END IF;

    n_operation_value = rec_opt.profit_amount * n_operation_ratio/100;

    n_occupy_value = rec_opt.profit_amount * (1 - n_operation_ratio/100) * rec_opt.topagent_ratio / 100;

    --插入总代API占成表
    INSERT INTO topagent_occupy_api ( occupy_bill_no, occupy_year, occupy_month, topagent_id, topagent_name, api_id, api_type_id, game_type,
      profit_amount, operation_ratio, operation_occupy, occupy_ratio, occupy_value)
    VALUES ( p_occupy_bill_no, p_occupy_year, p_occupy_month, rec_opt.topagent_id, rec_opt.topagent_name, rec_opt.api_id, rec_opt.api_type_id, rec_opt.game_type,
      rec_opt.profit_amount,n_operation_ratio, n_operation_value, rec_opt.topagent_ratio, n_occupy_value);

  END LOOP;

  RETURN 0;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_topagent_occupy_api( p_occupy_bill_no TEXT, p_occupy_year INT, p_occupy_month INT, p_net_maps hstore[])
IS 'Leisure-总代占成账单-API占成';


DROP FUNCTION IF EXISTS gb_topagent_occupy_gather( TEXT, INT, INT);
CREATE OR REPLACE FUNCTION gb_topagent_occupy_gather(
  p_occupy_bill_no TEXT,
  p_occupy_year   INT,
  p_occupy_month   INT
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Leisure  创建此函数: 总代占成账单-总代汇总
--v1.01  2017/08/21  Leisure  适应多级代理返佣调整

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