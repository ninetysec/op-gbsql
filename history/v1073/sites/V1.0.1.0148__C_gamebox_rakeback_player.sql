-- auto gen by admin 2016-05-17 20:23:13
DROP FUNCTION IF EXISTS gamebox_rakeback_player(INT, TEXT);
create or replace function gamebox_rakeback_player(
	bill_id INT,
	flag TEXT
) returns void as $$

/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：返水-各玩家返水
--v1.01  2016/05/16  Leisure  插入rekeback增加audit_num字段
*/

DECLARE
	rec 				record;
	pending_lssuing 	text:='pending_lssuing';
	pending_pay 		text:='pending_pay';
	max_back_water 		float:=0.00; -- 返水上限
	backwater 			float:=0.00;
	gradshash 			hstore;
	agenthash 			hstore;
  n_audit_num     numeric(20,2);
BEGIN
	raise info '取得当前返水梯度设置信息.';
 	SELECT gamebox_rakeback_api_grads() into gradshash;
 	raise info '取得代理返水设置.';
 	SELECT gamebox_agent_rakeback() 	into agenthash;

	IF flag = 'Y' THEN--已出账
		FOR rec IN
			SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
				   s.rakeback, pending_lssuing, u.agent_id, u.topagent_id, up.rakeback_id, s.effTrans
		  	  FROM ( SELECT player_id,
						    SUM(rakeback) rakeback,
							SUM(effective_transaction) effTrans
					   FROM rakeback_api
					  WHERE rakeback_bill_id = bill_id
					  GROUP BY player_id) s,
		  	   	   v_sys_user_tier u,
				   user_player up
		 	 WHERE s.player_id = u.id
			   AND s.player_id = up."id"
			 ORDER BY u.id, s.effTrans asc
		LOOP
			SELECT gamebox_rakeback_limit(rec.rakeback_id, gradshash, agenthash, rec.effTrans) into max_back_water;
			backwater = rec.rakeback;
			-- max_back_water 为0表示未设置返水上限
			IF backwater > max_back_water AND max_back_water<>0 THEN
				backwater = max_back_water;
			END IF;

			SELECT r.audit_num
			  INTO n_audit_num
				FROM user_player u,
						 rakeback_set r
			 WHERE u.rakeback_id = r."id"
				 AND u."id" = rec."id";

			n_audit_num := coalesce(n_audit_num, 0.00);

			INSERT INTO rakeback_player(
				rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker,
				rakeback_total, rakeback_actual, settlement_state, agent_id, top_agent_id, audit_num
			) VALUES (
				bill_id, rec.id, rec.username, rec.rank_id, rec.rank_name, rec.risk_marker,
				backwater, backwater, pending_lssuing, rec.agent_id, rec.topagent_id, n_audit_num
			);
		END LOOP;

	ELSEIF flag = 'N' THEN--未出账
		FOR rec IN
			SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
				   s.rakeback, u.agent_id, u.topagent_id, up.rakeback_id, s.effTrans
		  	  FROM ( SELECT player_id,
						    SUM(rakeback) rakeback,
							SUM(effective_transaction) effTrans
					   FROM rakeback_api_nosettled
					  WHERE rakeback_bill_nosettled_id = bill_id
					  GROUP BY player_id) s,
		  	   	   v_sys_user_tier u, user_player up
		 	 WHERE s.player_id = u.id
			   AND s.player_id = up."id"

		LOOP
			SELECT gamebox_rakeback_limit(rec.rakeback_id, gradshash, agenthash, rec.effTrans) into max_back_water;
			backwater = rec.rakeback;
			IF backwater > max_back_water AND max_back_water <> 0 THEN
				backwater = max_back_water;
			END IF;

			SELECT r.audit_num
			  INTO n_audit_num
				FROM user_player u,
						 rakeback_set r
			 WHERE u.rakeback_id = r."id"
				 AND u."id" = rec."id";

			n_audit_num := coalesce(n_audit_num, 0.00);

			INSERT INTO rakeback_player_nosettled (
				rakeback_bill_nosettled_id, player_id, username, rank_id, rank_name, risk_marker,
				rakeback_total, agent_id, top_agent_id, audit_num
			) VALUES (
				bill_id, rec.id, rec.username, rec.rank_id, rec.rank_name, rec.risk_marker,
				backwater, rec.agent_id, rec.topagent_id, n_audit_num
			);
		END LOOP;
	END IF;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_player(bill_id INT, flag TEXT)
IS 'Lins-返水-各玩家返水';
