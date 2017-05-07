-- auto gen by tom 2016-03-18 12:44:23
CREATE OR REPLACE FUNCTION "gamebox_rebate_api"(bill_id int4, start_time timestamp, end_time timestamp, gradshash "hstore", checkhash "hstore", mainhash "hstore", flag text)
  RETURNS "pg_catalog"."void" AS $BODY$

DECLARE
	rec 				record;
	rebate_value 		FLOAT:=0.00;--返佣.
	tmp 				int:=0;
	key_name 			TEXT:='';
	operation_occupy 	FLOAT:=0.00;
	col_split 			TEXT:='_';

BEGIN
  	raise info '计算各API各代理的盈亏总和';
	FOR rec IN
		--SELECT rab.agent_id, rab.player_id,rab.api_id,rab.api_type_id,rab.game_type,COUNT(DISTINCT rab.player_id)	as player_num,SUM(-rab.profit_loss)			as profit_loss,SUM(rab.effective_transaction)	as effective_transaction
		 -- FROM rakeback_api_base rab
 		 --WHERE rab.rakeback_time >= start_time
	 	 --  AND rab.rakeback_time < end_time
 		 --GROUP BY rab.agent_id, rab.player_id, rab.api_id, rab.api_type_id, rab.game_type
		SELECT su.owner_id as agent_id,
				po.player_id,
				po.api_id,
				po.api_type_id,
				po.game_type,
				po.effective_trade_amount as effective_transaction,
				(-po.profit_amount) as profit_loss
		   FROM (SELECT pgo.player_id,
						pgo.api_id,
						pgo.api_type_id,
						pgo.game_type,
						SUM(COALESCE(pgo.effective_trade_amount, 0.00))	as effective_trade_amount,
						SUM(COALESCE(pgo.profit_amount, 0.00))			as profit_amount
				   FROM player_game_order pgo
				  WHERE pgo.create_time >= start_time  and pgo.create_time <end_time
				  GROUP BY pgo.player_id, pgo.api_id, pgo.api_type_id, pgo.game_type) po
		   LEFT JOIN sys_user su ON po.player_id = su."id"
		   LEFT JOIN user_player up ON po.player_id = up."id"
		   LEFT JOIN user_agent ua ON su.owner_id = ua."id"
		  WHERE su.user_type = '24'


	LOOP
		--检查当前代理是否满足返佣梯度.
		IF isexists(checkhash, (rec.agent_id)::text) = false THEN
			CONTINUE;
		END IF;

		raise info '取得各API各分类佣金总和';
		key_name = rec.player_id||col_split||rec.api_id||col_split||rec.game_type;
		-- raise info 'key_name = %', key_name;
		operation_occupy = (mainhash->key_name)::FLOAT;
		operation_occupy = coalesce(operation_occupy, 0);
		SELECT gamebox_rebate_calculator(
			gradshash,
			checkhash,
			rec.agent_id,
			rec.api_id,
			rec.game_type,
			rec.profit_loss,
			operation_occupy
		) INTO rebate_value;

		--新增各API代理返佣:目前返佣不分正负都新增.
	  	IF flag='Y' THEN
			INSERT INTO rebate_api (
				rebate_bill_id, player_id, api_id, api_type_id, game_type,
				rebate_total, effective_transaction, profit_loss
			) VALUES (
				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,
				rebate_value, rec.effective_transaction, rec.profit_loss
			);
		 	SELECT currval(pg_get_serial_sequence('rebate_api', 'id')) INTO tmp;
		 	raise info '返拥API.键值:%', tmp;
		ELSEIF flag='N' THEN
			INSERT INTO rebate_api_nosettled (
				rebate_bill_nosettled_id, player_id, api_id, api_type_id, game_type,
				rebate_total, effective_transaction, profit_loss
			) VALUES(
				bill_id, rec.player_id, rec.api_id, rec.api_type_id, rec.game_type,
				rebate_value, rec.effective_transaction, rec.profit_loss
			);
		 	SELECT currval(pg_get_serial_sequence('rebate_api_nosettled', 'id')) INTO tmp;
		 	raise info '返拥API.键值:%',tmp;
		END IF;

	END LOOP;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "gamebox_rebate_api"(bill_id int4, start_time timestamp, end_time timestamp, gradshash "hstore", checkhash "hstore", mainhash "hstore", flag text) OWNER TO "postgres";

COMMENT ON FUNCTION "gamebox_rebate_api"(bill_id int4, start_time timestamp, end_time timestamp, gradshash "hstore", checkhash "hstore", mainhash "hstore", flag text) IS 'Lins-返佣-玩家API返佣';