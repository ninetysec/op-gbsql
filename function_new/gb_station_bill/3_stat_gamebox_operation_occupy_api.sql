DROP FUNCTION IF EXISTS gb_operation_occupy_api(INT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_operation_occupy_api(
  sid INT,
  start_time TIMESTAMP,
  end_time TIMESTAMP
) RETURNS refcursor AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/08/01  Lins     创建此函数: Leisure-站点账务.API盈亏

*/
DECLARE
  cur refcursor;
BEGIN
  /*
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
  */
  OPEN cur FOR
  SELECT api_id, game_type, -SUM(profit_loss) profit_amount, SUM(effective_transaction) trade_amount
    FROM site_operate
   WHERE site_id = sid
     AND static_time >= start_time
     AND static_time_end <= end_time
   GROUP BY api_id, game_type;

  return cur;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_operation_occupy_api( sid INT, start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Leisure-站点账务.API盈亏';
