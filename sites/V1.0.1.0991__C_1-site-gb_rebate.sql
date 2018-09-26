-- auto gen by steffan 2018-09-26 17:17:56
DROP FUNCTION IF EXISTS "gb_rebate"(p_period text, p_start_time text, p_end_time text, p_settle_flag text);
CREATE OR REPLACE FUNCTION "gb_rebate"(p_period text, p_start_time text, p_end_time text, p_settle_flag text)
  RETURNS "pg_catalog"."int4" AS $BODY$

/*版本更新说明

  版本   时间        作者    内容

--v1.00  2016/10/08  Laser  创建此函数: 返佣结算账单-入口（新）

--v1.10  2017/07/31  Laser  增加多级代理返佣支持

--v1.11  2017/07/31  Laser  改用返佣周期判重

--v1.12  2017/11/20  Laser  改由period来确定上期



*/

DECLARE



  t_start_time   TIMESTAMP;

  t_end_time   TIMESTAMP;



  n_rebate_bill_id INT:=-1; --返佣主表键值

  n_bill_count   INT :=0;



  n_sid       INT;--站点ID



  redo_status BOOLEAN:=false; --重跑标志，默认不允许重跑



  text_var1 TEXT;

  text_var2 TEXT;

  text_var3 TEXT;

  text_var4 TEXT;



BEGIN

  t_start_time = p_start_time::TIMESTAMP;

  t_end_time = p_end_time::TIMESTAMP;



  IF p_settle_flag = 'Y' THEN

    SELECT COUNT(*)

     INTO n_bill_count

      FROM rebate_bill rb

     WHERE (rb.period = p_period OR rb."start_time" = t_start_time) --v1.11  2017/07/31  Laser

       AND rb.lssuing_state <> 'pending_pay';



    IF n_bill_count = 0 THEN

      DELETE FROM rebate_agent_api ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period OR "start_time" = t_start_time);

      DELETE FROM rebate_player_fee rp WHERE rp.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period OR "start_time" = t_start_time);

      DELETE FROM rebate_agent ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period OR "start_time" = t_start_time);

      DELETE FROM rebate_bill rb WHERE "id" IN (SELECT "id" FROM rebate_bill WHERE period = p_period OR "start_time" = t_start_time);

    ELSE

      raise notice '已生成本期返佣账单，无需重新生成。';

      RETURN 1;

    END IF;

  ELSEIF p_settle_flag = 'N' THEN

    TRUNCATE TABLE rebate_agent_api_nosettled;

    TRUNCATE TABLE rebate_player_fee_nosettled;

    TRUNCATE TABLE rebate_agent_nosettled;

    TRUNCATE TABLE rebate_bill_nosettled;

  END IF;



  raise notice '开始统计第( % )期的返佣【%】, 周期( % - % )', p_period, p_settle_flag, p_start_time, p_end_time;



  raise notice '返佣rebate_bill新增记录';

  SELECT gb_rebate_bill(n_rebate_bill_id, p_period, t_start_time, t_end_time, 'I', p_settle_flag) INTO n_rebate_bill_id;



  raise notice '统计代理API返佣信息';

  perform gb_rebate_agent_api(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);



  raise notice '统计玩家费用';

  perform gb_rebate_player_fee(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);



  raise notice '统计代理返佣';

  --v1.12  2017/11/20  Laser

  --perform gb_rebate_agent(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);

  perform gb_rebate_agent(n_rebate_bill_id, p_period, t_start_time, t_end_time, p_settle_flag);



  raise notice '更新返佣总表';

  perform gb_rebate_bill(n_rebate_bill_id, p_period, t_start_time, t_end_time, 'U', p_settle_flag);



  RETURN 0;



EXCEPTION

  WHEN QUERY_CANCELED THEN

    RETURN 2;

  WHEN OTHERS THEN

    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,

                            text_var2 = PG_EXCEPTION_DETAIL,

                            text_var3 = PG_EXCEPTION_HINT,

                            text_var4 = PG_EXCEPTION_CONTEXT;

    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;



    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;

    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;



    RETURN 2;



END;



$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gb_rebate"(p_period text, p_start_time text, p_end_time text, p_settle_flag text) IS 'Laser-返佣结算账单-入口（新）';