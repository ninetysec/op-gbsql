/**
 * 包网方案API占成梯度信息.
 * @author	Lins
 * @date 	2015.11.27
 * @param 	scheme_id 	占成主案ID
 * @param 	is_max 		是否只取最大值
 * @return 	hstore类型数据.
**/
drop function if EXISTS gamebox_contract_occupy(int,BOOLEAN);
create or replace function gamebox_contract_occupy(scheme_id int,is_max BOOLEAN) 
	returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	key text;
	val TEXT:='';
	min_value FLOAT:=0.00;
	max_value FLOAT:=0.00;
	retio FLOAT:=0.00;
	api INT;
	game_type TEXT;
	id INT;
	rs text:='^&^';
	cs text:='_';
	sql text:='';
BEGIN
	sql = 'SELECT a.contract_scheme_id, 
			   a.id,
			   a.profit_lower,
			   a.profit_limit,
			   b.id,
			   b.api_id,
			   b.game_type,
			   b.ratio 
		  FROM contract_occupy_grads a,
			   contract_occupy_api b
		 WHERE a.id = b.contract_occupy_grads_id 
		   AND b.ratio IS NOT NULL
		   AND a.contract_scheme_id = $1';
	IF is_max THEN
		sql = sql||'
			AND 1 > (
				SELECT count(b1.id)
				  FROM contract_occupy_grads a1,
					   contract_occupy_api b1
				 WHERE a1.id = b1.contract_occupy_grads_id
				   AND a1.contract_scheme_id = a.contract_scheme_id 
				   AND b1.ratio is not null
				   AND b1.ratio > b.ratio
				   AND b1.api_id = b.api_id 
				   AND b1.game_type = b.game_type
			)';
	END IF;
	sql = sql||' order by b.api_id,b.game_type,a.profit_lower';

	raise info 'sql = %', sql;

	FOR rec IN EXECUTE sql USING scheme_id
	LOOP
		min_value = COALESCE(rec.profit_lower,0);
		max_value = COALESCE(rec.profit_limit,0);
		retio = COALESCE(rec.ratio,0);
		id = rec.id;
		api = rec.api_id;
		game_type = rec.game_type;
		key = api||cs||game_type;
		IF is_max THEN
			--key=api||cs||game_type;
			val = retio;
		ELSE
			--key=id||cs||api||cs||game_type;
			--val=min_value||cs||max_value||cs||retio;
			IF exist(hash,key) THEN
				val = hash->key;
				val = val||rs||min_value||cs||max_value||cs||retio;
			ELSE
				val = min_value||cs||max_value||cs||retio;
			END IF;
		END IF;

		IF hash is null THEN
			select key||'=>'||val into hash;
		ELSE
			hash=hash||(select (key||'=>'||val)::hstore);
		END IF;
	END LOOP;
	--raise info 'h=%',hash;
	RETURN hash;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_contract_occupy(scheme_id int,is_max BOOLEAN)
IS 'Lins-包网方案-API占成';