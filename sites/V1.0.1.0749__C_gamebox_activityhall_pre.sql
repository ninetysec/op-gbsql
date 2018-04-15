-- auto gen by linsen 2018-04-15 21:30:08
-- 优惠活动前置条件 by kobe
DROP FUNCTION IF EXISTS gamebox_activityhall_pre;
CREATE OR REPLACE FUNCTION "gamebox_activityhall_pre"(activitymessage json)
  RETURNS "pg_catalog"."text" AS $BODY$
declare
	--活动信息
  activitymessageid INT;--活动id
	startTime TIMESTAMP;--活动开始时间
	endTime TIMESTAMP;--活动结束时间
	checkstatus  VARCHAR;--活动审核状态
	activitytype VARCHAR;--活动类型
	--状态常量
	ACTIVITY_STATUS_SUCCESS VARCHAR := '1';--活动审核通过状态值
	ACTIVITY_MEET_PRE text:='00';--活动满足前置条件
	ACTIVITY_NOT_EXIST text :='01';--活动不存在
	ACTIVITY_NOT_CHECK text :='02';--活动未审核
	ACTIVITY_NOT_START text :='03';--活动未开始
	ACTIVITY_END text :='04';--活动已结束
BEGIN
activitymessageid =  (activitymessage ->> 'activitymessageid')::INT;
startTime =  (activitymessage ->> 'activitystarttime')::TIMESTAMP;
endTime =  (activitymessage ->> 'activityendtime')::TIMESTAMP;
checkstatus =  activitymessage ->> 'checkstatus';
activitytype =  activitymessage ->> 'activitytype';
--前置条件判断
IF NOT EXISTS(SELECT * FROM activity_message WHERE id=activitymessageid) THEN
RETURN ACTIVITY_NOT_EXIST;
END IF;
IF checkstatus <> ACTIVITY_STATUS_SUCCESS THEN
RETURN ACTIVITY_NOT_CHECK;
END IF;
IF startTime > CURRENT_TIMESTAMP THEN
RETURN ACTIVITY_NOT_START;
END IF;
IF endTime < CURRENT_TIMESTAMP THEN
RETURN ACTIVITY_END;
END IF;
RETURN ACTIVITY_MEET_PRE;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "gamebox_activityhall_pre"(activitymessage json) IS '优惠活动前置条件';