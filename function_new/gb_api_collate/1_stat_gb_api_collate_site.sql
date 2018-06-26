DROP FUNCTION IF EXISTS gb_api_collate_site(TEXT, TEXT, TEXT, TEXT, TEXT, INT);
CREATE OR REPLACE FUNCTION gb_api_collate_site(
  p_comp_url    TEXT,
  p_static_date TEXT,
  p_siteid      TEXT,
  p_site_url    TEXT,
  p_apis        TEXT,
  p_stat_days   INT
) returns text as $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2018/01/18  Laser   API注单核对: API注单核对-站点报表
--v1.01  2018/01/29  Laser   删除无用参数
--v1.02  2018/02/06  Laser   修改关闭连接的方法

参数说明 p_apis: 执行哪些api，多个用','分隔，如'1,2,3,4'，输入空串''表示执行所有api
*/
DECLARE

  rtn text:='';
  tmp text:='';
  v_static_date  varchar;
  --v_start_time   varchar;
  --v_end_time     varchar;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  FOR i IN 0..p_stat_days - 1 LOOP

    v_static_date := (p_static_date::DATE + (i||'day')::INTERVAL)::DATE::TEXT;

    RAISE INFO '%.', v_static_date;

    --raise notice '当前站点库信息：%', p_site_url;
    IF p_site_url is null OR trim(p_site_url) = '' THEN
      return '站点库信息不能为空';
    END IF;

    --连接站点库
    perform dblink_connect_u('master', p_site_url);

    tmp = '    ┗ 开始收集站点id['||p_siteid||'],日期['|| v_static_date ||']API核对报表：';
    raise notice '%', tmp;
    --执行玩家API报表
    rtn = rtn||chr(13)||chr(10)||tmp;
    SELECT P .msg
      FROM
      dblink ('master',
              'SELECT * FROM gb_api_collate_player('''||p_comp_url||''', '''||v_static_date||''', '''||p_apis||''')'
      ) AS P (msg TEXT)
      INTO tmp ;
    rtn = rtn||tmp;
    raise notice '收集完毕';
    --收集站点API报表
    rtn = rtn||chr(13)||chr(10)||'        ┗2.正在执行站点API核对报表：';
    SELECT gb_api_collate_site_create('master', p_siteid, v_static_date) into tmp; --v1.01  2018/01/29  Laser
    rtn = rtn||'||'||tmp;
    perform dblink_disconnect('master');

    rtn = rtn||chr(13)||chr(10)||'    ┗收集完毕';
  END LOOP;

  return rtn;
EXCEPTION
  WHEN QUERY_CANCELED THEN
    --v1.02  2018/02/06  Laser
    --perform dblink_close_all();
    perform dblink_disconnect_all();
    RETURN 2;
  WHEN OTHERS THEN
    --perform dblink_close_all();
    perform dblink_disconnect_all();

    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    RETURN 2;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gb_api_collate_site(p_comp_url text, p_static_date  text, p_siteid text, p_site_url text, p_apis text, p_stat_days  int)
IS 'Laser-API注单核对-站点经营报表';
