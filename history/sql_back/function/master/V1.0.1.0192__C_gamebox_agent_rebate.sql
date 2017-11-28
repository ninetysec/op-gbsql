/*
* 代理返佣方案.
* @author Lins
* @date 2015-11-11
* 返回hstore类型
*/
--drop function gamebox_agent_rebate();
create or replace function gamebox_agent_rebate() returns hstore as $$
DECLARE
	hash hstore;
	rec record;
	param text:='';
BEGIN
	for rec in
		select a.user_id,a.rebate_id from user_agent_rebate a,sys_user u where a.user_id=u.id and u.user_type='22'
    loop
			param=param||rec.user_id||'=>'||rec.rebate_id||',';
	end loop;
	if length(param)>0 THEN
		param=substring(param,1,length(param)-1);
	end IF;
	--raise info '结果:%',param;
	select param::hstore into hash;
	--测试引用值.
  --raise info '4:%',hash->'3';
	return hash;
END;
$$ language plpgsql;

--SELECT * FROM gamebox_agent_rebate();
COMMENT ON FUNCTION gamebox_agent_rebate() IS '返佣-代理返佣方案-Lins';