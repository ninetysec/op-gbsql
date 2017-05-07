/**
 * MAP.新增健值.
**/
DROP FUNCTION IF exists put(INOUT hstore, TEXT, TEXT);
create or replace function put(
	INOUT map 	hstore,
	key 		TEXT,
	value 		TEXT
) returns hstore as $$
BEGIN
	IF value is null OR value = '' OR key is null OR key = '' THEN
		RETURN;
	END IF;

	IF map is null THEN
		SELECT key||'=>'||value INTO map;
	ELSE
		map = map||(SELECT (key||'=>'||value)::hstore);
	END IF;

	RETURN;
END;

$$ language plpgsql;
COMMENT ON FUNCTION put(INOUT map hstore, key TEXT, value TEXT)
IS 'Lins-Hashmap.put方法';

/**
 * 设置一些系统常量
**/
DROP FUNCTION IF exists sys_config();
create or replace function sys_config() returns hstore as $$
DECLARE
	config hstore;
BEGIN
	SELECT put(config, 'row_split', 	'^&^') 		INTO config;
	SELECT put(config, 'row_split_a', 	'\^&\^') 	INTO config;
	SELECT put(config, 'col_split', 	'^') 		INTO config;
	SELECT put(config, 'col_split_a', 	'^') 		INTO config;
	-- 格式:key|id^name^&^id^name;
	SELECT put(config, 'sp_split', 		'@') 		INTO config;
	SELECT put(config, 'sp_split_a', 	'\@') 		INTO config;
	RETURN config;
END;

$$ language plpgsql;
COMMENT ON FUNCTION sys_config()
IS 'Lins-系统变量';

/**
 * 生成流水号
 * @author 	Lins
 * @date 	2015.12.22
 * @param 	trans_type 	交易类型:B或T
 * @param 	site_code 	站点code
 * @param 	order_type 	流水号类型
 * @param 	url 		Dblink URL
**/
DROP FUNCTION if exists gamebox_generate_order_no(TEXT, TEXT, TEXT, TEXT);
create or replace function gamebox_generate_order_no(
	trans_type 	TEXT,
	site_code 	TEXT,
	order_type 	TEXT,
	url 		TEXT
) returns TEXT as $$
DECLARE
	order_no TEXT:='';
BEGIN
	SELECT INTO order_no seq FROM dblink(
		url,
		'SELECT gamebox_generate_order_no('''||trans_type||''', '''||site_code||''' , '''||order_type||''')'
	) as p(seq TEXT);
	RETURN order_no;
END;

$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION gamebox_generate_order_no(trans_type TEXT, site_code TEXT, order_type TEXT, url TEXT)
IS 'Lins-生成流水号';
