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
