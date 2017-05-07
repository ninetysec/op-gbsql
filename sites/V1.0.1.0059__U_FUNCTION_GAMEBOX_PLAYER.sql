-- auto gen by tom 2016-03-14 15:49:39

CREATE OR REPLACE FUNCTION "gamebox_rakeback_player"(bill_id int4, flag text)
  RETURNS "pg_catalog"."void" AS $BODY$
DECLARE
	rec 				record;
	pending_lssuing 	text:='pending_lssuing';
	pending_pay 		text:='pending_pay';
	max_back_water 		float:=0.00; -- 返水上限
	backwater 			float:=0.00;
	gradshash 			hstore;
	agenthash 			hstore;
BEGIN
	raise info '取得当前返水梯度设置信息.';
  	SELECT gamebox_rakeback_api_grads() into gradshash;
  	raise info '取得代理返水设置.';
  	SELECT gamebox_agent_rakeback() 	into agenthash;

	IF flag = 'Y' THEN--已出账
		FOR rec IN
			SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
				   s.rakeback, pending_lssuing, u.agent_id, u.topagent_id, up.rakeback_id,s.effTrans
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
        order by u.id,s.effTrans asc

		LOOP
					SELECT gamebox_rakeback_limit(rec.rakeback_id, gradshash, agenthash,rec.effTrans) into max_back_water;
					backwater = rec.rakeback;
          raise info 'max_back_water 为0表示未设置返水上限';
					IF backwater > max_back_water  and max_back_water<>0  THEN
						backwater = max_back_water;
					END IF;
					INSERT INTO rakeback_player(
						rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker,
						rakeback_total, rakeback_actual, settlement_state, agent_id, top_agent_id
					) VALUES (
						bill_id, rec.id, rec.username, rec.rank_id, rec.rank_name, rec.risk_marker,
						backwater, backwater, pending_lssuing, rec.agent_id, rec.topagent_id
					);
		END LOOP;
	ELSEIF flag = 'N' THEN--未出账
		FOR rec IN
			SELECT bill_id, u.id, u.username, u.rank_id, u.rank_name, u.risk_marker,
				   s.rakeback, u.agent_id, u.topagent_id, up.rakeback_id
		  	  FROM ( SELECT player_id,
						    SUM(rakeback) rakeback
					   FROM rakeback_api_nosettled
					  WHERE rakeback_bill_nosettled_id = bill_id
					  GROUP BY player_id) s,
		  	   	   v_sys_user_tier u,
				   user_player up
		 	 WHERE s.player_id = u.id
			   AND s.player_id = up."id"
		LOOP
			SELECT gamebox_rakeback_limit(rec.rakeback_id, gradshash, agenthash) into max_back_water;
			backwater = rec.rakeback;
      raise info 'max_back_water 为0表示未设置返水上限';
			IF backwater > max_back_water  and max_back_water<>0  THEN
				backwater = max_back_water;
			END IF;
			INSERT INTO rakeback_player_nosettled (
				rakeback_bill_nosettled_id, player_id, username, rank_id, rank_name, risk_marker,
				rakeback_total, agent_id, top_agent_id
			) VALUES (
				bill_id, rec.id, rec.username, rec.rank_id, rec.rank_name, rec.risk_marker,
				backwater, rec.agent_id, rec.topagent_id
			);
		END LOOP;
	END IF;
raise info 'xx%xx.','finish';
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "gamebox_rakeback_player"(bill_id int4, flag text) OWNER TO "postgres";

COMMENT ON FUNCTION "gamebox_rakeback_player"(bill_id int4, flag text) IS 'Lins-返水-各玩家返水';