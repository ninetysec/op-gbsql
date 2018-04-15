-- auto gen by linsen 2018-04-15 21:35:54
-- 查询活动名称，包含所有语言版本 by kobe
DROP FUNCTION IF EXISTS gamebox_activityhall_query_activityname;
CREATE OR REPLACE FUNCTION "gamebox_activityhall_query_activityname"(activitymessageid int4)
  RETURNS "pg_catalog"."text" AS $BODY$
DECLARE
	rec_activity RECORD;--活动国际化结果集
	activityname_json VARCHAR := '' ;--活动名称，所有语言版本的名称都需要存储
BEGIN
FOR rec_activity IN SELECT * FROM activity_message_i18n WHERE activity_message_id=activitymessageid
LOOP
	activityname_json = activityname_json || '"' || rec_activity.activity_terminal_type || '-' ||rec_activity.activity_version||'":"'||rec_activity.activity_name||'",';
END LOOP;

IF length(activityname_json) > 0 THEN
	activityname_json = substring(activityname_json,  1 , length(activityname_json)-1);
	activityname_json = '{' || activityname_json  || '}';
END IF;
RETURN activityname_json;
END $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gamebox_activityhall_query_activityname"(activitymessageid int4) IS '查询活动名称，包含所有语言版本';