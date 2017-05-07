-- auto gen by cherry 2017-02-25 11:35:23
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
--v1.00  2017/02/23  Leisure  创建此函数: 经营报表-站点报表
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
    perform dblink_connect('master', p_site_url);

    tmp = '    ┗ 开始收集站点id['||p_siteid||'],日期['|| v_static_date ||']经营报表';
    raise notice '%', tmp;
    --执行玩家经营报表
    rtn = rtn||chr(13)||chr(10)||tmp;
    SELECT P .msg
      FROM
      dblink (p_site_url,
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
IS 'Lins-经营报表-站点经营报表';


drop function IF EXISTS gb_operations_statement_master(text, text, text, text, text, text, text, text, int);
create or replace function gb_operations_statement_master(
  p_comp_url    text,
  p_master_id   text,
  p_static_date text,
  p_site_urls   text,
  p_start_times text,
  p_end_times   text,
  p_siteids     text,
  p_splitchar   text,
  p_stat_days   int
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/02/23  Leisure  创建此函数: 经营报表-入口
*/
DECLARE
  v_site_urls     varchar[];
  v_start_times   varchar[];
  v_end_times     varchar[];
  v_siteids       varchar[];
  n_center_id     int;
  tmp             text:='';
  rtn             text:='';

  v_static_date  varchar;
  v_start_time   varchar;
  v_end_time     varchar;

BEGIN
  IF p_comp_url is null or trim(p_comp_url) = '' THEN
    raise info '运营商库信息没有设置';
    return '运营商库信息没有设置';
  END IF;

  IF p_site_urls is null or trim(p_site_urls) = '' THEN
    raise info '站点库信息没有设置';
    return '站点库信息没有设置';
  END IF;

  --关闭所有链接.
  perform dblink_close_all();
  --收集当前所有运营站点相关信息.
  perform gamebox_collect_site_infor(p_comp_url);

  --获取当前运营商id
  SELECT operationid INTO n_center_id FROM sys_site_info WHERE masterid = p_master_id::INT LIMIT 1;
  IF n_center_id is null or n_center_id = 0 THEN
    raise info '获取运营商id失败';
    return '获取运营商id失败';
  END IF;

  --拆分所有站点数据库信息.
  v_site_urls:=regexp_split_to_array(p_site_urls, p_splitchar);
  v_start_times :=regexp_split_to_array(p_start_times, p_splitchar);
  v_end_times   :=regexp_split_to_array(p_end_times, p_splitchar);
  v_siteids    :=regexp_split_to_array(p_siteids, p_splitchar);

  rtn = '【开始执行经营报表】';
  rtn = rtn || '站长ID：' || p_master_id || '，运营商ID：' || n_center_id::TEXT;

  IF array_length(v_siteids, 1) > 0 THEN
    FOR i_day IN 0..p_stat_days - 1 LOOP

      v_static_date := (p_static_date::DATE + (i_day||'day')::INTERVAL)::DATE::TEXT;
      rtn = rtn||chr(13)||chr(10)||' ┣1.开始执行日期['|| v_static_date ||']站点经营报表  ';

      FOR i_site in 1..array_length(v_siteids, 1)
      LOOP

        v_start_time  := (v_start_times[i_site]::TIMESTAMP + (i_day||'day')::INTERVAL)::TEXT;
        v_end_time    := (v_end_times[i_site]::TIMESTAMP + (i_day||'day')::INTERVAL)::TEXT;

        SELECT gb_operations_statement_site(p_comp_url, v_static_date, v_site_urls[i_site], v_start_time, v_end_time, v_siteids[i_site], 1) into tmp;
        rtn = rtn || tmp;
      END LOOP;

      rtn = rtn||chr(13)||chr(10)||' ┣2.开始执行站长经营报表  ';
      SELECT gamebox_operation_master(p_master_id, v_static_date) into tmp;
      rtn = rtn||'||'||tmp;

      rtn = rtn||chr(13)||chr(10)||' ┗3.开始执行运营商经营报表';
      SELECT gamebox_operation_company(n_center_id::TEXT, v_static_date) into tmp;
      rtn = rtn||'||'||tmp||chr(13)||chr(10);

    END LOOP;
  END IF;

  rtn = rtn||chr(13)||chr(10)||'【执行经营报表完毕】'||chr(13)||chr(10);

  --raise info '%', rtn;
  return rtn;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gb_operations_statement_master(p_comp_url text, p_master_id text, p_static_date  text, p_site_urls text, p_start_times text, p_end_times text, p_siteids text, p_splitchar text, p_stat_days  int)
IS 'Leisure-经营报表-入口';