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
	SELECT put(config,'col_split','^') INTO config;
	--格式:key|id^name^&^id^name;
	SELECT put(config,'sp_split','@') INTO config;
	RETURN config;
END;
$$ language plpgsql;
COMMENT ON FUNCTION sys_config() IS 'Lins-系统变量';