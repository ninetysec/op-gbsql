DROP FUNCTION IF EXISTS gb_data_archive( TEXT, TEXT, TEXT, TEXT, TIMESTAMP, TIMESTAMP, INT);
CREATE OR REPLACE FUNCTION gb_data_archive(
  p_table_names    TEXT,
  p_time_column    TEXT,
  p_condition      TEXT,
  p_archive_month  TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP,
  p_limit_days INT
) RETURNS INT AS $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2017/11/21  Laser   创建此函数:数据归档-通用
--v1.01  2018/06/01  Laser   增加v_condition初始化
*/
DECLARE

  d_archive_month DATE;
  v_target_name    VARCHAR;
  arr_table_name  VARCHAR[];
  v_condition  TEXT := ''; --v1.01  2018/06/01  Laser
  v_source_name VARCHAR;
  n_rel_count   INT;
  n_count  INT;
  v_sql TEXT;

BEGIN

  d_archive_month := to_date(p_archive_month, 'YYYY-MM');

  IF now() - p_end_time < (p_limit_days || ' days')::interval THEN
    RAISE INFO '距离当前日期小于 % 天，不能进行归档！', p_limit_days;
    RETURN 1;
  END IF;

  arr_table_name = regexp_split_to_array( replace(p_table_names, ' ', ''), ',');

  IF length(p_condition) > 0 THEN
    v_condition = ' AND (' ||  p_condition || ')';
  END IF;

  v_target_name = '';
  FOR v_source_name IN SELECT unnest(arr_table_name)
  LOOP

    IF d_archive_month < '2016-10-01' THEN
      v_target_name = v_source_name || '_bak_20161001';
    ELSE
      v_target_name = v_source_name || '_bak_' || to_char(d_archive_month, 'YYYYMM');
    END IF;

    SELECT COUNT(*)
      INTO n_rel_count
      FROM pg_catalog.pg_class c
           LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
     WHERE c.relname = v_target_name
       AND pg_catalog.pg_table_is_visible(c.oid);

    IF n_rel_count = 0 THEN
      v_sql = 'CREATE TABLE ' || v_target_name || ' ( LIKE '|| v_source_name || ' INCLUDING COMMENTS )';
      EXECUTE v_sql;
    END IF;

    v_sql = 'WITH t AS ' ||
            '( DELETE FROM ' || v_source_name || ' pgo '||
            '   WHERE '|| p_time_column ||' >= ''' || p_start_time::TEXT || '''' ||
            '     AND '|| p_time_column ||' < ''' || p_end_time::TEXT || ''' ' ||
            v_condition ||
            '   RETURNING * ) ' ||
            'INSERT INTO ' || v_target_name || ' SELECT * FROM t';
    EXECUTE v_sql;

    GET DIAGNOSTICS n_count = ROW_COUNT;
    RAISE NOTICE '% 本次归档记录数 %', v_target_name, n_count;

    EXECUTE 'SELECT COUNT(*) FROM ( SELECT * FROM ' || v_target_name || ' LIMIT 1) t'
    INTO n_count;

    IF n_count = 0 THEN
      EXECUTE 'DROP TABLE ' || v_target_name;
      RAISE NOTICE '% 记录数为0, 已删除', v_target_name;
    END IF;

  END LOOP;

  RETURN 0;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_data_archive( p_table_names TEXT, p_time_column TEXT, p_condition TEXT, d_archive_month TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_limit_days INT)
IS 'Laser-数据归档-通用';
