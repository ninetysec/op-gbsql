-- auto gen by admin 2016-04-19 21:06:08
/**
 * 返水插入与更新数据.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	周期数.
 * @param 	返水周期开始时间(yyyy-mm-dd)
 * @param 	返水周期结束时间(yyyy-mm-dd)
 * @param 	返水键值
 * @param 	操作类型.I:新增.U:更新.
 * @param 	出账标示:Y.已出账, N.未出账
 */
DROP FUNCTION IF EXISTS gamebox_rakeback_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rakeback_bill (
	name 			TEXT,
	start_time 		TIMESTAMP,
	end_time 		TIMESTAMP,
	INOUT bill_id 	INT,
	op 				TEXT,
	flag 			TEXT
) returns INT as $$
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
			);
			SELECT currval(pg_get_serial_sequence('rakeback_bill',  'id')) into bill_id;
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
			ELSE
				DELETE FROM rakeback_bill WHERE id = bill_id;
			END IF;
		END IF;

	ELSEIF flag='N' THEN--未出账

		IF op='I' THEN
			--先插入返水总记录并取得键值.
			INSERT INTO rakeback_bill_nosettled (
			 	start_time, end_time, rakeback_total, create_time
			) VALUES (
			 	start_time, end_time, 0, now()
			);
			SELECT currval(pg_get_serial_sequence('rakeback_bill_nosettled', 'id')) into bill_id;
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
			ELSE
				DELETE FROM rakeback_bill_nosettled WHERE id = bill_id;
			END IF;
		END IF;

	END IF;
	raise info 'rakeback_bill.完成.键值:%', bill_id;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, bill_id INT, op TEXT, flag TEXT)
IS 'Lins-返水-返水周期主表';

/**
 * 返佣插入与更新数据.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	name 		周期数.
 * @param 	start_time 	返佣周期开始时间(yyyy-mm-dd)
 * @param 	end_time 	返佣周期结束时间(yyyy-mm-dd)
 * @param 	bill_id 	返佣键值
 * @param 	op 			操作类型: I-新增, U-更新.
 * @param 	flag 		出账标示: Y-已出账, N-未出账
 */
DROP FUNCTION IF EXISTS gamebox_rebate_bill(TEXT, TIMESTAMP, TIMESTAMP, INT, TEXT, TEXT);
create or replace function gamebox_rebate_bill(
    name 			TEXT,
    start_time 		TIMESTAMP,
    end_time 		TIMESTAMP,
    INOUT bill_id 	INT,
    op 				TEXT,
    flag 			TEXT
)
  returns INT as $$

DECLARE
	rec 		record;
	pending_pay text:='pending_pay';
	key_id 		INT;
    ra_count    INT:=0; -- rebate_agent 条数

BEGIN
	IF flag='Y' THEN 	--已出账
		IF op='I' THEN
			INSERT INTO rebate_bill (
				period, start_time, end_time,
				agent_count, agent_lssuing_count, agent_reject_count, rebate_total, rebate_actual,
				last_operate_time, create_time, lssuing_state
			) VALUES (
				name, start_time, end_time,
				0, 0, 0, 0, 0,
				now(), now(), pending_pay
			);
			SELECT currval(pg_get_serial_sequence('rebate_bill', 'id')) INTO bill_id;
			raise info 'rebate_bill.完成.Y键值:%', bill_id;
		ELSE
            SELECT COUNT(1) FROM rebate_agent WHERE rebate_bill_id = bill_id INTO ra_count;
            IF ra_count > 0 THEN
    			FOR rec in
    				SELECT rebate_bill_id,
    					   COUNT(DISTINCT agent_id) 	agent_num,
    					   SUM(effective_transaction) 	effective_transaction,
    					   SUM(profit_loss) 			profit_loss,
    					   SUM(rakeback) 				rakeback,
    					   SUM(rebate_total) 			rebate_total,
    					   SUM(refund_fee) 				refund_fee,
    					   SUM(recommend) 				recommend,
    					   SUM(preferential_value) 		preferential_value,
    					   SUM(apportion) 				apportion
    				  FROM rebate_agent
    				 WHERE rebate_bill_id = bill_id
    				 GROUP BY rebate_bill_id
    			LOOP
    				UPDATE rebate_bill SET
    					   agent_count 				= rec.agent_num,
    					   rebate_total 			= rec.rebate_total,
    					   effective_transaction 	= rec.effective_transaction,
    					   profit_loss 				= rec.profit_loss,
    					   rakeback 				= rec.rakeback,
    					   refund_fee 				= rec.refund_fee,
    					   recommend 				= rec.recommend,
    					   preferential_value 		= rec.preferential_value,
    					   apportion 				= rec.apportion
    				 WHERE id = rec.rebate_bill_id;
    			END LOOP;
            ELSE
                DELETE FROM rebate_bill WHERE id = bill_id;
            END IF;
		END IF;

	ELSEIF flag = 'N' THEN 	--未出账
		IF op='I' THEN
			INSERT INTO rebate_bill_nosettled (
				start_time, end_time, create_time,
				rebate_total, effective_transaction, profit_loss, refund_fee,
				recommend, preferential_value, apportion, rakeback
			) VALUES (
				start_time, end_time, now(),
				0, 0, 0, 0,
				0, 0, 0, 0
			);
			SELECT currval(pg_get_serial_sequence('rebate_bill_nosettled', 'id')) INTO bill_id;
			raise info 'rebate_bill_nosettled.完成.N键值:%', bill_id;
		ELSE
            SELECT COUNT(1) FROM rebate_agent_nosettled WHERE rebate_bill_nosettled_id = bill_id INTO ra_count;
            IF ra_count > 0 THEN
    			FOR rec IN
    				SELECT rebate_bill_nosettled_id,
    					   SUM(effective_transaction) 	effective_transaction,
    					   SUM(profit_loss) 			profit_loss,
    					   SUM(rakeback) 				rakeback,
    					   SUM(rebate_total) 			rebate_total,
    					   SUM(refund_fee) 				refund_fee,
    					   SUM(recommend) 				recommend,
    					   SUM(preferential_value) 		preferential_value,
    					   SUM(apportion) apportion
    				  FROM rebate_agent_nosettled
    				 WHERE rebate_bill_nosettled_id = bill_id
    				 GROUP BY rebate_bill_nosettled_id
    			LOOP
    				UPDATE rebate_bill_nosettled SET
    					   rebate_total				= rec.rebate_total,
    					   effective_transaction	= rec.effective_transaction,
    					   profit_loss			 	= rec.profit_loss,
    					   rakeback 				= rec.rakeback,
    					   refund_fee 				= rec.refund_fee,
    					   recommend 				= rec.recommend,
    					   preferential_value 		= rec.preferential_value,
    					   apportion 				= rec.apportion
    				 WHERE id = rec.rebate_bill_nosettled_id;
    			END LOOP;
            ELSE
                DELETE FROM rebate_bill_nosettled WHERE id = bill_id;
            END IF;
		END IF;

	END IF;

	RETURN;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_bill(name TEXT, start_time TIMESTAMP, end_time TIMESTAMP, bill_id INT, op TEXT, flag TEXT)
IS 'Lins-返佣-返佣周期主表';

-- 推荐奖励计划任务
DROP FUNCTION IF EXISTS f_player_recommend_award(VARCHAR, VARCHAR);
/**
 * 玩家推荐奖励存储函数
 * @author: Fly
 * @date: 2015-12-18
 */
CREATE OR REPLACE FUNCTION f_player_recommend_award (
	siteCode VARCHAR,		-- 站点代码
	orderType VARCHAR		-- 订单类型: 01-充值, 02-优惠, 03-游戏API, 04-返水, 05-返佣, 06-玩家取款, 07-代理提现, 08-转账
)
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
				/* 去除已奖励的玩家 */
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
				/* 被推荐人满足交易量 */
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
					/** 奖励推荐人 */
					WITH award1 AS (
						-- 新增推荐记录数据
						INSERT INTO player_recommend_award (transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)
						VALUES (orderNo,
							rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '推荐')
						RETURNING id
					)
					-- 新增交易订单数据
					INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id,
						effective_transaction, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data)
					VALUES (orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id), transStatus,
						rec.recommend_id, (SELECT id FROM award1), rec.trade_amount, rewardPoint, false, false, fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referee||'"}');
					-- 修改玩家余额
					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.recommend_id;

					/** 奖励被推荐人 */
					orderNo := (SELECT f_order_no(siteCode, orderType));
					WITH award2 AS (
						-- 新增推荐记录数据
						INSERT INTO player_recommend_award (transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)
						VALUES (orderNo,
							rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '被推荐')
						RETURNING id
					)
					-- 新增交易订单数据
					INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id,
						effective_transaction, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data)
					VALUES (orderNo,
						now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.berecommend_id), transStatus,
						rec.berecommend_id, (SELECT id FROM award2), rec.trade_amount, rewardPoint, false, false, fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referen||'"}');
					-- 修改玩家余额
					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.berecommend_id;

				ELSEIF rewardWay = '2' THEN 	-- 奖励推荐人
					orderNo := (SELECT f_order_no(siteCode, orderType));
					WITH award AS (
						-- 新增推荐记录数据
						INSERT INTO player_recommend_award (transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)
						VALUES (orderNo,
							rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '推荐')
						RETURNING id
					)
					-- 新增交易订单数据
					INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id,
						effective_transaction, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data)
					VALUES (orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id), transStatus,
						rec.recommend_id, (SELECT id FROM award), rec.trade_amount, rewardPoint, false, false, fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referee||'"}');
					-- 修改玩家余额
					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.recommend_id;

				ELSEIF rewardWay = '3' THEN	-- 奖励被推荐人
					orderNo := (SELECT f_order_no(siteCode, orderType));
					WITH award AS (
						-- 新增推荐记录数据
						INSERT INTO player_recommend_award (transaction_no, user_id, user_name, recommend_user_id, recommend_user_name, reward_mode, reward_amount, reward_time, reward_reason)
						VALUES (orderNo,
							rec.recommend_id, rec.recommend_name, rec.berecommend_id, rec.berecommend_name, single, rewardAmount, now(), '被推荐')
						RETURNING id
					)
					-- 新增交易订单数据
					INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id,
						effective_transaction, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data)
					VALUES (orderNo,
						now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.berecommend_id), transStatus,
						rec.berecommend_id, (SELECT id FROM award), rec.trade_amount, rewardPoint, false, false, fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referen||'"}');
					-- 修改玩家余额
					UPDATE user_player SET wallet_balance = wallet_balance + rewardAmount WHERE id = rec.berecommend_id;

				END IF;

			END LOOP;

	END IF;

	IF bonusReward THEN 	--推荐红利

		FOR rec IN
			SELECT up.recommend_user_id recommend_id,
				   su.username 			recommend_name,
				   COUNT(DISTINCT pgo.player_id) 	recommend_total,
				   SUM(pgo.effective_trade_amount) 	trade_amount
			  FROM user_player up
		 	  LEFT JOIN sys_user su ON up.recommend_user_id = su."id"
			  LEFT JOIN player_game_order pgo ON up."id" = pgo.player_id
		 	 WHERE recommend_user_id IS NOT NULL
		 	   AND to_char(pgo.create_time, 'yyyy-MM-dd') = to_char((CURRENT_DATE - INTERVAL '1 day'), 'yyyy-MM-dd')
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
							INSERT INTO player_recommend_award (transaction_no, user_id, user_name, reward_mode, reward_amount, reward_time, reward_reason)
							VALUES (orderNo,
								rec.recommend_id, rec.recommend_name, bonus, bonusAmount, now(), '推荐')
							RETURNING id
						)
						-- 新增交易订单数据
						INSERT INTO player_transaction (transaction_no, create_time, transaction_type, remark, transaction_money, balance, status, player_id, source_id,
							effective_transaction, favorable_audit_points, is_satisfy_audit, is_clear_audit, fund_type, transaction_way, transaction_data)
						VALUES (orderNo, now(), transType, '推荐奖励-红利', bonusAmount, bonusAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id), transStatus,
							rec.recommend_id, (SELECT id FROM award), rec.trade_amount, bonusPoint, false, false, fundType, bonus, '{"username":"'||rec.recommend_name||'"}');
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
LANGUAGE 'plpgsql' VOLATILE;

ALTER FUNCTION f_player_recommend_award(siteCode VARCHAR, orderType VARCHAR) OWNER TO "postgres";
COMMENT ON FUNCTION f_player_recommend_award(siteCode VARCHAR, orderType VARCHAR) IS 'Fly - 玩家推荐奖励存储函数';