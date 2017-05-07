-- auto gen by admin 2016-05-23 16:02:01
DROP FUNCTION IF EXISTS gamebox_occupy_api_map(TIMESTAMP, TIMESTAMP, hstore, hstore);

create or replace function gamebox_occupy_api_map(

	start_time 				TIMESTAMP,

	end_time 				TIMESTAMP,

	occupy_grads_map 		hstore,

	operation_occupy_map 	hstore

) returns hstore as $$

/*版本更新说明

  版本   时间        作者     内容

--v1.00  2015/01/01  Lins     创建此函数：总代占成-各API占成

--v1.01  2016/05/17  Leisure  API盈利信息改由原始表获取

*/

DECLARE

	rec 					record;

	key_name 				TEXT:='';

	col_split 				TEXT:='_';



	operation_occupy_value 	FLOAT:=0.00;--运营商API占成金额

	occupy_value 			FLOAT:=0.00;--占成金额

	profit_amount 			FLOAT:=0.00;--盈亏总和



	api 		INT;

	game_type 	TEXT;

	owner_id 	TEXT;

	name 		TEXT:='';

	retio 		FLOAT:=0.00;--占成比例



	api_map 	hstore;

	param 		TEXT:='';



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

	-- raise info '------ operation_occupy_map = %', operation_occupy_map;



	--v1.01  2016/05/17  Leisure  API盈利信息改由原始表获取

	/*

	FOR rec IN

		SELECT ut."id"									as topagent_id,

			   ut.username								as topagent_name,

			   rab.api_id,

			   rab.game_type,

			   COALESCE(SUM(-rab.profit_loss), 0.00)	as profit_amount

		  FROM rakeback_api_base rab

		  LEFT JOIN sys_user su ON rab.player_id = su."id"

		  LEFT JOIN sys_user ua ON su.owner_id = ua.id

		  LEFT JOIN sys_user ut ON ua.owner_id = ut.id

		 WHERE rab.rakeback_time >= start_time

		   AND rab.rakeback_time < end_time

		   AND su.user_type = '24'

		   AND ua.user_type = '23'

		   AND ut.user_type = '22'

		 GROUP BY ut."id", ut.username, rab.api_id, rab.game_type

		*/

	FOR rec IN

		SELECT ut."id"									as topagent_id,

					 ut.username								as topagent_name,

					 pgo.api_id,

					 pgo.game_type,

					 COALESCE(SUM(-pgo.profit_amount), 0.00)	as profit_amount

			FROM player_game_order pgo

			LEFT JOIN sys_user su ON pgo.player_id = su."id"

			LEFT JOIN sys_user ua ON su.owner_id = ua.id

			LEFT JOIN sys_user ut ON ua.owner_id = ut.id

		 WHERE pgo.order_state = 'settle'

			 AND pgo.is_profit_loss = TRUE

			 AND pgo.bet_time >= start_time

			 AND pgo.bet_time < end_time

			 AND su.user_type = '24'

			 AND ua.user_type = '23'

			 AND ut.user_type = '22'

		 GROUP BY ut."id", ut.username, pgo.api_id, pgo.game_type

	LOOP

		api 			= rec.api_id;

		game_type 		= rec.game_type;

		owner_id 		= rec.topagent_id::TEXT;

		name 			= rec.topagent_name;

		profit_amount 	= rec.profit_amount;



		--取得运营商API占成.

		key_name = api||col_split||game_type;



		operation_occupy_value = 0.00;

		IF exist(operation_occupy_map, key_name) THEN

			operation_occupy_value = (operation_occupy_map->key_name)::FLOAT;

		END IF;



		--计算总代占成.

		key_name = owner_id||col_split||api||col_split||game_type;



		occupy_value = 0.00;

		retio 		 = 0.00;



  IF exist(occupy_grads_map, key_name) THEN

			retio = (occupy_grads_map->key_name)::FLOAT;

			occupy_value = (profit_amount - operation_occupy_value) * retio / 100;

		ELSE

			raise info '总代ID = %, API = %, GAME_TYPE = % 未设置占成.', owner_id, api, game_type;

		END IF;



		--格式:id->'name@api^type^val~api^type^val^retio

		key_name = owner_id;



		IF api_map is null THEN

			param = name||sp||api||cs||game_type||cs||occupy_value||cs||retio||cs||profit_amount;

			SELECT key_name||'=>'||param INTO api_map;

		ELSEIF exist(api_map, key_name) THEN

			param = api_map->key_name;

			param = param||rs||api||cs||game_type||cs||occupy_value||cs||retio||cs||profit_amount;

			api_map = api_map||(SELECT (key_name||'=>'||param)::hstore);

		ELSE

			param = name||sp||api||cs||game_type||cs||occupy_value||cs||retio||cs||profit_amount;

			api_map = api_map||(SELECT (key_name||'=>'||param)::hstore);

		END IF;



	END LOOP;



	RETURN api_map;

END;



$$ language plpgsql;

COMMENT ON FUNCTION gamebox_occupy_api_map(start_time TIMESTAMP, end_time TIMESTAMP, occupy_grads_map hstore, operation_occupy_map hstore)

IS 'Lins-总代占成-各API占成';

