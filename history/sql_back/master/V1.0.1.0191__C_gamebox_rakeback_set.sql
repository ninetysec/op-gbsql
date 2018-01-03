/*
* 各种API返水方案.
*/
--drop function gamebox_rakeback_set();
create or replace function gamebox_rakeback_set() returns hstore as $$
DECLARE
	rec record;
	param text:='';
	gradshash hstore;
	tmphash hstore;
	keyname text:='';
	val text:='';
	val2 text:='';
BEGIN
	for rec in
	SELECT
		m.id,
		s.id as grads_id,
		d.api_id,
		d.game_type,
		d.ratio,
		s.max_rakeback,
		s.valid_value,
		m.name,
		m.audit_num
	FROM
		rakeback_grads s,
		rakeback_grads_api d,
		rakeback_set m
	WHERE
		s.id = d.rakeback_grads_id AND
		s.rakeback_id = m.id AND m.status='1'
		order by m.id,d.api_id,d.game_type,s.valid_value desc
   loop
		--判断主方案是否存在.
		--键值格式:ID+GRADSID+API+GAMETYPE
		  keyname=	rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text;
			--val:=row_to_json(row(5,6,7,8,9));
		  val:=row_to_json(rec);
			val:=replace(val,',','\|');
			val:=replace(val,'null','-1');
			--raise info '============%,%',keyname,gradshash?keyname;
			--raise info 'count:%',array_length(akeys(gradshash), 1);
			if (gradshash?keyname) is null OR (gradshash?keyname) =false THEN
				--raise info '创建KEY:%',val;
				--select keyname||'=>'||val into tmphash;
        --gradshash=hash||tmphash;
					if gradshash is null then
						select keyname||'=>'||val into gradshash;
					ELSE
						select keyname||'=>'||val into tmphash;
						gradshash=gradshash||tmphash;
					end IF;
	      -- raise info 'gradsHash=%',gradshash->keyname;
			else
				val2=gradshash->keyname;
				--raise info '原值=%',gradshash->keyname;
				select keyname||'=>'||val||'^&^'||val2 into tmphash;
				gradshash=gradshash||tmphash;
				--raise info '新值=%',gradshash->keyname;
			end if;
			--raise info '============';
	end loop;
		--raise info '键的数量：%',array_length(akeys(gradshash),1);
    --raise info '键值：%',akeys(gradshash);
    --raise info '值：%',avals(gradshash);
	return gradshash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rakeback_set() IS '返水-梯度设置信息萃取-Lins';
--SELECT * FROM gamebox_rakeback_set();