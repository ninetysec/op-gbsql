-- auto gen by cherry 2017-07-24 15:01:48
drop function if exists gb_rakeback(TEXT, TEXT, TEXT, TEXT);
create or replace function gb_rakeback(
  p_period   TEXT,
  p_start_time   TEXT,
  p_end_time   TEXT,
  p_settle_flag   TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/15  Leisure  创建此函数: 返水结算账单.入口
--v1.01  2017/07/24  Leisure  修改判断账单是否已生成的逻辑
*/
DECLARE

  t_start_time   TIMESTAMP;
  t_end_time   TIMESTAMP;

  n_rakeback_bill_id INT:=-1; --返水主表键值.
  n_bill_count   INT :=0;

  n_sid       INT;--站点ID.
  --b_is_max     BOOLEAN := true;

  redo_status BOOLEAN:=false; --重跑标志，默认不允许重跑

BEGIN
  t_start_time = p_start_time::TIMESTAMP;
  t_end_time = p_end_time::TIMESTAMP;

  SELECT gamebox_current_site() INTO n_sid;

  RAISE INFO '开始统计站点 %，周期 %( %-% )返水', n_sid, p_period, p_start_time, p_end_time;

  IF p_settle_flag = 'Y' THEN
    --查找是否本期有已支付的返水
    SELECT COUNT("id")
      INTO n_bill_count
      FROM rakeback_bill rb
      --v1.01  2017/07/24  Leisure
     --WHERE rb.period = p_period
       --AND rb."start_time" = t_start_time
       --AND rb."end_time" = t_end_time
     WHERE rb."start_time" = t_start_time
       AND rb."end_time" = t_end_time
       AND rb.lssuing_state <> 'pending_pay';

    IF n_bill_count = 0 THEN
      --v1.01  2017/07/24  Leisure
      --DELETE FROM rakeback_api ra WHERE ra.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
      --DELETE FROM rakeback_player rp WHERE rp.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
      --DELETE FROM rakeback_bill rb WHERE "id" IN (SELECT "id" FROM rakeback_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
      DELETE FROM rakeback_api ra WHERE ra.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE "start_time" = t_start_time AND "end_time" = t_end_time);
      DELETE FROM rakeback_player rp WHERE rp.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE "start_time" = t_start_time AND "end_time" = t_end_time);
      DELETE FROM rakeback_bill rb WHERE "id" IN (SELECT "id" FROM rakeback_bill WHERE "start_time" = t_start_time AND "end_time" = t_end_time);
    ELSE
      RAISE INFO '已生成本期返水账单，不能重新生成！';
      RETURN;
    END IF;
  ELSEIF p_settle_flag = 'N' THEN
    TRUNCATE TABLE rakeback_api_nosettled;
    TRUNCATE TABLE rakeback_player_nosettled;
    TRUNCATE TABLE rakeback_bill_nosettled;
  END IF;

  RAISE INFO '返水总表数据预新增.';
  SELECT gamebox_rakeback_bill(p_period, t_start_time, t_end_time, n_rakeback_bill_id, 'I', p_settle_flag) INTO n_rakeback_bill_id;

  RAISE INFO '统计玩家API返水';
  perform gb_rakeback_api(n_rakeback_bill_id, p_settle_flag, t_start_time, t_end_time);
  RAISE INFO '统计玩家API返水.完成';

  RAISE INFO '统计玩家返水';
  perform gb_rakeback_player(n_rakeback_bill_id, p_settle_flag);
  RAISE INFO '统计玩家返水.完成';

  RAISE INFO '更新返水总表';
  perform gamebox_rakeback_bill(p_period, t_start_time, t_end_time, n_rakeback_bill_id, 'U', p_settle_flag);
  RAISE INFO '站点 %，周期 %( %-% )返水.完成', n_sid, p_period, p_start_time, p_end_time;

END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback(p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Leisure-返水结算账单.入口';