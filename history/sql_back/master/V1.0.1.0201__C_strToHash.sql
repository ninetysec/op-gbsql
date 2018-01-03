/*
* 把字符串转为hstore.
* @author Lins
* @date 2015.11.10
* 返回hstore类型数据.
*/
create or replace function strToHash(param text) returns hstore as $$
DECLARE
	hash hstore;
BEGIN
	--进行字符串转换.
			--raise info 'param:%',param;
			param=replace(param,'|',',');
			param=replace(param,':','=>');
			param=replace(param,'{','');
			param=replace(param,'}','');
      --raise info 'param:%',param;
			select param into hash;
			--raise info 'keys:%',akeys(hash);
			--raise info 'vals:%',avals(hash);
		  --raise info 'game_type:%',hash->'game_type';
			return hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION strToHash(param text) IS '把字符串转为Hash-Lins';
--select * from strToHash('{"id":104|"rakeback_id":"52"|"valid_value":1000|"max_rakeback":200}');
--select * from strToHash('{"id":43|"grads_id":56|"api_id":1|"game_type":"01"|"ratio":3.00|"max_rakeback":1|"valid_value":1|"name":"lorne1"|"audit_num":4}');