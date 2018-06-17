-- auto gen by steffan 2018-06-01 17:35:59 create by min
DROP FUNCTION IF EXISTS gb_data_archive_lbo(TEXT, TIMESTAMP, TIMESTAMP, INT);
CREATE OR REPLACE FUNCTION gb_data_archive_lbo(
  p_archive_month text,
  p_start_time    timestamp,
  p_end_time      timestamp,
  p_limit_days    int4
) RETURNS pg_catalog.int4 AS
$BODY$

/*版本更新说明
  版本   时间        作者    内容
--v1.00  2018/06/01  Min     创建此函数:数据归档-lbo
*/

DECLARE

 --d_archive_month DATE; --暂时无日期处理需求 --v1.00 2018/06/01 Min

 v_table_names VARCHAR;

BEGIN

  --d_archive_month := to_date(p_archive_month, 'YYYY-MM');

  v_table_names = 'lottery_bet_order';

  perform gb_data_archive( v_table_names, 'payout_time', '', p_archive_month, p_start_time, p_end_time, p_limit_days);

  RETURN 0;

END;

$BODY$
LANGUAGE plpgsql VOLATILE;
COMMENT ON FUNCTION gb_data_archive_lbo( p_archive_month text, p_start_time timestamp, p_end_time timestamp, p_limit_days int4)
IS 'Laser-数据归档-lbo';