/*
*根据参数类型取得当前系统中所设置的各种参数的KEY-VALUE。
* 目前应该是取得站点中代理与总代各种承担比例的KEY-VALUE键值对.
* 各种承担比例的参数类型为:apportionSetting
* @author Lins
* @date 2015.11.9
* 调用例子:
* select * from gamebox_sys_param('apportionSetting');
* 返回JSON格式内容.
* 调用：hstore变量名->key 取得值.
* 比如变量名为hash,取总代-返水优惠分摊比例
* hash->'topagent.rakeback.percent'
*/
create or replace function gamebox_sys_param(paramType text) returns hstore as $$
DECLARE
	param text:='';
	hash hstore;
	rec record;
BEGIN
	for rec in select param_code,param_value from sys_param where param_type=$1 loop
		param=param||rec.param_code||'=>'||rec.param_value||',';
	end loop;
	--raise notice '结果:%',param;
	if length(param)>0 THEN
		param=substring(param,1,length(param)-1);
	end IF;
	select param::hstore into hash;
  --raise info '取得优惠值比例:%',hash->'topagent.rakeback.percent';
	return hash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_sys_param(paramType text) IS '返佣-系统各种参数萃取-Lins';
--select * from gamebox_sys_param('apportionSetting');