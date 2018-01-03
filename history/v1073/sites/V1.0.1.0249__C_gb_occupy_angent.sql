-- auto gen by cherry 2016-09-06 16:28:47
DROP FUNCTION IF EXISTS gb_occupy_angent(INT, TIMESTAMP, TIMESTAMP);

CREATE OR REPLACE FUNCTION gb_occupy_angent(

	p_bill_id		INT,

	p_start_time		TIMESTAMP,

	p_end_time		TIMESTAMP

) RETURNS VOID AS $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2016/08/18  Leisure  创建此函数: 总代占成.代理贡献（占成和费用）

--v1.01  2016/09/06  Leisure  查表佣金改为分摊部分n_rebate_apportion_top

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

		   AND pgo.bet_time >= p_start_time

		   AND pgo.bet_time < p_end_time

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

		    n_deposit_amount, n_rebate_apportion_top, n_withdrawal_amount, n_favourable_apportion_top, rec.topagent_occupy, n_occupy_top_final,

		    NULL, 'pending_pay', n_apportion_top, n_refund_fee_apportion_top, 0.00, n_backwater_apportion_top

		);

	END LOOP;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gb_occupy_angent(p_bill_id INT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)

IS 'Leisure-总代占成.代理贡献（占成和费用）';





DROP FUNCTION IF EXISTS gb_topagent_occupy(text, text, text, text);

CREATE OR REPLACE FUNCTION gb_topagent_occupy(

	p_period 		text,

	p_start_time 	text,

	p_end_time 	text,

	p_comp_url 		text

) RETURNS VOID AS $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2016/08/15  Leisure  创建此函数: 总代占成统计—入口

--v1.01  2016/09/06  Leisure  修正一处书写错误occupy_angent_api

*/

DECLARE



	d_start_time 	TIMESTAMP;

	d_end_time 	TIMESTAMP;



	n_bill_count		INT;

	n_bill_id 			INT;



	n_sid 				INT;--站点ID.

	c_is_max		BOOLEAN := true;

	h_net_schema_map 	hstore[];-- 包网方案map



	redo_status BOOLEAN:=false; -- 重跑标识，默认不允许重跑



BEGIN

	d_start_time = p_start_time::TIMESTAMP;

	d_end_time = p_end_time::TIMESTAMP;



	SELECT COUNT("id")

	  INTO n_bill_count

	  FROM occupy_bill cb

	 WHERE cb.period = p_period

	   AND cb."start_time" = d_start_time

	   AND cb."end_time" = d_end_time;



	IF n_bill_count > 0 THEN

		IF redo_status THEN

			--DELETE FROM occupy_api WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			--DELETE FROM occupy_player WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			--v1.01  2016/09/06  Leisure

			DELETE FROM occupy_agent_api WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			DELETE FROM occupy_agent WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			DELETE FROM occupy_topagent WHERE occupy_bill_id IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

			DELETE FROM occupy_bill WHERE "id" IN (SELECT "id" FROM occupy_bill WHERE period = p_period AND "start_time" = d_start_time AND "end_time" = d_end_time);

		ELSE

			raise info '已生成本期总代占成统计报表，无需重新生成。';

			RETURN;

		END IF;

	END IF;



	SELECT gamebox_current_site() INTO n_sid;



	raise info '统计站点( % )周期( % )的总代占成, 时间( %-% )', n_sid, p_period, p_start_time, p_end_time;



	raise info '总代占成.总表新增';

	SELECT gamebox_occupy_bill(p_period, d_start_time, d_end_time, n_bill_id, 'I') into n_bill_id;

	raise info 'occupy_bill.键值:%', n_bill_id;



	raise info '取得包网方案';

	SELECT * FROM dblink(p_comp_url, 'SELECT gamebox_contract('||n_sid||', '||c_is_max||')') as a(hash hstore[]) INTO h_net_schema_map;



	raise info '总代占成.代理API交易表';

	perform gb_occupy_angent_api(n_bill_id, d_start_time, d_end_time, h_net_schema_map);



	raise info '总代占成.代理贡献度.';

	perform gb_occupy_angent(n_bill_id, d_start_time, d_end_time);



	raise info '总代占成.总代明细';

	perform gamebox_occupy_topagent(n_bill_id);



	raise info '总代占成.总表更新';

	perform gamebox_occupy_bill(p_period, d_start_time, d_end_time, n_bill_id, 'U');



END;



$$ language plpgsql;

COMMENT ON FUNCTION gb_topagent_occupy(p_period text, p_start_time text, p_end_time text, url text)

IS 'Leisure-总代占成统计—入口';