-- auto gen by cherry 2017-06-29 09:48:21
DROP FUNCTION IF EXISTS "f_init_lottery_odd"(siteid int4);
CREATE OR REPLACE FUNCTION "f_init_lottery_odd"(siteid int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
	INSERT INTO "site_lottery_odd" ("site_id", "code", "bet_code", "bet_num", "odd","odd_limit")
	SELECT siteid, code, bet_code, bet_num, odd,odd_limit FROM lottery_odd t1
	WHERE not EXISTS (SELECT id FROM site_lottery_odd where code= t1.code and t1.bet_code = bet_code and t1.bet_num = bet_num AND site_id=siteid);
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '新增site_lottery_odd %', v_count;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_init_lottery_odd"(siteid int4) IS '同步彩票赔率';



CREATE OR REPLACE FUNCTION "f_update_site_lottery_odd"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare

rec_site	RECORD;
BEGIN

FOR rec_site IN (SELECT * FROM sys_site where status='1' and id >0)
loop
  raise notice '同步站点赔率:%',rec_site.id;
  PERFORM f_init_lottery_odd(rec_site.id);
END loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;