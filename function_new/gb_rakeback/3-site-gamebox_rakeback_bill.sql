DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rakeback_bill (
  name       TEXT,
  start_time     TIMESTAMP,
  end_time     TIMESTAMP,
  INOUT bill_id   INT,
  op         TEXT,
  flag       TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-返水周期主表
--v1.01  2016/05/30  Laser    改为returning，防止并发
--v1.02  2017/01/18  Laser    没有返水玩家，依然保留返水总表记录
--v1.10  2017/07/01  Laser    增加pending_lssuing字段，以支持返水重结
*/
DECLARE
  pending_lssuing text:='pending_lssuing';
  pending_pay   text:='pending_pay';
  rec       record;
  max_back_water   float:=0.00;
  backwater     float:=0.00;
  rp_count    INT:=0;  -- rakeback_player 条数

BEGIN
  IF flag='Y' THEN--已出账

    IF op='I' THEN
      --先插入返水总记录并取得键值.
      INSERT INTO rakeback_bill (
         period, start_time, end_time,
         player_count, player_lssuing_count, player_reject_count, rakeback_total, rakeback_actual,
         create_time, lssuing_state
      ) VALUES (
         name, start_time, end_time,
         0, 0, 0, 0, 0,
         now(), pending_pay
      ) returning id into bill_id;

      --改为returning，防止并发 Laser   20160530
      --SELECT currval(pg_get_serial_sequence('rakeback_bill',  'id')) into bill_id; --v1.01  2016/05/30  Laser  

    ELSE
      SELECT COUNT(1) FROM rakeback_player WHERE rakeback_bill_id = bill_id INTO rp_count;
      IF rp_count > 0 THEN
        FOR rec IN
          SELECT rakeback_bill_id,
               COUNT(DISTINCT player_id)   as cl,
               SUM(rakeback_total)       as sl
            FROM rakeback_player
           WHERE rakeback_bill_id = bill_id
           GROUP BY rakeback_bill_id
        LOOP
          --v1.10  2017/07/01  Laser  
          UPDATE rakeback_bill SET player_count = rec.cl, rakeback_total = rec.sl, rakeback_pending = rec.sl WHERE id = bill_id;
        END LOOP;
      --ELSE
        --DELETE FROM rakeback_bill WHERE id = bill_id;
      END IF;
    END IF;

  ELSEIF flag='N' THEN--未出账

    IF op='I' THEN
      --先插入返水总记录并取得键值.
      INSERT INTO rakeback_bill_nosettled (
         start_time, end_time, player_count, rakeback_total, create_time
      ) VALUES (
         start_time, end_time, 0, 0, now()
      ) returning id into bill_id;

      --改为returning，防止并发 Laser   20160530
      --SELECT currval(pg_get_serial_sequence('rakeback_bill_nosettled', 'id')) into bill_id;
    ELSE
      SELECT COUNT(1) FROM rakeback_player_nosettled WHERE rakeback_bill_nosettled_id = bill_id INTO rp_count;
      -- raise info '---- rp_count = %', rp_count;
      IF rp_count > 0 THEN
        FOR rec in
          SELECT rakeback_bill_nosettled_id,
               COUNT(DISTINCT player_id)   as cl,
               SUM(rakeback_total)       as sl
            FROM rakeback_player_nosettled
           WHERE rakeback_bill_nosettled_id = bill_id
           GROUP BY rakeback_bill_nosettled_id
        LOOP
          --v1.10  2017/07/01  Laser  
          UPDATE rakeback_bill_nosettled SET player_count = rec.cl, rakeback_total = rec.sl WHERE id = bill_id;
        END LOOP;
        DELETE FROM rakeback_bill_nosettled WHERE id <> bill_id;
      --ELSE
        --DELETE FROM rakeback_bill_nosettled WHERE id = bill_id;
      END IF;
    END IF;

  END IF;
  raise info 'rakeback_bill.完成.键值:%', bill_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, bill_id INT, op TEXT, flag TEXT)
IS 'Lins-返水-返水周期主表';
