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
