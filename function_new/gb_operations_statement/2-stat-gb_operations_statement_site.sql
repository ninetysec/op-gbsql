DROP FUNCTION IF EXISTS gb_operations_statement_site(text, text, text, text, text, text, int);
CREATE OR REPLACE FUNCTION gb_operations_statement_site(
  p_comp_url    text,
  p_static_date text,
  p_site_url    text,
  p_start_time  text,
  p_end_time    text,
  p_siteid      text,
  p_stat_days   int
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/02/23  Laser    创建此函数: 经营报表-站点报表
--v1.01  2017/09/18  Laser    修改dblink的连接方式
*/
DECLARE

  rtn text:='';
  tmp text:='';
  v_static_date  varchar;
  v_start_time   varchar;
  v_end_time     varchar;

BEGIN

  FOR i IN 0..p_stat_days - 1 LOOP

    v_static_date := (p_static_date::DATE + (i||'day')::INTERVAL)::DATE::TEXT;
    v_start_time  := (p_start_time::TIMESTAMP + (i||'day')::INTERVAL)::TEXT;
    v_end_time    := (p_end_time::TIMESTAMP + (i||'day')::INTERVAL)::TEXT;

    RAISE INFO '%, %, %', v_static_date, v_start_time, v_end_time;

    --raise notice '当前站点库信息：%', p_site_url;
    IF p_site_url is null OR trim(p_site_url) = '' THEN
      return '站点库信息不能为空';
    END IF;

    --连接站点库
    perform dblink_connect_u('master', p_site_url);

    tmp = '    ┗ 开始收集站点id['||p_siteid||'],日期['|| v_static_date ||']经营报表';
    raise notice '%', tmp;
    --执行玩家经营报表
    rtn = rtn||chr(13)||chr(10)||tmp;
    SELECT P .msg
      FROM
      dblink ('master', --p_site_url, --v1.01  2017/09/18  Laser
              'SELECT * from gamebox_operations_statement('''||p_comp_url||''', '||p_siteid||', '''||v_static_date||''', '''||v_start_time||''', '''||v_end_time||''')'
      ) AS P (msg TEXT)
      INTO tmp ;
    rtn = rtn||tmp;
    raise notice '收集完毕';
    --收集站点经营报表
    rtn = rtn||chr(13)||chr(10)||'        ┗4.正在执行站点经营报表';
    SELECT gamebox_operation_site('master', p_siteid, v_static_date, v_start_time, v_end_time) into tmp;
    rtn = rtn||'||'||tmp;
    perform dblink_disconnect('master');

    rtn = rtn||chr(13)||chr(10)||'    ┗收集完毕';
  END LOOP;

  return rtn;

END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gb_operations_statement_site(p_comp_url text, p_static_date  text, p_site_url text, p_start_time text, p_end_time text, p_siteid text, p_stat_days  int)
IS 'Laser-经营报表-站点经营报表';
