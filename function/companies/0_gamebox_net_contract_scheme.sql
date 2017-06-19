/**
 * 包网方案信息收集.
 * 根据站点ID取得包网方案相关信息.
 * @author		Lins
 * @date 		2015.11.27
 * @param 		site_id	站点ID
 * @param		is_max	是否最大数(占成值)
 * 调用例子：	select gamebox_contract(1,TRUE)
**/
drop function if EXISTS gamebox_contract(INT, BOOLEAN);
create or replace function gamebox_contract(
	site_id 	INT,
	is_max 		BOOLEAN
) returns hstore[] as $$
DECLARE
	hash 	hstore;
	hashs 	hstore[];
	id 		INT:=0;
	favorable_type text:='0';
BEGIN
	select gamebox_contract_scheme(site_id) into hash;
	IF hash IS NULL THEN
		raise info '未找到包网方案';
	ELSE
		hashs = array[hash];
		--取得占成方案
		id = (hash->'id')::INT;
		hashs = array_append(hashs, (SELECT gamebox_contract_occupy(id, is_max)));
		--取得共担方案.
		hashs = array_append(hashs, (SELECT gamebox_contract_assume(id)));
		--取得优惠方案
		favorable_type = '1';	--减免维护费
		hashs = array_append(hashs, (SELECT gamebox_contract_favorable(id, favorable_type)));
		favorable_type = '2';	--返还盈利
		hashs = array_append(hashs, (SELECT gamebox_contract_favorable(id, favorable_type)));
		--raise info '数组维度:%',array_length(hashs, 1);
		--raise info '包网方案:%',hashs[1];
		--raise info '占成方案:%',hashs[2];
		--raise info '盈亏共担方案:%',hashs[3];
		--raise info '优惠方案:%',hashs[4];
	END IF;
	return hashs;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_contract(site_id INT, is_max BOOLEAN)
IS 'Lins-包网方案-入口';

/**
 * 包网方案信息.
 * @author	Lins
 * @date 	2015.11.27
 * @param	site_id 站点ID
 * @return 	hstore	类型数据.
**/
drop function if EXISTS gamebox_contract_scheme(INT);
create or replace function gamebox_contract_scheme(site_id INT)
	returns hstore as $$
DECLARE
	rec record;
BEGIN
	FOR rec IN
		select a."id",
			   a.ensure_consume,
			   a.maintenance_charges,
			   b.id site_id
		  from sys_site b, contract_scheme a
		 where b.id = site_id
		   and b.status = '1'
	  	   and b.site_net_scheme_id = a.id
		   and a.status = '1'
	LOOP
		return hstore(rec);
	END LOOP;

	RETURN NULL;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_contract_scheme(site_id INT)
IS 'Lins-包网方案-方案信息';

/**
 * 包网方案API占成梯度信息.
 * @author	Lins
 * @date 	2015.11.27
 * @param 	scheme_id 	占成主案ID
 * @param 	is_max 		是否只取最大值
 * @return 	hstore类型数据.
**/
drop function if EXISTS gamebox_contract_occupy(INT, BOOLEAN);
create or replace function gamebox_contract_occupy(scheme_id INT, is_max BOOLEAN)
	returns hstore as $$
DECLARE
	rec 		record;
	hash 		hstore;
	key 		TEXT;
	val 		TEXT:='';
	min_value 	FLOAT:=0.00;
	max_value 	FLOAT:=0.00;
	retio 		FLOAT:=0.00;
	api 		INT;
	game_type 	TEXT;
	id 			INT;
	rs 			TEXT:='^&^';
	cs 			TEXT:='_';
	sql 		TEXT:='';
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
	sql = sql||' order by b.api_id, b.game_type, a.profit_lower';

	raise info 'sql = %', sql;

	FOR rec IN EXECUTE sql USING scheme_id
	LOOP
		min_value = COALESCE(rec.profit_lower, 0);
		max_value = COALESCE(rec.profit_limit, 0);
		retio = COALESCE(rec.ratio, 0);
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

COMMENT ON FUNCTION gamebox_contract_occupy(scheme_id INT, is_max BOOLEAN)
IS 'Lins-包网方案-API占成';

/**
 * 包网方案API盈亏共担信息.
 * @author	Lins
 * @date 	2015.11.27
 * @param 	scheme_id 	盈亏共担ID
 * @return 	hstore类型数据.
**/
drop function if EXISTS gamebox_contract_assume(INT);
create or replace function gamebox_contract_assume(scheme_id INT)
	returns hstore as $$
DECLARE
	rec 	record;
	hash 	hstore;
	key 	TEXT;
	val 	TEXT:='Y';
BEGIN
	FOR rec IN
	select * from contract_api
	where contract_scheme_id = scheme_id
	LOOP
		key = rec.api_id::TEXT;
		val = rec.is_assume::TEXT;
		IF hash is null THEN
			select key||'=>'||val into hash;
		ELSE
			hash = (select (key||'=>'||val)::hstore)||hash;
		END IF;
	END LOOP;
	RETURN hash;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_contract_assume(scheme_id INT)
IS 'Lins-包网方案-盈亏共担';

/**
 * 包网方案优惠方案信息.
 * @author	Lins
 * @date 	2015.11.27
 * @param 	scheme_id 	优惠方案ID
 * @return 	hstore类型数据.
**/
drop function if EXISTS gamebox_contract_favorable(INT, TEXT);
create or replace function gamebox_contract_favorable(scheme_id INT, favorable_type TEXT)
	returns hstore as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2015/01/01  Lins     创建此函数: 包网方案-优惠信息
--v1.01  2016/06/13  Leisure  梯度map的key改为下限值；
                              增加order子句，保证梯度map递增
*/
DECLARE
	rec 	record;
	hash 	hstore;
	key 	TEXT;
	val 	TEXT:='Y';
	rs 		TEXT:='^&^';
	cs 		TEXT:='_';

	min_value 			FLOAT:=0.00;
	max_value 			FLOAT:=0.00;
	favourable_value 	FLOAT:=0.00;
	favourable_limit 	FLOAT:=0.00;
	favourable_way 		TEXT;
	favourable_type 	TEXT;

BEGIN
	FOR rec IN EXECUTE
		'select a.*,
			   b.profit_lower,
			   b.profit_limit,
			   b.favourable_value
		  from contract_favourable a, contract_favourable_grads b
		 where a.id = b.contract_favourable_id
		   and a.contract_scheme_id = $1
		   and a.favourable_type = $2
	   order by b.profit_lower' --v1.02  2016/06/13  Leisure
	USING scheme_id, favorable_type

	LOOP
		min_value = COALESCE(rec.profit_lower, 0);
		max_value = COALESCE(rec.profit_limit, 0);
		favourable_type = COALESCE(rec.favourable_type, '1');
		favourable_way = COALESCE(rec.favourable_way, '1');
		favourable_value = COALESCE(rec.favourable_value, 0);
		favourable_limit = COALESCE(rec.favourable_limit, 0);

		val = min_value||cs||max_value||cs||favourable_type||cs||favourable_way||cs||favourable_value||cs||favourable_limit;

		--v1.02  2016/06/13  Leisure
		--key = max_value::text;
		key = min_value::text;

		IF hash is null THEN
			select key||'=>'||val into hash;
		ELSE
			hash = (select (key||'=>'||val)::hstore)||hash;
		END IF;
	END LOOP;
	RETURN hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_contract_favorable(scheme_id INT, favorable_type TEXT)
IS 'Lins-包网方案-优惠信息';
