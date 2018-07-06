drop function IF EXISTS gamebox_operation_site(TEXT, TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_operation_site(
  conn   TEXT,
  siteid  TEXT,
  curday   TEXT,
  start_time   TEXT,
  end_time     TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-站点报表
--v1.01  2016/05/31  Leisure  统计日期由current_date，改为参数获取，
                              站点报表增加参数startTime TEXT, endTime TEXT
--v1.02  2016/07/07  Leisure  增加参数siteid，清除数据时，只清除当前站点的数据
--v1.03  2016/07/08  Leisure  优化输出日志
--v1.04  2016/09/18  Leisure  增加彩金字段统计
*/
DECLARE
  rtn   text:='';
  v_count  int:=0;
  d_static_date DATE; --v1.01  2016/05/31
BEGIN
  --v1.01  2016/05/31  Leisure
  d_static_date := to_date(curday, 'YYYY-MM-DD');
  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';

  --delete from site_operate where to_char(static_time, 'YYYY-MM-DD') = to_char(curday, 'YYYY-MM-DD');
  --v1.02  2016/07/07  Leisure
  --DELETE FROM site_operate WHERE static_date = d_static_date;
  DELETE FROM site_operate WHERE static_date = d_static_date AND site_id = siteid::INT;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  raise notice '本次删除记录数 %',  v_count;
  rtn = rtn||'|执行完毕,删除记录数: '||v_count||' 条||';

  --开始执行站点经营报表信息收集
  rtn = rtn||'|开始执行'||curday||'站点经营报表||';
  INSERT INTO site_operate(
    site_id, site_name, center_id, center_name, master_id, master_name, player_num,
    api_id, api_type_id, game_type,
    --static_time, create_time, --v1.01  2016/05/31  Leisure
    static_date, static_time, static_time_end, create_time,
    transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  ) SELECT
      s.siteid, s.sitename, s.operationid, s.operationname, s.masterid, s.mastername, a.players_num,
      a.api_id, a.api_type_id, a.game_type,
      --current_date, now(), --v1.01  2016/05/31  Leisure
      d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
      a.transaction_order, a.transaction_volume, a.effective_transaction_volume,
      a.transaction_profit_loss,  winning_amount, contribution_amount
    FROM
      dblink (conn,
              'SELECT * from gamebox_operations_site('''||curday||''')
               AS q(siteid int, api_id int, game_type varchar, api_type_id int, players_num bigint,
                    transaction_order NUMERIC, transaction_volume NUMERIC,
                    effective_transaction_volume NUMERIC, transaction_profit_loss NUMERIC,
                    winning_amount NUMERIC, contribution_amount NUMERIC
                   )
              '
              )
    AS a(
          siteid int,
          api_id int,
          game_type varchar,
          api_type_id int,
          players_num bigint ,
          transaction_order NUMERIC ,
          transaction_volume NUMERIC,
          effective_transaction_volume NUMERIC,
          transaction_profit_loss NUMERIC,
          winning_amount NUMERIC,
          contribution_amount NUMERIC
        ) left join sys_site_info s on a.siteid = s.siteid;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  raise notice '本次插入数据量 %', v_count;
    rtn = rtn||'|执行完毕,新增记录数: '||v_count||' 条||';
  return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gamebox_operation_site(  conn TEXT, siteid TEXT, curday TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-经营报表-站点报表';
