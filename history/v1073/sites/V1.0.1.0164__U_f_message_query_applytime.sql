-- auto gen by bruce 2016-06-05 15:13:13
Drop FUNCTION IF EXISTS f_message_query_applytime(INT);
CREATE OR REPLACE FUNCTION "f_message_query_applytime"(activitymessageid int4)
  RETURNS "pg_catalog"."json" AS $BODY$
DECLARE
  starttime TIMESTAMP;--申请开始时间
  endtime TIMESTAMP;--申请结束时间
  claimperiod VARCHAR; --活动申领周期
BEGIN
  SELECT start_time,end_time FROM activity_message WHERE id = activitymessageid INTO starttime,endtime;
  SELECT
    CASE
    WHEN (claim_period = 'NaturalDay') THEN '1 day'
    WHEN (claim_period = 'NaturalWeek') THEN '1 week'
    WHEN (claim_period = 'NaturalMonth') THEN '1 month'
    WHEN (claim_period = 'ActivityCycle') THEN 'cycle'
    ELSE 'cycle'
    END AS claim_period FROM activity_rule WHERE activity_message_id=activitymessageid INTO claimperiod;
  raise info '活动申领周期:%',claimperiod;
  IF claimperiod <> 'cycle' THEN
    loop
      exit WHEN (starttime+ claimperiod::INTERVAL) > CURRENT_TIMESTAMP;
      starttime = starttime + claimperiod::INTERVAL;
    END loop;
    IF (starttime + claimperiod::INTERVAL) <= endtime THEN
      endtime = starttime + claimperiod::INTERVAL;
    END IF;
  END IF;
  raise info '申领周期的开始时间为:%,结束时间为:%',starttime,endtime;
  RETURN json_build_object('applystarttime',starttime,'applyendtime',endtime);
END $BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_message_query_applytime"(activitymessageid int4) IS '查询活动的当前申请时间区间';

update sys_resource set id = 4504 , sort_num = 1 where  url = 'operation/pAnnouncementMessage/gameNotice.html';
update sys_resource set id = 4503 , sort_num = 3 where  url = 'operation/pAnnouncementMessage/messageList.html';
update sys_resource set id = 4501 , sort_num = 1 where  url = 'operation/pAnnouncementMessage/gameNotice.html';