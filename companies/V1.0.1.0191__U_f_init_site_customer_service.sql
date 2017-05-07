-- auto gen by bruce 2016-10-06 14:29:29
DROP FUNCTION if EXISTS f_init_site_customer_service(int4);
CREATE OR REPLACE FUNCTION "f_init_site_customer_service"(siteid int4)
  RETURNS "pg_catalog"."void" AS $BODY$
declare
v_count int;
BEGIN
--拷贝总控的customer_service到具体站点
INSERT INTO site_customer_service (site_id, code, name, parameter, status, create_time, create_user, built_in,type)
select siteid, code, name, '' parameter , status, now(), create_user, built_in,type from site_customer_service where site_id=0 and built_in =true and not exists (select * from site_customer_service s where s.site_id=siteid);
GET DIAGNOSTICS v_count = ROW_COUNT;
raise notice '新增 site_customer_service 数量 %', v_count;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;