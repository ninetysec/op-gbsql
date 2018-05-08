-- auto gen by linsen 2018-05-08 09:52:54
-- 查询活动的当前申请时间区间 by kobe
DROP FUNCTION IF EXISTS "gamebox_activityhall_query_applytime"(activitymessageid int4);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_query_applytime"(activitymessageid int4)
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


COMMENT ON FUNCTION "gamebox_activityhall_query_applytime"(activitymessageid int4) IS '查询活动的当前申请时间区间';