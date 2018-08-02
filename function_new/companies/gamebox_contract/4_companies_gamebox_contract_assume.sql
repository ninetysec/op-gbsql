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
