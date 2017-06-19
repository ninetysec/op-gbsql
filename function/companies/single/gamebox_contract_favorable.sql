/**
 * 包网方案优惠方案信息.
 * @author	Lins
 * @date 	2015.11.27
 * @param 	scheme_id 	优惠方案ID
 * @return 	hstore类型数据.
**/
drop function if EXISTS gamebox_contract_favorable(int, text);
create or replace function gamebox_contract_favorable(scheme_id int, favorable_type text) 
	returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	key text;
	val text:='Y';
	rs text:='^&^';
	cs text:='_';

	min_value FLOAT:=0.00;
	max_value FLOAT:=0.00;
	favourable_value FLOAT:=0.00;
	favourable_limit FLOAT:=0.00;
	favourable_way TEXT;
	favourable_type TEXT;

BEGIN
	FOR rec IN EXECUTE
		'select a.*,
			   b.profit_lower, 
			   b.profit_limit, 
			   b.favourable_value
		  from contract_favourable a,contract_favourable_grads b
		 where a.id = b.contract_favourable_id
		   and a.contract_scheme_id = $1
		   and a.favourable_type = $2'
	USING scheme_id,favorable_type

	LOOP
		min_value = COALESCE(rec.profit_lower,0);
		max_value = COALESCE(rec.profit_limit,0);
		favourable_type = COALESCE(rec.favourable_type,'1');
		favourable_way = COALESCE(rec.favourable_way,'1');
		favourable_value = COALESCE(rec.favourable_value,0);
		favourable_limit = COALESCE(rec.favourable_limit,0);

		val = min_value||cs||max_value||cs||favourable_type||cs||favourable_way||cs||favourable_value||cs||favourable_limit;

		key = max_value::text;
		IF hash is null THEN
			select key||'=>'||val into hash;
		ELSE
			hash = (select (key||'=>'||val)::hstore)||hash;
		END IF;
	END LOOP;
	RETURN hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_contract_favorable(scheme_id int, favorable_type text)
IS 'Lins-包网方案-优惠信息';