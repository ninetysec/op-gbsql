DROP FUNCTION IF EXISTS gb_topagent_occupy_create(TEXT, INT, TEXT, INT, INT);
CREATE OR REPLACE FUNCTION gb_topagent_occupy_create(
  p_site_url   TEXT,
  p_site_id    INT,
  p_occupy_bill_no TEXT,
  p_occupy_year   INT,
  p_occupy_month  INT
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Laser    创建此函数: 总代占成账单-生成账单记录
--v1.01  2017/08/21  Laser    适应多级代理返佣调整
--v1.02  2017/09/03  Laser    numeric(4,2)溢出问题

*/
DECLARE

  rec_to record;
  rec_si record;
  --n_occupy_bill_no TEXT;
  n_station_bill_id INT;
  n_amount_payable FLOAT := 0;

  v_sql TEXT;

BEGIN

  perform dblink_connect_u('master',  p_site_url);

  FOR rec_to IN
    --v1.01  2017/08/21  Laser
    SELECT * FROM
       dblink( 'master',
              'SELECT topagent_id, topagent_name, profit_amount, operation_occupy, topagent_occupy,
                      favorable, favorable_ratio, rakeback, rakeback_ratio, rebate, rebate_ratio, apportion_value
                 FROM topagent_occupy WHERE occupy_bill_no =''' || p_occupy_bill_no || ''''
             )
       AS t ( topagent_id int4,
              topagent_name varchar(32),
              profit_amount numeric(20,2),
              operation_occupy numeric(20,2),
              topagent_occupy numeric(20,2),
              --poundage numeric(20,2),
              favorable numeric(20,2),
              favorable_ratio numeric(5,2),
              --recommend numeric(20,2),
              --refund_fee numeric(20,2),
              rakeback numeric(20,2),
              rakeback_ratio numeric(5,2),
              rebate numeric(20,2),
              rebate_ratio numeric(5,2),
              --apportion_ratio numeric(20,2),
              apportion_value numeric(20,2)
            )
  LOOP

    n_amount_payable = rec_to.topagent_occupy - rec_to.apportion_value;

    SELECT operationid center_id,
           operationname center_name,
           masterid master_id,
           mastername master_name,
           siteid site_id,
           sitename site_name
      INTO rec_si
      FROM sys_site_info WHERE siteid = p_site_id;

    INSERT INTO station_bill ( bill_num, center_id, center_name, master_id, master_name, site_id, site_name, topagent_id, topagent_name,
      bill_type, bill_year, bill_month, amount_payable, amount_actual, create_time)
    VALUES ( p_occupy_bill_no, rec_si.center_id, rec_si.center_name, rec_si.master_id, rec_si.master_name, rec_si.site_id, rec_si.site_name, rec_to.topagent_id, rec_to.topagent_name,
      '2', p_occupy_year, p_occupy_month, n_amount_payable, n_amount_payable, now()
    ) RETURNING id INTO n_station_bill_id;

    --手续费
    --INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    --VALUES (n_station_bill_id, 'poundage', rec_to.poundage*rec_to.apportion_ratio/100, rec_to.poundage*rec_to.apportion_ratio/100, rec_to.apportion_ratio);

    --优惠
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'favorable', rec_to.favorable*rec_to.favorable_ratio/100, rec_to.favorable*rec_to.favorable_ratio/100, rec_to.favorable_ratio);

    --推荐
    --INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    --VALUES (n_station_bill_id, 'recommend', rec_to.recommend*rec_to.apportion_ratio/100, rec_to.recommend*rec_to.apportion_ratio/100, rec_to.apportion_ratio);

    --返手续费
    --INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    --VALUES (n_station_bill_id, 'refund_fee', rec_to.refund_fee*rec_to.apportion_ratio/100, rec_to.refund_fee*rec_to.apportion_ratio/100, rec_to.apportion_ratio);

    --返水
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'backwater', rec_to.rakeback*rec_to.rakeback_ratio/100, rec_to.rakeback*rec_to.rakeback_ratio/100, rec_to.rakeback_ratio);

    --返佣
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'rebate', rec_to.rebate*rec_to.rebate_ratio/100, rec_to.rebate*rec_to.rebate_ratio/100, rec_to.rebate_ratio);

    v_sql = 'SELECT api_id, api_type_id, game_type, profit_amount, occupy_ratio, occupy_value
                   FROM topagent_occupy_api
                  WHERE occupy_bill_no = ''' || p_occupy_bill_no || ''' AND topagent_id =' || rec_to.topagent_id;
    RAISE INFO 'SQL: %', v_sql;

    --v1.02  2017/08/21  Laser
    INSERT INTO station_profit_loss ( station_bill_id, api_id, api_type_id, game_type, profit_loss, occupy_proportion, amount_payable)
    SELECT
      n_station_bill_id, api_id, api_type_id, game_type, profit_amount, occupy_ratio, occupy_value
      FROM
        dblink( 'master',
                'SELECT api_id, api_type_id, game_type, profit_amount, occupy_ratio, occupy_value
                   FROM topagent_occupy_api
                  WHERE occupy_bill_no = ''' || p_occupy_bill_no || ''' AND topagent_id =' || rec_to.topagent_id
        )
        AS t ( api_id int4,
               api_type_id int4,
               game_type varchar(32),
               profit_amount numeric(20,2),
               occupy_ratio numeric(5,2),
               occupy_value numeric(20,2)
             );
  END LOOP;

  --关闭连接
  perform dblink_disconnect('master');

  RETURN 0;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_topagent_occupy_create( p_site_url TEXT, p_site_id INT, p_occupy_bill_no TEXT, p_occupy_year INT, p_occupy_month INT)
IS 'Laser-总代占成账单-生成账单记录';
