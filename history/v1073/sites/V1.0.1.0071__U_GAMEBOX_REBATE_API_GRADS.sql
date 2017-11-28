-- auto gen by tom 2016-03-18 10:35:59
CREATE OR REPLACE FUNCTION "gamebox_rebate_api_grads"()
  RETURNS "hstore" AS $BODY$
DECLARE
	rec 		record;
	param 		text:='';
	gradshash 	hstore;
	tmphash 	hstore;
	keyname 	text:='';
	val 		text:='';
	val2 		text:='';

BEGIN
	FOR rec in
		SELECT DISTINCT m.id, --返佣主案ID
			   m.name,
			   s.id 	as grads_id, --返佣梯度ID
			   d.api_id,
			   d.game_type,
			   d.ratio, --API占成比例
			   m.valid_value,--有效交易量
			   s.total_profit,--有效盈利总额
			   s.max_rebate,--返佣上限
			   s.valid_player_num--有效玩家数
		  FROM rebate_set 		m,
		  	   rebate_grads 	s,
		  	   rebate_grads_api d
		 WHERE m.id = s.rebate_id
		   AND m.status = '1'
		   AND s.id = d.rebate_grads_id
		 ORDER BY m.id,s.total_profit desc, s.valid_player_num desc,d.api_id,d.game_type,m.valid_value desc

    LOOP
		--判断主方案是否存在.
		--键值格式:ID+GRADSID+API+GAMETYPE
		keyname = rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text;
		--keyname =	rec.id::text||col_split_char||rec.grads_id::text||col_split_char||rec.api_id::text||col_split_char||rec.game_type::text;
		--val:=row_to_json(row(5,6,7,8,9));
		val:=row_to_json(rec);
		--raise info 'rec=%',val;

		val:=replace(val,',','\|');
		val:=replace(val,'\:null\,','\:-1\,');
		--raise info 'count:%',array_length(akeys(gradshash), 1);

		IF (gradshash?keyname) is null OR (gradshash?keyname) =false THEN

		IF gradshash is null then
			SELECT keyname||'=>'||val into gradshash;
		ELSE
			SELECT keyname||'=>'||val into tmphash;
			gradshash = gradshash||tmphash;
		END IF;
		-- raise info 'gradsHash=%',gradshash->keyname;

		ELSE
			val2 = gradshash->keyname;
			--raise info '原值=%',gradshash->keyname;
			SELECT keyname||'=>'||val||'^&^'||val2 into tmphash;
			gradshash=gradshash||tmphash;
			--raise info '新值=%',gradshash->keyname;
		END if;

	END LOOP;
	raise info 'gamebox_rebate_set.键的数量：%',array_length(akeys(gradshash),1);

	return gradshash;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "gamebox_rebate_api_grads"() OWNER TO "postgres";

COMMENT ON FUNCTION "gamebox_rebate_api_grads"() IS 'Lins-返佣-返佣API梯度';