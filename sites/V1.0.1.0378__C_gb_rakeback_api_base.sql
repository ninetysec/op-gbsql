-- auto gen by cherry 2017-01-17 15:20:25
DROP FUNCTION IF EXISTS gb_rakeback_api_base(INT, TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_rakeback_api_base(
	p_bill_id 	INT,
	p_settle_flag 	TEXT,
	p_start_time 	TIMESTAMP,
	p_end_time 	TIMESTAMP
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返水结算账单.API返水基础表
*/
DECLARE

	h_occupy_map 	hstore;		-- API占成梯度map
	--h_assume_map 	hstore;		-- 盈亏共担map

	--h_sys_config 	hstore;
	--sp 			TEXT:='@';
	--rs 			TEXT:='\~';
	--cs 			TEXT:='\^';
	b_meet_or_not 	BOOLEAN; --是否达到返水条件

	n_rakeback_set_id 	INT;
	n_audit_num 	numeric(20,2); --优惠稽核
	--v_rakeback_set_name 	TEXT:='';
	--n_valid_value 		FLOAT:=0.00;

	v_key_name 				TEXT:='';
	COL_SPLIT 			TEXT:='_';

	rec_player 	record;
	rec_api 	record;
	--rec_grad 	record;
	n_grad_id 	INT;
	--rec_grad_api 	record;
	n_grad_api_id 	INT;
	n_rakeback_ratio 	FLOAT := 0.00;

	n_player_id 	INT;
	v_player_name 	TEXT;
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
	n_rakeback_value 	FLOAT:=0.00;--代理API返水金额

BEGIN
	--取得系统变量
	--SELECT sys_config() INTO h_sys_config;
	--sp = h_sys_config->'sp_split';
	--rs = h_sys_config->'row_split';
	--cs = h_sys_config->'col_split';

	DELETE FROM rakeback_api_base WHERE rakeback_time >= p_start_time AND rakeback_time < p_end_time;

	--玩家循环
	FOR rec_player IN
		SELECT su."id" 									as player_id,
		       su.username 							as player_name,
		       up.rakeback_id 					as rakeback_id,
		       ua."id" 									as agent_id,
		       ua.username 							as agent_name,
		       ut."id" 									as topagent_id,
		       ut.username 							as topagent_name,
		       pgo.effective_transaction,
		       pgo.profit_amount
		  FROM
		(
		  SELECT player_id,
		         COALESCE( SUM(pg.effective_trade_amount), 0.00) as effective_transaction,
		         COALESCE( SUM(pg.profit_amount), 0.00)	as profit_amount
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
		 ORDER BY su."id"
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
				RAISE INFO '玩家ID: %, 名称: %，未设置返水方案！代理ID: %, 名称: %，亦未设置返水方案！', n_player_id, v_player_name, n_agent_id, v_agent_name;
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
				RAISE INFO '代理ID: %, 名称: %, 返水方案ID: %, 未达返水梯度！',
				           n_agent_id, v_agent_name, n_rakeback_set_id;
				--CONTINUE;
				b_meet_or_not = FALSE;
			END IF; --返水梯度

		END IF; --返水方案

		--玩家api循环
		FOR rec_api IN
			SELECT pgo.api_id,
			       pgo.game_type,
			       COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
			       COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount
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
			n_api_id 			= rec_api.api_id;
			v_game_type 		= rec_api.game_type;
			n_effective_transaction 	= rec_api.effective_transaction;
			n_profit_amount 	= rec_api.profit_amount;

			n_grad_api_id = NULL;
			n_rakeback_ratio = 0.00;

			n_rakeback_value = 0.00;

			IF b_meet_or_not THEN
				--取得返水比率
				SELECT rga.id AS grads_api_id, --返水梯度API比率ID
				       rga.ratio 				--API返水比例
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
			--	n_rakeback_value = rec_grad.max_rakeback;
			--END IF;

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

		END LOOP;
	END LOOP;
END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_api_base(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-返水结算账单.代理API返水';