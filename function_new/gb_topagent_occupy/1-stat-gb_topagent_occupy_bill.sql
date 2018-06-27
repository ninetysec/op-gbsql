DROP FUNCTION IF EXISTS gb_topagent_occupy_bill(TEXT, TEXT, INT, INT, INT);
CREATE OR REPLACE FUNCTION gb_topagent_occupy_bill(
  p_comp_url   TEXT,
  p_site_url   TEXT,
  p_site_id    INT,
  p_occupy_year   INT,
  p_occupy_month  INT
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Laser  创建此函数: 总代占成账单-入口
--v1.01  2017/07/22  Laser  增加重跑前删除旧数据功能

*/
DECLARE

  n_occupy_bill_no TEXT;    -- 账务流水号
  --rec_site_info RECORD;
  --h_station_bill HSTORE;
  d_date_of_month TIMESTAMP;
  --n_year     INT;
  --n_month   INT;

  v_return_code TEXT;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  IF ltrim(rtrim(p_comp_url)) = '' THEN
    RAISE EXCEPTION '-1, 运营商URL为空';
  END IF;

  IF ltrim(rtrim(p_site_url)) = '' THEN
    RAISE EXCEPTION '-1, 站点库URL为空';
  END IF;

  --v1.01  2017/07/22  Laser
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
  --v1.11  2017/07/10  Laser
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
    RETURN 2;
  END IF;

  --h_station_bill = h_station_bill || ('bill_no=>'||n_occupy_bill_no::TEXT)::hstore;

  --同步站点库统计结果到统计库
  SELECT gb_topagent_occupy_create(  p_site_url, p_site_id, n_occupy_bill_no, p_occupy_year, p_occupy_month) INTO v_return_code;
  IF v_return_code <> '0' THEN
    RAISE NOTICE '同步统计结果到统计库失败！';
    RETURN '2';
  END IF;

  RETURN 0;

EXCEPTION
  WHEN QUERY_CANCELED THEN
    RAISE NOTICE '用户取消操作！';
    perform dblink_disconnect_all();
    RETURN 2;
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    perform dblink_disconnect_all();

    RETURN 2;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_topagent_occupy_bill( p_comp_url TEXT, p_site_url TEXT, p_site_id INT, p_occupy_year INT, p_occupy_month INT)
IS 'Laser-总代占成账单-入口';
