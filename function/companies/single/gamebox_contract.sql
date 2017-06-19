/**
 * 包网方案信息收集.
 * 根据站点ID取得包网方案相关信息.
 * @author		Lins
 * @date 		2015.11.27
 * @param 		site_id	站点ID
 * @param		is_max	是否最大数(占成值)
 * 调用例子：	select gamebox_contract(1,TRUE)
**/
drop function if EXISTS gamebox_contract(int, BOOLEAN);
create or replace function gamebox_contract(
	site_id 	int, 
	is_max 		BOOLEAN
) returns hstore[] as $$
DECLARE
	hash 	hstore;
	hashs 	hstore[];
	id 		int:=0;
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

COMMENT ON FUNCTION gamebox_contract(site_id int, is_max BOOLEAN)
IS 'Lins-包网方案-入口';
