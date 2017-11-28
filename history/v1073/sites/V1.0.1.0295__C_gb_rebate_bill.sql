-- auto gen by cherry 2016-10-20 11:16:43
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

	n_bill_count	INT :=0;



	n_sid 			INT;--站点ID.

	b_is_max		BOOLEAN := true;

	h_net_schema_map 	hstore[];-- 包网方案map



	redo_status BOOLEAN:=true; --重跑标志，默认不允许重跑



BEGIN

	t_start_time = p_start_time::TIMESTAMP;

	t_end_time = p_end_time::TIMESTAMP;



	IF p_settle_flag = 'Y' THEN

		SELECT COUNT("id")

		 INTO n_bill_count

			FROM rebate_bill rb

		 WHERE rb.period = p_period

			 AND rb."start_time" = t_start_time

			 AND rb."end_time" = t_end_time;



		IF n_bill_count > 0 THEN

			IF redo_status THEN

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

	rec_grad 	record;

	rec_api 	record;

	rec_grad_api 	record;



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

		v_agent_name = v_agent_name;

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

			--计算有效玩家数

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

				SELECT rg.id AS grads_id,   --返佣梯度ID

				       rg.total_profit,     --有效盈利总额

				       rg.max_rebate,       --返佣上限

				       rg.valid_player_num  --有效玩家数

				  FROM rebate_grads 	rg

				 WHERE rg.rebate_id = n_rebate_set_id

				   AND n_profit_amount > rg.total_profit --实际盈亏 > 梯度盈亏

				   AND n_effective_player_num > rg.valid_player_num --有效玩家数 > 梯度玩家数

				 ORDER BY rg.total_profit DESC, rg.valid_player_num DESC

				 LIMIT 1

				  INTO rec_grad;



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



			n_operation_occupy_retio = 0.00;

			n_operation_occupy_value = 0.00;

			n_rebate_value = 0.00;



			IF b_meet_or_not THEN

				--取得返佣比率

				SELECT rga.id AS grads_api_id, --返佣梯度API比率ID

				       rga.ratio 				--API返佣比例

				  FROM rebate_grads_api rga

				 WHERE rga.rebate_grads_id = rec_grad.grads_id

				   AND rga.api_id = n_api_id

				   AND rga.game_type = v_game_type

				 LIMIT 1

				  INTO rec_grad_api;

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

					n_rebate_value := n_profit_amount * (1 - n_operation_occupy_retio/100) * rec_grad_api.ratio/100;

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

			    n_operation_occupy_retio, n_operation_occupy_value, n_rebate_set_id, rec_grad.grads_id, rec_grad_api.grads_api_id, rec_grad_api.ratio, n_rebate_value

			);



		END LOOP;

	END LOOP;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gb_rebate_agent_api(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_net_maps hstore[])

IS 'Leisure-返佣结算账单.代理API返佣';



drop function if exists gb_rebate_agent(INT, TEXT, TIMESTAMP, TIMESTAMP);

create or replace function gb_rebate_agent(

	p_bill_id 	INT,

	p_settle_flag 	TEXT,

	p_start_time		TIMESTAMP,

	p_end_time		TIMESTAMP

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单-代理返佣

--v1.00  2016/10/15  Leisure  更新分摊费用计算

*/

DECLARE

	rec 	record;

	c_agent_name 	TEXT := '';

	c_pending_state 	TEXT := 'pending_lssuing';

	n_rebate_original 		FLOAT := 0.00;	-- 代理返佣（原始佣金）

	n_max_rebate	FLOAT := 0.00;	-- 返佣上限

	n_rebate_final	FLOAT := 0.00;	-- 最终佣金（佣金+上期未结-分摊费用）

	--n_player_num	INT := 0; 	--有效玩家数

	n_next_lssuing 	FLOAT := 0.00; --未结算佣金（往期未结）



	h_sys_apportion hstore;  --分摊比例配置信息



	n_agent_retio float := 0.00; --代理分摊比率

	n_favorable_apportion 	float:=0.00;-- 优惠分摊费用

	n_recommend_apportion 	float:=0.00;-- 推荐分摊费用

	n_backwater_apportion 	float:=0.00;-- 返水分摊费用

	n_refund_fee_apportion 	float:=0.00;-- 返手续费分摊费用

	n_apportion float:=0.00; --代理分摊总费用



BEGIN



	SELECT gamebox_sys_param('apportionSetting') INTO h_sys_apportion;



	FOR rec IN



		WITH pt AS (

		  SELECT *

		    FROM player_transaction

		   WHERE status = 'success'

		     AND completion_time >= p_start_time

		     AND completion_time < p_end_time

		),



		raa AS (

		  SELECT agent_id,

		         MIN(rebate_grads_id) rebate_grads_id,

		         SUM(effective_transaction) effective_transaction,

		         MIN(effective_player_num) effective_player_num,

		         SUM(profit_loss) profit_loss,

		         SUM(rebate_value) rebate

		    FROM rebate_agent_api

		   WHERE rebate_bill_id = p_bill_id

		     AND settle_flag = p_settle_flag

		   GROUP BY agent_id),



		ptt AS (

		  SELECT agent_id,

		         SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit,

		         SUM(CASE transaction_type WHEN 'withdrawal' THEN transaction_money ELSE 0 END) AS withdrawal,

		         SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money ELSE 0 END) AS favorable,

		         SUM(CASE transaction_type WHEN 'recommend' THEN transaction_money ELSE 0 END) AS recommend,

		         SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS backwater,

		         SUM(CASE transaction_type WHEN 'refund_fee' THEN transaction_money ELSE 0 END) AS refund_fee

		    FROM

		  (SELECT ua."id" AS agent_id,

		           transaction_type,

		           transaction_money

		      FROM (--存款

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

		           ) pti

		           LEFT JOIN

		           sys_user su ON pti.player_id = su."id" AND su.user_type = '24'

		           LEFT JOIN

		           sys_user ua ON su.owner_id = ua."id" AND ua.user_type = '23'

		  ) AS pto

		   GROUP BY agent_id

		)



		SELECT COALESCE(raa.agent_id, ptt.agent_id) agent_id,

		       rebate_grads_id,

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



		ELSE

			c_pending_state := 'next_lssuing';

		END IF;



		n_rebate_final := n_rebate_original + n_next_lssuing - n_apportion;



		IF p_settle_flag = 'Y' THEN



			INSERT INTO rebate_agent(

				rebate_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,

				rakeback, rebate_total, rebate_actual, refund_fee, recommend, preferential_value, settlement_state,

				apportion, deposit_amount, withdrawal_amount, history_apportion

			) VALUES (

				p_bill_id, rec.agent_id, c_agent_name, rec.effective_player_num, rec.effective_transaction, rec.profit_loss,

				rec.backwater, n_rebate_final, n_rebate_final, rec.refund_fee, rec.recommend, rec.favorable, c_pending_state,

				--rec.backwater + rec.refund_fee + rec.recommend + rec.favorable,

				n_apportion,

				rec.deposit, rec.withdrawal, n_next_lssuing

			);

		ELSEIF p_settle_flag='N' THEN



			INSERT INTO rebate_agent_nosettled (

				rebate_bill_nosettled_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,

				rakeback, rebate_total, refund_fee, recommend, preferential_value,

				apportion, deposit_amount, withdrawal_amount, history_apportion

			) VALUES (

				p_bill_id, rec.agent_id, c_agent_name, rec.effective_player_num, rec.effective_transaction, rec.profit_loss,

				rec.backwater, n_rebate_final, rec.refund_fee, rec.recommend, rec.favorable,

				--rec.backwater + rec.refund_fee + rec.recommend + rec.favorable,

				n_apportion,

				rec.deposit, rec.withdrawal, n_next_lssuing

			);



		END IF;



	END LOOP;



END;



$$ language plpgsql;

COMMENT ON FUNCTION gb_rebate_agent(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)

IS 'Leisure-返佣结算账单-代理返佣';



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

								AND is_profit_loss = TRUE --v1.03  2016/06/13  Leisure

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



drop function if exists gamebox_rebate_player(hstore, hstore, hstore, int, text, text, TEXT);

create or replace function gamebox_rebate_player(

    syshash 		hstore,

    expense_map 	hstore,

    rakeback_map 	hstore,

    bill_id 		INT,

    row_split 		text,

    col_split 		text,

    flag 			TEXT

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数: 返佣-玩家返佣

--v1.01  2016/10/03  Leisure  更新分摊费用的计算，favourable统一改为favorable

--v1.02  2016/10/08  Leisure  更新分摊费用的计算，改为returning防并发

*/

DECLARE



	keys 		text[];

	keyname 	text:='';

	val 		text:='';

	--vals 		text[];



	user_id 	INT:=-1;



	mhash 		hstore;

	--param 		text:='';

	--money 		float:=0.00;



	player_num 	int:=0;					-- 玩家数

	profit_amount float:=0.00;			-- 盈亏总和

	effective_trade_amount float:=0.00;	-- 有效交易量



	agent_id 	int;

	agent_name 	text:='';



	rebate 		float:=0.00;	-- 返佣

	backwater 	float:=0.00;			-- 返水费用

	backwater_apportion 	float:=0.00;-- 返水分摊费用



	favorable 	float:=0.00;			-- 优惠费用

	recommend 	float:=0.00;			-- 推荐费用

	--artificial_depositfavorable		float:=0.00;-- 手动存入优惠



	retio 		float;			-- 占成比

	favorable_apportion 	float:=0.00;-- 优惠分摊费用

	refund_fee 	float:=0.00;			-- 返手续费费用

	refund_fee_apportion 	float:=0.00;-- 返手续费分摊费用

	apportion 	FLOAT:=0.00;	-- 分摊总费用



	deposit 		float:=0.00;	-- 存款

	--company_deposit float:=0.00;	-- 存款:公司入款

	--online_deposit	float:=0.00;	-- 存款:线上支付

	--artificial_deposit float:=0.00; -- 存款:手动存款



	withdrawal 		float:=0.00;	-- 取款

	--artificial_withdraw	float:=0.00;-- 取款:手动取款

	--player_withdraw	float:=0.00;	-- 取款:玩家取款



	--rebate_keys		text[];

	--rebate_keyname  text:='';

	--rebate_val		text:='';

	--rebate_vals 	text[];

	--rebate_hash		hstore;

	--max_rebate		float:=0.00;



	--tmp 		text:='';

	return_id 		text:='';



BEGIN

	-- raise info 'expense_map = %', expense_map;

	IF expense_map is null THEN

		RETURN;

	END IF;



	keys = akeys(expense_map);

	-- raise info '---- keys = %', keys;



	FOR i in 1..array_length(keys, 1)



	LOOP

		keyname = keys[i];



		user_id = keyname::INT;

		val = expense_map->keyname;

		--转换成hstore数据格式:key1=>value1,key2=>value2

		val = replace(val, row_split, ',');

		val = replace(val, col_split, '=>');

		--raise info 'val=%',val;

		SELECT val INTO mhash;



		--代理id

		agent_id = -1;

		IF exist(mhash, 'agent_id') THEN

			agent_id = (mhash->'agent_id')::INT;

		END IF;



		--代理名称

		agent_name = '';

		IF exist(mhash, 'agent_name') THEN

			agent_name = mhash->'agent_name';

		END IF;



		--返佣

		rebate = 0.00;

		IF exist(mhash, 'rebate') THEN

			rebate = (mhash->'rebate')::float;

		END IF;



		--backwater = 0.00;

		-- raise info 'rakeback_map = %', rakeback_map;

		/*

		IF isexists(rakeback_map, keyname) THEN

			backwater = (rakeback_map->keyname)::FLOAT;

		END IF;

		*/



		backwater = 0.00;

		IF exist(mhash, 'backwater') THEN

			backwater = (mhash->'backwater')::float;

		END IF;



		-- raise info 'backwater = %', backwater;



		refund_fee = 0.00;

		IF exist(mhash, 'refund_fee') THEN

			refund_fee = (mhash->'refund_fee')::float;

		END IF;



		favorable = 0.00;

		IF exist(mhash, 'favorable') THEN

			favorable = (mhash->'favorable')::float;

		END IF;



		recommend = 0.00;

		IF exist(mhash, 'recommend') THEN

			recommend = (mhash->'recommend')::float;

		END IF;



		/*

		artificial_depositfavorable = 0.00;

		IF exist(mhash, 'artificial_depositfavorable') THEN

			artificial_depositfavorable = (mhash->'artificial_depositfavorable')::float;

		END IF;

		favorable = favorable + artificial_depositfavorable;

		*/



		/*

		company_deposit = 0.00;

		IF exist(mhash, 'company_deposit') THEN

			company_deposit = (mhash->'company_deposit')::float;

		END IF;

		online_deposit = 0.00;

		IF exist(mhash, 'online_deposit') THEN

			online_deposit = (mhash->'online_deposit')::float;

		END IF;

		artificial_deposit = 0.00;

		IF exist(mhash, 'artificial_deposit') THEN

			artificial_deposit = (mhash->'artificial_deposit')::float;

		END IF;

		deposit = company_deposit + online_deposit + artificial_deposit;

		*/

		/*

		artificial_withdraw = 0.00;

		IF exist(mhash, 'artificial_withdraw') THEN

			artificial_withdraw = (mhash->'artificial_withdraw')::float;

		END IF;

		player_withdraw = 0.00;

		IF exist(mhash, 'player_withdraw') THEN

			player_withdraw = (mhash->'player_withdraw')::float;

		END IF;

		withdraw = artificial_withdraw + player_withdraw;

		*/



		deposit = 0.00;

		IF exist(mhash, 'deposit') THEN

			deposit = (mhash->'deposit')::float;

		END IF;



		withdrawal = 0.00;

		IF exist(mhash, 'withdrawal') THEN

			withdrawal = (mhash->'withdrawal')::float;

		END IF;



		--有效交易量

		effective_trade_amount = 0.00;

		IF exist(mhash, 'effective_transaction') THEN

			effective_trade_amount = (mhash->'effective_transaction')::float;

		END IF;



		--盈亏总和

		profit_amount = 0.00;

		IF exist(mhash, 'profit_loss') THEN

			profit_amount = (mhash->'profit_loss')::float;

		END IF;



		/*

			计算各种优惠.

			1、返水承担费用 = 赠送给体系下玩家的返水 * 代理承担比例；

			2、优惠承担费用 = 赠送给体系下玩家的优惠 * 代理承担比例；

			3、返还手续费承担费用 = 返还给体系下玩家的手续费 * 代理承担比例；

		*/

		--优惠与推荐分摊

		IF isexists(syshash, 'agent.preferential.percent') THEN

			retio = (syshash->'agent.preferential.percent')::float;

			-- raise info '优惠与推荐分摊比例:%', retio;

			favorable_apportion = (favorable + recommend) * retio / 100;

		ELSE

			favorable_apportion = 0;

		END IF;

		--返水分摊

		IF isexists(syshash, 'agent.rakeback.percent') THEN

			retio = (syshash->'agent.rakeback.percent')::float;

			-- raise info '返水分摊比例:%', retio;

			backwater_apportion = backwater * retio / 100;

		ELSE

			backwater_apportion = 0;

		END IF;

		--返手续费分摊

		IF isexists(syshash, 'agent.poundage.percent') THEN

			retio = (syshash->'agent.poundage.percent')::float;

			-- raise info '手续费优惠分摊比例:%', retio;

			refund_fee_apportion = refund_fee * retio / 100;

		ELSE

			refund_fee_apportion = 0;

		END IF;



		--分摊总费用

		apportion = backwater_apportion + refund_fee_apportion + favorable_apportion;

		-- raise info '-------- 分摊总费用 = %', apportion;



		--代理佣金 = 各API佣金总和 - 优惠 - 返水 - 返手续费.

		rebate = rebate - apportion;



		IF flag = 'Y' THEN

			INSERT INTO rebate_player(

				rebate_bill_id, agent_id, user_id,

				effective_transaction, profit_loss, rebate_total, rakeback,

				preferential_value, recommend, refund_fee, apportion,

				deposit_amount, withdrawal_amount

			) VALUES (

				bill_id, agent_id, user_id,

				effective_trade_amount, profit_amount, rebate, backwater,

				favorable, recommend, refund_fee, apportion,

				deposit, withdrawal

			) RETURNING id INTO return_id;

			--SELECT currval(pg_get_serial_sequence('rebate_player', 'id')) INTO tmp;

			-- raise info 'Y返佣代理表的键值:%', tmp;

		ELSEIF flag='N' THEN

			INSERT INTO rebate_player_nosettled (

				rebate_bill_nosettled_id, agent_id, player_id,

				effective_transaction, profit_loss, rebate_total, rakeback,

				preferential_value, recommend, refund_fee, apportion,

				deposit_amount, withdrawal_amount

			) VALUES (

				bill_id, agent_id, user_id,

				effective_trade_amount, profit_amount, rebate, backwater,

				favorable, recommend, refund_fee, apportion,

				deposit, withdrawal

			) RETURNING id INTO return_id;

			--SELECT currval(pg_get_serial_sequence('rebate_player_nosettled', 'id')) INTO tmp;



			raise info 'N返佣代理表的键值:%',return_id;

		END IF;

	END LOOP;

	raise info '开始统计代理返佣.完成';

END

$$ language plpgsql;



COMMENT ON FUNCTION gamebox_rebate_player(syshash hstore, expense_map hstore, rakeback_map hstore, bill_id INT, row_split text, col_split text, flag TEXT)

IS 'Lins-返佣-玩家返佣';



drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP, text, text);

create or replace function gamebox_expense_gather(

	start_time 	TIMESTAMP,

	end_time 	TIMESTAMP,

	row_split 	text,

	col_split 	text

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：返佣--分摊费用

--v1.01  2016/05/12  Leisure  修正统计优惠信息的条件（返佣）

--v1.02  2016/06/06  Leisure  公司存款、线上支付增加微信、支付宝存款、支付

--v1.03  2016/10/03  Leisure  调整player_transaction金额类型的判断方法；

                              时间由create_time改为completion_time

--v1.04  2016/10/08  Leisure  更新分摊费用的计算，改为returning防并发

*/

DECLARE

	rec 		record;

	hash 		hstore;

	mhash 		hstore;

	param 		text:='';

	user_id 	text:='';

	money 		float:=0.00;



BEGIN

	/*--v1.03  2016/10/03  Leisure

		FOR rec IN

		SELECT pt.*, su.owner_id

		  FROM (SELECT player_id,

		               fund_type,

		               SUM(transaction_money) as transaction_money

		          FROM (SELECT player_id,

		                       fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND fund_type in ('backwater', 'refund_fee', 'artificial_deposit',

		                                     'artificial_withdraw', 'player_withdraw')

		                   AND create_time >= start_time

		                   AND create_time < end_time

		                   AND NOT (fund_type = 'artificial_deposit' AND

		                            transaction_type = 'favorable')



		                UNION ALL

		                --优惠、推荐

		                SELECT player_id,

		                       --fund_type||transaction_type,

		                       'favourable' fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND (fund_type = 'favourable' OR

		                        fund_type = 'recommend'  OR

		                        (fund_type = 'artificial_deposit' AND transaction_type = 'favorable'))

		                   AND create_time >= start_time

		                   AND create_time < end_time



		                UNION ALL

		                --公司存款 --v1.02  2016/06/06  Leisure

		                SELECT player_id,

		                       --fund_type||transaction_type,

		                       'company_deposit' fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND fund_type IN ('company_deposit','wechatpay_fast' ,'alipay_fast')

		                   AND create_time >= start_time

		                   AND create_time < end_time



		                UNION ALL

		                --线上支付 --v1.02  2016/06/06  Leisure

		                SELECT player_id,

		                       --fund_type||transaction_type,

		                       'online_deposit' fund_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND fund_type IN ('online_deposit','wechatpay_scan' ,'alipay_scan')

		                   AND create_time >= start_time

		                   AND create_time < end_time

		               ) ptu

		         GROUP BY player_id, fund_type

		       ) pt

		       LEFT JOIN

		       sys_user su ON pt.player_id = su."id"

		 WHERE su.user_type = '24'

	LOOP

	*/

	FOR rec IN

		SELECT pt.*, su.owner_id

		  FROM (SELECT player_id,

		               transaction_type,

		               SUM(transaction_money) as transaction_money

		          FROM (--存款

		                SELECT player_id,

		                       'deposit' AS transaction_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND transaction_type = 'deposit'

		                   AND (fund_type <> 'artificial_deposit' OR transaction_way = 'manual_deposit')

		                   AND completion_time >= start_time

		                   AND completion_time < end_time



		                UNION ALL

		                --取款

		                SELECT player_id,

		                       'withdrawal' AS transaction_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND transaction_type = 'withdrawals'

		                   AND (fund_type <> 'artificial_withdraw' OR transaction_way = 'manual_deposit')

		                   AND completion_time >= start_time

		                   AND completion_time < end_time



		                UNION ALL

		                --优惠

		                SELECT player_id,

		                       'favorable' AS transaction_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND (transaction_type = 'favorable'

		                        AND fund_type <> 'refund_fee'

		                        AND transaction_way <> 'manual_rakeback')

		                   AND completion_time >= start_time

		                   AND completion_time < end_time



		                UNION ALL

		                --推荐

		                SELECT player_id,

		                       'recommend' AS transaction_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND transaction_type = 'recommend'

		                   AND completion_time >= start_time

		                   AND completion_time < end_time



		                UNION ALL

		                --返水

		                SELECT player_id,

		                       'backwater' AS transaction_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND (transaction_type = 'backwater' OR

		                        (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))

		                   AND completion_time >= start_time

		                   AND completion_time < end_time



		                UNION ALL

		                --返手续费

		                SELECT player_id,

		                       'refund_fee' transaction_type,

		                       transaction_money

		                  FROM player_transaction

		                 WHERE status = 'success'

		                   AND fund_type = 'refund_fee'

		                   AND completion_time >= start_time

		                   AND completion_time < end_time

		               ) ptu

		         GROUP BY player_id, transaction_type

		       ) pt

		       LEFT JOIN

		       sys_user su ON pt.player_id = su."id"

		 WHERE su.user_type = '24'

	LOOP

		user_id = rec.player_id::text;

		money 	= rec.transaction_money;

		IF isexists(hash, user_id) THEN

			param = hash->user_id;

			param = param||row_split||rec.transaction_type||col_split||money::text;

		ELSE

			param = rec.transaction_type||col_split||money::text;

		END IF;



		IF position('agent_id' IN param) = 0  THEN

			param = param||row_split||'agent_id'||col_split||rec.owner_id::TEXT;

		END IF;



		SELECT user_id||'=>'||param into mhash;

		IF hash is null THEN

			hash = mhash;

		ELSE

			hash = hash||mhash;

		END IF;

	END LOOP;



	return hash;

END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP, row_split text, col_split text)

IS 'Lins-分摊费用';

-- auto gen by cherry 2016-10-19 21:13:28
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
--V1.02  2016/10/17  Leisure  改用变量代替record，并增加初始化操作
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
		v_agent_name = v_agent_name;
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
			--计算有效玩家数
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
				   AND n_profit_amount > rg.total_profit --实际盈亏 > 梯度盈亏
				   AND n_effective_player_num > rg.valid_player_num --有效玩家数 > 梯度玩家数
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