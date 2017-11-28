-- auto gen by tom 2016-03-22 11:11:58
CREATE OR REPLACE FUNCTION "public"."gamebox_rakeback_api_grads"()
  RETURNS "public"."hstore" AS $BODY$
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
		SELECT m.id,
			   s.id as grads_id,
			   d.api_id,
			   d.game_type,
			   COALESCE(d.ratio,0) 			as ratio,
			   COALESCE(s.max_rakeback,0) 	as max_rakeback,
			   COALESCE(s.valid_value,0) 	as valid_value,
			   m.name,
			   COALESCE(m.audit_num,0) 		as audit_num
		  FROM rakeback_grads s, rakeback_grads_api d, rakeback_set m
		 WHERE s.id = d.rakeback_grads_id
		   AND s.rakeback_id = m.id
		   AND m.status='1'
		 ORDER BY m.id,s.valid_value desc,d.api_id,d.game_type
   	LOOP
		-- 判断主方案是否存在.
		-- 键值格式:ID + gradsId + API + gameType
		keyname = rec.id::text||'_'||rec.grads_id::text||'_'||rec.api_id::text||'_'||rec.game_type::text||'_'||rec.valid_value::float;

		val:=row_to_json(rec);
		val:=replace(val,',','\|');
		val:=replace(val,'null','-1');
		IF (gradshash?keyname) is null OR (gradshash?keyname) = false THEN
			--gradshash=hash||tmphash;
			IF gradshash is null THEN
				select keyname||'=>'||val into gradshash;
			ELSE
				select keyname||'=>'||val into tmphash;
				gradshash = gradshash||tmphash;
			END IF;

		ELSE
			val2 = gradshash->keyname;
			select keyname||'=>'||val||'^&^'||val2 into tmphash;
			gradshash = gradshash||tmphash;
		END IF;
	END LOOP;

	return gradshash;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

ALTER FUNCTION "public"."gamebox_rakeback_api_grads"() OWNER TO "postgres";

COMMENT ON FUNCTION "public"."gamebox_rakeback_api_grads"() IS 'Lins-返水-API梯度';