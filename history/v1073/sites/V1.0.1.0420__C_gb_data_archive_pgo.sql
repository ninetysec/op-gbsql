-- auto gen by cherry 2017-03-31 20:04:28
DROP FUNCTION IF EXISTS gb_data_archive_pgo(DATE, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_data_archive_pgo(
  p_archive_date   DATE,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/02/20  Leisure  创建此函数:数据归档-pgo
*/
DECLARE

  v_rel_name   VARCHAR;
  n_rel_count   INT;
  n_count  INT;

BEGIN

  IF now() - p_end_time < '40 day' THEN
    RAISE INFO '当前日期数据小于40天，不能进行归档！';
    RETURN -1;
  END IF;

  IF p_archive_date < '2016-10-01' THEN
    v_rel_name = 'player_game_order_bak_20161001';
  ELSE
    v_rel_name = 'player_game_order_bak_' || to_char(p_archive_date, 'YYYYMM');
  END IF;

  SELECT COUNT(*)
    INTO n_rel_count
    FROM pg_catalog.pg_class c
         LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
   WHERE c.relname = v_rel_name
     AND pg_catalog.pg_table_is_visible(c.oid);

  IF n_rel_count = 0 THEN
    EXECUTE 'CREATE TABLE ' || v_rel_name || ' ( LIKE player_game_order INCLUDING COMMENTS )';
  END IF;

  CREATE TABLE IF NOT EXISTS player_audit_status (player_id INT PRIMARY KEY, clear_audit_time TIMESTAMP);

  TRUNCATE TABLE player_audit_status;

  INSERT INTO player_audit_status
  SELECT player_id, max(CREATE_TIME)
    FROM player_withdraw
   WHERE is_clear_audit = TRUE
     AND withdraw_status = '4'
   GROUP BY player_id;

  EXECUTE 'INSERT INTO ' || v_rel_name || ' SELECT * FROM player_game_order pgo '||
          ' WHERE order_state = ''settle''' ||
          ' AND payout_time >= ''' || p_start_time::TEXT || '''' ||
          ' AND payout_time < ''' || p_end_time::TEXT || '''' ||
          ' AND payout_time < (SELECT clear_audit_time FROM player_audit_status WHERE player_id = pgo.player_id)';

  DELETE FROM player_game_order pgo
   WHERE order_state = 'settle'
     AND payout_time >= p_start_time
     AND payout_time < p_end_time
     AND payout_time < (SELECT clear_audit_time FROM player_audit_status WHERE player_id = pgo.player_id);

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice 'player_game_order本次归档记录数 %', n_count;
  RETURN n_count;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_data_archive_pgo(p_archive_date   DATE, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-数据归档-pgo';