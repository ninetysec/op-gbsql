-- auto gen by admin 2016-04-16 20:39:41
update sys_dict set dict_type='manual_event_type' where "module"='notice' and dict_code='CHANGE_PLAYER_DATA';

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")

SELECT 'notice', 'auto_event_type', 'SCHEDULE_EXCEPTION', NULL, '定时任务异常', NULL, 't'

where 'SCHEDULE_EXCEPTION' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');

CREATE OR REPLACE FUNCTION "f_update_site_data"()
  RETURNS "pg_catalog"."void" AS $BODY$
declare

rec_site	RECORD;
BEGIN

FOR rec_site IN (SELECT * FROM sys_site where status='1' and id >0)
loop
  raise notice '更新站点数据:%',rec_site.id;
  PERFORM f_init_site_data(rec_site.id);
END loop;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;