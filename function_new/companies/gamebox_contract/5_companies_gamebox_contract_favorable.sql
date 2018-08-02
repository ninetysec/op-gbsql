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
