/*
* 各种API返佣方案.
* @author Lins
* @date 2015.11.11
*/
--drop function gamebox_rebate_set();
create or replace function gamebox_rebate_set() returns hstore as $$
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
		DISTINCT
		m.id, --返佣主案ID
		m.name,
		s.id as grads_id, --返佣梯度ID
		d.api_id,
		d.game_type,
		d.ratio, --API占成比例
		m.valid_value,--有效交易量
		s.total_profit,--有效盈利总额
		s.max_rebate,--返佣上限
		s.valid_player_num--有效玩家数
		--,d.id
	FROM
		rebate_set m,
		rebate_grads s,
		rebate_grads_api d
	WHERE
    m.id=s.rebate_id AND m.status='1'
		AND s.id = d.rebate_grads_id

		order by m.id,d.api_id,d.game_type,m.valid_value desc,s.total_profit desc,s.valid_player_num desc

   loop
		--判断主方案是否存在.
		--键值格式:ID+GRADSID+API+GAMETYPE
			keyname=	rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text;
		  --keyname=	rec.id::text||col_split_char||rec.grads_id::text||col_split_char||rec.api_id::text||col_split_char||rec.game_type::text;
			--val:=row_to_json(row(5,6,7,8,9));
		  val:=row_to_json(rec);
			--raise info 'rec=%',val;

			val:=replace(val,',','\|');
			val:=replace(val,'\:null\,','\:-1\,');
			--raise info 'rec2=%',val;
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
				--select keyname||'=>'||val||row_split_char||val2 into tmphash;
				gradshash=gradshash||tmphash;
				--raise info '新值=%',gradshash->keyname;
			end if;
			--raise info '============';
	end loop;
	raise info 'gamebox_rebate_set.键的数量：%',array_length(akeys(gradshash),1);
    --raise info '键值：%',akeys(gradshash);
    --raise info '值：%',avals(gradshash);
	--raise info '%',gradshash;
	return gradshash;
END;
$$ language plpgsql;
COMMENT ON FUNCTION gamebox_rebate_set() IS '返佣-返佣梯度收集-Lins';
--SELECT * FROM gamebox_rebate_set('^&^','^');