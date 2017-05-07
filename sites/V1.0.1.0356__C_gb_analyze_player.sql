-- auto gen by cherry 2016-12-17 09:55:27
drop function if exists gb_analyze_player(DATE, TIMESTAMP, TIMESTAMP);
create or replace function gb_analyze_player(
	stat_date 	DATE,
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/12/10  Leisure  创建此函数: 经营分析-玩家
*/
DECLARE
	rec 	record;
	gs_id 	INT;
	n_count 	INT;

BEGIN

	raise info '清除 % 号统计数据...', stat_date;
	DELETE FROM analyze_player WHERE static_date = stat_date;
	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice '本次删除记录数 %', n_count;

	raise info '统计 % 号经营数据.START', stat_date;

	INSERT INTO analyze_player (
	    player_id,
	    agent_id,
	    topagent_id,
	    promote_link,
	    is_new_player,
	    deposit_amount,
	    withdraw_amount,
	    effective_amount,
	    payout_amount,
	    static_date,
	    static_time,
	    static_time_end
	)
	WITH up AS
	(
		SELECT su."id" player_id,
					 ua."id" agent_id,
					 ut."id" topagent_id,
					 su.register_site,
					 su.create_time >= start_time AND su.create_time < end_time is_new_player
			FROM sys_user su
			LEFT JOIN  sys_user ua ON ua.user_type= '23' AND su.owner_id = ua."id"
			LEFT JOIN  sys_user ut ON ut.user_type= '22' AND ua.owner_id = ut."id"
		WHERE su.user_type = '24'
	),

	pt AS (
		SELECT *
			FROM player_transaction
		 WHERE status = 'success'
			 AND completion_time >= start_time
			 AND completion_time < end_time
	),

	pti AS (
					--存款
					 SELECT player_id,
									'deposit' AS transaction_type,
									transaction_money
						 FROM pt
						WHERE transaction_type = 'deposit'

					 UNION ALL
					 --取款
					 SELECT player_id,
									'withdrawal' AS transaction_type,
									transaction_money
						 FROM pt
						WHERE transaction_type = 'withdrawals'
	),

	pto AS (
		SELECT player_id,
					 SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit_amount,
					 SUM(CASE transaction_type WHEN 'withdrawal' THEN transaction_money ELSE 0 END) AS withdraw_amount
			FROM pti
		 GROUP BY player_id
	),

	pgo AS (
	  SELECT player_id,
	         SUM(effective_trade_amount) effective_amount,
		       SUM(profit_amount) payout_amount
	    FROM player_game_order
	   WHERE order_state = 'settle'
	 		 AND is_profit_loss = TRUE
	     AND payout_time >= start_time
			 AND payout_time < end_time
	   group BY player_id
	)
	SELECT up.*, pto.deposit_amount, pto.withdraw_amount, pgo.effective_amount, pgo.payout_amount, start_time, end_time, stat_date
	  FROM up
	  LEFT JOIN pto ON up.player_id = pto.player_id
	  LEFT JOIN pgo ON up.player_id = pgo.player_id;

	GET DIAGNOSTICS n_count = ROW_COUNT;
	raise notice 'analyze_player新增记录数 %', n_count;

	raise info '统计 % 号经营数据.END', stat_date;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_analyze_player(stat_date DATE, start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Leisure-经营分析-玩家';

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

