-- auto gen by cherry 2017-07-14 10:06:01
CREATE OR REPLACE FUNCTION "f_update_site_lottery_quota"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare

rec_site	RECORD;
BEGIN

FOR rec_site IN (SELECT * FROM sys_site where status='1' and id >0)
loop
  raise notice '同步站点限额:%',rec_site.id;
  PERFORM f_init_lottery_quota(rec_site.id);
END loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_update_site_lottery_quota"() is '同步站点限额';


CREATE OR REPLACE FUNCTION "f_init_site_lottery"(siteId int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare

rec_site	RECORD;
BEGIN
PERFORM f_init_lottery_odd(siteId);
PERFORM f_init_lottery_quota(siteId);
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;
COMMENT ON FUNCTION "f_init_site_lottery"(siteId int4) is '同步站点彩票数据';


