-- auto gen by marz 2017-10-05 21:40:43
CREATE OR REPLACE FUNCTION "f_init_lottery_odd"(siteid int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
	INSERT INTO "site_lottery_odd" ("site_id", "code", "bet_code", "bet_num", "odd","odd_limit", "rebate", "rebate_limit")
	SELECT siteid, code, bet_code, bet_num, odd,odd_limit,rebate,rebate_limit FROM lottery_odd t1
	WHERE not EXISTS (SELECT id FROM site_lottery_odd where code= t1.code and t1.bet_code = bet_code and t1.bet_num = bet_num AND site_id=siteid);
	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '新增site_lottery_odd %', v_count;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_init_lottery_odd"(siteid int4) IS '初始化站点赔率';
