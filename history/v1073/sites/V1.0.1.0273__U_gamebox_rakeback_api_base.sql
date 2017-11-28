-- auto gen by bruce 2016-10-02 11:03:14
DROP FUNCTION IF EXISTS gamebox_rakeback_api_base(TIMESTAMP);
create or replace function gamebox_rakeback_api_base(
	p_rakeback_time 	TIMESTAMP
) returns void as $$
/*版本更新说明
--版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 返水-各玩家API返水基础表.入口
--v1.01  2016/05/12  Leisure  交易时间由create_time改为bet_time
--v1.02  2016/08/01  Leisure  取消当前日期是否有返水活动判断
--v1.03  2016/09/28  Leisure  交易时间由bet_time改为payout_time
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
		             WHERE pgo.order_state = 'settle'
		               AND pgo.is_profit_loss = TRUE
		               --v1.03  2016/09/28  Leisure
		               AND payout_time >= p_rakeback_time
		               AND payout_time < p_rakeback_time + '24hour'
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