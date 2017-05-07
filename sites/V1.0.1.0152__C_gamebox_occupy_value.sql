-- auto gen by admin 2016-05-20 15:37:55
DROP FUNCTION IF EXISTS gamebox_occupy_value(TIMESTAMP, TIMESTAMP, hstore);
create or replace function gamebox_occupy_value(
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	expense_map hstore
) returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数：总代占成-当前周期的返佣
--v1.01  2016/05/12  Leisure  当期返佣的逻辑修正为，所有当前周期内审核通过的返佣
--v1.02  2016/05/12  Leisure  修正分组统计的SQL
--v1.03  2016/05/20  Leisure  占成金额取实付金额（by Acheng）
*/
DECLARE
	rec 		record;
	key_name 	TEXT:='';
	param 		TEXT:='';
	name 		TEXT:='';

	sys_config 	hstore;
	sp 			TEXT:='@';
	rs 			TEXT:='\~';
	cs 			TEXT:='\^';
BEGIN
	--取得系统变量
	SELECT sys_config() INTO sys_config;
	sp = sys_config->'sp_split';
	rs = sys_config->'row_split';
	cs = sys_config->'col_split';
/*
FOR rec IN EXECUTE
	'SELECT ut."id"  as topagent_id,
					ut.username  as name,
					SUM (rp.rebate_total)  as rebate_total
		 FROM rebate_bill rb
		 LEFT JOIN rebate_agent ra ON rb."id" = ra.rebate_bill_id
		 LEFT JOIN rebate_player rp ON rb."id" = rp.rebate_bill_id
		 LEFT JOIN sys_user su ON rp.user_id = su."id"
		 LEFT JOIN sys_user ua ON su.owner_id = ua."id"
		 LEFT JOIN sys_user ut ON ua.owner_id = ut."id"
		WHERE rb.settlement_time >= $1
			AND rb.settlement_time < $2
			AND ra.settlement_state = ''lssuing''
			AND su.user_type = ''24''
			AND ua.user_type = ''23''
			AND ut.user_type = ''22''
		GROUP BY ut."id", ut.username'
*/--v1.02
	FOR rec IN EXECUTE
		'SELECT ut."id"  as topagent_id,
		        ut.username  as name,
		        SUM (ra.rebate_actual)  as rebate_total
		   FROM rebate_agent ra, sys_user ua, sys_user ut
		  WHERE ra.agent_id = ua."id"
		    AND ua.owner_id = ut."id"
		    AND ua.user_type = ''23''
		    AND ut.user_type = ''22''
		    AND ra.settlement_time >= $1
		    AND ra.settlement_time < $2
		    AND ra.settlement_state = ''lssuing''
		  GROUP BY ut.id, ut.username'
		USING start_time, end_time
	LOOP
		key_name = rec.topagent_id::TEXT;
		name 	 = rec.name;
		IF expense_map is null THEN
			param = 'user_name'||cs||name||rs||'rebate'||cs||rec.rebate_total::TEXT;
			SELECT key_name||'=>'||param INTO expense_map;
		ELSEIF exist(expense_map, key_name) THEN
			param = expense_map->key_name;
			param = param||rs||'rebate'||cs||rec.rebate_total::TEXT;
			expense_map = expense_map||(SELECT (key_name||'=>'||param)::hstore);
		ELSE
			param = 'user_name'||cs||name||rs||'rebate'||cs||rec.rebate_total;
			expense_map = expense_map||(SELECT (key_name||'=>'||param)::hstore);
		END IF;
	END LOOP;

	RETURN expense_map;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gamebox_occupy_value(start_time TIMESTAMP, end_time TIMESTAMP, expense_map hstore)
IS 'Lins-总代占成-当前周期的返佣';