-- auto gen by bruce 2016-06-16 14:45:01
DROP FUNCTION IF EXISTS gamebox_occupy_api(INT, TIMESTAMP, TIMESTAMP, hstore, hstore, hstore, hstore, hstore);
create or replace function gamebox_occupy_api(
	bill_id 				INT,
	start_time 				TIMESTAMP,
	end_time 				TIMESTAMP,
	occupy_grads_map 		hstore,
	operation_occupy_map 	hstore,
	rakeback_map 			hstore,
	rebate_grads_map 		hstore,
	agent_check_map 		hstore
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：返佣-统计各玩家API返佣
--v1.01  2016/06/14  Leisure  从原始表取各API各代理的盈亏总和
*/
DECLARE
	rec 				record;
	rakeback 			FLOAT:=0.00;--返水.
	rebate_value 		FLOAT:=0.00;--返佣.
	occupy_value 		FLOAT:=0.00;--占成.
	operation_occupy 	FLOAT:=0.00;--运营商API占成额

	tmp 				int:=0;
	keyname 			TEXT:='';
	col_split 			TEXT:='_';
	pending_lssuing 	text:='pending_lssuing';
	pending_pay 		text:='pending_pay';

BEGIN
	raise info '计算各API各代理的盈亏总和';
	FOR rec IN

	/*
		SELECT rab.top_agent_id,
			   rab.agent_id,
			   rab.player_id,
			   rab.api_id,
			   rab.api_type_id,
			   rab.game_type,
			   SUM(-rab.profit_loss)			as profit_loss,
			   SUM(rab.effective_transaction)	as effective_transaction
		  FROM rakeback_api_base rab
		 WHERE rab.rakeback_time >= start_time
		   AND rab.rakeback_time < end_time
 		 GROUP BY rab.top_agent_id, rab.agent_id, rab.player_id, rab.api_id, rab.api_type_id, rab.game_type
		*/
		SELECT
				 ua.parent_id		top_agent_id,
				 ua."id"		agent_id,
				 po.player_id,
				 po.api_id,
				 po.api_type_id,
				 po.game_type,
				 po.profit_loss,
				 po.effective_transaction
			FROM(SELECT
							 pgo.player_id,
							 pgo.api_id,
							 pgo.api_type_id,
							 pgo.game_type,
							 -SUM(pgo.profit_amount)			as profit_loss,
							 SUM(pgo.effective_trade_amount)	as effective_transaction
						 FROM player_game_order pgo
						WHERE pgo.bet_time >= start_time
							AND pgo.bet_time < end_time
						GROUP BY  pgo.player_id, pgo.api_id, pgo.api_type_id, pgo.game_type) po
					LEFT JOIN sys_user su ON po.player_id = su."id"
					LEFT JOIN user_agent ua ON su.owner_id = ua."id"
		 WHERE su.user_type = '24'
  LOOP
		keyname = rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
		operation_occupy = (operation_occupy_map->keyname)::FLOAT;

		SELECT gamebox_rebate_calculator(
			rebate_grads_map,
			agent_check_map,
			rec.agent_id,
			rec.api_id,
			rec.game_type,
			rec.profit_loss,
			operation_occupy
		) INTO rebate_value;

		--取得各API占成
		SELECT gamebox_occupy_api_calculator(
			occupy_grads_map,
			operation_occupy_map,
			rec.top_agent_id,
			rec.player_id,
			rec.api_id,
			rec.game_type,
			rec.profit_loss
		) into occupy_value;

		rakeback = 0.00;
		IF isexists(rakeback_map, keyname) THEN
			rakeback = (rakeback_map->keyname)::FLOAT;
		END IF;
		INSERT INTO occupy_api (
			occupy_bill_id, player_id, api_id, game_type, api_type_id,
			occupy_total, effective_transaction, profit_loss, rakeback, rebate
		) VALUES(
			bill_id, rec.player_id, rec.api_id, rec.game_type, rec.api_type_id, occupy_value,
			rec.effective_transaction, rec.profit_loss, rakeback, rebate_value
		);
		SELECT currval(pg_get_serial_sequence('occupy_api', 'id')) into tmp;
		-- raise info '总代占成.API键值:%',tmp;
	END LOOP;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_api(bill_id INT, start_time TIMESTAMP, end_time TIMESTAMP, occupy_grads_map hstore, operation_occupy_map hstore, rakeback_map hstore, rebate_grads_map hstore, agent_check_map hstore)
IS 'Lins-返佣-统计各玩家API返佣';

DROP FUNCTION IF EXISTS f_player_recommend_award(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS f_player_recommend_award(VARCHAR, VARCHAR, VARCHAR, VARCHAR);
CREATE OR REPLACE FUNCTION f_player_recommend_award (
	siteCode VARCHAR,		-- 站点代码
	orderType VARCHAR,		-- 订单类型: 01-充值, 02-优惠, 03-游戏API, 04-返水, 05-返佣, 06-玩家取款, 07-代理提现, 08-转账
	start_time VARCHAR,
	end_time VARCHAR
)
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Fei      创建此函数：玩家推荐奖励存储函数
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
						fund_type, transaction_way, transaction_data)
					VALUES (
						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id),
						transStatus,rec.recommend_id, (SELECT id FROM award1), rewardPoint, false, false,
						fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referee||'"}');
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
						fund_type, transaction_way, transaction_data)
					VALUES (
						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.berecommend_id),
						transStatus, rec.berecommend_id, (SELECT id FROM award2), rewardPoint, false, false,
						fundType, single, '{"username":"'||rec.recommend_name||'","rewardType":"'||referen||'"}');
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
						fund_type, transaction_way, transaction_data)
					VALUES (
						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id),
						transStatus, rec.recommend_id, (SELECT id FROM award), rewardPoint, false, false,
						fundType, single, '{"username":"'||rec.berecommend_name||'","rewardType":"'||referee||'"}');
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
						fund_type, transaction_way, transaction_data)
					VALUES (
						orderNo, now(), transType, '推荐奖励-单次', rewardAmount, rewardAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.berecommend_id),
						transStatus, rec.berecommend_id, (SELECT id FROM award), rewardPoint, false, false,
						fundType, single, '{"username":"'||rec.recommend_name||'","rewardType":"'||referen||'"}');
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
							fund_type, transaction_way, transaction_data)
						VALUES (
							orderNo, now(), transType, '推荐奖励-红利', bonusAmount, bonusAmount + (SELECT wallet_balance FROM user_player WHERE id = rec.recommend_id),
							transStatus, rec.recommend_id, (SELECT id FROM award), bonusPoint, false, false,
							fundType, bonus, '{"username":"'||rec.recommend_name||'"}');
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
LANGUAGE 'plpgsql';

COMMENT ON FUNCTION f_player_recommend_award(siteCode VARCHAR, orderType VARCHAR, start_time VARCHAR, end_time VARCHAR) IS 'Fly - 玩家推荐奖励存储函数';

drop function if exists gamebox_expense_gather(TIMESTAMP, TIMESTAMP);
create or replace function gamebox_expense_gather(
	startTime 	TIMESTAMP,
	endTime 	TIMESTAMP
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：分摊费用
--v1.01  2016/06/15  Leisure  追加返回值判空逻辑
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
		 WHERE rb.start_time >= startTime
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
END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_gather(start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Lins-分摊费用';

drop function if exists gamebox_expense_map(TIMESTAMP, TIMESTAMP, hstore);
create or replace function gamebox_expense_map(
	start_time 	TIMESTAMP,
	end_time 	TIMESTAMP,
	sys_map 	hstore
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：返佣-其它费用.外调
--v1.01  2016/06/09  Leisure  增加上期未结费用计算
--v1.02  2016/06/15  Leisure  调整返回值
*/
DECLARE
	cost_map 	hstore;
	share_map 	hstore;
	leaving_map		hstore; --v1.01  2016/06/29  Leisure
	sid INT;
BEGIN
	SELECT gamebox_expense_gather(start_time, end_time) INTO cost_map;

	SELECT gamebox_expense_share(cost_map, sys_map) INTO share_map;

	--v1.01  2016/06/29  Leisure
	SELECT gamebox_expense_leaving(start_time, end_time) INTO leaving_map;


	SELECT gamebox_current_site() INTO sid;
	--share_map = (SELECT ('site_id=>'||sid)::hstore)||share_map;

	--raise info 'cost_map : %, share_map : % , leaving_map, %', cost_map, share_map, leaving_map;

	RETURN (SELECT ('site_id=>'||sid)::hstore)||cost_map||share_map||leaving_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_expense_map(start_time TIMESTAMP, end_time TIMESTAMP, sys_map hstore)
IS 'Lins-返佣-其它费用.外调';

DROP FUNCTION IF EXISTS gamebox_rebate_map(TIMESTAMP, TIMESTAMP);
create or replace function gamebox_rebate_map(
	startTime 				TIMESTAMP,
	endTime 				TIMESTAMP
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：分摊费用
--v1.01  2016/06/15  Leisure  追加返回值判空逻辑
*/
DECLARE
	rec 				record;
	rebate 				FLOAT:=0.00;--返佣.
	key_name 			TEXT;--运营商占成KEY值.
	rebate_map 			hstore;--各API返佣值.
	col_split 			TEXT:='_';
BEGIN
	FOR rec IN
		SELECT ra.api_id, ra.game_type, SUM(ra.rebate_total) rebate_total
		  FROM rebate_api ra
		  LEFT JOIN rebate_bill rb ON ra.rebate_bill_id = rb."id"
		 WHERE rb.start_time >= startTime
		   AND rb.end_time <= endTime
		 GROUP BY ra.api_id, ra.game_type
		 ORDER BY ra.api_id
	LOOP
		key_name = rec.api_id||col_split||rec.game_type;
		rebate = rec.rebate_total;

		IF rebate_map is null THEN
			SELECT key_name||'=>'||rebate INTO rebate_map;
		ELSEIF exist(rebate_map, key_name) THEN
			rebate = rebate + ((rebate_map->key_name)::FLOAT);
			rebate_map = rebate_map||(SELECT (key_name||'=>'||rebate)::hstore);
		ELSE
			rebate_map = (SELECT (key_name||'=>'||rebate)::hstore)||rebate_map;
		END IF;
	END LOOP;

	RETURN coalesce(rebate_map, '');

END

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_map(start_time TIMESTAMP, end_time TIMESTAMP)
IS 'Lins-返佣-API返佣-外调';