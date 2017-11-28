-- auto gen by marz 2017-10-19 17:05:08
DROP FUNCTION IF EXISTS "f_init_lottery"(siteid int4);
CREATE OR REPLACE FUNCTION "f_init_lottery"(siteid int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
	INSERT INTO "site_lottery" ("site_id", "code", "status", "order_num", "terminal","type","genre")
		SELECT siteid, code, status, order_num, terminal,type,genre FROM lottery l
		WHERE not EXISTS (SELECT sl.id from site_lottery sl where site_id=siteid and sl.code=l.code);
		GET DIAGNOSTICS v_count = ROW_COUNT;
		raise notice '同步站点彩种:%,执行%条',siteid,v_count;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_init_lottery"(siteid int4) IS '根据站点同步彩种';