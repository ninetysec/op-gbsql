-- auto gen by steffan 2018-06-01 17:36:17 create by min
DROP FUNCTION IF EXISTS gb_data_archive_scheduler(TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_data_archive_scheduler(
  p_archive_month text,
  p_start_time    timestamp,
  p_end_time      timestamp
) RETURNS pg_catalog.int4 AS
$BODY$

/*版本更新说明
  版本   时间        作者    内容
--v1.00  2018/06/01  Min     创建此函数:GB归档调度入口

*/

BEGIN

  perform gb_data_archive_pgo( p_archive_month, p_start_time, p_end_time, 63);  -- 归档63天
  RAISE NOTICE 'player_game_order归档完成';

  perform gb_data_archive_lbo( p_archive_month, p_start_time, p_end_time, 63);  -- 归档63天
  RAISE NOTICE 'lottery_bet_order归档完成';

RETURN 0;

END;

$BODY$ language plpgsql;
COMMENT ON FUNCTION gb_data_archive_scheduler(p_archive_month text, p_start_time timestamp, p_end_time timestamp )
IS 'Min-GB归档调度入口';