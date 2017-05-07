-- auto gen by cherry 2016-07-14 14:36:32
drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP);

create or replace function gamebox_expense_gather(

	startTime 	TIMESTAMP,

	endTime 	TIMESTAMP

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数: 分摊费用

--v1.01  2016/06/15  Leisure  追加返回值判空逻辑

--v1.01  2016/07/13  Leisure  next_lssuing的费用，由下期history_apportion来计算，

                              本期不计算。

*/

DECLARE

	rec 		record;

	hash 		hstore;

	mhash 		hstore;

	param 		text:='';

	money 		float:=0.00;

	key_name 	TEXT;



	player_num 	INT:=0;

	apportion 	FLOAT:=0.00;

	rakeback 	FLOAT:=0.00;

	recommend	FLOAT:=0.00;

	refund_fee 	FLOAT:=0.00;

	profit_loss FLOAT:=0.00;

	deposit 	FLOAT:=0.00;

	effe_trans 	FLOAT:=0.00;

	favorable 	FLOAT:=0.00;

	withdraw 	FLOAT:=0.00;

	rebate_tot 	FLOAT:=0.00;

	rebate_act 	FLOAT:=0.00;



BEGIN



	FOR rec IN

		SELECT SUM(ra.effective_player) 		player_num,

			   SUM(ra.apportion) 				apportion,

			   SUM(ra.rakeback) 				rakeback,

			   SUM(ra.recommend) 				recommend,

		 	   SUM(ra.refund_fee) 				refund_fee,

			   SUM(ra.profit_loss) 				profit_loss,

			   SUM(ra.deposit_amount) 			deposit,

			   SUM(ra.effective_transaction) 	effe_trans,

			   SUM(ra.preferential_value) 		favorable,

			   SUM(ra.withdrawal_amount) 		withdraw,

			   SUM(ra.rebate_total) 			rebate_total,

			   SUM(ra.rebate_actual) 			rebate_actual

		  FROM rebate_agent ra

		  LEFT JOIN rebate_bill rb ON ra.rebate_bill_id = rb."id"

		 WHERE ra.settlement_state <> 'next_lssuing' --v1.01  2016/07/13  Leisure

		   AND rb.start_time >= startTime

		   AND rb.end_time <= endTime

	 LOOP

	 	player_num 	= player_num + rec.player_num;

	 	apportion 	= apportion + rec.apportion;

	 	rakeback 	= rakeback + rec.rakeback;

	 	recommend 	= recommend + rec.recommend;

	 	refund_fee 	= refund_fee + rec.refund_fee;

	 	profit_loss = profit_loss + rec.profit_loss;

	 	deposit 	= deposit + rec.deposit;

	 	effe_trans 	= effe_trans + rec.effe_trans;

	 	favorable 	= favorable + rec.favorable;

		withdraw  	= withdraw + rec.withdraw;

		rebate_tot 	= rebate_tot + rec.rebate_total;

		rebate_act  = rebate_act + rec.rebate_actual;

	END LOOP;



	param = 'player_num=>'||player_num;

	param = param||',apportion=>'||apportion||',rakeback=>'||rakeback||',recommend=>'||recommend;

	param = param||',refund_fee=>'||refund_fee||',profit_loss=>'||profit_loss||',deposit=>'||deposit;

	param = param||',effe_trans=>'||effe_trans||',favorable=>'||favorable||',withdraw=>'||withdraw;

	param = param||',rebate_tot=>'||rebate_tot||',rebate_act=>'||rebate_act;



	SELECT param::hstore INTO hash;



	return coalesce(hash, '');

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP)

IS 'Lins-分摊费用';



drop function if exists gamebox_expense_leaving(TIMESTAMP, TIMESTAMP);

CREATE OR REPLACE FUNCTION gamebox_expense_leaving(

	p_start_time TIMESTAMP,

	p_end_time TIMESTAMP

)

  RETURNS "public"."hstore" AS $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2016/06/09  Leisure  创建此函数: 返佣——上期未结费用

--v1.01  2016/07/13  Leisure  修改上期未结统计逻辑，

                              改为统计当期结算的历史未结金额

*/

DECLARE

	leaving_map 	hstore;

	f_expense_leaving		FLOAT := 0.00;

BEGIN

--v1.01  2016/07/13  Leisure

/*

	SELECT COALESCE(SUM(rao.rebate_actual), 0.00)

		FROM rebate_agent rao, rebate_bill rb

	 WHERE rao.rebate_bill_id = rb.id

		 AND rao.settlement_state = 'next_lssuing'

		 AND rb.end_time <= p_end_time

		 AND rao.rebate_bill_id > (

			 SELECT COALESCE(MAX(rebate_bill_id), 0)

				 FROM rebate_agent rai

				WHERE rai.settlement_state <> 'next_lssuing'

					AND rai.agent_id = rao.agent_id

		 ) INTO f_expense_leaving;

*/

	SELECT COALESCE(SUM(ra.history_apportion), 0.00)

		FROM rebate_agent ra, rebate_bill rb

	 WHERE ra.rebate_bill_id = rb.id

		 AND ra.settlement_state <> 'next_lssuing'

		 AND rb.start_time >= p_end_time

		 AND rb.end_time <= p_end_time

	  INTO f_expense_leaving;



	leaving_map := (SELECT ('expense_leaving=>'||f_expense_leaving)::hstore);



	RETURN leaving_map;

END;



$$ LANGUAGE 'plpgsql';

COMMENT ON FUNCTION gamebox_expense_leaving(p_start_time timestamp, p_end_time timestamp)

IS 'Leisure-返佣——上期未结费用';





DROP FUNCTION IF EXISTS f_player_recommend_award (VARCHAR, VARCHAR, VARCHAR, VARCHAR);

CREATE OR REPLACE FUNCTION f_player_recommend_award (

	siteCode VARCHAR,		-- 站点代码

	orderType VARCHAR,		-- 订单类型: 01-充值, 02-优惠, 03-游戏API, 04-返水, 05-返佣, 06-玩家取款, 07-代理提现, 08-转账

	start_time VARCHAR,

	end_time VARCHAR

)

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Fei      创建此函数: 玩家推荐奖励存储函数

--v1.01  2016/06/15  Leisure  增加时间参数，解决时区问题

--v1.02  2016/07/04  Leisure  player_transaction新增记录，增加completion_time

--v1.03  2016/07/06  Leisure  修正推荐红利重复生成bug；

                              修正一个bug，begin_time改为start_time

--v1.04  2016/07/06  Leisure  修正推荐红利-优惠稽核倍数不对的问题

*/

	RETURNS INTEGER AS $BODY$

DECLARE

	rec record;

	-- 单次奖励

	singleReward BOOLEAN:= (SELECT active FROM sys_param WHERE param_type = 'recommended' AND param_code = 'reward');

	-- 奖励方式: 1-奖励双方,2-奖励推荐人,3-奖励被推荐人

	rewardWay INTEGER:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'reward');

	-- 单次奖励存款金额

	deposit NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'reward.theWay');

	-- 奖励金额

	rewardAmount NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'reward.money');

	-- 单次奖励优惠稽核倍数

	rewardMultiple NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'audit');

	-- 优惠稽核点

	rewardPoint NUMERIC:= (rewardAmount * rewardMultiple);



	br record;

	-- 推荐红利

	bonusReward BOOLEAN:= (SELECT active FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus');

	-- 推荐红利有效玩家交易量

	effeTrade NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus.trading');

	-- 红利上限

	toplimit NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus.bonusMax');

	-- 奖励金额

	bonusAmount NUMERIC:=0.0;



	-- 优惠稽核点

	bonusPoint NUMERIC:=0.0;

	--v1.03  2016/07/06  Leisure

	-- 优惠稽核

	bonusAudit NUMERIC:= (SELECT CASE WHEN param_value = '' OR param_value IS NULL THEN '0.00' ELSE param_value END FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus.audit');



	orderNo 	VARCHAR:='';

	transType 	VARCHAR:='recommend';		-- 交易类型:推荐

	transStatus VARCHAR:='success';			-- 交易状态:待处理

	fundType 	VARCHAR:='recommend';		-- 资金类型:推荐

	single 		VARCHAR:='single_reward'; 	-- 单次奖励

	bonus 		VARCHAR:='bonus_awards';	-- 推荐红利

	referee 	VARCHAR:='2';				-- 推荐人

	referen 	VARCHAR:='3';				-- 被推荐人

BEGIN

	IF singleReward THEN	-- 单次奖励

		FOR rec IN

			SELECT * FROM (

				/* 去除已奖励的玩家**/

				SELECT up."id", up.recommend_user_id recommend_id, su.username recommend_name

				  FROM user_player up

				 INNER JOIN sys_user su ON up."recommend_user_id" = su."id"

				 WHERE su.user_type = '24'

				   AND up.recommend_user_id IS NOT NULL

				   AND up."id" NOT IN (

					 	SELECT DISTINCT recommend_user_id FROM player_recommend_award

					 	 WHERE reward_mode = 'single_reward'

						   AND user_id IN (SELECT DISTINCT(recommend_user_id) FROM user_player WHERE recommend_user_id IS NOT NULL)

				   )

			) tr INNER JOIN (

				/* 被推荐人满足交易量**/

				SELECT su."id" berecommend_id, su.username berecommend_name, ep.trade_amount

				  FROM (SELECT *

				  		  FROM (SELECT player_id, SUM(transaction_money) trade_amount

							      FROM player_transaction

							     WHERE transaction_type = 'deposit'

							       AND status = 'success'

							     GROUP BY player_id) pt

				  		 WHERE trade_amount >= deposit

					   ) ep

				  LEFT JOIN sys_user su ON ep.player_id = su."id"

				 WHERE su.user_type = '24'

			) ta ON tr."id" = ta.berecommend_id



			LOOP



				IF rewardWay = '1' THEN	-- 奖励双方

					orderNo := (SELECT f_order_no(siteCode, orderType));

					/** 奖励推荐人**/

					WITH award1 AS (

						-- 新增推荐记录数据

						INSERT INTO player_recommend_award (

							transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)

						VALUES (

							orderNo, rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '推荐')

						RETURNING id

					)

					-- 新增交易订单数据

					INSERT INTO player_transaction (

						transaction_no, create_time, transaction_type, remark, transaction_money, balance,

						status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,

						completion_time, fund_type, transaction_way, transaction_data)

					VALUES (

						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id),

						transStatus,rec.recommend_id, (SELECT id FROM award1), rewardPoint, false, false,

						now(), fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referee||'"}');

					-- 修改玩家余额

					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.recommend_id;



					/** 奖励被推荐人**/

					orderNo := (SELECT f_order_no(siteCode, orderType));

					WITH award2 AS (

						-- 新增推荐记录数据

						INSERT INTO player_recommend_award (

							transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)

						VALUES (

							orderNo, rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '被推荐')

						RETURNING id

					)

					-- 新增交易订单数据

					INSERT INTO player_transaction (

						transaction_no, create_time, transaction_type, remark, transaction_money, balance,

						status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,

						completion_time, fund_type, transaction_way, transaction_data)

					VALUES (

						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.berecommend_id),

						transStatus, rec.berecommend_id, (SELECT id FROM award2), rewardPoint, false, false,

						now(), fundType, single, '{"username":"'||rec.recommend_name||'","rewardType":"'||referen||'"}');

					-- 修改玩家余额

					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.berecommend_id;



				ELSEIF rewardWay = '2' THEN 	-- 奖励推荐人

					orderNo := (SELECT f_order_no(siteCode, orderType));

					WITH award AS (

						-- 新增推荐记录数据

						INSERT INTO player_recommend_award (

							transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)

						VALUES (

							orderNo, rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '推荐')

						RETURNING id

					)

					-- 新增交易订单数据

					INSERT INTO player_transaction (

						transaction_no, create_time, transaction_type, remark, transaction_money, balance,

						status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,

						completion_time, fund_type, transaction_way, transaction_data)

					VALUES (

						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id),

						transStatus, rec.recommend_id, (SELECT id FROM award), rewardPoint, false, false,

						now(), fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referee||'"}');

					-- 修改玩家余额

					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.recommend_id;



				ELSEIF rewardWay = '3' THEN	-- 奖励被推荐人

					orderNo := (SELECT f_order_no(siteCode, orderType));

					WITH award AS (

						-- 新增推荐记录数据

						INSERT INTO player_recommend_award (

							transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)

						VALUES (

							orderNo, rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '被推荐')

						RETURNING id

					)

					-- 新增交易订单数据

					INSERT INTO player_transaction (

						transaction_no, create_time, transaction_type, remark, transaction_money, balance, status,

						player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,

						completion_time, fund_type, transaction_way, transaction_data)

					VALUES (

						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.berecommend_id),

						transStatus, rec.berecommend_id, (SELECT id FROM award), rewardPoint, false, false,

						now(), fundType, single, '{"username":"'||rec.recommend_name||'","rewardType":"'||referen||'"}');

					-- 修改玩家余额

					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.berecommend_id;



				END IF;



			END LOOP;



	END IF;



	IF bonusReward THEN 	--推荐红利



		FOR rec IN

			SELECT up.recommend_user_id 			recommend_id,

			       su.username 						recommend_name,

			       COUNT(DISTINCT pgo.player_id) 	recommend_total,

			       SUM(pgo.effective_trade_amount) 	trade_amount

			  FROM user_player up

			  LEFT JOIN sys_user su ON up.recommend_user_id = su."id"

			  LEFT JOIN player_game_order pgo ON up."id" = pgo.player_id

			 WHERE up.recommend_user_id IS NOT NULL

			   AND NOT EXISTS (--v1.03  2016/07/06  Leisure add

			     SELECT 1 FROM player_recommend_award pra

			      WHERE pra.user_id = up.recommend_user_id

			        AND pra.reward_mode = bonus

			        AND pra.reward_time = end_time::TIMESTAMP

			   )

			   --v1.01  2016/06/15  Leisure

			   --AND to_char(pgo.create_time, 'yyyy-MM-dd') = to_char((CURRENT_DATE - INTERVAL '1 day'), 'yyyy-MM-dd')

			   --v1.03  2016/07/06  Leisure

			   AND pgo.bet_time >= start_time::TIMESTAMP

			   AND pgo.bet_time <  end_time::TIMESTAMP

			   AND su.user_type = '24'

			   AND pgo.is_profit_loss = TRUE

			   AND pgo.order_state = 'settle'

			 GROUP BY up.recommend_user_id, su.username



		LOOP



			-- 达到有效交易量

			IF rec.trade_amount >= effeTrade THEN



				FOR br IN

					SELECT playernum, proportion

					  FROM json_to_recordset((SELECT lower(param_value) FROM sys_param WHERE param_type = 'recommended' AND param_code = 'bonus.json')::json)

						AS x(id INTEGER,playernum INTEGER,proportion FLOAT)

					 ORDER BY playernum DESC



				LOOP



					-- 达到推荐人数

					IF rec.recommend_total >= br.playernum THEN



						bonusAmount := br.proportion / 100 * rec.trade_amount; -- 奖励金额

						IF bonusAmount > toplimit THEN -- 奖励金额高于红利上限取上限值

							bonusAmount := toplimit;

						END IF;



						--v1.03  2016/07/06  Leisure

						-- 优惠稽核点 = (奖励稽核 x 优惠稽核倍数)

						bonusPoint := bonusAmount * bonusAudit;



						orderNo := (SELECT f_order_no(siteCode, orderType));

						WITH award AS (

							-- 新增推荐记录数据

							INSERT INTO player_recommend_award (

								transaction_no, user_id, user_name, reward_mode, reward_amount, reward_time, reward_reason)

							VALUES (

								--v1.03  2016/07/06  Leisure

								--orderNo, rec.recommend_id, rec.recommend_name, bonus, bonusAmount, now(), '推荐')

								orderNo, rec.recommend_id, rec.recommend_name, bonus, bonusAmount, end_time::TIMESTAMP, '推荐')

							RETURNING id

						)

						-- 新增交易订单数据

						INSERT INTO player_transaction (

							transaction_no, create_time, transaction_type, remark, transaction_money, balance,

							status, player_id, source_id, favorable_audit_points, is_satisfy_audit, is_clear_audit,

							completion_time, fund_type, transaction_way, transaction_data)

						VALUES (

							orderNo, now(), transType, '推荐奖励-红利', bonusAmount, bonusAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id),

							transStatus, rec.recommend_id, (SELECT id FROM award), bonusPoint, false, false,

							now(), fundType, bonus, '{"username":"'||rec.recommend_name||'"}');

						-- 修改玩家余额

						UPDATE user_player SET wallet_balance = wallet_balance + bonusAmount WHERE id = rec.recommend_id;



						EXIT; -- 跳出循环



					END IF; -- end 达到推荐人数



				END LOOP;



			END IF; -- end 达到有效交易量



		END LOOP;



	END IF;



	RETURN 1;

END;

$BODY$

LANGUAGE 'plpgsql';-- VOLATILE;



--ALTER FUNCTION f_player_recommend_award(siteCode VARCHAR, orderType VARCHAR) OWNER TO "postgres";

COMMENT ON FUNCTION f_player_recommend_award(siteCode VARCHAR, orderType VARCHAR, start_time VARCHAR, end_time VARCHAR) IS 'Fly - 玩家推荐奖励存储函数';