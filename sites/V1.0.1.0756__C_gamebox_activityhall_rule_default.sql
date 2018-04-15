-- auto gen by linsen 2018-04-15 21:39:05
-- 活动规则判断 by kobe
DROP FUNCTION IF EXISTS gamebox_activityhall_rule_default;
CREATE OR REPLACE FUNCTION "gamebox_activityhall_rule_default"(activitymessage json, playerinfo json)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
	activitymessageid int4;--活动id
	applystarttime TIMESTAMP;--申领开始时间
	applyendtime TIMESTAMP;--申领结束时间
	playerid int4;--玩家id
	ACTIVITY_MEET text:='000';--满足注册送条件
	ACTIVITY_REPEAT_APPLY text:='99';--本申领周期已达申请上限
BEGIN
activitymessageid =  activitymessage ->> 'activitymessageid';
applystarttime = (activitymessage->>'applystarttime')::TIMESTAMP;
applyendtime  = (activitymessage->>'applyendtime')::TIMESTAMP;
playerid =  playerInfo ->> 'playerid';
--同一申请周期是否存在重复申请
IF EXISTS(SELECT * FROM activity_player_apply WHERE user_id = playerid AND activity_message_id = activitymessageid AND apply_time>=applystarttime AND apply_time<=applystarttime) THEN
	RETURN json_build_object( 'resultcode',ACTIVITY_REPEAT_APPLY);
	END IF;
	RETURN json_build_object( 'resultcode',ACTIVITY_MEET);
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gamebox_activityhall_rule_default"(activitymessage json, playerinfo json) IS '活动规则判断';