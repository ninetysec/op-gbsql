-- auto gen by cherry 2017-07-24 14:41:26
DROP FUNCTION IF EXISTS dblink_disconnect_all();
CREATE OR REPLACE FUNCTION dblink_disconnect_all()
returns TEXT as $$
DECLARE linkname TEXT;
BEGIN

  FOR linkname IN ( SELECT unnest(dblink_get_connections()) )
  LOOP
    PERFORM dblink_disconnect(linkname);
  END LOOP;

  RETURN 'OK';

END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION dblink_disconnect_all()
IS 'Leisure-断开所有dblink连接.';


DROP FUNCTION IF EXISTS gb_topagent_occupy_bill(TEXT, TEXT, INT, INT, INT);
CREATE OR REPLACE FUNCTION gb_topagent_occupy_bill(
  p_comp_url   TEXT,
  p_site_url   TEXT,
  p_site_id    INT,
  p_occupy_year   INT,
  p_occupy_month  INT
) returns TEXT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Leisure  创建此函数: 总代占成账单-入口
--v1.01  2017/07/22  Leisure  增加重跑前删除旧数据功能
*/
DECLARE

  n_occupy_bill_no TEXT;    -- 账务流水号
  --rec_site_info RECORD;
  --h_station_bill HSTORE;
  d_date_of_month TIMESTAMP;
  --n_year     INT;
  --n_month   INT;

  v_return_code TEXT;

BEGIN

  IF ltrim(rtrim(p_comp_url)) = '' THEN
    RAISE EXCEPTION '-1, 运营商URL为空';
  END IF;

  IF ltrim(rtrim(p_site_url)) = '' THEN
    RAISE EXCEPTION '-1, 站点库URL为空';
  END IF;

  --v1.01  2017/07/22  Leisure
  -- 删除重复运行记录.
  DELETE FROM station_bill_other WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = p_site_id AND bill_year = p_occupy_year AND bill_month = p_occupy_month AND bill_type = '2');
  DELETE FROM station_profit_loss WHERE station_bill_id IN (SELECT id FROM station_bill WHERE site_id = p_site_id AND bill_year = p_occupy_year AND bill_month = p_occupy_month AND bill_type = '2');
  DELETE FROM station_bill WHERE site_id = p_site_id AND bill_year = p_occupy_year AND bill_month = p_occupy_month AND bill_type = '2';

  --下面是生成总表记录
  --SELECT gamebox_site_map(p_site_id::INT) INTO h_station_bill;
  --h_station_bill = h_station_bill || ('bill_type=>'||'2')::hstore; -- 账务类型，2表示总代占成账单

  /*
  d_date_of_month = p_start_time::TIMESTAMP;
  IF extract(day FROM d_date_of_month) <> '1' THEN
    d_date_of_month = d_date_of_month + INTERVAL'1 day';
  END IF;

  SELECT extract( year FROM d_date_of_month) INTO n_year;
  SELECT extract( month FROM d_date_of_month) INTO n_month;
  */

  --h_station_bill = h_station_bill || ('year=>'||p_occupy_year)::hstore||('month=>'||p_occupy_month)::hstore;

  perform dblink_disconnect_all();
  --v1.11  2017/07/10  Leisure
  perform dblink_connect_u('master',  p_site_url);
  --总代账单流水号
  SELECT gamebox_generate_order_no('B', p_site_id::TEXT, '04', 'master') INTO n_occupy_bill_no;
  RAISE NOTICE '账单流水号: %', n_occupy_bill_no;

  --到站点库统计本月占成情况
  SELECT return_code
    INTO v_return_code
    FROM dblink( 'master',
                 'SELECT gb_topagent_occupy(''' || p_comp_url || ''',''' || n_occupy_bill_no || ''',' || p_occupy_year || ',' || p_occupy_month || ')'
               ) AS t(return_code TEXT);

  --关闭连接
  perform dblink_disconnect('master');

  IF v_return_code <> '0' THEN
    RAISE NOTICE '到站点库统计本月占成情况失败！';
    RETURN '2';
  END IF;

  --h_station_bill = h_station_bill || ('bill_no=>'||n_occupy_bill_no::TEXT)::hstore;

  --同步站点库统计结果到统计库
  SELECT gb_topagent_occupy_create(  p_site_url, p_site_id, n_occupy_bill_no, p_occupy_year, p_occupy_month) INTO v_return_code;
  IF v_return_code <> '0' THEN
    RAISE NOTICE '同步统计结果到统计库失败！';
    RETURN '2';
  END IF;

  RETURN '0';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_topagent_occupy_bill( p_comp_url TEXT, p_site_url TEXT, p_site_id INT, p_occupy_year INT, p_occupy_month INT)
IS 'Leisure-总代占成账单-入口';


DROP FUNCTION IF EXISTS gb_topagent_occupy_create(TEXT, INT, TEXT, INT, INT);
CREATE OR REPLACE FUNCTION gb_topagent_occupy_create(
  p_site_url   TEXT,
  p_site_id    INT,
  p_occupy_bill_no TEXT,
  p_occupy_year   INT,
  p_occupy_month  INT
) returns TEXT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Leisure  创建此函数: 总代占成账单-入口
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
    SELECT * FROM
       dblink( 'master',
              'SELECT topagent_id, topagent_name, profit_amount, operation_occupy, topagent_occupy,
                      poundage, favorable, recommend, refund_fee, rakeback, rebate, apportion_retio, apportion_value
                 FROM topagent_occupy WHERE occupy_bill_no =''' || p_occupy_bill_no || ''''
             )
       AS t ( topagent_id int4,
              topagent_name varchar(32),
              profit_amount numeric(20,2),
              operation_occupy numeric(20,2),
              topagent_occupy numeric(20,2),
              poundage numeric(20,2),
              favorable numeric(20,2),
              recommend numeric(20,2),
              refund_fee numeric(20,2),
              rakeback numeric(20,2),
              rebate numeric(20,2),
              apportion_retio numeric(20,2),
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
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'poundage', rec_to.poundage*rec_to.apportion_retio/100, rec_to.poundage*rec_to.apportion_retio/100, rec_to.apportion_retio);

    --优惠
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'favorable', rec_to.favorable*rec_to.apportion_retio/100, rec_to.favorable*rec_to.apportion_retio/100, rec_to.apportion_retio);

    --推荐
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'recommend', rec_to.recommend*rec_to.apportion_retio/100, rec_to.recommend*rec_to.apportion_retio/100, rec_to.apportion_retio);

    --返手续费
    --INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    --VALUES (n_station_bill_id, 'refund_fee', rec_to.refund_fee*rec_to.apportion_retio/100, rec_to.refund_fee*rec_to.apportion_retio/100, rec_to.apportion_retio);

    --返水
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'backwater', rec_to.rakeback*rec_to.apportion_retio/100, rec_to.rakeback*rec_to.apportion_retio/100, rec_to.apportion_retio);

    --返佣
    INSERT INTO station_bill_other( station_bill_id, project_code, amount_payable, amount_actual, apportion_proportion)
    VALUES (n_station_bill_id, 'rebate', rec_to.rebate*rec_to.apportion_retio/100, rec_to.rebate*rec_to.apportion_retio/100, rec_to.apportion_retio);

    v_sql = 'SELECT api_id, api_type_id, game_type, profit_amount, occupy_retio, occupy_value
                   FROM topagent_occupy_api
                  WHERE occupy_bill_no = ''' || p_occupy_bill_no || ''' AND topagent_id =' || rec_to.topagent_id;
    RAISE INFO 'SQL: %', v_sql;

    INSERT INTO station_profit_loss ( station_bill_id, api_id, api_type_id, game_type, profit_loss, occupy_proportion, amount_payable)
    SELECT
      n_station_bill_id, api_id, api_type_id, game_type, profit_amount, occupy_retio, occupy_value
      FROM
        dblink( 'master',
                'SELECT api_id, api_type_id, game_type, profit_amount, occupy_retio, occupy_value
                   FROM topagent_occupy_api
                  WHERE occupy_bill_no = ''' || p_occupy_bill_no || ''' AND topagent_id =' || rec_to.topagent_id
        )
        AS t ( api_id int4,
               api_type_id int4,
               game_type varchar(32),
               profit_amount numeric(20,2),
               occupy_retio numeric(4,2),
               occupy_value numeric(20,2)
             );
  END LOOP;

  --关闭连接
  perform dblink_disconnect('master');

  RETURN '0';

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_topagent_occupy_create( p_site_url TEXT, p_site_id INT, p_occupy_bill_no TEXT, p_occupy_year INT, p_occupy_month INT)
IS 'Leisure-总代占成账单-入口';