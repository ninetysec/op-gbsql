-- auto gen by cherry 2016-10-25 20:52:46
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
--v10.3  2016/10/25  Leisure  修正梯度判断，由“>”改为“>=”
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

DROP FUNCTION IF EXISTS gamebox_rebate_map(TIMESTAMP, TIMESTAMP);
create or replace function gamebox_rebate_map(
	startTime 				TIMESTAMP,
	endTime 				TIMESTAMP
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 分摊费用
--v1.01  2016/06/15  Leisure  追加返回值判空逻辑
--v1.02  2016/10/25  Leisure  改为从rebate_agent_api获取
*/
DECLARE
	rec 				record;
	rebate 				FLOAT:=0.00;--返佣.
	key_name 			TEXT;--运营商占成KEY值.
	rebate_map 			hstore;--各API返佣值.
	col_split 			TEXT:='_';
BEGIN
	FOR rec IN
		--v1.02  2016/10/25  Leisure
		--SELECT ra.api_id, ra.game_type, SUM(ra.rebate_total) rebate_total
		--  FROM rebate_api ra
		SELECT ra.api_id, ra.game_type, SUM(ra.rebate_value) rebate_total
		  FROM rebate_agent_api ra
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