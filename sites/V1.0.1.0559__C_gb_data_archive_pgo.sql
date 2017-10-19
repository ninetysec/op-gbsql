-- auto gen by george 2017-10-17 10:45:58
DROP FUNCTION IF EXISTS gb_data_archive_pgo(TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_data_archive_pgo(
  p_archive_month  TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2017/02/20  Laser   创建此函数:数据归档-pgo
--v2.00  2017/10/05  Laser   新增pgo未稽核表，允许归档所有已结算数据

*/
DECLARE

  d_archive_month DATE;
  v_rel_name    VARCHAR;
  arr_rel_name  VARCHAR[];
  v_source_name VARCHAR;
  n_rel_count   INT;
  n_count  INT;

BEGIN

  d_archive_month := to_date(p_archive_month, 'YYYY-MM');

  IF now() - p_end_time < '40 day' THEN
    RAISE INFO '距离当前日期小于40天，不能进行归档！';
    RETURN 1;
  END IF;

  IF d_archive_month < '2016-10-01' THEN
    v_rel_name = 'player_game_order_bak_20161001';
  ELSE
    v_rel_name = 'player_game_order_bak_' || to_char(d_archive_month, 'YYYYMM');
  END IF;

  arr_rel_name = array_append( arr_rel_name, v_rel_name);

  IF d_archive_month >= '2017-08-01' THEN --8月新增detail表
     v_rel_name = 'player_game_order_detail_bak_' || to_char(d_archive_month, 'YYYYMM');
     arr_rel_name = array_append( arr_rel_name, v_rel_name);
  END IF;

  v_rel_name = '';
  FOR v_rel_name IN SELECT unnest(arr_rel_name)
  LOOP

    IF position('detail' in v_rel_name) > 0 THEN
      v_source_name = 'player_game_order_detail';
    ELSE
      v_source_name = 'player_game_order';
    END IF;
    SELECT COUNT(*)
      INTO n_rel_count
      FROM pg_catalog.pg_class c
           LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
     WHERE c.relname = v_rel_name
       AND pg_catalog.pg_table_is_visible(c.oid);

    IF n_rel_count = 0 THEN
      EXECUTE 'CREATE TABLE ' || v_rel_name || ' ( LIKE '|| v_source_name || ' INCLUDING COMMENTS )';
    END IF;

    EXECUTE 'WITH t AS ' ||
            '( DELETE FROM ' || v_source_name || ' pgo '||
            '   WHERE order_state IN (''settle'', ''cancel'')' ||
            '     AND payout_time >= ''' || p_start_time::TEXT || '''' ||
            '     AND payout_time < ''' || p_end_time::TEXT || '''
               RETURNING * ) ' ||
            'INSERT INTO ' || v_rel_name || ' SELECT * FROM t';

    GET DIAGNOSTICS n_count = ROW_COUNT;
    RAISE NOTICE '% 本次归档记录数 %', v_rel_name, n_count;

    EXECUTE 'SELECT COUNT(*) FROM ( SELECT * FROM ' || v_rel_name || ' LIMIT 1) t'
    INTO n_count;

    IF n_count = 0 THEN
      EXECUTE 'DROP TABLE ' || v_rel_name;
      RAISE NOTICE '% 记录数为0, 已删除', v_rel_name;
    END IF;

  END LOOP;

  RETURN 0;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_data_archive_pgo(d_archive_month TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Laser-数据归档pgo';



DROP FUNCTION IF EXISTS gb_drop_null_archive_pgo();
CREATE OR REPLACE FUNCTION gb_drop_null_archive_pgo()
 RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2017/10/14  Laser   创建此函数:删除空归档表pgo

*/
DECLARE

  v_rel_name    VARCHAR;
  n_count  INT;

BEGIN

  FOR v_rel_name IN
    SELECT relname
      FROM pg_catalog.pg_class c
           LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
     WHERE ( c.relname LIKE 'player_game_order_bak%' OR c.relname LIKE 'player_game_order_detail_bak%')
       AND pg_catalog.pg_table_is_visible(c.oid)
     ORDER BY relname
  LOOP

    EXECUTE 'SELECT COUNT(*) FROM ( SELECT * FROM ' || v_rel_name || ' LIMIT 1) t'
    INTO n_count;

    IF n_count = 0 THEN
      EXECUTE 'DROP TABLE ' || v_rel_name;
      RAISE NOTICE '% 记录数为0, 已删除', v_rel_name;
    END IF;

  END LOOP;

  RETURN 0;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_drop_null_archive_pgo() IS 'Laser-删除空归档表pgo';
