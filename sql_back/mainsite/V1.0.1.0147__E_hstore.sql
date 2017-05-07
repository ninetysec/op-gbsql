-- auto gen by longer 2015-12-11 09:19:39
-- from lins's V1.0.1.0127__C_gamebox_net_contract_scheme

--CREATE EXTENSION hstore;

--create extension hstore;
drop function if EXISTS gamebox_contract(int,BOOLEAN);
create or replace function gamebox_contract(site_id int,is_max BOOLEAN) returns hstore[] as $$
DECLARE
	hash hstore;
	hashs hstore[];
	id int:=0;
	favorable_type text:='0';
BEGIN

	--select 'a=>1,b=>2' into hash;
	select gamebox_contract_scheme(site_id) into hash;
	IF hash IS NULL THEN
		raise info '未找到包网方案';
	ELSE
		hashs=array[hash];
		--取得占成方案
		id=(hash->'id')::INT;
		hashs=array_append(hashs, (SELECT gamebox_contract_occupy(id,is_max)));
		--取得共担方案.
		hashs=array_append(hashs, (SELECT gamebox_contract_assume(id)));
		--取得优惠方案
		favorable_type='1';--减免维护费
		hashs=array_append(hashs, (SELECT gamebox_contract_favorable(id,favorable_type)));
		favorable_type='2';--返还盈利
		hashs=array_append(hashs, (SELECT gamebox_contract_favorable(id,favorable_type)));

	END IF;
	raise info '数组维度:%',array_length(hashs, 1);
	raise info '包网方案:%',hashs[1];
	raise info '占成方案:%',hashs[2];
  raise info '盈亏共担方案:%',hashs[3];
	raise info '优惠方案:%',hashs[4];
	raise info '优惠方案:%',hashs[5];
	return hashs;
END
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_contract(site_id int,is_max BOOLEAN)
IS 'Lins-包网方案-入口';


/*
* description:包网方案信息.
* @author:Lins
* @date 2015.11.27
* 参数1.站点ID
* 返回:hstore类型数据.
*/
drop function if EXISTS gamebox_contract_scheme(int);
create or replace function gamebox_contract_scheme(site_id int) returns hstore as $$
DECLARE
	rec record;
BEGIN
	FOR rec IN
	select a.*,b.id site_id from sys_site b,contract_scheme a
	where b.id=site_id
	and b.status='1'
  and b.site_net_scheme_id=a.id
	and a.status='1'
	LOOP
		return hstore(rec);
	END LOOP;
	RETURN NULL;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_contract_scheme(site_id int)
IS 'Lins-包网方案-方案信息';


/*
* description:包网方案API占成梯度信息.
* @author:Lins
* @date 2015.11.27
* 参数1.占成主案ID
* 参数2.是否只取最大值
* 返回:hstore类型数据.
*/
drop function if EXISTS gamebox_contract_occupy(int,BOOLEAN);
create or replace function gamebox_contract_occupy(scheme_id int,is_max BOOLEAN) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	key text;
	val TEXT:='';
	row_split text:='^&^';
	col_split text:='_';
	sql text:='';
BEGIN
	sql='select a.contract_scheme_id,a.id
		,a.profit_lower,a.profit_limit,b.id
		,b.api_id,b.game_type,b.ratio from
		contract_occupy_grads a,contract_occupy_api b
		where a.id=b.contract_occupy_grads_id
		AND a.contract_scheme_id=$1 ';

	IF is_max THEN
	sql=sql||'
		AND 1 >(
		select  count(b1.id)  from contract_occupy_grads a1,contract_occupy_api b1
		where a1.id=b1.contract_occupy_grads_id
			AND a1.contract_scheme_id=a.contract_scheme_id
			AND b1.ratio > b.ratio
			AND b1.api_id=b.api_id AND b1.game_type=b.game_type
		)';
	END IF;
	sql=sql||' order by b.api_id,b.game_type';

	FOR rec IN EXECUTE sql USING scheme_id
	LOOP
		IF is_max THEN
			key=rec.api_id||col_split||rec.game_type;
			val=rec.ratio;
		ELSE
			key=rec.id||col_split||rec.api_id||col_split||rec.game_type;
			val=rec.profit_lower||col_split||rec.profit_limit||col_split||rec.ratio;
		END IF;

		IF hash is null THEN
			select key||'=>'||val into hash;
		ELSE
			hash=(select (key||'=>'||val)::hstore)||hash;
		END IF;
	END LOOP;
	RETURN hash;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_contract_occupy(scheme_id int,is_max BOOLEAN)
IS 'Lins-包网方案-API占成';


/*
* description:包网方案API盈亏共担信息.
* @author:Lins
* @date 2015.11.27
* 参数1.盈亏共担ID
* 返回:hstore类型数据.
*/
drop function if EXISTS gamebox_contract_assume(int);
create or replace function gamebox_contract_assume(scheme_id int) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	key text;
	val text:='Y';
	row_split text:='^&^';
	col_split text:='_';
BEGIN
	FOR rec IN
	select *from contract_api
	where contract_scheme_id=scheme_id
	LOOP
		key=rec.api_id::TEXT;
		val=rec.is_assume::TEXT;
		IF hash is null THEN
			select key||'=>'||val into hash;
		ELSE
			hash=(select (key||'=>'||val)::hstore)||hash;
		END IF;
	END LOOP;
	RETURN hash;
END;
$$ language plpgsql;

COMMENT ON FUNCTION gamebox_contract_assume(scheme_id int)
IS 'Lins-包网方案-盈亏共担';

/*
* description:包网方案优惠方案信息.
* @author:Lins
* @date 2015.11.27
* 参数1.优惠方案ID
* 返回:hstore类型数据.
*/
drop function if EXISTS gamebox_contract_favorable(int,text);
create or replace function gamebox_contract_favorable(scheme_id int,favorable_type text) returns hstore as $$
DECLARE
	rec record;
	hash hstore;
	key text;
	val text:='Y';
	row_split text:='^&^';
	col_split text:='_';
BEGIN
	FOR rec IN EXECUTE
	'select a.*
	,b.profit_lower,b.profit_limit,b.favourable_value
	from contract_favourable a,contract_favourable_grads b
	where a.id=b.contract_favourable_id
	and a.contract_scheme_id=$1
	and a.favourable_type=$2 '
	USING scheme_id,favorable_type

	LOOP
		val=rec.profit_lower::text||col_split||rec.profit_limit::text||col_split||rec.favourable_type::text||col_split||rec.favourable_way::text||col_split||rec.favourable_value::text||col_split||rec.favourable_limit::text;
		key=rec.profit_lower::text;
		IF hash is null THEN
			select key||'=>'||val into hash;
		ELSE
			hash=(select (key||'=>'||val)::hstore)||hash;
		END IF;
	END LOOP;
	RETURN hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_contract_favorable(scheme_id int,favorable_type text)
IS 'Lins-包网方案-优惠信息';