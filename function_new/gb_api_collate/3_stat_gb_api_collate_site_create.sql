DROP FUNCTION IF EXISTS gb_api_collate_site_create(TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_api_collate_site_create(
  p_conn   TEXT,
  p_siteid  TEXT,
  p_curday   TEXT
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2018/01/19  Laser    创建此函数: API注单核对-站点报表
--v1.01  2018/01/19  Laser    增加时间分组条件，删除无用参数start_time、end_time
--v1.02  2018/02/28  Laser    增加currency字段
*/
DECLARE
  rtn   text:='';
  v_count  int:=0;
  d_static_date DATE;
BEGIN

  d_static_date := to_date(p_curday, 'YYYY-MM-DD');
  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||chr(13)||chr(10)||'          |清除当天的统计数据，保证每天只作一次统计||';
  DELETE FROM api_collate_site WHERE static_date = d_static_date AND site_id = p_siteid::INT;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  raise notice '本次删除记录数 %',  v_count;
  rtn = rtn||'|执行完毕，删除记录数: '||v_count||' 条||';

  --开始执行站点经营报表信息收集
  rtn = rtn||chr(13)||chr(10)||'          |开始汇总API经营报表';
  INSERT INTO api_collate_site(
    site_id, site_name, center_id, center_name, master_id, master_name,  currency, --v1.02  2018/02/28  Laser
    player_num, api_id, api_type_id, game_type,
    static_date, static_time, static_time_end, create_time,
    transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  ) SELECT
      s.siteid, s.sitename, s.operationid, s.operationname, s.masterid, s.mastername, s.currency, --v1.02  2018/02/28  Laser
      acp.players_num, acp.api_id, acp.api_type_id, acp.game_type,
      d_static_date, static_time, static_time_end, now(),
      acp.transaction_order, acp.transaction_volume, acp.effective_transaction,
      acp.transaction_profit_loss,  winning_amount, contribution_amount
    FROM
      dblink (p_conn,
              'SELECT site_id, api_id, game_type, api_type_id, static_time, static_time_end,
                      COUNT (player_id)           as players_num,
                      SUM (transaction_order)     as transaction_order,
                      SUM (transaction_volume)    as transaction_volume,
                      SUM (effective_transaction) as effective_transaction,
                      SUM (profit_loss)           as transaction_profit_loss,
                      SUM(winning_amount)         as winning_amount,
                      SUM(contribution_amount)    as contribution_amount
                 FROM api_collate_player
                WHERE static_date = ''' || p_curday || '''
                GROUP BY site_id,api_id,game_type,api_type_id, static_time, static_time_end
              '
              )
    AS acp (
            site_id int,
            api_id int,
            game_type varchar,
            api_type_id int,
            static_time timestamp,
            static_time_end timestamp,
            players_num bigint ,
            transaction_order NUMERIC ,
            transaction_volume NUMERIC,
            effective_transaction NUMERIC,
            transaction_profit_loss NUMERIC,
            winning_amount NUMERIC,
            contribution_amount NUMERIC
           ) LEFT JOIN sys_site_info s ON acp.site_id = s.siteid;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  raise notice '本次插入数据量 %', v_count;
    rtn = rtn||'|执行完毕，新增记录数: '||v_count||' 条||';
  return rtn;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION gb_api_collate_site_create( p_conn TEXT, p_siteid TEXT, p_curday TEXT)
IS 'Laser-API核对报表-站点报表';
