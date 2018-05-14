drop function IF EXISTS gamebox_operations_topagent(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_topagent(
  start_time   TEXT,
  end_time   TEXT,
  curday   TEXT,
  rec   JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-总代报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.02  2016/07/08  Leisure  优化输出日志
--v1.03  2016/09/18  Leisure  增加彩金字段统计
*/
DECLARE
  rtn     text:='';
  v_COUNT    int4:=0;
  s_id     INT;
  m_id     INT;
  c_id     INT;
  s_name     TEXT:='';
  m_name     TEXT:='';
  c_name     TEXT:='';
  d_static_date DATE; --v1.01  2016/05/31
BEGIN
  --v1.01  2016/05/31  Leisure
  d_static_date := to_date(curday, 'YYYY-MM-DD');
  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
  --DELETE FROM operate_topagent WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
  DELETE FROM operate_topagent WHERE static_date = d_static_date;
  GET DIAGNOSTICS v_COUNT = ROW_COUNT;
  raise notice '本次删除记录数 %', v_COUNT;
  rtn = rtn||'|执行完毕,删除记录数: '||v_COUNT||' 条||';
  --开始执行总代经营报表信息收集
  rtn = rtn||'|开始执行'||curday||'总代经营报表||';

  s_id   = COALESCE((rec->>'siteid')::INT, -1);
  s_name   = COALESCE(rec->>'sitename', '');
  m_id   = COALESCE((rec->>'masterid')::INT, -1);
  m_name   = COALESCE(rec->>'mastername', '');
  c_id   = COALESCE((rec->>'operationid')::INT, -1);
  c_name   = COALESCE(rec->>'operationname', '');

  INSERT INTO operate_topagent(
    center_id, center_name, master_id, master_name,
    site_id, site_name, topagent_id, topagent_name,
    api_id, api_type_id, game_type,
    --static_time, create_time, --v1.01  2016/05/31  Leisure
    static_date, static_time, static_time_end, create_time,
    player_num, transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  ) SELECT
      c_id, c_name, m_id, m_name,
      s_id, s_name, topagent_id, topagent_name,
      api_id, api_type_id, game_type,
      --now(), now(), --v1.01  2016/05/31  Leisure
      d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
      SUM (player_num)                as player_num,
      COALESCE(SUM (transaction_order), 0)       as transaction_order,
      COALESCE(SUM (transaction_volume), 0.00)     as transaction_volume,
      COALESCE(SUM (effective_transaction), 0.00)   as effective_transaction,
      COALESCE(SUM (profit_loss), 0.00)         as profit_loss,
      COALESCE(SUM(winning_amount), 0.00) as winning_amount,
      COALESCE(SUM(contribution_amount), 0.00) as contribution_amount
    FROM operate_agent
   --WHERE to_char(static_time,  'YYYY-MM-dd') = curday
   WHERE static_date = d_static_date --v1.01  2016/05/31  Leisure
   GROUP BY topagent_id, topagent_name, api_id, api_type_id, game_type;

  GET DIAGNOSTICS v_COUNT = ROW_COUNT;
  raise notice '本次插入数据量 %',  v_COUNT;
    rtn = rtn||'|执行完毕,新增记录数: '||v_COUNT||' 条||';

  return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_topagent(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-总代报表';
