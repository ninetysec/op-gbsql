DROP FUNCTION IF EXISTS gb_topagent_occupy( TEXT, TEXT, INT, INT);
CREATE OR REPLACE FUNCTION gb_topagent_occupy(
  p_comp_url   TEXT,
  p_occupy_bill_no TEXT,
  p_occupy_year   INT,
  p_occupy_month   INT
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/12  Laser  创建此函数: 总代占成账单-入口
--v1.01  2017/07/22  Laser  增加重跑前删除旧数据功能
--v1.02  2017/08/21  Laser  适应多级代理返佣调整

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
  --v1.02  2017/08/21  Laser  
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
IS 'Laser-总代占成账单-站点入口(外调)';
