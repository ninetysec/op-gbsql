-- auto gen by Lins 2015-12-18 03:20:02

/*
* MAP.新增健值.
*/
DROP FUNCTION IF exists put(INOUT hstore,TEXT,TEXT);
create or replace function put(INOUT map hstore,key TEXT,value TEXT) returns hstore as $$
BEGIN
	--key=COALESCE(key,'');
	--value=COALESCE(value,'s');
	IF value is null OR key is null THEN
		RETURN;
	END IF;
	IF map is null THEN
		SELECT key||'=>'||value INTO map;
	ELSE
		map=map||(SELECT (key||'=>'||value)::hstore);
	END IF;
	RETURN;
END;
$$ language plpgsql;
COMMENT ON FUNCTION put(
INOUT map hstore
,key TEXT
,value TEXT
) IS 'Lins-Hashmap.put方法';

/*
* 设置一些系统常量
*/
DROP FUNCTION IF exists sys_config();
create or replace function sys_config() returns hstore as $$
DECLARE
	config hstore;
BEGIN
	SELECT put(config,'row_split','^&^') INTO config;
	SELECT put(config,'row_split_a','\^&\^') INTO config;
	SELECT put(config,'col_split','^') INTO config;
	SELECT put(config,'col_split_a','^') INTO config;
	--格式:key|id^name^&^id^name;
	SELECT put(config,'sp_split','@') INTO config;
	SELECT put(config,'sp_split_a','\@') INTO config;
	RETURN config;
END;
$$ language plpgsql;
COMMENT ON FUNCTION sys_config() IS 'Lins-系统变量';


/*
drop function if exists func_demo();
create or replace function func_demo() returns void as $$
DECLARE
	map hstore;
	m hstore;
	val TEXT;

	sys_config hstore;
	sp TEXT:='@';
	rs TEXT:='\~';
	cs TEXT:='\^';
BEGIN
	--取得系统变量
	select sys_config() INTO sys_config;
	sp=sys_config->'sp_split';
	rs=sys_config->'row_split';
	cs=sys_config->'col_split';

	SELECT put(map,'name','lins') INTO map;
	SELECT put(map,'age','30') INTO map;
	SELECT put(map,'address','Xiamen.china') INTO map;

	val='user_name^topagent^&^refund_fee^532^&^recommend^84^&^backwater^952^&^favourable^1988^&^rebate^35604.80^&^apportion^1627.678808^&^rebate_apportion^1780.24^&^favourable_apportion^1595.44^&^backwater_apportion^17.52156^&^refund_fee_apportion^14.717248';
	val='1^02^1.5^3^50^&^1^01^2000110^20^10000550^&^1^03^-52.5^15^-350^&^3^02^0^0^-5^&^2^03^-160^16^-1000';
	raise info 'va:%',val;
	raise info 'rs:%,cs:%',rs,cs;
	val=replace(val,'^&^',',');
raise info 'va:%',val;
	val=replace(val,'^','=>');
raise info 'va:%',val;
	select val INTO m;
	raise info 'm=%',m;
	raise info 'val=%',val;
	raise info '%',map;
END;
$$ language plpgsql;
*/