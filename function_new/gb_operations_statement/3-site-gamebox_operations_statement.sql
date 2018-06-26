DROP FUNCTION IF EXISTS gamebox_operations_statement(text,int,text,text,text);
CREATE OR REPLACE FUNCTION gamebox_operations_statement(
  mainhost   text,
  sid     int,
  curday   text, --v1.01  2016/05/31  Laser  
  start_time   text,
  end_time   text
) RETURNS TEXT AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-入口
--v1.01  2016/05/31  Laser    统计日期由current_date，改为参数获取
--v1.02  2016/07/08  Laser    优化输出日志
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
  --v1.01  2016/05/31  Laser  
  --设置当前日期.
  --SELECT CURRENT_DATE::TEXT into curday;

  --raise notice 'ip:%',hostinfo;
  if mainhost is null or rtrim(ltrim(mainhost)) = '' THEN
    return '运营商库信息没有设置';
  end if;

  --收集当前所有运营站点相关信息.
  SELECT gamebox_collect_site_infor(mainhost, sid) into rec;
  IF rec->>'siteid' = '-1' THEN
    rtn = '运营商库中不存在当前站点的相关信息,请确保此站点是否合法.';
    raise info '%', rtn;
    return rtn;
  END IF;

  rtn = rtn || (rec->>'siteid');
  --拆分所有站点数据库信息.
  rtn = rtn||chr(13)||chr(10)||'        ┣1.正在收集玩家下单信息';
  SELECT gamebox_operations_player(start_time, end_time, curday, rec) into tmp;
  rtn = rtn||'||'||tmp;
  --raise info '%.收集完毕',i;

  --处理另外一些报表信息收集

  --统一执行代理以上的经营报表
  --执行代理经营报表
  rtn = rtn||chr(13)||chr(10)||'        ┣2.正在执行代理经营报表';
  --SELECT gamebox_operations_agent(curday, rec) into tmp; --v1.01  2016/05/31  Laser  
  SELECT gamebox_operations_agent(start_time, end_time, curday, rec) into tmp;
  rtn = rtn||'||'||tmp;
  --执行总代经营报表
  rtn = rtn||chr(13)||chr(10)||'        ┣3.正在执行总代经营报表';
  --SELECT gamebox_operations_topagent(curday, rec) into tmp; --v1.01  2016/05/31  Laser  
  SELECT gamebox_operations_topagent(start_time, end_time, curday, rec) into tmp;
  rtn = rtn||'||'||tmp;

  return rtn;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operations_statement(mainhost text, sid int, curday text, start_time text, end_time text)
IS 'Lins-经营报表-入口';
