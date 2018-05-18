DROP FUNCTION IF EXISTS gb_rebate_bill( INT, TEXT, TIMESTAMP, TIMESTAMP, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_bill(
  p_bill_id  INOUT  INT,
  p_period    TEXT,
  p_start_time    TIMESTAMP,
  p_end_time    TIMESTAMP,
  p_operation    TEXT,
  p_flag    TEXT
)
RETURNS INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure   创建此函数: 返佣结算账单-入口（新）
--v1.00  2017/07/31  Leisure   增加多级代理返佣支持

*/
DECLARE
  rec     record;
  n_rebate_count    INT:=0; -- rebate_agent 条数

BEGIN
  IF p_flag='Y' THEN   --已出帐

    IF p_operation='I' THEN
      INSERT INTO rebate_bill (
        period, start_time, end_time,
        rebate_total, rebate_actual, agent_count, agent_lssuing_count, agent_reject_count,
        create_time, lssuing_state
      ) VALUES (
        p_period, p_start_time, p_end_time,
        0, 0, 0, 0, 0,
        clock_timestamp(), 'pending_pay'
      ) returning id into p_bill_id;

      raise notice 'rebate_bill.完成.Y键值:%', p_bill_id;

    ELSEIF p_operation='U' THEN

      SELECT COUNT(1) FROM rebate_agent WHERE rebate_bill_id = p_bill_id AND settlement_state = 'pending_lssuing' INTO n_rebate_count;

      IF n_rebate_count = 0 THEN
        --DELETE FROM rebate_bill WHERE id = p_bill_id;
        UPDATE rebate_bill SET lssuing_state = 'all_pay' WHERE id = p_bill_id;
      ELSE

        SELECT COUNT(agent_id)      agent_num,
               SUM(effective_self)  effective_transaction,
               SUM(profit_self)     profit_loss,
               SUM(rebate_total)    rebate_total
          FROM rebate_agent
         WHERE rebate_bill_id = p_bill_id
           AND settlement_state = 'pending_lssuing'
          INTO rec;

        UPDATE rebate_bill
           SET agent_count = rec.agent_num,
               effective_transaction = rec.effective_transaction,
               profit_loss = rec.profit_loss,
               rebate_total = rec.rebate_total,
               last_operate_time = clock_timestamp()
         WHERE id = p_bill_id;
      END IF;
    END IF;

  ELSEIF p_flag = 'N' THEN   --未出帐
    IF p_operation='I' THEN
      INSERT INTO rebate_bill_nosettled (
        period, start_time, end_time,
        rebate_total, agent_count,
        create_time
      ) VALUES (
        p_period, p_start_time, p_end_time,
        0, 0,
        clock_timestamp()
      ) returning id into p_bill_id;

      raise notice 'rebate_bill_nosettled.完成.N键值:%', p_bill_id;

    ELSEIF p_operation='U' THEN

      SELECT COUNT(1) FROM rebate_agent_nosettled WHERE rebate_bill_id = p_bill_id INTO n_rebate_count;
      IF n_rebate_count = 0 THEN
        NULL;
      ELSE

        SELECT COUNT(agent_id)      agent_num,
               SUM(effective_self)  effective_transaction,
               SUM(profit_self)     profit_loss,
               SUM(rebate_total)    rebate_total
          FROM rebate_agent_nosettled
         WHERE rebate_bill_id = p_bill_id
          INTO rec;

        UPDATE rebate_bill_nosettled
           SET agent_count = rec.agent_num,
               effective_transaction = rec.effective_transaction,
               profit_loss = rec.profit_loss,
               rebate_total = rec.rebate_total,
               last_operate_time = clock_timestamp()
         WHERE id = p_bill_id;

        --DELETE FROM rebate_bill_nosettled WHERE id <> p_bill_id;
      END IF;
    END IF;
  END IF;

  RETURN;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_bill( p_bill_id INT, p_period TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_operation TEXT, p_flag TEXT)
IS 'Leisure-返佣结算账单.返佣主表';
