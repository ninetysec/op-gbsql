-- auto gen by cherry 2017-06-24 14:20:39
drop function if exists gb_rakeback_task(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gb_rakeback_task(
  p_comp_url  TEXT,
	p_period 	TEXT,
	p_start_time 	TEXT,
	p_end_time 	TEXT,
	p_settle_flag 	TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/06/17  Leisure   创建此函数: 返水结算账单.入口(调度)

  返回值说明：0成功，1警告，2错误
*/
DECLARE

	t_start_time 	TIMESTAMP;
	t_end_time 	TIMESTAMP;
  n_sid  INT;
  n_return_code INT := 0;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  t_start_time = clock_timestamp()::timestamp(0);

  perform gb_rakeback(p_period, p_start_time, p_end_time, p_settle_flag);

  t_end_time = clock_timestamp()::timestamp(0);

  IF p_settle_flag = 'Y' THEN

    SELECT gamebox_current_site() INTO n_sid;

    --perform dblink_close_all();
    --perform dblink_connect('master',  p_comp_url);

    SELECT t.return_code
      INTO n_return_code
      FROM
      dblink (p_comp_url,
              'SELECT * from gb_task_infomation_site( ''' || n_sid || ''', ''gb_rakeback'', ''返水结算账单'', ''' || p_period || ''', ''1'', ''' ||
               t_start_time || ''', ''' || t_end_time || ''', '''')'
             ) AS t(return_code INT);
    --perform dblink_disconnect('master');
  END IF;

  IF n_return_code <> 0 THEN
    RAISE INFO '任务记录未成功写入远端表';
  END IF;

RETURN 0;

EXCEPTION
  WHEN QUERY_CANCELED THEN
    RETURN 2;
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    RETURN 2;
END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_task( p_comp_url  TEXT, p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Leisure-返水结算账单.入口(调度)';


drop function IF EXISTS gamebox_operations_statement(text,int,text,text,text);
create or replace function gamebox_operations_statement(
  mainhost   text,
  sid     int,
  curday   text, --v1.01  2016/05/31  Leisure
  start_time   text,
  end_time   text
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-入口
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取
--v1.02  2016/07/08  Leisure  优化输出日志
--v1.03  2017/06/21  Leisure  取消DBLINK多级嵌套调用
*/
DECLARE
  --curday   TEXT;
  rtn   text:='';
  tmp   text:='';
  rec   json;
  red   record;
  vname   text:='vp_site_game';
  cnum   int:=0;
BEGIN
  --v1.01  2016/05/31  Leisure
  --设置当前日期.
  --SELECT CURRENT_DATE::TEXT into curday;

  --raise notice 'ip:%',hostinfo;
  if mainhost is null or rtrim(ltrim(mainhost)) = '' THEN
    return '运营商库信息没有设置';
  end if;

  /*--v1.03  2017/06/21  Leisure
  --收集当前所有运营站点相关信息.
  SELECT gamebox_collect_site_infor(mainhost, sid) into rec;
  IF rec->>'siteid' = '-1' THEN
    rtn = '运营商库中不存在当前站点的相关信息,请确保此站点是否合法.';
    raise info '%', rtn;
    return rtn;
  END IF;
  */

  --拆分所有站点数据库信息.
  rtn = rtn||chr(13)||chr(10)||'        ┣1.正在收集玩家下单信息';
  SELECT gamebox_operations_player(start_time, end_time, curday, rec) into tmp;
  rtn = rtn||'||'||tmp;
  --raise info '%.收集完毕',i;

  --处理另外一些报表信息收集

  --统一执行代理以上的经营报表
  --执行代理经营报表
  rtn = rtn||chr(13)||chr(10)||'        ┣2.正在执行代理经营报表';
  --SELECT gamebox_operations_agent(curday, rec) into tmp; --v1.01  2016/05/31  Leisure
  SELECT gamebox_operations_agent(start_time, end_time, curday, rec) into tmp;
  rtn = rtn||'||'||tmp;
  --执行总代经营报表
  rtn = rtn||chr(13)||chr(10)||'        ┣3.正在执行总代经营报表';
  --SELECT gamebox_operations_topagent(curday, rec) into tmp; --v1.01  2016/05/31  Leisure
  SELECT gamebox_operations_topagent(start_time, end_time, curday, rec) into tmp;
  rtn = rtn||'||'||tmp;

  return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, sid int, curday text, start_time text, end_time text)
IS 'Lins-经营报表-入口';