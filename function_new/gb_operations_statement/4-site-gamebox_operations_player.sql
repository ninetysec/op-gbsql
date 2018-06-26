DROP FUNCTION IF EXISTS gamebox_operations_player(TEXT, TEXT, TEXT, JSON);
CREATE OR REPLACE FUNCTION gamebox_operations_player(
  start_time   TEXT,
  end_time   TEXT,
  curday     TEXT,
  rec     JSON
) RETURNS text AS $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2015/01/01  Lins    创建此函数: 经营报表-玩家报表
--v1.01  2016/05/12  Laser   交易时间由create_time改为bet_time
--v1.02  2016/05/31  Laser   统计日期由current_date，改为参数获取;
                             经营报表增加字段static_date统计日期
--v1.03  2016/06/13  Laser   is_profit_loss=false的记录也需要统计by acheng
--v1.04  2016/06/27  Laser   统计时间由bet_time改为payout_time --by acheng
--v1.05  2016/07/08  Laser   优化输出日志
--v1.05  2016/10/05  Laser   撤销v1.03的修改 by kitty
--v1.06  2017/02/05  Laser   删除is_profit_loss = TRUE条件
--v1.07  2017/09/18  Laser   增加彩金字段统计
--v1.08  2018/06/06  Laser   增对代理线修改问题，代理改由流水表取
*/
DECLARE
  rtn     text:='';
  n_count    INT:=0;
  site_id   INT;
  master_id   INT;
  center_id   INT;
  site_name   TEXT:='';
  master_name TEXT:='';
  center_name TEXT:='';
  d_static_date DATE; --v1.02  2016/05/31
BEGIN
  --v1.02  2016/05/31  Laser
  d_static_date := to_date(curday, 'YYYY-MM-DD');

  --清除当天的统计信息，保证每天只作一次统计信息
  rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
  --delete from operate_player WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
  delete from operate_player WHERE static_date = d_static_date;

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice '本次删除记录数 %', n_count;
  rtn = rtn||'|执行完毕,删除记录数: '||n_count||' 条||';

  --开始执行玩家经营报表信息收集
  site_id   = COALESCE((rec->>'siteid')::INT, -1);
  site_name  = COALESCE(rec->>'sitename', '');
  master_id  = COALESCE((rec->>'masterid')::INT, -1);
  master_name  = COALESCE(rec->>'mastername', '');
  center_id  = COALESCE((rec->>'operationid')::INT, -1);
  center_name  = COALESCE(rec->>'operationname', '');

  raise info '开始日期:%, 结束日期:%', start_time, end_time;
  INSERT INTO operate_player(
    center_id, center_name, master_id, master_name,
    site_id, site_name, topagent_id, topagent_name,
    agent_id, agent_name, player_id, player_name,
    api_id, api_type_id, game_type,
    --static_time, create_time, --v1.02  2016/05/31  Laser
    static_date, static_time, static_time_end, create_time,
    transaction_order, transaction_volume, effective_transaction,
    profit_loss, winning_amount, contribution_amount
  )
  SELECT
      center_id, center_name, master_id, master_name, site_id, site_name,
      topagentid topagent_id, topagentusername topagent_name,
      agentid agent_id, agentusername agent_name, player_id, username player_name,
      p.api_id, p.api_type_id, p.game_type,
      d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
      p.transaction_order, p.transaction_volume, p.effective_transaction,
      p.profit_loss, p.winning_amount, p.contribution_amount
   FROM ( SELECT
              player_id, username, agentid, agentusername, topagentid, topagentusername,
              api_id, api_type_id, game_type,
              COUNT(order_no)                as transaction_order,
              COALESCE(SUM(single_amount), 0.00)      as transaction_volume,
              COALESCE(SUM(profit_amount), 0.00)      as profit_loss,
              COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
              COALESCE(SUM(winning_amount), 0.00) as winning_amount,
              COALESCE(SUM(contribution_amount), 0.00) as contribution_amount
            FROM player_game_order
           WHERE payout_time >= start_time::TIMESTAMP
             AND payout_time < end_time::TIMESTAMP
             AND order_state = 'settle'
           GROUP BY player_id, username, agentid, agentusername, topagentid, topagentusername, api_id, api_type_id, game_type
         ) p;

--v1.08  2018/06/06  Laser
/*    SELECT
      center_id, center_name, master_id, master_name,
      site_id, site_name, u.topagent_id, u.topagent_name,
      u.agent_id, u.agent_name, u.id, u.username,
      p.api_id, p.api_type_id, p.game_type,
      --now(), now(), --v1.02  2016/05/31  Laser
      d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
      p.transaction_order, p.transaction_volume, p.effective_transaction,
      p.profit_loss, p.winning_amount, p.contribution_amount
      FROM (SELECT
              player_id, api_id, api_type_id, game_type,
              COUNT(order_no)                as transaction_order,
              COALESCE(SUM(single_amount), 0.00)      as transaction_volume,
              COALESCE(SUM(profit_amount), 0.00)      as profit_loss,
              COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
              COALESCE(SUM(winning_amount), 0.00) as winning_amount,
              COALESCE(SUM(contribution_amount), 0.00) as contribution_amount
             FROM player_game_order
            --WHERE bet_time >= start_time::TIMESTAMP
            --  AND bet_time < end_time::TIMESTAMP
            WHERE payout_time >= start_time::TIMESTAMP
              AND payout_time < end_time::TIMESTAMP
              AND order_state = 'settle'
              --v1.06  2017/02/05  Laser
              --AND is_profit_loss = TRUE --v1.03  2016/06/13  Laser
            GROUP BY player_id, api_id, api_type_id, game_type
            ) p, v_sys_user_tier u
  WHERE p.player_id = u.id;
*/

  GET DIAGNOSTICS n_count = ROW_COUNT;
  raise notice '本次插入数据量 %', n_count;
  rtn = rtn||'|执行完毕,新增记录数: '||n_count||' 条||';

  return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-玩家报表';
