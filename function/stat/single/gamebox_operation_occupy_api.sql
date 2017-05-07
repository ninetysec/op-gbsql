/**
 * Lins-站点账务-API游标.
 * @author 	Lins
 * @date 	2015.12.2
 * @param 	url 	站点库Dblink.
 * @param 	start_time 	周期开始时间(yyyy-mm-dd HH24:mm:ss)
 * @param 	end_time 	周期结束时间(yyyy-mm-dd HH24:mm:ss)
**/
DROP FUNCTION IF EXISTS gamebox_operation_occupy_api(TEXT, TEXT, TEXT);
create or replace function gamebox_operation_occupy_api(
	url 		TEXT,
	start_time 	TEXT,
	end_time 	TEXT
) returns refcursor as $$
DECLARE
	cur refcursor;
BEGIN
    OPEN cur FOR
    	SELECT * FROM dblink(
    		url,
    		'SELECT o.api_id,
    				o.game_type,
    				COALESCE(sum(-o.profit_amount), 0.00) 			as profit_amount,
    				COALESCE(sum(o.effective_trade_amount), 0.00)  	as trade_amount
			   FROM player_game_order o
			  WHERE o.create_time >='''||start_time||'''
				AND o.create_time < '''||end_time||'''
			  GROUP BY o.api_id, o.game_type '
		) as p(api_id INT, game_type VARCHAR, profit_amount NUMERIC, trade_amount NUMERIC);
	return cur;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_operation_occupy_api(conn_name TEXT, start_time TEXT, end_time TEXT)
IS 'Lins-站点账务-API游标';