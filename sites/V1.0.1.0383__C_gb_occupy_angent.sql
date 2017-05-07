-- auto gen by cherry 2017-02-12 20:58:05
DROP FUNCTION IF EXISTS gb_occupy_angent(INT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_occupy_angent(
	p_bill_id		INT,
	p_start_time		TIMESTAMP,
	p_end_time		TIMESTAMP
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/08/18  Leisure  创建此函数: 总代占成.代理贡献（占成和费用）
--v1.01  2016/11/01  Leisure  修改分摊费用条件，bet_time改为payout_time
--v1.02  2016/12/14  Leisure  修复record "rec" has no field "topagent_occupy"问题
*/
DECLARE
	rec record;

	n_effective_player  INT := 0;

	n_rebate_amount  FLOAT := 0.00;
	n_backwater_amount FLOAT := 0.00;
	n_favourable_amount FLOAT := 0.00;
	n_refund_fee_amount FLOAT := 0.00;

	n_deposit_amount 		float := 0.00;	-- 存款
	--n_company_deposit  float:=0.00;  -- 存款:公司入款
	--n_online_deposit  float:=0.00;  -- 存款:线上支付
	--n_artificial_deposit  float:=0.00;  -- 存款:手动存款

	n_withdrawal_amount  float := 0.00;  -- 取款
	--n_artificial_withdraw  float:=0.00;  -- 取款:手动取款
	--n_player_withdraw  float:=0.00;  -- 取款:玩家取款

	h_sys_apportion hstore;  --分摊比例配置信息
	n_agent_retio float := 0.00;  --代理分摊比例
	n_topagent_retio float := 0.00;  --总代分摊比例

	n_rebate_apportion_top  FLOAT := 0.00;
	n_apportion_top  FLOAT := 0.00;
	n_backwater_apportion_top  FLOAT := 0.00;
	n_favourable_apportion_top  FLOAT := 0.00;
	n_refund_fee_apportion_top  FLOAT := 0.00;

	n_occupy_top_final FLOAT := 0.00;

BEGIN
/*
	FOR rec IN
		SELECT oaa.agent_id,
		       oaa.agent_name,
		       SUM(oaa.effective_transaction)  effective_transaction,
		       SUM(oaa.profit_loss)  profit_loss,
		       SUM(oaa.topagent_occupy)  topagent_occupy
		  FROM occupy_agent_api oaa
		 WHERE oaa.occupy_bill_id = p_bill_id
		 GROUP BY oaa.agent_id, oaa.agent_name
	LOOP

		--有效玩家
		SELECT COUNT(DISTINCT player_id) effective_player
			INTO n_effective_player
		  FROM player_game_order pgo, v_sys_user_tier sut
		 WHERE pgo.player_id = sut.id
		   AND pgo.order_state = 'settle'
		   AND pgo.is_profit_loss = TRUE
		   --v1.01  2016/11/01  Leisure
		   AND pgo.payout_time >= p_start_time
		   AND pgo.payout_time < p_end_time
		   AND sut.agent_id = rec.agent_id;

		--取得存款金额
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_deposit_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND p.fund_type IN ('artificial_deposit',  --手动存款
		                       'company_deposit'', ''wechatpay_fast'', ''alipay_fast',  --公司存款
		                       'online_deposit'', ''wechatpay_scan'', ''alipay_scan'  --线上支付
		                      )
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;

		--取款金额
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_withdrawal_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND p.fund_type IN ('artificial_withdraw',  --手动取款
		                       'player_withdraw'  --玩家取款
		                      )
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;

		--取得返佣金额
		SELECT SUM (ra.rebate_actual)
		  INTO n_rebate_amount
		  FROM rebate_agent ra
		 WHERE ra.agent_id = rec.agent_id
		   AND ra.settlement_time >= p_start_time
		   AND ra.settlement_time < p_end_time
		   AND ra.settlement_state = 'lssuing';

		--统计各种费用
		--反水
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_backwater_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND p.fund_type = 'backwater'
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;

		--优惠、推荐
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_favourable_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND (fund_type = 'favourable' OR
		       fund_type = 'recommend' OR
		       (fund_type = 'artificial_deposit' AND transaction_type = 'favorable'))
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;

		--返手续费
		SELECT SUM(transaction_money) as transaction_money
		  INTO n_refund_fee_amount
		  FROM player_transaction p, v_sys_user_tier u
		 WHERE p.player_id = u.id
		   AND u.agent_id = rec.agent_id
		   AND p.fund_type = 'refund_fee'
		   AND p.status = 'success'
		   AND p.create_time >= p_start_time
		   AND p.create_time < p_end_time;
*/
	FOR rec IN
		WITH oaa AS(
		  SELECT agent_id,
		         agent_name,
		         SUM(effective_transaction)  effective_transaction,
		         SUM(profit_loss)  profit_loss,
		         SUM(topagent_occupy)  topagent_occupy
		    FROM occupy_agent_api
		   WHERE occupy_bill_id = p_bill_id
		   GROUP BY agent_id, agent_name
		),

		pt AS (
		  SELECT *
		    FROM player_transaction
		   WHERE status = 'success'
		     AND completion_time >= p_start_time
		     AND completion_time < p_end_time
		),

		pti AS (
		        --存款
		         SELECT player_id,
		                'deposit' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE transaction_type = 'deposit'
		            --AND (fund_type <> 'artificial_deposit' OR transaction_way = 'manual_deposit')

		         UNION ALL
		         --取款
		         SELECT player_id,
		                'withdrawal' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE transaction_type = 'withdrawals'
		            --AND (fund_type <> 'artificial_withdraw' OR transaction_way = 'manual_deposit')

		         UNION ALL
		         --优惠
		         SELECT player_id,
		                'favorable' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE (transaction_type = 'favorable'
		                 AND fund_type <> 'refund_fee'
		                 AND transaction_way <> 'manual_rakeback')

		         UNION ALL
		         --推荐
		         SELECT player_id,
		                'recommend' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE transaction_type = 'recommend'

		         UNION ALL
		         --返水
		         SELECT player_id,
		                'backwater' AS transaction_type,
		                transaction_money
		           FROM pt
		          WHERE (transaction_type = 'backwater' OR
		                 (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))

		         UNION ALL
		         --返手续费
		         SELECT player_id,
		                'refund_fee' transaction_type,
		                transaction_money
		           FROM pt
		          WHERE fund_type = 'refund_fee'
		        ),

		pto AS (
		  SELECT ua."id" AS agent_id,
		         ua.username AS agent_name,
		         transaction_type,
		         transaction_money
		    FROM pti
		         LEFT JOIN
		         sys_user su ON pti.player_id = su."id" AND su.user_type = '24'
		         LEFT JOIN
		         sys_user ua ON su.owner_id = ua."id" AND ua.user_type = '23'
		),

		ptt AS (
		  SELECT agent_id,
		         agent_name,
		         SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit,
		         SUM(CASE transaction_type WHEN 'withdrawal' THEN transaction_money ELSE 0 END) AS withdrawal,
		         SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money ELSE 0 END) AS favorable,
		         SUM(CASE transaction_type WHEN 'recommend' THEN transaction_money ELSE 0 END) AS recommend,
		         SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS backwater,
		         SUM(CASE transaction_type WHEN 'refund_fee' THEN transaction_money ELSE 0 END) AS refund_fee
		    FROM pto
		   GROUP BY agent_id, agent_name
		)

		SELECT COALESCE(oaa.agent_id, ptt.agent_id) agent_id,
		       COALESCE(oaa.agent_name, ptt.agent_name) agent_name,
		       COALESCE(effective_transaction, 0.00) effective_transaction,
		       COALESCE(profit_loss, 0) profit_loss,
		       COALESCE(topagent_occupy, 0) topagent_occupy,--v1.02  2016/12/14  Leisure
		       COALESCE(deposit, 0.00) deposit,
		       COALESCE(withdrawal, 0.00) withdrawal,
		       COALESCE(favorable, 0.00) favorable,
		       COALESCE(recommend, 0.00) recommend,
		       COALESCE(backwater, 0.00) backwater,
		       COALESCE(refund_fee, 0.00) refund_fee
		  FROM oaa FULL JOIN ptt ON oaa.agent_id = ptt.agent_id
		 ORDER BY agent_id
	LOOP

		--存款金额
		n_deposit_amount = rec.deposit;
		--取款金额
		n_withdrawal_amount = rec.withdrawal;

		--优惠、推荐
		n_favourable_amount = rec.favorable + rec.recommend;
		--反水
		n_backwater_amount = rec.backwater;
		--返手续费
		n_refund_fee_amount = rec.refund_fee;

		--有效玩家
		SELECT gamebox_valid_player_num(p_start_time, p_end_time, rec.agent_id, 0.00) INTO n_effective_player;

		--取得返佣金额
		SELECT SUM (ra.rebate_actual)
		  INTO n_rebate_amount
		  FROM rebate_agent ra
		 WHERE ra.agent_id = rec.agent_id
		   AND ra.settlement_time >= p_start_time
		   AND ra.settlement_time < p_end_time
		   AND ra.settlement_state = 'lssuing';

		--计算分摊费用、分摊佣金
		SELECT gamebox_sys_param('apportionSetting') INTO h_sys_apportion;

		--佣金分摊
		n_topagent_retio = 0.00;

		IF isexists(h_sys_apportion, 'topagent.rebate.percent') THEN
			n_topagent_retio = (h_sys_apportion->'topagent.rebate.percent')::float;
		END IF;

		n_rebate_apportion_top = n_rebate_amount * n_topagent_retio / 100;

		--优惠与推荐分摊
		n_agent_retio = 0.00;
		n_topagent_retio = 0.00;

		IF isexists(h_sys_apportion, 'agent.preferential.percent') THEN
			n_agent_retio = (h_sys_apportion->'agent.preferential.percent')::float;  --代理分摊比例
		END IF;

		IF isexists(h_sys_apportion, 'topagent.preferential.percent') THEN
			n_topagent_retio = (h_sys_apportion->'topagent.preferential.percent')::float;  --总代分摊比例
		END IF;

		n_favourable_apportion_top = n_favourable_amount * (1 - n_agent_retio / 100) * n_topagent_retio / 100;

		--返手续费分摊
		n_agent_retio = 0.00;
		n_topagent_retio = 0.00;

		IF isexists(h_sys_apportion, 'agent.poundage.percent') THEN
			n_agent_retio = (h_sys_apportion->'agent.poundage.percent')::float;
		END IF;

		IF isexists(h_sys_apportion, 'topagent.poundage.percent') THEN
			n_topagent_retio = (h_sys_apportion->'topagent.poundage.percent')::float;
		END IF;

		n_topagent_retio = (1 - n_agent_retio / 100) * n_topagent_retio / 100;

		n_refund_fee_apportion_top = n_refund_fee_amount * n_topagent_retio;

		--返水分摊
		n_agent_retio = 0.00;
		n_topagent_retio = 0.00;

		IF isexists(h_sys_apportion, 'agent.rakeback.percent') THEN
			n_agent_retio = (h_sys_apportion->'agent.rakeback.percent')::float;
		END IF;

		IF isexists(h_sys_apportion, 'topagent.rakeback.percent') THEN
			n_topagent_retio = (h_sys_apportion->'topagent.rakeback.percent')::float;
		END IF;

		n_topagent_retio = (1 - n_agent_retio / 100) * n_topagent_retio / 100;

		n_backwater_apportion_top = n_backwater_amount * n_topagent_retio;

		--费用分摊总和 = (优惠+返手续费+反水+返佣)
		n_apportion_top = n_backwater_apportion_top + n_favourable_apportion_top + n_refund_fee_apportion_top + n_rebate_apportion_top;

		--总代最终占成金额 = 总代占成金额 - 佣金分摊 - 其他费用分摊
		n_occupy_top_final = rec.topagent_occupy - n_apportion_top;

		--插入总代占成-代理贡献占成表
		INSERT INTO occupy_agent(
		    occupy_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
		    deposit_amount, rebate, withdrawal_amount, preferential_value, occupy_total, occupy_actual,
		    remark, lssuing_state, apportion, refund_fee, recommend, rakeback
		) VALUES(
		    p_bill_id, rec.agent_id, rec.agent_name, n_effective_player, rec.effective_transaction, rec.profit_loss,
		    n_deposit_amount, n_rebate_amount, n_withdrawal_amount, n_favourable_apportion_top, rec.topagent_occupy, n_occupy_top_final,
		    NULL, 'pending_pay', n_apportion_top, n_refund_fee_apportion_top, 0.00, n_backwater_apportion_top
		);
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_occupy_angent(p_bill_id INT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-总代占成.代理贡献（占成和费用）';

drop function if exists gb_analyze(DATE, TIMESTAMP, TIMESTAMP);
create or replace function gb_analyze(
	p_stat_date 	DATE,
	p_start_time 	TIMESTAMP,
	p_end_time 	TIMESTAMP
) RETURNS INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/12/10  Leisure  创建此函数: 经营分析-玩家
--v1.01  2016/12/19  Leisure  取款改为实际取款。存取款改由存取款表获取
--v1.02  2017/01/19  Leisure  删除条件“是否盈亏”
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
	                SUM(withdraw_actual_amount) withdraw_amount
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
	     --v1.02  2017/01/19  Leisure
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
IS 'Leisure-经营分析-玩家';

select redo_sqls($$
      ALTER TABLE rakeback_api_nosettled
			ADD COLUMN audit_num numeric(20,2);

		ALTER TABLE rakeback_api
			ADD COLUMN audit_num numeric(20,2);

		ALTER TABLE rakeback_api_nosettled
			ADD COLUMN rakeback_limit numeric(20,2);

		ALTER TABLE rakeback_api
			ADD COLUMN rakeback_limit numeric(20,2);

$$);

	COMMENT ON COLUMN rakeback_api_nosettled.audit_num IS '优惠稽核';

	COMMENT ON COLUMN rakeback_api.audit_num IS '优惠稽核';

COMMENT ON COLUMN rakeback_api_nosettled.rakeback_limit IS '玩家返水上限';

COMMENT ON COLUMN rakeback_api.rakeback_limit IS '玩家返水上限';

DROP FUNCTION IF EXISTS gamebox_rakeback_api_base(TIMESTAMP);
create or replace function gamebox_rakeback_api_base(
	p_rakeback_time 	TIMESTAMP
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-各玩家API返水基础表.入口
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/08/01  Leisure  取消当前日期是否有返水活动判断 by shook
--v1.03  2017/01/15  Leisure  取消is_profit_loss判断，统计时间由bet_time改为payout_time by Ketty
*/
DECLARE
	rakeback 	FLOAT:=0.00;
	rec 		record;
	gradshash 	hstore;
	agenthash 	hstore;
	is_prefer	int:=0;

BEGIN
	raise info '取得当前返水梯度设置信息';
	SELECT gamebox_rakeback_api_grads() into gradshash;
	raise info '取得代理返水设置';
	SELECT gamebox_agent_rakeback() 	into agenthash;

	raise info '统计前清空当前日期( % )已有数据', p_rakeback_time;
	DELETE FROM rakeback_api_base WHERE rakeback_time >= p_rakeback_time AND rakeback_time < p_rakeback_time + '24hour';

	--v1.02  2016/08/01  Leisure
	/*
	raise info '统计日期( % )内是否有返水优惠活动', p_rakeback_time;
	SELECT COUNT(1) FROM activity_message
	 WHERE p_rakeback_time >= start_time
	   AND p_rakeback_time <end_time
	   AND check_status = '1'
	   AND is_display = TRUE
	   AND is_deleted = FALSE
	   AND activity_type_code = 'back_water' into is_prefer;
	*/

	FOR rec IN
		SELECT ua.parent_id,
		       su.owner_id,
		       su.username,
		       po.player_id 	as userid,
		       po.api_id,
		       po.api_type_id,
		       po.game_type,
		       po.effective_trade_amount,
		       po.profit_amount,
		       up.rakeback_id,
		       up.rank_id
		  FROM (SELECT pgo.player_id,
		               pgo.api_id,
		               pgo.api_type_id,
		               pgo.game_type,
		               SUM(COALESCE(pgo.effective_trade_amount, 0.00))	as effective_trade_amount,
		               SUM(COALESCE(pgo.profit_amount, 0.00))			as profit_amount
		              FROM player_game_order pgo
		             --WHERE bet_time >= p_rakeback_time
		               --AND bet_time < p_rakeback_time + '24hour'
		             WHERE payout_time >= p_rakeback_time
		               AND payout_time < p_rakeback_time + '24hour'
		               AND pgo.order_state = 'settle'
		               --AND pgo.is_profit_loss = TRUE
		             GROUP BY pgo.player_id, pgo.api_id, pgo.api_type_id, pgo.game_type) po
		       LEFT JOIN sys_user su ON po.player_id = su."id"
		       LEFT JOIN user_player up ON po.player_id = up."id"
		       LEFT JOIN user_agent ua ON su.owner_id = ua."id"
		 WHERE su.user_type = '24'

	LOOP
		--v1.02  2016/08/01  Leisure
		--IF is_prefer > 0 THEN
		SELECT gamebox_rakeback_calculator(gradshash, agenthash, row_to_json(rec), p_rakeback_time) into rakeback;
		--END IF;
		raise info '玩家[%]返水 = %', rec.username, rakeback;

		-- 新增玩家返水:有返水才新增.
		IF rakeback > 0 THEN
			INSERT INTO rakeback_api_base(
			    top_agent_id, agent_id, player_id, api_id, api_type_id, game_type,
			    effective_transaction, profit_loss, rakeback, rakeback_time
			) VALUES (
			    rec.parent_id, rec.owner_id, rec.userid, rec.api_id, rec.api_type_id, rec.game_type,
			    rec.effective_trade_amount, rec.profit_amount, rakeback, p_rakeback_time
			);
		END IF;
	END LOOP;

	raise info '收集每个API下每个玩家的返水.完成';
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_api_base(p_rakeback_time TIMESTAMP)
IS 'Lins-返水-各玩家API返水基础表.入口';


DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rakeback_bill (
	name 			TEXT,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	INOUT bill_id 	INT,
	op 				TEXT,
	flag 			TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-返水周期主表
--v1.01  2016/05/30  Leisure  改为returning，防止并发
--v1.01  2017/01/18  Leisure  没有返水玩家，依然保留返水总表记录
*/
DECLARE
	pending_lssuing text:='pending_lssuing';
	pending_pay 	text:='pending_pay';
	rec 			record;
	max_back_water 	float:=0.00;
	backwater 		float:=0.00;
	rp_count		INT:=0;	-- rakeback_player 条数

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

			--改为returning，防止并发 Leisure 20160530
			--SELECT currval(pg_get_serial_sequence('rakeback_bill',  'id')) into bill_id; --v1.01  2016/05/30  Leisure

		ELSE
			SELECT COUNT(1) FROM rakeback_player WHERE rakeback_bill_id = bill_id INTO rp_count;
			IF rp_count > 0 THEN
				FOR rec IN
					SELECT rakeback_bill_id,
						   COUNT(DISTINCT player_id) 	as cl,
						   SUM(rakeback_total) 			as sl
					  FROM rakeback_player
					 WHERE rakeback_bill_id = bill_id
					 GROUP BY rakeback_bill_id
				LOOP
					UPDATE rakeback_bill SET player_count = rec.cl, rakeback_total = rec.sl WHERE id = bill_id;
				END LOOP;
			--ELSE
				--DELETE FROM rakeback_bill WHERE id = bill_id;
			END IF;
		END IF;

	ELSEIF flag='N' THEN--未出账

		IF op='I' THEN
			--先插入返水总记录并取得键值.
			INSERT INTO rakeback_bill_nosettled (
			 	start_time, end_time, rakeback_total, create_time
			) VALUES (
			 	start_time, end_time, 0, now()
			) returning id into bill_id;

			--改为returning，防止并发 Leisure 20160530
			--SELECT currval(pg_get_serial_sequence('rakeback_bill_nosettled', 'id')) into bill_id;
		ELSE
			SELECT COUNT(1) FROM rakeback_player_nosettled WHERE rakeback_bill_nosettled_id = bill_id INTO rp_count;
			-- raise info '---- rp_count = %', rp_count;
			IF rp_count > 0 THEN
				FOR rec in
					SELECT rakeback_bill_nosettled_id,
						   COUNT(DISTINCT player_id) 	as cl,
						   SUM(rakeback_total) 			as sl
					  FROM rakeback_player_nosettled
					 WHERE rakeback_bill_nosettled_id = bill_id
					 GROUP BY rakeback_bill_nosettled_id
				LOOP
					UPDATE rakeback_bill_nosettled SET rakeback_total = rec.sl WHERE id = bill_id;
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


drop function if exists gb_rakeback(TEXT, TEXT, TEXT, TEXT);
create or replace function gb_rakeback(
	p_period 	TEXT,
	p_start_time 	TEXT,
	p_end_time 	TEXT,
	p_settle_flag 	TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/10/08  Leisure   创建此函数: 返水结算账单.入口
*/
DECLARE

	t_start_time 	TIMESTAMP;
	t_end_time 	TIMESTAMP;

	n_rakeback_bill_id INT:=-1; --返水主表键值.
	n_bill_count 	INT :=0;

	n_sid 			INT;--站点ID.
	--b_is_max 		BOOLEAN := true;

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
		 WHERE rb.period = p_period
		   AND rb."start_time" = t_start_time
		   AND rb."end_time" = t_end_time
		   AND rb.lssuing_state <> 'pending_pay';

		IF n_bill_count = 0 THEN
			DELETE FROM rakeback_api ra WHERE ra.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rakeback_player rp WHERE rp.rakeback_bill_id IN (SELECT "id" FROM rakeback_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rakeback_bill rb WHERE "id" IN (SELECT "id" FROM rakeback_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
		ELSE
			RAISE INFO '已生成本期返水账单，不能重新生成！';
			RETURN;
		END IF;
	ELSEIF p_settle_flag = 'N' THEN
		TRUNCATE TABLE rakeback_api_nosettled;
		TRUNCATE TABLE rakeback_player_nosettled;
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


DROP FUNCTION IF EXISTS gb_rakeback_api(INT, TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_rakeback_api(
  p_bill_id   INT,
  p_settle_flag   TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返水结算账单.玩家API返水
--v1.01  2016/01/22  Leisure  增加返水金额空值处理
*/
DECLARE

  h_occupy_map   hstore;    -- API占成梯度map
  --h_assume_map   hstore;    -- 盈亏共担map

  --h_sys_config   hstore;
  --sp       TEXT:='@';
  --rs       TEXT:='\~';
  --cs       TEXT:='\^';
  b_meet_or_not   BOOLEAN; --是否达到返水条件

  n_rakeback_set_id   INT;
  n_audit_num   numeric(20,2); --优惠稽核
  --v_rakeback_set_name   TEXT:='';
  --n_valid_value     FLOAT:=0.00;

  v_key_name         TEXT:='';
  COL_SPLIT       TEXT:='_';

  rec_player   record;
  rec_api   record;
  --rec_grad   record;
  n_grad_id   INT;
  n_max_rakeback   FLOAT:=0.00;--返水上限

  --rec_grad_api   record;
  n_grad_api_id   INT;
  n_rakeback_ratio   FLOAT := 0.00;

  n_player_id   INT;
  v_player_name   TEXT;
  n_agent_id   INT;
  v_agent_name   TEXT;
  --n_topagent_id   INT;
  n_api_id     INT;
  v_game_type   TEXT;

  n_profit_amount       FLOAT:=0.00;--盈亏总和
  n_effective_transaction   FLOAT:=0.00;--有效交易量

  n_row_count   INT :=0;
  n_effective_player_num INT :=0;

  n_rakeback_value   FLOAT:=0.00;--代理API返水金额

  n_rakeback_api_id   INT :=0;

BEGIN
  --取得系统变量
  --SELECT sys_config() INTO h_sys_config;
  --sp = h_sys_config->'sp_split';
  --rs = h_sys_config->'row_split';
  --cs = h_sys_config->'col_split';

  DELETE FROM rakeback_api_base WHERE rakeback_time >= p_start_time AND rakeback_time < p_end_time;

  --玩家循环
  FOR rec_player IN
    SELECT su."id"                   as player_id,
           su.username               as player_name,
           up.rakeback_id            as rakeback_id,
           ua."id"                   as agent_id,
           ua.username               as agent_name,
           ut."id"                   as topagent_id,
           ut.username               as topagent_name,
           pgo.effective_transaction,
           pgo.profit_amount
      FROM
    (
      SELECT player_id,
             COALESCE( SUM(pg.effective_trade_amount), 0.00) as effective_transaction,
             COALESCE( SUM(pg.profit_amount), 0.00) as profit_amount
          FROM player_game_order pg
       WHERE pg.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pg.payout_time >= p_start_time
         AND pg.payout_time < p_end_time
       GROUP BY player_id
    ) pgo
        LEFT JOIN user_player up ON pgo.player_id = up."id"
        LEFT JOIN sys_user su ON up.id = su."id"  AND su.user_type = '24'
        LEFT JOIN sys_user ua ON su.owner_id = ua.id AND ua.user_type = '23'
        LEFT JOIN sys_user ut ON ua.owner_id = ut.id AND ut.user_type = '22'
     ORDER BY effective_transaction DESC, su."id"
  LOOP
    --重新初始化变量
    b_meet_or_not = TRUE;
    n_player_id = rec_player.player_id;
    v_player_name = rec_player.player_name;

    n_agent_id = rec_player.agent_id;
    v_agent_name = rec_player.agent_name;
    --n_topagent_id = rec_player.topagent_id;
    n_effective_transaction = rec_player.effective_transaction;
    n_profit_amount = rec_player.profit_amount;

    --取得玩家返水方案
    --n_rakeback_set_id = rec_player.rakeback_id;

    SELECT rs.id, rs.audit_num
      INTO n_rakeback_set_id, n_audit_num
      FROM rakeback_set rs
     WHERE rs.id = rec_player.rakeback_id;

    --若玩家未设置返水方案，取代理返水方案
    IF n_rakeback_set_id IS NULL THEN
      --取得代理返水方案
      SELECT ua.rakeback_id, rs.audit_num
        INTO n_rakeback_set_id, n_audit_num
        FROM user_agent_rakeback ua, rakeback_set rs
       WHERE ua.user_id = n_agent_id
         AND rs.status = '1'
         AND rs.id = ua.rakeback_id;

      GET DIAGNOSTICS n_row_count = ROW_COUNT;
      IF n_row_count = 0 THEN
        RAISE INFO '玩家ID: %, 名称: %, 未设置返水方案！代理ID: %, 名称: %, 亦未设置返水方案！',
                   n_player_id, v_player_name, n_agent_id, v_agent_name;
        --CONTINUE;
        b_meet_or_not = FALSE;
      END IF;
    END IF;

    IF b_meet_or_not THEN

      --取得返水梯度
      SELECT rg.id AS grads_id,   --返水梯度ID
             rg.max_rakeback       --返水上限
        FROM rakeback_grads rg
       WHERE rg.rakeback_id = n_rakeback_set_id
         AND n_effective_transaction >= rg.valid_value --实际有效交易量 >= 梯度有效交易量
       ORDER BY rg.valid_value DESC
       LIMIT 1
        --INTO rec_grad;
        INTO n_grad_id, n_max_rakeback;

      GET DIAGNOSTICS n_row_count = ROW_COUNT;
      IF n_row_count = 0 THEN
        RAISE INFO '玩家ID: %, 名称: %, 代理ID: %, 名称: %, 返水方案ID: %, 未达返水梯度！',
                   n_player_id, v_player_name, n_agent_id, v_agent_name, n_rakeback_set_id;
        --CONTINUE;
        b_meet_or_not = FALSE;
      END IF; --返水梯度

    END IF; --返水方案

    --玩家api循环
    FOR rec_api IN
      SELECT pgo.api_id,
             pgo.game_type,
             COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
             COALESCE(SUM(-pgo.profit_amount), 0.00)  as profit_amount
          FROM player_game_order pgo
          LEFT JOIN sys_user su ON pgo.player_id = su."id"
          --LEFT JOIN sys_user ua ON su.owner_id = ua.id
       WHERE pgo.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pgo.payout_time >= p_start_time
         AND pgo.payout_time < p_end_time
         AND su.user_type = '24'
         --AND ua.user_type = '23'
         AND su."id" = n_player_id
       GROUP BY pgo.api_id, pgo.game_type
       ORDER BY effective_transaction DESC, pgo.api_id, pgo.game_type
    LOOP

      --重新初始化变量
      n_api_id       = rec_api.api_id;
      v_game_type     = rec_api.game_type;
      n_effective_transaction   = rec_api.effective_transaction;
      n_profit_amount   = rec_api.profit_amount;

      n_grad_api_id = NULL;
      n_rakeback_ratio = 0.00;

      n_rakeback_value = 0.00;

      IF b_meet_or_not THEN
        --取得返水比率
        SELECT rga.id AS grads_api_id, --返水梯度API比率ID
               rga.ratio --API返水比例
          FROM rakeback_grads_api rga
         WHERE rga.rakeback_grads_id = n_grad_id --rec_grad.grads_id
           AND rga.api_id = n_api_id
           AND rga.game_type = v_game_type
         LIMIT 1
          --INTO rec_grad_api;
          INTO n_grad_api_id, n_rakeback_ratio;
      END IF;

      IF b_meet_or_not THEN
        --计算返水
        n_rakeback_value := n_effective_transaction * n_rakeback_ratio/100;
      END IF;

      --返水不能超过返水上限
      --IF n_rakeback_value > rec_grad.max_rakeback THEN
      --  n_rakeback_value = rec_grad.max_rakeback;
      --END IF;

      INSERT INTO rakeback_api_base (
          top_agent_id, agent_id, player_id, api_id, game_type,
          effective_transaction, profit_loss, rakeback, rakeback_time
      )
      VALUES (
          rec_player.topagent_id, rec_player.agent_id, rec_player.player_id, rec_api.api_id, rec_api.game_type,
          rec_api.effective_transaction, rec_api.profit_amount, n_rakeback_value, p_start_time
      );

      --v1.01  2016/01/22  Leisure
      IF n_rakeback_value > 0 THEN

        IF p_settle_flag = 'Y' THEN
          INSERT INTO rakeback_api (
              rakeback_bill_id, player_id, api_id, game_type, rakeback,
              effective_transaction, profit_loss, audit_num, rakeback_limit
          )
          VALUES (
              p_bill_id, rec_player.player_id, rec_api.api_id, rec_api.game_type, n_rakeback_value,
              rec_api.effective_transaction, rec_api.profit_amount, n_audit_num, n_max_rakeback
          ) RETURNING id INTO n_rakeback_api_id;

        ELSEIF p_settle_flag = 'N' THEN
          INSERT INTO rakeback_api_nosettled (
              rakeback_bill_nosettled_id, player_id, api_id, game_type, rakeback,
              effective_transaction, profit_loss, audit_num, rakeback_limit
          )
          VALUES (
              p_bill_id, rec_player.player_id, rec_api.api_id, rec_api.game_type, n_rakeback_value,
              rec_api.effective_transaction, rec_api.profit_amount, n_audit_num, n_max_rakeback
          ) RETURNING id INTO n_rakeback_api_id;
        END IF;

          RAISE INFO 'rakeback_api.新增键值 %.玩家 %, API %, GAME_TYPE %, .金额 %.', n_rakeback_api_id, rec_player.player_id, rec_api.api_id, rec_api.game_type, n_rakeback_value;
      END IF;

    END LOOP;
  END LOOP;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_api(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-返水.玩家API返水';


DROP FUNCTION IF EXISTS gb_rakeback_api_base(INT, TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_rakeback_api_base(
  p_bill_id   INT,
  p_settle_flag   TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/15  Leisure  创建此函数: 返水结算账单.API返水基础表
--v1.01  2016/01/22  Leisure  增加返水金额空值处理
*/
DECLARE

  h_occupy_map   hstore;    -- API占成梯度map
  --h_assume_map   hstore;    -- 盈亏共担map

  --h_sys_config   hstore;
  --sp       TEXT:='@';
  --rs       TEXT:='\~';
  --cs       TEXT:='\^';
  b_meet_or_not   BOOLEAN; --是否达到返水条件

  n_rakeback_set_id   INT;
  n_audit_num   numeric(20,2); --优惠稽核
  --v_rakeback_set_name   TEXT:='';
  --n_valid_value     FLOAT:=0.00;

  v_key_name         TEXT:='';
  COL_SPLIT       TEXT:='_';

  rec_player   record;
  rec_api   record;
  --rec_grad   record;
  n_grad_id   INT;
  --rec_grad_api   record;
  n_grad_api_id   INT;
  n_rakeback_ratio   FLOAT := 0.00;

  n_player_id   INT;
  v_player_name   TEXT;
  n_agent_id   INT;
  v_agent_name   TEXT;
  --n_topagent_id  INT;
  n_api_id     INT;
  v_game_type   TEXT;

  n_profit_amount       FLOAT:=0.00;--盈亏总和
  n_effective_transaction   FLOAT:=0.00;--有效交易量

  n_row_count   INT :=0;
  n_effective_player_num INT :=0;

  n_rakeback_value   FLOAT:=0.00;--代理API返水金额

BEGIN
  --取得系统变量
  --SELECT sys_config() INTO h_sys_config;
  --sp = h_sys_config->'sp_split';
  --rs = h_sys_config->'row_split';
  --cs = h_sys_config->'col_split';

  DELETE FROM rakeback_api_base WHERE rakeback_time >= p_start_time AND rakeback_time < p_end_time;

  --玩家循环
  FOR rec_player IN
    SELECT su."id"                   as player_id,
           su.username               as player_name,
           up.rakeback_id            as rakeback_id,
           ua."id"                   as agent_id,
           ua.username               as agent_name,
           ut."id"                   as topagent_id,
           ut.username               as topagent_name,
           pgo.effective_transaction,
           pgo.profit_amount
      FROM
    (
      SELECT player_id,
             COALESCE( SUM(pg.effective_trade_amount), 0.00) as effective_transaction,
             COALESCE( SUM(pg.profit_amount), 0.00) as profit_amount
          FROM player_game_order pg
       WHERE pg.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pg.payout_time >= p_start_time
         AND pg.payout_time < p_end_time
       GROUP BY player_id
    ) pgo
        LEFT JOIN user_player up ON pgo.player_id = up."id"
        LEFT JOIN sys_user su ON up.id = su."id"  AND su.user_type = '24'
        LEFT JOIN sys_user ua ON su.owner_id = ua.id AND ua.user_type = '23'
        LEFT JOIN sys_user ut ON ua.owner_id = ut.id AND ut.user_type = '22'
     ORDER BY effective_transaction DESC, su."id"
  LOOP
    --重新初始化变量
    b_meet_or_not = TRUE;
    n_player_id = rec_player.player_id;
    v_player_name = rec_player.player_name;

    n_agent_id = rec_player.agent_id;
    v_agent_name = rec_player.agent_name;
    --n_topagent_id = rec_player.topagent_id;
    n_effective_transaction = rec_player.effective_transaction;
    n_profit_amount = rec_player.profit_amount;

    --取得玩家返水方案
    n_rakeback_set_id = rec_player.rakeback_id;

    --若玩家未设置返水方案，取代理返水方案
    IF n_rakeback_set_id IS NULL THEN
      --取得代理返水方案
      SELECT ua.rakeback_id, rs.audit_num
        INTO n_rakeback_set_id, n_audit_num
        FROM user_agent_rakeback ua, rakeback_set rs
       WHERE ua.user_id = n_agent_id
         AND rs.status = '1'
         AND rs.id = ua.rakeback_id;

      GET DIAGNOSTICS n_row_count = ROW_COUNT;
      IF n_row_count = 0 THEN
        RAISE INFO '玩家ID: %, 名称: %，未设置返水方案！代理ID: %, 名称: %，亦未设置返水方案！',
                   n_player_id, v_player_name, n_agent_id, v_agent_name;
        --CONTINUE;
        b_meet_or_not = FALSE;
      END IF;
    END IF;

    IF b_meet_or_not THEN

      --取得返水梯度
      SELECT rg.id AS grads_id   --返水梯度ID
             --rg.total_profit,     --有效盈利总额
             --rg.max_rakeback,       --返水上限
             --rg.valid_player_num  --有效玩家数
        FROM rakeback_grads rg
       WHERE rg.rakeback_id = n_rakeback_set_id
         AND n_effective_transaction >= rg.valid_value --实际有效交易量 >= 梯度有效交易量
       ORDER BY rg.valid_value DESC
       LIMIT 1
        --INTO rec_grad;
        INTO n_grad_id;

      GET DIAGNOSTICS n_row_count = ROW_COUNT;
      IF n_row_count = 0 THEN
        RAISE INFO '玩家ID: %, 名称: %, 代理ID: %, 名称: %, 返水方案ID: %, 未达返水梯度！',
                   n_player_id, v_player_name, n_agent_id, v_agent_name, n_rakeback_set_id;
        --CONTINUE;
        b_meet_or_not = FALSE;
      END IF; --返水梯度

    END IF; --返水方案

    --玩家api循环
    FOR rec_api IN
      SELECT pgo.api_id,
             pgo.game_type,
             COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
             COALESCE(SUM(-pgo.profit_amount), 0.00) as profit_amount
          FROM player_game_order pgo
          LEFT JOIN sys_user su ON pgo.player_id = su."id"
          --LEFT JOIN sys_user ua ON su.owner_id = ua.id
       WHERE pgo.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pgo.payout_time >= p_start_time
         AND pgo.payout_time < p_end_time
         AND su.user_type = '24'
         --AND ua.user_type = '23'
         AND su."id" = n_player_id
       GROUP BY pgo.api_id, pgo.game_type
       ORDER BY pgo.api_id, pgo.game_type
    LOOP

      --重新初始化变量
      n_api_id       = rec_api.api_id;
      v_game_type     = rec_api.game_type;
      n_effective_transaction   = rec_api.effective_transaction;
      n_profit_amount   = rec_api.profit_amount;

      n_grad_api_id = NULL;
      n_rakeback_ratio = 0.00;

      n_rakeback_value = 0.00;

      IF b_meet_or_not THEN
        --取得返水比率
        SELECT rga.id AS grads_api_id, --返水梯度API比率ID
               rga.ratio --API返水比例
          FROM rakeback_grads_api rga
         WHERE rga.rakeback_grads_id = n_grad_id --rec_grad.grads_id
           AND rga.api_id = n_api_id
           AND rga.game_type = v_game_type
         LIMIT 1
          --INTO rec_grad_api;
          INTO n_grad_api_id, n_rakeback_ratio;
      END IF;

      IF b_meet_or_not THEN
        --计算返水
        n_rakeback_value := n_effective_transaction * n_rakeback_ratio/100;
      END IF;

      --返水不能超过返水上限
      --IF n_rakeback_value > rec_grad.max_rakeback THEN
      --  n_rakeback_value = rec_grad.max_rakeback;
      --END IF;

      --v1.01  2016/01/22  Leisure
      IF n_rakeback_value > 0 THEN

        INSERT INTO rakeback_api_base (
            top_agent_id, agent_id, player_id, api_id, game_type,
            effective_transaction, profit_loss, rakeback, rakeback_time
        )
        VALUES (
            rec_player.topagent_id, rec_player.agent_id, rec_player.player_id, rec_api.api_id, rec_api.game_type,
            rec_api.effective_transaction, rec_api.profit_amount, n_rakeback_value, p_start_time
        );

      /*
      --写入API返水基础表
      INSERT INTO rakeback_api_base (
          settle_flag, rakeback_bill_id, agent_id, agent_name, api_id, game_type, effective_transaction, effective_player_num, profit_loss,
          operation_retio, operation_occupy, rakeback_set_id, rakeback_grads_id, rakeback_grads_api_id, rakeback_retio, rakeback_value)
      VALUES (
          p_settle_flag, p_bill_id, n_agent_id, v_agent_name, n_api_id, v_game_type, n_effective_transaction, n_effective_player_num, n_profit_amount,
          n_operation_occupy_retio, n_operation_occupy_value, n_rakeback_set_id, n_grad_id, n_grad_api_id, n_rakeback_ratio, n_rakeback_value
      );
      */

        RAISE INFO 'rakeback_api_base.新增.玩家 %, API %, GAME_TYPE %, .金额 %.', rec_player.player_id, rec_api.api_id, rec_api.game_type, n_rakeback_value;
      END IF;

    END LOOP;
  END LOOP;
END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_api_base(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-返水结算账单.API返水基础表';


DROP FUNCTION IF EXISTS gb_rakeback_player(INT, TEXT);
create or replace function gb_rakeback_player(
	p_bill_id 	INT,
	p_settle_flag 	TEXT
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/18  Leisure  创建此函数: 返水.玩家返水
*/
DECLARE

BEGIN

	IF p_settle_flag = 'Y' THEN--已出账

		INSERT INTO rakeback_player(
		    rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker,
		    rakeback_total, rakeback_actual, settlement_state, agent_id, top_agent_id, audit_num
		)
		SELECT p_bill_id, ut.id, ut.username, ut.rank_id, ut.rank_name, ut.risk_marker,
		       ra.rakeback, ra.rakeback, 'pending_lssuing', ut.agent_id, ut.topagent_id, ra.audit_num
		  FROM (
		        SELECT player_id,
		               CASE WHEN SUM(rakeback) > MIN(rakeback_limit) THEN MIN(rakeback_limit) ELSE SUM(rakeback) END rakeback, --顺序不能改，因为返水上限可能为NULL
		               MIN(audit_num) audit_num,
		               SUM(effective_transaction) effective_transaction
		          FROM rakeback_api
		         WHERE rakeback_bill_id = p_bill_id
		         GROUP BY player_id
		      ) ra,
		      v_sys_user_tier ut
		 WHERE ra.player_id = ut."id"
		 ORDER BY ra.rakeback DESC, ut.id;

	ELSEIF p_settle_flag = 'N' THEN--未出账

		INSERT INTO rakeback_player_nosettled (
		    rakeback_bill_nosettled_id, player_id, username, rank_id, rank_name, risk_marker,
		    rakeback_total, agent_id, top_agent_id, audit_num
		)
		SELECT p_bill_id, ut.id, ut.username, ut.rank_id, ut.rank_name, ut.risk_marker,
		       ra.rakeback, ut.agent_id, ut.topagent_id, ra.audit_num
		  FROM (
		        SELECT player_id,
		               CASE WHEN SUM(rakeback) > MIN(rakeback_limit) THEN MIN(rakeback_limit) ELSE SUM(rakeback) END rakeback, --顺序不能改，因为返水上限可能为NULL
		               MIN(audit_num) audit_num,
		               SUM(effective_transaction) effective_transaction
		          FROM rakeback_api_nosettled
		         WHERE rakeback_bill_nosettled_id = p_bill_id
		         GROUP BY player_id
		       ) ra,
		       v_sys_user_tier ut,
		       user_player up
		 WHERE ra.player_id = ut.id
		   AND ra.player_id = up."id"
		 ORDER BY ra.rakeback DESC, ut.id;

	END IF;

END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_player(p_bill_id INT, p_settle_flag TEXT)
IS 'Leisure-返水.玩家返水';


DROP FUNCTION IF EXISTS gb_rebate_agent_api(INT, TEXT, TIMESTAMP, TIMESTAMP, hstore[]);
CREATE OR REPLACE FUNCTION gb_rebate_agent_api(
	p_bill_id		INT,
	p_settle_flag 	TEXT,
	p_start_time		TIMESTAMP,
	p_end_time		TIMESTAMP,
	p_net_maps		hstore[]
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单.代理API返佣
--v1.01  2016/10/15  Leisure  对于不返佣的情况，依然计算其交易额和盈亏
--v1.02  2016/10/17  Leisure  改用变量代替record，并增加初始化操作
--v1.03  2016/10/25  Leisure  修正梯度判断，由“>”改为“>=”
--v1.04  2017/01/15  Leisure  修正一处bug，原来代理名称可能显示错误
*/
DECLARE

	h_occupy_map 	hstore;		-- API占成梯度map
	--h_assume_map 	hstore;		-- 盈亏共担map

	--h_sys_config 	hstore;
	--sp 			TEXT:='@';
	--rs 			TEXT:='\~';
	--cs 			TEXT:='\^';
	b_meet_or_not 	BOOLEAN; --是否达到返佣条件

	n_rebate_set_id 	INT;
	v_rebate_set_name 	TEXT:='';
	n_valid_value 		FLOAT:=0.00;

	v_key_name 				TEXT:='';
	COL_SPLIT 			TEXT:='_';

	rec_agt 	record;
	rec_api 	record;
	--rec_grad 	record;
	n_grad_id 	INT;
	--rec_grad_api 	record;
	n_grad_api_id 	INT;
	n_rebate_ratio 	FLOAT := 0.00;

	n_agent_id 	INT;
	v_agent_name 	TEXT;
	--n_topagent_id  INT;
	n_api_id 		INT;
	v_game_type 	TEXT;

	n_profit_amount 			FLOAT:=0.00;--盈亏总和
	n_effective_transaction 	FLOAT:=0.00;--有效交易量

	n_row_count 	INT :=0;
	n_effective_player_num INT :=0;

	n_operation_occupy_retio FLOAT:=0.00;--运营商占成比例
	n_operation_occupy_value 	FLOAT:=0.00;--运营商API占成金额
	n_rebate_value 	FLOAT:=0.00;--代理API返佣金额

BEGIN
	--取得系统变量
	--SELECT sys_config() INTO h_sys_config;
	--sp = h_sys_config->'sp_split';
	--rs = h_sys_config->'row_split';
	--cs = h_sys_config->'col_split';

	--取得运营商占成、盈亏共担map
	h_occupy_map = p_net_maps[2];
	--h_assume_map = p_net_maps[3];

	--代理循环
	FOR rec_agt IN
		SELECT ua."id"									as agent_id,
		       ua.username							as agent_name,
		       --ut."id"									as topagent_id,
		       --ut.username							as topagent_name,
		       COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
		       COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount
		    FROM player_game_order pgo
		    LEFT JOIN sys_user su ON pgo.player_id = su."id"
		    LEFT JOIN sys_user ua ON su.owner_id = ua.id
		    --LEFT JOIN sys_user ut ON ua.owner_id = ut.id
		 WHERE pgo.order_state = 'settle'
		   AND pgo.is_profit_loss = TRUE
		   AND pgo.payout_time >= p_start_time
		   AND pgo.payout_time < p_end_time
		   AND su.user_type = '24'
		   AND ua.user_type = '23'
		   --AND ut.user_type = '22'
		 GROUP BY ua."id", ua.username
		 ORDER BY ua."id"
	LOOP
		--重新初始化变量
		b_meet_or_not = TRUE;
		n_agent_id = rec_agt.agent_id;
		v_agent_name = rec_agt.agent_name; --v_agent_name; --v1.04  2017/01/15  Leisure
		--n_topagent_id = rec_agt.topagent_id;
		n_effective_transaction = rec_agt.effective_transaction;
		n_profit_amount = rec_agt.profit_amount;

		/*
		IF n_profit_amount <= 0 THEN
			RAISE INFO '代理ID: %, 名称: % ，盈利为负，不返佣！', n_agent_id, v_agent_name;
			--v1.01  2016/10/15  Leisure
			--CONTINUE;
		END IF;
		*/

		--取得代理返佣方案
		SELECT ua.rebate_id, rs.name, rs.valid_value
		  INTO n_rebate_set_id, v_rebate_set_name, n_valid_value
		  FROM user_agent_rebate ua, rebate_set rs
		 WHERE ua.user_id = n_agent_id
		   AND rs.status = '1'
		   AND rs.id = ua.rebate_id;

		GET DIAGNOSTICS n_row_count = ROW_COUNT;
		IF n_row_count = 0 THEN
			RAISE INFO '代理ID: %, 名称: %，未设置返佣方案！', n_agent_id, v_agent_name;
			--v1.01  2016/10/15  Leisure
			--CONTINUE;
			b_meet_or_not = FALSE;
		ELSE
			--计算梯度有效玩家数
			SELECT gamebox_valid_player_num(p_start_time, p_end_time, n_agent_id, n_valid_value) INTO n_effective_player_num;

			IF n_effective_transaction < n_valid_value THEN
				RAISE INFO '代理ID: % 名称: %, 有效交易量: % ；返佣方案ID: %, 名称: %, 有效交易量: % ，未达到有效交易量！',
				           n_agent_id, v_agent_name, n_effective_transaction,
				           n_rebate_set_id, v_rebate_set_name, n_valid_value;
				--v1.01  2016/10/15  Leisure
				--CONTINUE;
				b_meet_or_not = FALSE;
			ELSE
				--取得返佣梯度
				SELECT rg.id AS grads_id   --返佣梯度ID
				       --rg.total_profit,     --有效盈利总额
				       --rg.max_rebate,       --返佣上限
				       --rg.valid_player_num  --有效玩家数
				  FROM rebate_grads 	rg
				 WHERE rg.rebate_id = n_rebate_set_id
				   --v10.3  2016/10/25  Leisure
				   AND n_profit_amount >= rg.total_profit --实际盈亏 >= 梯度盈亏
				   AND n_effective_player_num >= rg.valid_player_num --有效玩家数 >= 梯度玩家数
				 ORDER BY rg.total_profit DESC, rg.valid_player_num DESC
				 LIMIT 1
				  --INTO rec_grad;
				  INTO n_grad_id;

				GET DIAGNOSTICS n_row_count = ROW_COUNT;
				IF n_row_count = 0 THEN
					RAISE INFO '代理ID: %, 名称: %, 返佣方案ID: %, 名称: %, 未达到返佣梯度！',
					           n_agent_id, v_agent_name, n_rebate_set_id, v_rebate_set_name;
					--v1.01  2016/10/15  Leisure
					--CONTINUE;
					b_meet_or_not = FALSE;
				END IF; --返佣梯度
			END IF; --有效交易量
		END IF; --返佣方案

		--代理api循环
		FOR rec_api IN
			SELECT pgo.api_id,
			       pgo.game_type,
			       COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
			       COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount
			    FROM player_game_order pgo
			    LEFT JOIN sys_user su ON pgo.player_id = su."id"
			    LEFT JOIN sys_user ua ON su.owner_id = ua.id
			 WHERE pgo.order_state = 'settle'
			   AND pgo.is_profit_loss = TRUE
			   AND pgo.payout_time >= p_start_time
			   AND pgo.payout_time < p_end_time
			   AND su.user_type = '24'
			   AND ua.user_type = '23'
			   AND ua."id" = n_agent_id
			 GROUP BY pgo.api_id, pgo.game_type
			 ORDER BY pgo.api_id, pgo.game_type
		LOOP

			--重新初始化变量
			n_api_id 			= rec_api.api_id;
			v_game_type 		= rec_api.game_type;
			n_effective_transaction 	= rec_api.effective_transaction;
			n_profit_amount 	= rec_api.profit_amount;

			n_grad_api_id = NULL;
			n_rebate_ratio = 0.00;

			n_operation_occupy_retio = 0.00;
			n_operation_occupy_value = 0.00;
			n_rebate_value = 0.00;

			IF b_meet_or_not THEN
				--取得返佣比率
				SELECT rga.id AS grads_api_id, --返佣梯度API比率ID
				       rga.ratio 				--API返佣比例
				  FROM rebate_grads_api rga
				 WHERE rga.rebate_grads_id = n_grad_id --rec_grad.grads_id
				   AND rga.api_id = n_api_id
				   AND rga.game_type = v_game_type
				 LIMIT 1
				  --INTO rec_grad_api;
				  INTO n_grad_api_id, n_rebate_ratio;
			END IF;

			IF n_profit_amount <= 0 THEN
				RAISE INFO '代理ID: %, 名称: %, API_ID: %, GAME_TYPE: %, 盈利为负，不返佣！', n_agent_id, v_agent_name, n_api_id, v_game_type;
				--v1.01  2016/10/15  Leisure
				--CONTINUE;
			ELSE
				--计算运营商占成
				v_key_name = n_api_id||COL_SPLIT||v_game_type;
				IF isexists(h_occupy_map, v_key_name) THEN
					n_operation_occupy_retio = (h_occupy_map->v_key_name)::float;
					n_operation_occupy_value = n_profit_amount * n_operation_occupy_retio/100;
				ELSE
					n_operation_occupy_value = 0.00;
				END IF; --是否存在占成比

				IF b_meet_or_not THEN
					--计算佣金
					n_rebate_value := n_profit_amount * (1 - n_operation_occupy_retio/100) * n_rebate_ratio/100;
				END IF;
			END IF; --盈利是否为正

			--返佣不能超过返佣上限
			--IF n_rebate_value > rec_grad.max_rebate THEN
			--	n_rebate_value = rec_grad.max_rebate;
			--END IF;

			--写入代理API佣金表
			INSERT INTO rebate_agent_api(
			    settle_flag, rebate_bill_id, agent_id, agent_name, api_id, game_type, effective_transaction, effective_player_num, profit_loss,
			    operation_retio, operation_occupy, rebate_set_id, rebate_grads_id, rebate_grads_api_id, rebate_retio, rebate_value)
			VALUES (
			    p_settle_flag, p_bill_id, n_agent_id, v_agent_name, n_api_id, v_game_type, n_effective_transaction, n_effective_player_num, n_profit_amount,
			    n_operation_occupy_retio, n_operation_occupy_value, n_rebate_set_id, n_grad_id, n_grad_api_id, n_rebate_ratio, n_rebate_value
			);

		END LOOP;
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent_api(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_net_maps hstore[])
IS 'Leisure-返佣结算账单.代理API返佣';

select redo_sqls($$
	ALTER TABLE rebate_agent ADD COLUMN rebate_original NUMERIC(20, 2);
	ALTER TABLE rebate_agent_nosettled ADD COLUMN rebate_original NUMERIC(20, 2);
$$);

COMMENT ON COLUMN rebate_agent.rebate_original IS '原始佣金（占成佣金）';

COMMENT ON COLUMN rebate_agent_nosettled.rebate_original IS '原始佣金（占成佣金）';

drop function if exists gb_rebate_agent(INT, TEXT, TIMESTAMP, TIMESTAMP);
create or replace function gb_rebate_agent(
  p_bill_id   INT,
  p_settle_flag   TEXT,
  p_start_time    TIMESTAMP,
  p_end_time    TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单-代理返佣
--v1.00  2016/10/15  Leisure  更新分摊费用计算
--v1.01  2016/11/01  Leisure  美化SQL
--v1.02  2017/02/11  Leisure  增加原始佣金（占成佣金）写入
--v1.03  2017/02/12  Leisure  调整上期未结计算SQL，旧的SQL对于历史期返佣这种非常规操作，有隐患；
                              并且如果计算完结算账单，再计算未结账单，可能存在同样问题
*/
DECLARE
  rec   record;
  c_agent_name   TEXT := '';
  c_pending_state   TEXT := 'pending_lssuing';
  n_rebate_original     FLOAT := 0.00;  -- 代理返佣（原始佣金）
  n_max_rebate  FLOAT := 0.00;  -- 返佣上限
  n_rebate_final  FLOAT := 0.00;  -- 最终佣金（佣金+上期未结-分摊费用）
  --n_player_num  INT := 0;   --有效玩家数
  n_next_lssuing   FLOAT := 0.00; --未结算佣金（往期未结）

  h_sys_apportion hstore;  --分摊比例配置信息

  n_agent_retio float := 0.00; --代理分摊比率
  n_favorable_apportion   float:=0.00;-- 优惠分摊费用
  n_recommend_apportion   float:=0.00;-- 推荐分摊费用
  n_backwater_apportion   float:=0.00;-- 返水分摊费用
  n_refund_fee_apportion   float:=0.00;-- 返手续费分摊费用
  n_apportion float:=0.00; --代理分摊总费用

BEGIN

  SELECT gamebox_sys_param('apportionSetting') INTO h_sys_apportion;

  FOR rec IN

    WITH raa AS (
      SELECT agent_id,
             MIN(rebate_grads_id) rebate_grads_id,
             SUM(effective_transaction) effective_transaction,
             MIN(effective_player_num) effective_player_num,
             SUM(profit_loss) profit_loss,
             SUM(rebate_value) rebate
        FROM rebate_agent_api
       WHERE rebate_bill_id = p_bill_id
         AND settle_flag = p_settle_flag
       GROUP BY agent_id
    ),

    pt AS (
      SELECT *
        FROM player_transaction
       WHERE status = 'success'
         AND completion_time >= p_start_time
         AND completion_time < p_end_time
    ),

    pti AS (
            --存款
             SELECT player_id,
                    'deposit' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE transaction_type = 'deposit'
                --AND (fund_type <> 'artificial_deposit' OR transaction_way = 'manual_deposit')

             UNION ALL
             --取款
             SELECT player_id,
                    'withdrawal' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE transaction_type = 'withdrawals'
                --AND (fund_type <> 'artificial_withdraw' OR transaction_way = 'manual_deposit')

             UNION ALL
             --优惠
             SELECT player_id,
                    'favorable' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE (transaction_type = 'favorable'
                     AND fund_type <> 'refund_fee'
                     AND transaction_way <> 'manual_rakeback')

             UNION ALL
             --推荐
             SELECT player_id,
                    'recommend' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE transaction_type = 'recommend'

             UNION ALL
             --返水
             SELECT player_id,
                    'backwater' AS transaction_type,
                    transaction_money
               FROM pt
              WHERE (transaction_type = 'backwater' OR
                     (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))

             UNION ALL
             --返手续费
             SELECT player_id,
                    'refund_fee' transaction_type,
                    transaction_money
               FROM pt
              WHERE fund_type = 'refund_fee'
            ),

    pto AS (
      SELECT ua."id" AS agent_id,
             transaction_type,
             transaction_money
        FROM pti
             LEFT JOIN
             sys_user su ON pti.player_id = su."id" AND su.user_type = '24'
             LEFT JOIN
             sys_user ua ON su.owner_id = ua."id" AND ua.user_type = '23'
    ),

    ptt AS (
      SELECT agent_id,
             SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit,
             SUM(CASE transaction_type WHEN 'withdrawal' THEN transaction_money ELSE 0 END) AS withdrawal,
             SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money ELSE 0 END) AS favorable,
             SUM(CASE transaction_type WHEN 'recommend' THEN transaction_money ELSE 0 END) AS recommend,
             SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS backwater,
             SUM(CASE transaction_type WHEN 'refund_fee' THEN transaction_money ELSE 0 END) AS refund_fee
        FROM pto
       GROUP BY agent_id
    )

    SELECT COALESCE(raa.agent_id, ptt.agent_id) agent_id,
           raa.rebate_grads_id,
           COALESCE(effective_transaction, 0.00) effective_transaction,
           COALESCE(effective_player_num, 0) effective_player_num,
           COALESCE(profit_loss, 0) profit_loss,
           COALESCE(rebate, 0.00) rebate,
           COALESCE(deposit, 0.00) deposit,
           COALESCE(withdrawal, 0.00) withdrawal,
           COALESCE(favorable, 0.00) favorable,
           COALESCE(recommend, 0.00) recommend,
           COALESCE(backwater, 0.00) backwater,
           COALESCE(refund_fee, 0.00) refund_fee
      FROM raa FULL JOIN ptt ON raa.agent_id = ptt.agent_id
     ORDER BY agent_id
  LOOP

    --在循环内部，需要初始化变量
    n_rebate_original = rec.rebate;
    n_max_rebate = 0.00;
    n_next_lssuing = 0.00;

    n_favorable_apportion = 0.00;-- 优惠分摊费用
    n_recommend_apportion = 0.00;-- 推荐分摊费用
    n_backwater_apportion = 0.00;-- 返水分摊费用
    n_refund_fee_apportion = 0.00;-- 返手续费分摊费用

    --获取代理名称
    SELECT username INTO c_agent_name FROM sys_user su WHERE su.user_type = '23' AND su.id = rec.agent_id;

    --获取分摊费用
    --优惠、推荐
    IF isexists(h_sys_apportion, 'agent.preferential.percent') THEN
      n_agent_retio = (h_sys_apportion->'agent.preferential.percent')::float;  --代理分摊比例
      n_favorable_apportion = rec.favorable * n_agent_retio/100;
      n_recommend_apportion = rec.recommend * n_agent_retio/100;
    END IF;
    --返水
    IF isexists(h_sys_apportion, 'agent.rakeback.percent') THEN
      n_agent_retio = (h_sys_apportion->'agent.rakeback.percent')::float;  --代理分摊比例
      n_backwater_apportion = rec.backwater * n_agent_retio/100;
    END IF;
    --返手续费
    IF isexists(h_sys_apportion, 'agent.poundage.percent') THEN
      n_agent_retio = (h_sys_apportion->'agent.poundage.percent')::float;  --代理分摊比例
      n_refund_fee_apportion = rec.refund_fee * n_agent_retio/100;
    END IF;

    n_apportion = n_favorable_apportion + n_recommend_apportion + n_backwater_apportion + n_refund_fee_apportion;

    --如果代理本期完成返佣梯度
    IF n_rebate_original > 0 THEN

      --获得返佣上限
      SELECT max_rebate
        FROM rebate_grads
       WHERE id = rec.rebate_grads_id
        INTO n_max_rebate;

      IF n_max_rebate > 0 AND n_rebate_original > n_max_rebate THEN
        n_rebate_original = n_max_rebate;
      END IF;

      c_pending_state :='pending_lssuing';

      --如果本期满足返佣梯度，需要结算往期费用
      --v1.03  2017/02/12  Leisure
      /*
      SELECT COALESCE(SUM(rebate_actual), 0.00)
        INTO n_next_lssuing
        FROM rebate_agent rao
       WHERE rao.settlement_state = 'next_lssuing'
         AND rao.agent_id = rec.agent_id
         --AND rao.rebate_bill_id <= bill_id
         AND rao.rebate_bill_id >
           (SELECT COALESCE(MAX(rebate_bill_id), 0)
              FROM rebate_agent rai
             WHERE rai.settlement_state <> 'next_lssuing'
               AND rai.agent_id = rec.agent_id
               --AND rai.rebate_bill_id < bill_id
           );
      */

      SELECT COALESCE(SUM(rao.rebate_actual), 0.00)
        INTO n_next_lssuing
        FROM rebate_agent rao, rebate_bill rbo
       WHERE rao.rebate_bill_id = rbo.id
         AND rao.settlement_state = 'next_lssuing'
         AND rao.agent_id = rec.agent_id
         AND rbo.end_time <= p_start_time
         AND rbo.start_time >=
           (SELECT COALESCE(MAX(end_time), '1879-03-14')
              FROM rebate_agent rai, rebate_bill rbi
             WHERE rai.rebate_bill_id = rbi.id
               AND rai.settlement_state <> 'next_lssuing'
               AND rbi.end_time <= p_start_time
               AND rai.agent_id = rec.agent_id
           );

    ELSE
      c_pending_state := 'next_lssuing';
    END IF;

    n_rebate_final := n_rebate_original + n_next_lssuing - n_apportion;
    --RAISE INFO 'n_rebate_final: % n_rebate_original: % n_next_lssuing: % n_apportion: %', n_rebate_final, n_rebate_original, n_next_lssuing, n_apportion;

    IF p_settle_flag = 'Y' THEN

      INSERT INTO rebate_agent(
        rebate_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
        rakeback, rebate_total, rebate_actual, refund_fee, recommend, preferential_value, settlement_state,
        apportion, deposit_amount, withdrawal_amount, history_apportion, rebate_original
      ) VALUES (
        p_bill_id, rec.agent_id, c_agent_name, rec.effective_player_num, rec.effective_transaction, rec.profit_loss,
        rec.backwater, n_rebate_final, n_rebate_final, rec.refund_fee, rec.recommend, rec.favorable, c_pending_state,
        --rec.backwater + rec.refund_fee + rec.recommend + rec.favorable,
        n_apportion,
        rec.deposit, rec.withdrawal, n_next_lssuing, n_rebate_original --v1.02  2017/02/11  Leisure
      );
    ELSEIF p_settle_flag='N' THEN

      INSERT INTO rebate_agent_nosettled (
        rebate_bill_nosettled_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,
        rakeback, rebate_total, refund_fee, recommend, preferential_value,
        apportion, deposit_amount, withdrawal_amount, history_apportion, rebate_original
      ) VALUES (
        p_bill_id, rec.agent_id, c_agent_name, rec.effective_player_num, rec.effective_transaction, rec.profit_loss,
        rec.backwater, n_rebate_final, rec.refund_fee, rec.recommend, rec.favorable,
        --rec.backwater + rec.refund_fee + rec.recommend + rec.favorable,
        n_apportion,
        rec.deposit, rec.withdrawal, n_next_lssuing, n_rebate_original --v1.02  2017/02/11  Leisure
      );

    END IF;

  END LOOP;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-返佣结算账单-代理返佣';


DROP FUNCTION IF EXISTS gb_rebate_agent_api(INT, TEXT, TIMESTAMP, TIMESTAMP, hstore[]);
CREATE OR REPLACE FUNCTION gb_rebate_agent_api(
	p_bill_id 	INT,
	p_settle_flag 	TEXT,
	p_start_time 	TIMESTAMP,
	p_end_time 	TIMESTAMP,
	p_net_maps 	hstore[]
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单.代理API返佣
--v1.01  2016/10/15  Leisure  对于不返佣的情况，依然计算其交易额和盈亏
--v1.02  2016/10/17  Leisure  改用变量代替record，并增加初始化操作
--v1.03  2016/10/25  Leisure  修正梯度判断，由“>”改为“>=”
--v1.04  2017/01/15  Leisure  修正一处bug，原来代理名称可能显示错误
--v1.05  2017/01/30  Leisure  修改返佣逻辑，数据来源改为经营报表
*/
DECLARE

	h_occupy_map 	hstore;		-- API占成梯度map
	--h_assume_map 	hstore;		-- 盈亏共担map

	--h_sys_config 	hstore;
	--sp 			TEXT:='@';
	--rs 			TEXT:='\~';
	--cs 			TEXT:='\^';
	b_meet_or_not 	BOOLEAN; --是否达到返佣条件

	n_rebate_set_id 	INT;
	v_rebate_set_name 	TEXT:='';
	n_valid_value 		FLOAT:=0.00;

	v_key_name 				TEXT:='';
	COL_SPLIT 			TEXT:='_';

	--cur_agt 	refcursor;
	--cur_api 	refcursor;
	rec_agt 	record;
	rec_api 	record;
	--rec_grad 	record;
	n_grad_id 	INT;
	--rec_grad_api 	record;
	n_grad_api_id 	INT;
	n_rebate_ratio 	FLOAT := 0.00;

	n_agent_id 	INT;
	v_agent_name 	TEXT;
	--n_topagent_id  INT;
	n_api_id 		INT;
	v_game_type 	TEXT;

	n_profit_amount 			FLOAT:=0.00;--盈亏总和
	n_effective_transaction 	FLOAT:=0.00;--有效交易量

	n_row_count 	INT :=0;
	n_effective_player_num INT :=0;

	n_operation_occupy_retio FLOAT:=0.00;--运营商占成比例
	n_operation_occupy_value 	FLOAT:=0.00;--运营商API占成金额
	n_rebate_value 	FLOAT:=0.00;--代理API返佣金额

BEGIN
	--取得系统变量
	--SELECT sys_config() INTO h_sys_config;
	--sp = h_sys_config->'sp_split';
	--rs = h_sys_config->'row_split';
	--cs = h_sys_config->'col_split';

	--取得运营商占成、盈亏共担map
	h_occupy_map = p_net_maps[2];
	--h_assume_map = p_net_maps[3];

	--代理循环
	/* --v1.05  2017/01/30
	FOR rec_agt IN
		SELECT ua."id"									as agent_id,
		       ua.username							as agent_name,
		       --ut."id"									as topagent_id,
		       --ut.username							as topagent_name,
		       COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
		       COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount
		    FROM player_game_order pgo
		    LEFT JOIN sys_user su ON pgo.player_id = su."id"
		    LEFT JOIN sys_user ua ON su.owner_id = ua.id
		    --LEFT JOIN sys_user ut ON ua.owner_id = ut.id
		 WHERE pgo.order_state = 'settle'
		   AND pgo.is_profit_loss = TRUE
		   AND pgo.payout_time >= p_start_time
		   AND pgo.payout_time < p_end_time
		   AND su.user_type = '24'
		   AND ua.user_type = '23'
		   --AND ut.user_type = '22'
		 GROUP BY ua."id", ua.username
		 ORDER BY ua."id"
	LOOP
	*/
	/*
	SELECT gb_rebate_agent_cursor(p_settle_flag, p_start_time, p_end_time) INTO cur_agt;
	FETCH cur_agt INTO rec_agt;
	WHILE FOUND
	LOOP
	*/
	FOR rec_agt IN
		SELECT agent_id, agent_name, SUM(effective_transaction) effective_transaction, -SUM(profit_loss) profit_amount
		  FROM operate_agent
		 WHERE static_time >= p_start_time
		   AND static_time_end <= p_end_time
		 GROUP BY agent_id, agent_name
		 ORDER BY agent_id, agent_name
	LOOP
		--重新初始化变量
		b_meet_or_not = TRUE;
		n_agent_id = rec_agt.agent_id;
		v_agent_name = rec_agt.agent_name; --v_agent_name; --v1.04  2017/01/15  Leisure
		--n_topagent_id = rec_agt.topagent_id;
		n_effective_transaction = rec_agt.effective_transaction;
		n_profit_amount = rec_agt.profit_amount;

		/*
		IF n_profit_amount <= 0 THEN
			RAISE INFO '代理ID: %, 名称: % ，盈利为负，不返佣！', n_agent_id, v_agent_name;
			--v1.01  2016/10/15  Leisure
			--CONTINUE;
		END IF;
		*/

		--取得代理返佣方案
		SELECT ua.rebate_id, rs.name, rs.valid_value
		  INTO n_rebate_set_id, v_rebate_set_name, n_valid_value
		  FROM user_agent_rebate ua, rebate_set rs
		 WHERE ua.user_id = n_agent_id
		   AND rs.status = '1'
		   AND rs.id = ua.rebate_id;

		GET DIAGNOSTICS n_row_count = ROW_COUNT;
		IF n_row_count = 0 THEN
			RAISE INFO '代理ID: %, 名称: %，未设置返佣方案！', n_agent_id, v_agent_name;
			--v1.01  2016/10/15  Leisure
			--CONTINUE;
			b_meet_or_not = FALSE;
		ELSE
			--计算梯度有效玩家数
			--v1.05  2017/01/30
			--SELECT gamebox_valid_player_num(p_start_time, p_end_time, n_agent_id, n_valid_value) INTO n_effective_player_num;
			SELECT gb_valid_player_num(p_start_time, p_end_time, n_agent_id, n_valid_value) INTO n_effective_player_num;

			IF n_effective_transaction < n_valid_value THEN
				RAISE INFO '代理ID: % 名称: %, 有效交易量: % ；返佣方案ID: %, 名称: %, 有效交易量: % ，未达到有效交易量！',
				           n_agent_id, v_agent_name, n_effective_transaction,
				           n_rebate_set_id, v_rebate_set_name, n_valid_value;
				--v1.01  2016/10/15  Leisure
				--CONTINUE;
				b_meet_or_not = FALSE;
			ELSE
				--取得返佣梯度
				SELECT rg.id AS grads_id   --返佣梯度ID
				       --rg.total_profit,     --有效盈利总额
				       --rg.max_rebate,       --返佣上限
				       --rg.valid_player_num  --有效玩家数
				  FROM rebate_grads 	rg
				 WHERE rg.rebate_id = n_rebate_set_id
				   --v10.3  2016/10/25  Leisure
				   AND n_profit_amount >= rg.total_profit --实际盈亏 >= 梯度盈亏
				   AND n_effective_player_num >= rg.valid_player_num --有效玩家数 >= 梯度玩家数
				 ORDER BY rg.total_profit DESC, rg.valid_player_num DESC
				 LIMIT 1
				  --INTO rec_grad;
				  INTO n_grad_id;

				GET DIAGNOSTICS n_row_count = ROW_COUNT;
				IF n_row_count = 0 THEN
					RAISE INFO '代理ID: %, 名称: %, 返佣方案ID: %, 名称: %, 未达到返佣梯度！',
					           n_agent_id, v_agent_name, n_rebate_set_id, v_rebate_set_name;
					--v1.01  2016/10/15  Leisure
					--CONTINUE;
					b_meet_or_not = FALSE;
				END IF; --返佣梯度
			END IF; --有效交易量
		END IF; --返佣方案

		--代理api循环
		/* --v1.05  2017/01/30
		FOR rec_api IN
			SELECT pgo.api_id,
			       pgo.game_type,
			       COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
			       COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount
			    FROM player_game_order pgo
			    LEFT JOIN sys_user su ON pgo.player_id = su."id"
			    LEFT JOIN sys_user ua ON su.owner_id = ua.id
			 WHERE pgo.order_state = 'settle'
			   AND pgo.is_profit_loss = TRUE
			   AND pgo.payout_time >= p_start_time
			   AND pgo.payout_time < p_end_time
			   AND su.user_type = '24'
			   AND ua.user_type = '23'
			   AND ua."id" = n_agent_id
			 GROUP BY pgo.api_id, pgo.game_type
			 ORDER BY pgo.api_id, pgo.game_type
		LOOP
		*/
		/*
		SELECT gb_rebate_api_cursor(p_settle_flag, n_agent_id, p_start_time, p_end_time) INTO cur_api;
		FETCH cur_api INTO rec_api;
		WHILE FOUND
		LOOP
		*/
		FOR rec_api IN
			SELECT api_id, game_type, SUM(effective_transaction) effective_transaction, -SUM(profit_loss) profit_amount
			  FROM operate_agent
			 WHERE static_time >= p_start_time
			   AND static_time_end <= p_end_time
			   AND agent_id = n_agent_id
			 GROUP BY api_id, game_type
			 ORDER BY api_id, game_type
		LOOP

			--重新初始化变量
			n_api_id 			= rec_api.api_id;
			v_game_type 		= rec_api.game_type;
			n_effective_transaction 	= rec_api.effective_transaction;
			n_profit_amount 	= rec_api.profit_amount;

			n_grad_api_id = NULL;
			n_rebate_ratio = 0.00;

			n_operation_occupy_retio = 0.00;
			n_operation_occupy_value = 0.00;
			n_rebate_value = 0.00;

			IF b_meet_or_not THEN
				--取得返佣比率
				SELECT rga.id AS grads_api_id, --返佣梯度API比率ID
				       rga.ratio --API返佣比例
				  FROM rebate_grads_api rga
				 WHERE rga.rebate_grads_id = n_grad_id --rec_grad.grads_id
				   AND rga.api_id = n_api_id
				   AND rga.game_type = v_game_type
				 LIMIT 1
				  --INTO rec_grad_api;
				  INTO n_grad_api_id, n_rebate_ratio;
			END IF;

			IF n_profit_amount <= 0 THEN
				RAISE INFO '代理ID: %, 名称: %, API_ID: %, GAME_TYPE: %, 盈利为负，不返佣！', n_agent_id, v_agent_name, n_api_id, v_game_type;
				--v1.01  2016/10/15  Leisure
				--CONTINUE;
			ELSE
				--计算运营商占成
				v_key_name = n_api_id||COL_SPLIT||v_game_type;
				IF isexists(h_occupy_map, v_key_name) THEN
					n_operation_occupy_retio = (h_occupy_map->v_key_name)::float;
					n_operation_occupy_value = n_profit_amount * n_operation_occupy_retio/100;
				ELSE
					n_operation_occupy_value = 0.00;
				END IF; --是否存在占成比

				IF b_meet_or_not THEN
					--计算佣金
					n_rebate_value := n_profit_amount * (1 - n_operation_occupy_retio/100) * n_rebate_ratio/100;
				END IF;
			END IF; --盈利是否为正

			--返佣不能超过返佣上限
			--IF n_rebate_value > rec_grad.max_rebate THEN
			--	n_rebate_value = rec_grad.max_rebate;
			--END IF;

			--写入代理API佣金表
			INSERT INTO rebate_agent_api(
			    settle_flag, rebate_bill_id, agent_id, agent_name, api_id, game_type, effective_transaction, effective_player_num, profit_loss,
			    operation_retio, operation_occupy, rebate_set_id, rebate_grads_id, rebate_grads_api_id, rebate_retio, rebate_value)
			VALUES (
			    p_settle_flag, p_bill_id, n_agent_id, v_agent_name, n_api_id, v_game_type, n_effective_transaction, n_effective_player_num, n_profit_amount,
			    n_operation_occupy_retio, n_operation_occupy_value, n_rebate_set_id, n_grad_id, n_grad_api_id, n_rebate_ratio, n_rebate_value
			);

		END LOOP;
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent_api(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_net_maps hstore[])
IS 'Leisure-返佣结算账单.代理API返佣';


drop function if exists gb_rebate_bill(text, text, text, text, text);
create or replace function gb_rebate_bill(
	p_period 	text,
	p_start_time 	text,
	p_end_time 	text,
	p_comp_url 	text,
	p_settle_flag 	text
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/10/08  Leisure   创建此函数: 返佣结算账单-入口
*/
DECLARE

	t_start_time 	TIMESTAMP;
	t_end_time 	TIMESTAMP;

	n_rebate_bill_id INT:=-1; --返佣主表键值.
	n_bill_count 	INT :=0;

	n_sid 			INT;--站点ID.
	b_is_max 		BOOLEAN := true;
	h_net_schema_map 	hstore[];-- 包网方案map

	redo_status BOOLEAN:=false; --重跑标志，默认不允许重跑

BEGIN
	t_start_time = p_start_time::TIMESTAMP;
	t_end_time = p_end_time::TIMESTAMP;

	IF p_settle_flag = 'Y' THEN
		SELECT COUNT("id")
		 INTO n_bill_count
			FROM rebate_bill rb
		 WHERE rb.period = p_period
			 AND rb."start_time" = t_start_time
			 AND rb."end_time" = t_end_time
			 AND rb.lssuing_state <> 'pending_pay';

		IF n_bill_count = 0 THEN
			--DELETE FROM rebate_api ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			--DELETE FROM rebate_player rp WHERE rp.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rebate_agent_api ra WHERE settle_flag = 'Y' AND ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rebate_agent ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
			DELETE FROM rebate_bill rb WHERE "id" IN (SELECT "id" FROM rebate_bill WHERE period = p_period AND "start_time" = t_start_time AND "end_time" = t_end_time);
		ELSE
			raise info '已生成本期返佣账单，无需重新生成。';
			RETURN;
		END IF;
	END IF;

	raise info '开始统计第( % )期的返佣,周期( % - % )', p_period, p_start_time, p_end_time;

	--先插入返佣总记录并取得键值.
	raise info '返佣rebate_bill新增记录';
	SELECT gamebox_rebate_bill(p_period, t_start_time, t_end_time, n_rebate_bill_id, 'I', p_settle_flag) INTO n_rebate_bill_id;

	SELECT gamebox_current_site() INTO n_sid;

	raise info '取得包网方案';
	SELECT * FROM dblink(p_comp_url, 'SELECT gamebox_contract('||n_sid||', '||b_is_max||')') as a(hash hstore[]) INTO h_net_schema_map;

	raise info '统计代理API返佣信息';
	perform gb_rebate_agent_api(n_rebate_bill_id, p_settle_flag, t_start_time, t_end_time, h_net_schema_map);

	raise info '统计代理返佣';
	perform gb_rebate_agent(n_rebate_bill_id, p_settle_flag, t_start_time, t_end_time);

	raise info '更新返佣总表';
	perform gamebox_rebate_bill(p_period, t_start_time, t_end_time, n_rebate_bill_id, 'U', p_settle_flag);

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_bill(p_period text, p_start_time text, p_end_time text, p_comp_url text, p_settle_flag text)
IS 'Leisure-返佣结算账单-入口';


drop function if exists gb_valid_player_num(TIMESTAMP, TIMESTAMP, INT, FLOAT);
create or replace function gb_valid_player_num(
	p_start_time 	TIMESTAMP,
	p_end_time 	TIMESTAMP,
	p_agent_id 	INT,
	p_valid_value 	FLOAT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Leisure  创建此函数: 计算有效玩家数
*/
DECLARE
	player_num 	INT:=0;

BEGIN
	/*
	SELECT COUNT(1)
	  FROM (SELECT player_id, SUM(effective_trade_amount) effeTa
	         FROM player_game_order pgo LEFT JOIN sys_user su ON player_id = su."id"
	        WHERE order_state = 'settle'
	          AND is_profit_loss = TRUE
	          --v1.03  2016/10/03  Leisure
	          --AND create_time >= start_time
	          --AND create_time < end_time
	          AND payout_time >= start_time
	          AND payout_time < end_time
	          AND su.owner_id = agent_id
	        GROUP BY player_id) pn
	 WHERE pn.effeTa >= valid_value
	  INTO player_num;
	*/
	SELECT COUNT(1)
	  FROM (SELECT player_id, SUM(effective_transaction) effective_transaction
	         FROM operate_player
	        WHERE static_time >= p_start_time
	          AND static_time_end <= p_end_time
	          AND agent_id = p_agent_id
	        GROUP BY player_id) pn
	 WHERE pn.effective_transaction >= p_valid_value
	  INTO player_num;
	RETURN player_num;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_valid_player_num(p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_agent_id INT, p_valid_value FLOAT)
IS 'Leisure-计算有效玩家数';

drop function IF EXISTS gamebox_operations_player(TEXT, TEXT, TEXT, JSON);
create or replace function gamebox_operations_player(
	start_time 	TEXT,
	end_time 	TEXT,
	curday 		TEXT,
	rec 		JSON
) returns text as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 经营报表-玩家报表
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/05/31  Leisure  统计日期由current_date，改为参数获取;
                              经营报表增加字段static_date统计日期
--v1.03  2016/06/13  Leisure  is_profit_loss=false的记录也需要统计by acheng
--v1.04  2016/06/27  Leisure  统计时间由bet_time改为payout_time --by acheng
--v1.05  2016/07/08  Leisure  优化输出日志
--v1.05  2016/10/05  Leisure  撤销v1.03的修改 by kitty
--v1.06  2017/02/05  Leisure  删除is_profit_loss = TRUE条件
*/
DECLARE
	rtn 		text:='';
	n_count		INT:=0;
	site_id 	INT;
	master_id 	INT;
	center_id 	INT;
	site_name 	TEXT:='';
	master_name TEXT:='';
	center_name TEXT:='';
	d_static_date DATE; --v1.02  2016/05/31
BEGIN
	--v1.02  2016/05/31  Leisure
	d_static_date := to_date(curday, 'YYYY-MM-DD');

	--清除当天的统计信息，保证每天只作一次统计信息
	rtn = rtn||'|清除当天的统计信息，保证每天只作一次统计信息||';
	--delete from operate_player WHERE to_char(static_time, 'YYYY-MM-dd') = curday;
	delete from operate_player WHERE static_date = d_static_date;

	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次删除记录数 %', n_count;
	rtn = rtn||'|执行完毕,删除记录数: '||n_count||' 条||';

	--开始执行玩家经营报表信息收集
	site_id 	= COALESCE((rec->>'siteid')::INT, -1);
	site_name	= COALESCE(rec->>'sitename', '');
	master_id	= COALESCE((rec->>'masterid')::INT, -1);
	master_name	= COALESCE(rec->>'mastername', '');
	center_id	= COALESCE((rec->>'operationid')::INT, -1);
	center_name	= COALESCE(rec->>'operationname', '');

	raise info '开始日期:%, 结束日期:%', start_time, end_time;
	INSERT INTO operate_player(
		center_id, center_name, master_id, master_name,
		site_id, site_name, topagent_id, topagent_name,
		agent_id, agent_name, player_id, player_name,
		api_id, api_type_id, game_type,
		--static_time, create_time, --v1.02  2016/05/31  Leisure
		static_date, static_time, static_time_end, create_time,
		transaction_order, transaction_volume, effective_transaction, profit_loss
		) SELECT
				center_id, center_name, master_id, master_name,
				site_id, site_name, u.topagent_id, u.topagent_name,
				u.agent_id, u.agent_name, u.id, u.username,
				p.api_id, p.api_type_id, p.game_type,
				--now(), now(), --v1.02  2016/05/31  Leisure
				d_static_date, start_time::TIMESTAMP, end_time::TIMESTAMP, now(),
				p.transaction_order, p.transaction_volume, p.effective_transaction, p.profit_loss
				FROM (SELECT
								player_id, api_id, api_type_id, game_type,
								COUNT(order_no)  							as transaction_order,
								SUM(COALESCE(single_amount, 0.00))  		as transaction_volume,
								SUM(COALESCE(profit_amount, 0.00))  		as profit_loss,
								SUM(COALESCE(effective_trade_amount, 0.00)) as effective_transaction
							 FROM player_game_order
							--WHERE bet_time >= start_time::TIMESTAMP
							--	AND bet_time < end_time::TIMESTAMP
							WHERE payout_time >= start_time::TIMESTAMP
							  AND payout_time < end_time::TIMESTAMP
								AND order_state = 'settle'
								--v1.06  2017/02/05  Leisure
								--AND is_profit_loss = TRUE --v1.03  2016/06/13  Leisure
							GROUP BY player_id, api_id, api_type_id, game_type
							) p, v_sys_user_tier u
	WHERE p.player_id = u.id;

	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次插入数据量 %', n_count;
	rtn = rtn||'|执行完毕,新增记录数: '||n_count||' 条||';

	return rtn;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_operations_player(start_time TEXT, end_time TEXT, curday TEXT, rec JSON)
IS 'Lins-经营报表-玩家报表';
