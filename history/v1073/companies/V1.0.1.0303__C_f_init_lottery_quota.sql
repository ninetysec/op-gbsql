-- auto gen by cherry 2017-06-14 11:12:45
CREATE OR REPLACE FUNCTION "f_init_lottery_quota"(siteid int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
	INSERT INTO "site_lottery_quota" ("code", "site_id", "play_code", "num_quota", "bet_quota", "play_quota")
	SELECT code, siteid, play_code, num_quota, bet_quota, play_quota FROM lottery_quota t1
	WHERE not EXISTS (SELECT id FROM site_lottery_quota where code= t1.code and t1.play_code = play_code AND site_id=siteid);

	GET DIAGNOSTICS v_count = ROW_COUNT;
	raise notice '新增site_lottery_quota%', v_count;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_init_lottery_quota"(siteid int4) IS '同步彩票限额';