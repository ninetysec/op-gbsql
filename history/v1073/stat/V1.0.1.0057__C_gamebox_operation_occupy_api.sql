-- auto gen by cherry 2017-02-12 20:59:28
DROP FUNCTION IF EXISTS gamebox_operation_occupy_api(TEXT, TEXT, TEXT);
create or replace function gamebox_operation_occupy_api(
    url     TEXT,
    start_time   TEXT,
    end_time   TEXT
) returns refcursor as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 站点账务-API游标
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/10/05  Leisure  交易时间由bet_time改为payout_time；
                              增加限制条件
--v1.03  2017/02/07  Leisure  取消is_profit_loss = TRUE
*/
DECLARE
  cur refcursor;
BEGIN
    OPEN cur FOR
      SELECT * FROM dblink(
        url,
        'SELECT o.api_id,
                o.game_type,
                COALESCE(sum(-o.profit_amount), 0.00)       as profit_amount,
                COALESCE(sum(o.effective_trade_amount), 0.00)    as trade_amount
           FROM player_game_order o
          --WHERE o.bet_time >='''||start_time||'''
          --  AND o.bet_time < '''||end_time||'''
          --v1.02  2016/10/05  Leisure
          WHERE o.order_state = ''settle''
            --v1.03  2017/02/07  Leisure
            --AND o.is_profit_loss = TRUE
            AND o.payout_time >='''||start_time||'''
            AND o.payout_time < '''||end_time||'''
          GROUP BY o.api_id, o.game_type '
    ) as p(api_id INT, game_type VARCHAR, profit_amount NUMERIC, trade_amount NUMERIC);
  return cur;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_api(conn_name TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-站点账务-API游标';