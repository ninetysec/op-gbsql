-- auto gen by linsen 2018-03-30 17:21:37
-- by laser
drop function if exists gb_analyze(DATE, TIMESTAMP, TIMESTAMP);
create or replace function gb_analyze(
	p_stat_date 	DATE,
	p_start_time 	TIMESTAMP,
	p_end_time 	TIMESTAMP
) RETURNS INT as $$
/*版本更新说明
  版本   时间        作者   内容
--v1.00  2016/12/10  Laser  创建此函数: 经营分析-玩家
--v1.01  2016/12/19  Laser  取款改为实际取款。存取款改由存取款表获取
--v1.02  2017/01/19  Laser  删除条件“是否盈亏”
--v1.03  2017/10/17  Laser  withdraw_actual_amount改为withdraw_amount
*/
DECLARE
	rec 	record;
	gs_id 	INT;
	n_count 	INT;
	n_count_player 	INT;

BEGIN

	raise info '清除 % 号统计数据...', p_stat_date;
	DELETE FROM analyze_player WHERE static_date = p_stat_date;
	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice 'analyze_player 本次删除记录数 %', n_count;

	raise info '统计 % 号经营数据.START', p_stat_date;

	WITH up AS
	(
	  SELECT su."id" player_id,
	         su.username user_name,
	         ua."id" agent_id,
	         ua.username agent_name,
	         ut."id" topagent_id,
	         ut.username topagent_name,
	         su.register_site,
	         su.create_time >= p_start_time AND su.create_time < p_end_time is_new_player
	    FROM sys_user su
	    LEFT JOIN  sys_user ua ON ua.user_type= '23' AND su.owner_id = ua."id"
	    LEFT JOIN  sys_user ut ON ut.user_type= '22' AND ua.owner_id = ut."id"
	   WHERE su.user_type = '24'
	),

	pr AS (
	        --存款
	         SELECT player_id,
	                --'deposit' AS transaction_type,
	                COUNT(id) deposit_count,
	                SUM(recharge_amount) deposit_amount
	           FROM player_recharge
	          WHERE recharge_status IN ('2', '5')
	            AND create_time >= p_start_time AND create_time < p_end_time
	          GROUP BY player_id
	),

	pw AS (
	         --取款
	         SELECT player_id,
	                --'withdrawal' AS transaction_type,
	                COUNT(id) withdraw_count,
                  --v1.03  2017/10/17  Laser --SUM(withdraw_actual_amount)
                  SUM(withdraw_amount) withdraw_amount
	           FROM player_withdraw
	          WHERE withdraw_type IN ('manual_deposit', 'first', 'normal')
	            AND withdraw_status = '4'
	            AND create_time >= p_start_time AND create_time < p_end_time
	          GROUP BY player_id
	),

	pgo AS (
	  SELECT player_id,
	         COUNT(id) transaction_order,
	         SUM(single_amount) transaction_volume,
	         SUM(effective_trade_amount) effective_amount,
	         SUM(profit_amount) payout_amount
	    FROM player_game_order
	   WHERE order_state = 'settle'
	     --v1.02  2017/01/19  Laser
	     --AND is_profit_loss = TRUE
	     AND payout_time >= p_start_time
	     AND payout_time < p_end_time
	   GROUP BY player_id
	)

	INSERT INTO analyze_player (
	    player_id,
	    user_name,
	    agent_id,
	    agent_name,
	    topagent_id,
	    topagent_name,
	    promote_link,
	    is_new_player,
	    deposit_amount,
	    deposit_count,
	    withdraw_amount,
	    withdraw_count,
	    transaction_order,
	    transaction_volume,
	    effective_amount,
	    payout_amount,
	    static_date,
	    static_time,
	    static_time_end
	)
	SELECT up.*, pr.deposit_amount, pr.deposit_count, pw.withdraw_amount, pw.withdraw_count,
	       pgo.transaction_order, pgo.transaction_volume, pgo.effective_amount, pgo.payout_amount,
	       p_stat_date, p_start_time, p_end_time
	  FROM up
	  LEFT JOIN pr ON up.player_id = pr.player_id
	  LEFT JOIN pw ON up.player_id = pw.player_id
	  LEFT JOIN pgo ON up.player_id = pgo.player_id;

	GET DIAGNOSTICS n_count_player = ROW_COUNT;
	raise notice 'analyze_player新增记录数 %', n_count_player;


	raise info 'analyze_agent 清除 % 号统计数据...', p_stat_date;
	DELETE FROM analyze_agent WHERE static_date = p_stat_date;
	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice 'analyze_agent 本次删除记录数 %', n_count;

	raise info '统计 % 号经营数据.END', p_stat_date;

	INSERT INTO analyze_agent (
	    agent_id,
	    agent_name,
	    topagent_id,
	    topagent_name,
	    new_player_num,
	    new_player_num_deposit,
	    new_player_num_withdraw,
	    new_player_deposit_count,
	    new_player_withdraw_count,
	    new_player_deposit_amount,
	    new_player_withdraw_amount,
	    player_num_deposit,
	    player_num_withdraw,
	    deposit_amount,
	    withdraw_amount,
	    transaction_order,
	    transaction_volume,
	    effective_amount,
	    rebate_amount,
	    payout_amount,
	    static_date,
	    static_time,
	    static_time_end
	)
	SELECT
	    ap.agent_id,
	    ap.agent_name,
	    ap.topagent_id,
	    ap.topagent_name,
	    apn.new_player_num,
	    apn.new_player_num_deposit,
	    apn.new_player_num_withdraw,
	    apn.new_player_deposit_count,
	    apn.new_player_withdraw_count,
	    apn.new_player_deposit_amount,
	    apn.new_player_withdraw_amount,
	    ap.player_num_deposit,
	    ap.player_num_withdraw,
	    ap.deposit_amount,
	    ap.withdraw_amount,
	    ap.transaction_order,
	    ap.transaction_volume,
	    ap.effective_amount,
	    ra.rebate_amount,
	    ap.payout_amount,
	    p_stat_date,
	    p_start_time,
	    p_end_time
	  FROM
	  (SELECT
	      agent_id,
	      agent_name,
	      topagent_id,
	      topagent_name,
	      SUM(sign(deposit_amount)) player_num_deposit,
	      SUM(sign(withdraw_amount)) player_num_withdraw,
	      SUM(deposit_amount) deposit_amount,
	      SUM(withdraw_amount) withdraw_amount,
	      SUM(transaction_order) transaction_order,
	      SUM(transaction_volume) transaction_volume,
	      SUM(effective_amount) effective_amount,
	      SUM(payout_amount) payout_amount
	    FROM analyze_player
	   WHERE static_date = p_stat_date
	   GROUP BY agent_id, agent_name, topagent_id, topagent_name) ap
	  LEFT JOIN
	  (SELECT
	      agent_id,
	      SUM (is_new_player::INT) new_player_num,
	      SUM(sign(deposit_count)) new_player_num_deposit,
	      SUM(sign(withdraw_count)) new_player_num_withdraw,
	      SUM(deposit_count) new_player_deposit_count,
	      SUM(withdraw_count) new_player_withdraw_count,
	      SUM(deposit_amount) new_player_deposit_amount,
	      SUM(withdraw_amount) new_player_withdraw_amount
	    FROM analyze_player
	   WHERE is_new_player = TRUE
	     AND static_date = p_stat_date
	   GROUP BY agent_id, agent_name, topagent_id, topagent_name
	  ) apn
	  ON ap.agent_id = apn.agent_id
	  LEFT JOIN
	  (SELECT agent_id,
	          COALESCE(SUM(ra.rebate_actual), 0.00) rebate_amount
	     FROM rebate_agent ra
	    WHERE ra.settlement_time >= p_start_time AND ra.settlement_time < p_end_time
	      AND ra.settlement_state = 'lssuing'
	    GROUP BY agent_id
	  ) ra
	  ON ap.agent_id = ra.agent_id;

	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice 'analyze_agent新增记录数 %', n_count;

	raise info 'analyze_agent_domain 清除 % 号统计数据...', p_stat_date;
	DELETE FROM analyze_agent_domain WHERE static_date = p_stat_date;
	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice 'analyze_agent_domain 本次删除记录数 %', n_count;

	raise info '统计 % 号经营数据.END', p_stat_date;

	INSERT INTO analyze_agent_domain (
	    promote_link,
	    agent_id,
	    agent_name,
	    topagent_id,
	    topagent_name,
	    new_player_num,
	    new_player_num_deposit,
	    new_player_num_withdraw,
	    new_player_deposit_count,
	    new_player_withdraw_count,
	    new_player_deposit_amount,
	    new_player_withdraw_amount,
	    player_num_deposit,
	    player_num_withdraw,
	    deposit_amount,
	    withdraw_amount,
	    transaction_order,
	    transaction_volume,
	    effective_amount,
	    --rebate_amount,
	    payout_amount,
	    static_date,
	    static_time,
	    static_time_end
	)
	SELECT
	    ap.promote_link,
	    ap.agent_id,
	    ap.agent_name,
	    ap.topagent_id,
	    ap.topagent_name,
	    apn.new_player_num,
	    apn.new_player_num_deposit,
	    apn.new_player_num_withdraw,
	    apn.new_player_deposit_count,
	    apn.new_player_withdraw_count,
	    apn.new_player_deposit_amount,
	    apn.new_player_withdraw_amount,
	    ap.player_num_deposit,
	    ap.player_num_withdraw,
	    ap.deposit_amount,
	    ap.withdraw_amount,
	    ap.transaction_order,
	    ap.transaction_volume,
	    ap.effective_amount,
	    --ra.rebate_amount,
	    ap.payout_amount,
	    p_stat_date,
	    p_start_time,
	    p_end_time
	  FROM
	  (SELECT
	      promote_link,
	      agent_id,
	      agent_name,
	      topagent_id,
	      topagent_name,
	      SUM(sign(deposit_amount)) player_num_deposit,
	      SUM(sign(withdraw_amount)) player_num_withdraw,
	      SUM(deposit_amount) deposit_amount,
	      SUM(withdraw_amount) withdraw_amount,
	      SUM(transaction_order) transaction_order,
	      SUM(transaction_volume) transaction_volume,
	      SUM(effective_amount) effective_amount,
	      SUM(payout_amount) payout_amount
	    FROM analyze_player
	   WHERE static_date = p_stat_date
	   GROUP BY promote_link, agent_id, agent_name, topagent_id, topagent_name) ap
	  LEFT JOIN
	  (SELECT
	      promote_link,
	      agent_id,
	      SUM (is_new_player::INT) new_player_num,
	      SUM(sign(deposit_count)) new_player_num_deposit,
	      SUM(sign(withdraw_count)) new_player_num_withdraw,
	      SUM(deposit_count) new_player_deposit_count,
	      SUM(withdraw_count) new_player_withdraw_count,
	      SUM(deposit_amount) new_player_deposit_amount,
	      SUM(withdraw_amount) new_player_withdraw_amount
	    FROM analyze_player
	   WHERE is_new_player = TRUE
	     AND static_date = p_stat_date
	   GROUP BY promote_link, agent_id, agent_name, topagent_id, topagent_name
	  ) apn
	  ON ap.agent_id = apn.agent_id AND ap.promote_link = apn.promote_link;

	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice 'analyze_agent_domain新增记录数 %', n_count;

	RETURN n_count_player;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_analyze(p_stat_date DATE, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Laser-经营分析-玩家';


DROP FUNCTION IF EXISTS gb_rakeback_recount(TEXT, TEXT, TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_rakeback_recount(
  p_comp_url  TEXT,
  p_period   TEXT,
  p_start_time   TEXT,
  p_end_time   TEXT,
  p_settle_flag   TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2017/06/26  Laser   创建此函数: 返水结算账单.返水补差
--v1.01  2017/07/18  Laser   增加更新API反水表，更新返水发放、拒绝人数
--v1.02  2017/07/26  Laser   更改ON CONFLICT的写法，方便理解，rakeback_total从player表统计
--v1.03  2017/07/28  Laser   更改rakeback_player、rakeback_api的更新条件，只要重结后rakeback_pending>=0的都允许重结
--v1.04  2017/09/18  Laser   修正某些情况下rakeback_bill.lssuing_state统计错误的问题
--v1.05  2017/10/05  Laser   增加对重结出现新的游戏类型的支持
--v1.06  2018/03/11  Laser   增加对玩家层级改变的处理

  返回值说明：0成功，1警告，2错误
*/
DECLARE

  t_start_time   TIMESTAMP;
  t_end_time   TIMESTAMP;
  n_sid  INT;
  n_return_code INT := 0;

  --rec_rb.id INT;
  --rec_rbn.id INT;

  rec_rb  RECORD;
  rec_rbn RECORD;

  n_player_count         INT := 0;
  n_player_lssuing_count INT := 0;
  n_player_reject_count  INT := 0;
  n_rakeback_total     FLOAT := 0;

  v_lssuing_state varchar(32);

  v_remark varchar(50) := '';
  v_sql text;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  t_start_time = clock_timestamp()::timestamp(0);

  perform gb_rakeback(p_period, p_start_time, p_end_time, 'N');

  BEGIN

    SELECT *
      INTO rec_rb
      FROM rakeback_bill WHERE start_time = p_start_time::TIMESTAMP;

    IF NOT FOUND THEN
      RAISE NOTICE '本期返水未结算，不能执行返水补差操作！';
      RETURN 2;
    END IF;

    SELECT *
      INTO rec_rbn
      FROM rakeback_bill_nosettled WHERE start_time = p_start_time::TIMESTAMP;

    IF NOT FOUND THEN
      RAISE NOTICE '本期返水补差账单未生成，不能执行返水补差操作！';
      RETURN 2;
    END IF;

  EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE '本期返水账单异常，任务失败！';
    RETURN 2;
  END;

  IF rec_rb.player_count = rec_rbn.player_count AND rec_rb.rakeback_total = rec_rbn.rakeback_total THEN
    RAISE NOTICE '返水人数、总额无变化，不需要返水补差！';
    v_remark = '返水人数、总额无变化，不需要返水补差！';
  ELSE

    --更新返水结算账单
    --更新API反水表
    --v1.03  2017/07/28  Laser
    /*
    DELETE FROM rakeback_api ra
     WHERE rakeback_bill_id = rec_rb.id
       AND EXISTS (SELECT 1
                     FROM rakeback_api_nosettled
                    WHERE rakeback_bill_nosettled_id = rec_rbn.id
                      AND player_id = ra.player_id
                      AND api_id = ra.api_id
                      AND game_type = ra.game_type
                      AND rakeback > ra.rakeback);
    */

    --rakeback_player的条件必须和下面更新Player反水表的一样
    --v1.04  2017/10/05  Laser
    /*
    DELETE FROM rakeback_api ra
     WHERE rakeback_bill_id = rec_rb.id
       AND EXISTS (SELECT 1
                     FROM rakeback_api_nosettled
                    WHERE rakeback_bill_nosettled_id = rec_rbn.id
                      AND player_id = ra.player_id
                      AND api_id = ra.api_id
                      AND game_type = ra.game_type
                      AND rakeback <> ra.rakeback)
       AND EXISTS (SELECT 1
                     FROM rakeback_player rp RIGHT JOIN rakeback_player_nosettled rpn
                       ON rp.rakeback_bill_id = rec_rb.id AND rpn.rakeback_bill_nosettled_id = rec_rbn.id AND rp.player_id=rpn.player_id
                    WHERE rpn.rakeback_total <> COALESCE(rp.rakeback_total, 0)
                      AND rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) >= 0 --最终得到的返水未结值不能小于0
                      AND rpn.player_id = ra.player_id
                  );
    */
    DELETE FROM rakeback_api ra
     WHERE rakeback_bill_id = rec_rb.id
       AND NOT EXISTS ( SELECT 1
                          FROM rakeback_api_nosettled
                         WHERE rakeback_bill_nosettled_id = rec_rbn.id
                           AND player_id = ra.player_id
                           AND api_id = ra.api_id
                           AND game_type = ra.game_type
                           AND rakeback = ra.rakeback ) --重结后没有这条记录，或者返水值不相等
       AND NOT EXISTS ( SELECT 1
                          FROM rakeback_player rp RIGHT JOIN rakeback_player_nosettled rpn
                            ON rp.rakeback_bill_id = rec_rb.id AND rpn.rakeback_bill_nosettled_id = rec_rbn.id AND rp.player_id=rpn.player_id
                         WHERE rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) < 0 --最终得到的返水未结值不能小于0
                           AND rpn.player_id = ra.player_id
                      ); --重结后没有这个玩家、或者重结后的返水未结值>=0

    INSERT INTO rakeback_api (
        rakeback_bill_id, player_id, api_id, game_type, effective_transaction, profit_loss, rakeback, api_type_id, audit_num, rakeback_limit)
    SELECT rec_rb.id, player_id, api_id, game_type, effective_transaction, profit_loss, rakeback, api_type_id, audit_num, rakeback_limit
      FROM rakeback_api_nosettled
     WHERE rakeback_bill_nosettled_id = rec_rbn.id
    --v1.02  2017/07/26  Laser
    --ON CONFLICT ON CONSTRAINT rakeback_api_rpag_uc
    ON CONFLICT (rakeback_bill_id, player_id, api_id, game_type)
    DO NOTHING;

    --更新Player反水表
    WITH rpn AS (
      SELECT * FROM rakeback_player_nosettled WHERE rakeback_bill_nosettled_id = rec_rbn.id
    ),
    rp AS (
      SELECT * FROM rakeback_player WHERE rakeback_bill_id = rec_rb.id
    ),
    rpj AS (
      SELECT
          rpn.*,
          COALESCE(rp.rakeback_paid, 0) rakeback_paid, --已付返水
          rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) rakeback_pending --返水差额 +此前未结
        FROM rpn
        LEFT JOIN rp ON rpn.player_id = rp.player_id
       --v1.03  2017/07/28  Laser
       --WHERE rpn.rakeback_total > COALESCE(rp.rakeback_total, 0)
       WHERE rpn.rakeback_total <> COALESCE(rp.rakeback_total, 0)
         AND rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) >= 0 --最终得到的返水未结值不能小于0
    )
    --SELECT * FROM rpj
    INSERT INTO rakeback_player (
        rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker, settlement_state, remark,
        agent_id, top_agent_id, audit_num, rakeback_total, rakeback_actual, rakeback_paid, rakeback_pending
    )
    SELECT rec_rb.id, player_id, username, rank_id, rank_name, risk_marker, 'pending_lssuing', '返水补差',
           agent_id, top_agent_id, audit_num, rakeback_total, rakeback_pending, rakeback_paid, rakeback_pending
      FROM rpj
     --WHERE rakeback_total <> 0
    --v1.02  2017/07/26  Laser
    --ON CONFLICT ON CONSTRAINT rakeback_player_rp_uc
    ON CONFLICT (rakeback_bill_id, player_id)
    DO UPDATE SET rank_id          = excluded.rank_id, --v1.06  2018/03/11  Laser
                  rank_name        = excluded.rank_name,
                  risk_marker      = excluded.risk_marker,
                  rakeback_total   = excluded.rakeback_total,
                  rakeback_actual  = excluded.rakeback_pending,
                  rakeback_pending = excluded.rakeback_pending,
                  settlement_state = 'pending_lssuing',
                  remark = COALESCE(rakeback_player.remark, '返水补差');

    --v1.01  2017/07/18  Laser
    --返水发放、拒绝人数
    SELECT COUNT(player_id),
           SUM( CASE settlement_state WHEN 'lssuing' THEN 1 ELSE 0 END),
           SUM( CASE settlement_state WHEN 'reject_lssuing' THEN 1 ELSE 0 END),
           SUM( rakeback_total) --v1.02  2017/07/26
      INTO n_player_count,
           n_player_lssuing_count,
           n_player_reject_count,
           n_rakeback_total
      FROM rakeback_player
     WHERE rakeback_bill_id = rec_rb.id;

    --v1.04  2017/09/18  Laser
    v_lssuing_state := 'part_pay';
    IF n_player_lssuing_count + n_player_reject_count = 0 THEN
      v_lssuing_state := 'pending_pay';
    ELSEIF n_player_count = n_player_lssuing_count + n_player_reject_count THEN
      v_lssuing_state := 'all_pay';
    END IF;

    --更新返水总表
    UPDATE rakeback_bill rb
       SET player_count = n_player_count,
           player_lssuing_count = n_player_lssuing_count,
           player_reject_count = n_player_reject_count,
           rakeback_total = n_rakeback_total, --v1.02  2017/07/26
           rakeback_pending = n_rakeback_total - rb.rakeback_total + rb.rakeback_pending,
           --v1.04  2017/09/18  Laser
           --lssuing_state = CASE rb.lssuing_state WHEN 'pending_pay' THEN 'pending_pay' ELSE 'part_pay' END
           lssuing_state = v_lssuing_state
      FROM ( SELECT * FROM rakeback_bill_nosettled rbni WHERE rbni.id = rec_rbn.id ) rbn
     WHERE rb.id = rec_rb.id
       AND rb.rakeback_total <> rbn.rakeback_total;
  END IF;

  t_end_time = clock_timestamp()::timestamp(0);

  SELECT gamebox_current_site() INTO n_sid;

  --perform dblink_close_all();
  --perform dblink_connect('master',  p_comp_url);
  v_sql = 'SELECT * from gb_task_infomation_site( ''' || n_sid || ''', ''gb_rakeback_recount'', ''返水补差'', ''' || p_period || ''', ''1'', ''' ||
           t_start_time || ''', ''' || t_end_time || ''', ''' || v_remark || ''')';
  RAISE INFO '%', v_sql;

  IF 'mainsite' IN ( SELECT unnest(dblink_get_connections()) ) THEN
    PERFORM dblink_disconnect('mainsite');
  END IF;

  PERFORM dblink_connect_u('mainsite', p_comp_url);

  SELECT t.return_code
    INTO n_return_code
    FROM
    dblink ('mainsite',
            v_sql
           ) AS t(return_code INT);
  --perform dblink_disconnect('master');

  PERFORM dblink_disconnect('mainsite');
  --PERFORM dblink_close('mainsite');

  IF n_return_code <> 0 THEN
    RAISE INFO '任务记录未成功写入远端表';
  END IF;

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

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_recount( p_comp_url  TEXT, p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Laser-返水结算账单.返水补差';