/*
* 取得各代API占成信息
* @author Lins
* @date 2015.11.18
* 调用方式：
* select * from gamebox_occupy_api_set();
*/
create or replace function gamebox_occupy_api_set() returns hstore as $$
DECLARE
	hash hstore;
	mhash hstore;
	param text:='';
	rec record;
	row_split text:='^&^';
	col_split text:='_';
BEGIN
	FOR rec in
		select DISTINCT user_id,api_id,game_type,ratio from user_agent_api order by user_id,api_id,game_type
	LOOP
		param=rec.user_id||col_split||rec.api_id||col_split||rec.game_type||'=>'||rec.ratio;
		IF hash is NULL THEN
			SELECT param into hash;
		ELSE
			SELECT param into mhash;
			hash=hash||mhash;
		END IF;
	END LOOP;
	--raise info 'API占成信息:%',hash->'3_1_01';
	return hash;
END;
$$ language plpgsql;

--select * from gamebox_occupy_api_set();
COMMENT ON FUNCTION gamebox_occupy_api_set() IS '总代占成-各API占成比例收集-Lins';
