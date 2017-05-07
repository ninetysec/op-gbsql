-- auto gen by admin 2016-07-05 14:19:55
drop function if exists gamebox_occupy_agent(INT);

create or replace function gamebox_occupy_agent(

	bill_id INT

) returns void as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数: 总代占成-代理贡献

--v1.01  2016/06/28  Leisure  增加返佣上限判断

--v1.02  2016/06/30  Leisure  各种分摊费用，改为只统计总代承担的部分 --by acheng

*/

DECLARE

	pending_lssuing text:='pending_lssuing';

	pending_pay 	text:='pending_pay';

	n_max_rebate	FLOAT;

	rec record;

	sys_map	hstore;

	retio 		FLOAT:=0.00; --代理分摊比例

	retio_rakeback   		FLOAT:=0.00; --总代返水分摊比例

	retio_rebate   		FLOAT:=0.00; --总代返佣分摊比例

	retio_refund_fee   		FLOAT:=0.00; --总代返手续费分摊比例

	retio_preferential   		FLOAT:=0.00; --总代优惠、推荐分摊比例



BEGIN

	--v1.02  2016/06/30  Leisure

	SELECT gamebox_sys_param('apportionSetting') into sys_map;



	--返水

	retio = 0;

	IF isexists(sys_map,  'agent.rakeback.percent') THEN

		retio = (sys_map->'agent.rakeback.percent')::float;

	END IF;

	IF isexists(sys_map,  'topagent.rakeback.percent') THEN

		retio_rakeback = (sys_map->'topagent.rakeback.percent')::float;

		retio_rakeback = (1 - retio / 100) * retio_rakeback / 100;

	END IF;



	--返佣

	IF isexists(sys_map,  'topagent.rebate.percent') THEN

		retio_rebate = (sys_map->'topagent.rebate.percent')::float;

		retio_rebate = retio_rebate / 100;

	END IF;



	--返手续费

	retio = 0;

	IF isexists(sys_map,  'agent.poundage.percent') THEN

		retio = (sys_map->'agent.poundage.percent')::float;

	END IF;

	IF isexists(sys_map,  'topagent.poundage.percent') THEN

		retio_refund_fee = (sys_map->'topagent.poundage.percent')::float;

		retio_refund_fee = (1 - retio / 100) * retio_refund_fee / 100;

	END IF;



	--优惠、推荐

	retio = 0;

	IF isexists(sys_map,  'agent.preferential.percent') THEN

		retio = (sys_map->'agent.preferential.percent')::float;

	END IF;

	IF isexists(sys_map,  'topagent.preferential.percent') THEN

		retio_preferential = (sys_map->'topagent.preferential.percent')::float;

		retio_preferential = (1 - retio / 100) * retio_preferential / 100;

	END IF;



--v1.01  2016/06/28  Leisure

/*

	INSERT INTO occupy_agent(

		occupy_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,

		preferential_value, rakeback, occupy_total, refund_fee, recommend, apportion, rebate, lssuing_state

	)

	SELECT a1.*, pending_pay

	  	FROM (SELECT

	  			p.occupy_bill_id, a.id, a.username,

	  			COUNT(distinct p.player_id), sum(p.effective_transaction), SUM(p.profit_loss),

	  			SUM(preferential_value), SUM(rakeback), SUM(occupy_total), SUM(refund_fee),

	  			SUM(recommend), SUM(apportion), SUM(rebate)

	 		  FROM occupy_player p, sys_user u, sys_user a

	 		 WHERE p.player_id = u.id

     		   AND p.occupy_bill_id = bill_id

	   		   AND u.owner_id = a.id

	   		   AND u.user_type = '24'

	   		   AND a.user_type = '23'

	  		 GROUP BY p.occupy_bill_id, a.id, a.username

	 ) a1;

*/



  FOR rec IN

		SELECT p.occupy_bill_id, a.id agent_id, a.username,

		       COUNT(distinct p.player_id) cnum, sum(p.effective_transaction) effective_transaction, SUM(p.profit_loss) profit_loss,

		       SUM(preferential_value) preferential_value, SUM(rakeback) rakeback, SUM(occupy_total) occupy_total, SUM(refund_fee) refund_fee,

		       SUM(recommend) recommend, SUM(apportion) apportion, SUM(rebate) rebate, pending_pay pending_pay

	 	  FROM occupy_player p, sys_user u, sys_user a

	 	 WHERE p.player_id = u.id

       AND p.occupy_bill_id = bill_id

	     AND u.owner_id = a.id

 		   AND u.user_type = '24'

	     AND a.user_type = '23'

	   GROUP BY p.occupy_bill_id, a.id, a.username

	LOOP



		SELECT COALESCE(MAX(max_rebate), 0)

		  INTO n_max_rebate

		  FROM (

		        SELECT ua.user_id, rg.valid_player_num, rg.total_profit, rg.max_rebate

		          FROM rebate_grads rg, user_agent_rebate ua

		         WHERE ua.rebate_id = rg.rebate_id) arg

		 WHERE arg.user_id = rec.agent_id

		   AND rec.cnum >= arg.valid_player_num

		   AND rec.profit_loss >= arg.total_profit;



		--raise info 'rec.rebate: % , n_max_rebate: %', rec.rebate, n_max_rebate;



		IF n_max_rebate <> 0 AND rec.rebate > n_max_rebate THEN

			rec.rebate = n_max_rebate;

		END IF;



		--v1.02  2016/06/30  Leisure

		rec.rakeback = rec.rakeback * retio_rakeback;

		rec.rebate = rec.rebate * retio_rebate;

		rec.refund_fee = rec.refund_fee * retio_refund_fee;

		rec.recommend = rec.recommend * retio_preferential;

		rec.preferential_value = rec.preferential_value * retio_preferential;



		INSERT INTO occupy_agent(

			occupy_bill_id, agent_id, agent_name, effective_player, effective_transaction, profit_loss,

			preferential_value, rakeback, occupy_total, refund_fee, recommend, apportion, rebate, lssuing_state

		)

    VALUES(rec.occupy_bill_id, rec.agent_id, rec.username,

		       rec.cnum, rec.effective_transaction, rec.profit_loss,

		       rec.preferential_value, rec.rakeback, rec.occupy_total, rec.refund_fee,

		       rec.recommend, rec.apportion, rec.rebate, rec.pending_pay

		);



	END LOOP;



  raise info '总代占成-代理贡献度.完成';



END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_agent(INT)

IS 'Lins-总代占成-代理贡献';



/**

 * 总代占成-总代明细.

 * @author 	Lins

 * @date 	2015.12.2

 * @param 	占成键值

**/

drop function if exists gamebox_occupy_topagent(INT);

create or replace function gamebox_occupy_topagent(

	bill_id INT

) returns void as $$



DECLARE

	pending_lssuing text:='pending_lssuing';

	pending_pay 	text:='pending_pay';

BEGIN

	INSERT INTO occupy_topagent(

		occupy_bill_id, top_agent_id, top_agent_name,effective_agent, effective_transaction, profit_loss,

		preferential_value, rakeback, occupy_total, rebate, refund_fee, recommend, apportion, lssuing_state

	)

	SELECT a1.*, pending_pay

	  FROM (SELECT

			  	p.occupy_bill_id, a.id, a.username,

			  	COUNT(distinct p.agent_id), sum(p.effective_transaction), SUM(p.profit_loss),

			  	SUM(preferential_value), SUM(rakeback), SUM(occupy_total), SUM(rebate),

			  	SUM(refund_fee), SUM(recommend), SUM(apportion)

			 FROM occupy_agent p, sys_user u, sys_user a

			WHERE p.agent_id = u.id

			  AND p.occupy_bill_id = bill_id

			  AND u.owner_id = a.id

			  AND u.user_type='23'

			  AND a.user_type='22'

			GROUP BY p.occupy_bill_id, a.id, a.username

		) a1;

   raise info '总代占成-总代明细.完成';



END



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_topagent(INT)

IS 'Lins-总代占成-总代明细';





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

		 	 WHERE recommend_user_id IS NOT NULL

		 	   --v1.01  2016/06/15  Leisure

		 	   --AND to_char(pgo.create_time, 'yyyy-MM-dd') = to_char((CURRENT_DATE - INTERVAL '1 day'), 'yyyy-MM-dd')

		 	   AND pgo.bet_time >= begin_time::TIMESTAMP

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



						-- 优惠稽核点	(奖励稽核 x 优惠稽核倍数)

						bonusPoint := bonusAmount * rewardPoint;



						orderNo := (SELECT f_order_no(siteCode, orderType));

						WITH award AS (

							-- 新增推荐记录数据

							INSERT INTO player_recommend_award (

								transaction_no, user_id, user_name, reward_mode, reward_amount, reward_time, reward_reason)

							VALUES (

								orderNo, rec.recommend_id, rec.recommend_name, bonus, bonusAmount, now(), '推荐')

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


COMMENT ON FUNCTION f_player_recommend_award(siteCode VARCHAR, orderType VARCHAR,start_time VARCHAR, end_time VARCHAR) IS 'Fly - 玩家推荐奖励存储函数';