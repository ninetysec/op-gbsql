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
--v1.10  2017/06/29  Leisure  改变sys_site_info同步方式
--v1.20  2017/08/01  Leisure  不再搜集站长，运营商报表
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
  perform dblink_disconnect_all();
  --v1.10  2017/06/29  Leisure
  --收集当前所有运营站点相关信息.
  --perform gamebox_collect_site_infor(p_comp_url);

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
    FOR i_day IN 0..p_stat_days-1 LOOP

      v_static_date := (p_static_date::DATE + (i_day||'day')::INTERVAL)::DATE::TEXT;
      rtn = rtn||chr(13)||chr(10)||' ┣1.开始执行日期['|| v_static_date ||']站点经营报表  ';

      FOR i_site in 1..array_length(v_siteids, 1)
      LOOP

        v_start_time  := (v_start_times[i_site]::TIMESTAMP + (i_day||'day')::INTERVAL)::TEXT;
        v_end_time    := (v_end_times[i_site]::TIMESTAMP + (i_day||'day')::INTERVAL)::TEXT;

        SELECT gb_operations_statement_site(p_comp_url, v_static_date, v_site_urls[i_site], v_start_time, v_end_time, v_siteids[i_site], 1) into tmp;
        rtn = rtn || tmp;
      END LOOP;

      --v1.20  2017/08/01  Leisure
      --rtn = rtn||chr(13)||chr(10)||' ┣2.开始执行站长经营报表  ';
      --SELECT gamebox_operation_master(p_master_id, v_static_date) into tmp;
      --rtn = rtn||'||'||tmp;

      --v1.20  2017/08/01  Leisure
      --rtn = rtn||chr(13)||chr(10)||' ┗3.开始执行运营商经营报表';
      --SELECT gamebox_operation_company(n_center_id::TEXT, v_static_date) into tmp;
      --rtn = rtn||'||'||tmp||chr(13)||chr(10);

    END LOOP;
  END IF;

  rtn = rtn||chr(13)||chr(10)||'【执行经营报表完毕】'||chr(13)||chr(10);

  --raise info '%', rtn;
  return rtn;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gb_operations_statement_master(p_comp_url text, p_master_id text, p_static_date  text, p_site_urls text, p_start_times text, p_end_times text, p_siteids text, p_splitchar text, p_stat_days  int)
IS 'Leisure-经营报表-入口';
