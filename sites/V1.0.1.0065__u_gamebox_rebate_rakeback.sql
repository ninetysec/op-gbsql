-- auto gen by tom 2016-03-16 11:51:24
CREATE OR REPLACE FUNCTION "gamebox_rebate_rakeback_map"(starttime timestamp, endtime timestamp)
  RETURNS "hstore" AS $BODY$

DECLARE
	rec record;
	sql TEXT:= '';
	key TEXT:= '';
	val TEXT:= '';
	hash hstore;
BEGIN
	raise info '统计玩家API返水';
	hash = '-1=>-1';
	sql = 'SELECT rp.player_id,
			 	  SUM(rp.rakeback_actual)	rakeback
			 FROM rakeback_bill rb
			 LEFT JOIN rakeback_player rp ON rb."id" = rp.rakeback_bill_id
			WHERE rb.start_time >= $1
			  AND rb.end_time <= $2
			  AND rp.settlement_state = ''lssuing''
			  AND rp.player_id IS NOT NULL
			GROUP BY rp.player_id';
	FOR rec IN EXECUTE sql USING startTime, endTime
	LOOP
		key = rec.player_id;
		val = key||'=>'||rec.rakeback;
		hash = hash||(SELECT val::hstore);
	END LOOP;
	-- raise info '玩家API返水 = %', hash;
	raise info '统计玩家API返水.完成';

	RETURN hash;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "gamebox_rebate_rakeback_map"(starttime timestamp, endtime timestamp) OWNER TO "postgres";

COMMENT ON FUNCTION "gamebox_rebate_rakeback_map"(starttime timestamp, endtime timestamp) IS 'Lins-返佣返水-返佣调用';
