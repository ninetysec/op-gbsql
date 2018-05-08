-- auto gen by linsen 2018-05-08 09:56:23
-- 注册送规则判断 by kobe
DROP FUNCTION IF EXISTS "gamebox_activityhall_rule_regist"(activitymessage json, playerinfo json);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_rule_regist"(activitymessage json, playerinfo json)
  RETURNS "pg_catalog"."json" AS $BODY$
declare

rec_preferential record; --唯一性条件
realname VARCHAR;  --真实姓名
registerip int8; --注册ip
bankcardnumber VARCHAR; --银行卡
activitymessageid int4;--活动id
playerid int4;--玩家id
registTime TIMESTAMP;--玩家注册时间
effectiveTime VARCHAR;--有效时间
activityEffectiveTime TIMESTAMP;--活动有效时间=玩家注册时间+有效时间

ACTIVITY_MEET text:='000';--满足注册送条件
ACTIVITY_REGIST_EXPIRE text:='11';--有效期已过
ACTIVITY_REPEAT_APPLY text:='99';--本申领周期已达申请上限
ACTIVITY_REALNAME_ERROR text:='81';--真实姓名错误
ACTIVITY_REGISTERIP_ERROR text:='82';--注册ip错误
ACTIVITY_BANKCARD_ERROR text:='83';--银行卡错误
preferentialdata 	VARCHAR:= '';	-- json存放活动详情信息
BEGIN
activitymessageid =  activitymessage ->> 'activitymessageid';
playerid =  playerInfo ->> 'playerid';
registTime =  (playerInfo ->> 'registertime')::TIMESTAMP;

--判断是否存在重复的申请
	IF EXISTS(SELECT * FROM activity_player_apply WHERE user_id = playerid AND activity_message_id = activitymessageid) THEN
	RETURN json_build_object( 'resultcode',ACTIVITY_REPEAT_APPLY);
	END IF;

--判断是否过期
	SELECT CASE
		WHEN (effective_time = 'OneDay') THEN '1'
		WHEN (effective_time = 'TwoDays') THEN '2'
		WHEN (effective_time = 'ThreeDays') THEN '3'
		WHEN (effective_time = 'SevenDays') THEN '7'
		WHEN (effective_time = 'ThirtyDays') THEN '30'
		ELSE '0'
	END AS effective_time FROM activity_rule WHERE activity_message_id = activitymessageid INTO effectiveTime;
	raise info '玩家:%,的注册时间为：%,活动：%,的有效时间为：%.',playerid,registTime,activitymessageid,effectiveTime;

	SELECT registTime + (effectiveTime || ' day')::interval  INTO activityEffectiveTime;
	IF activityEffectiveTime < CURRENT_TIMESTAMP THEN
		RETURN json_build_object( 'resultcode',ACTIVITY_REGIST_EXPIRE);
	END IF;

--判断信息唯一
	FOR rec_preferential IN (SELECT * FROM activity_preferential_relation WHERE activity_message_id = activitymessageid)
	LOOP
		IF (rec_preferential.preferential_code = 'bankcard_unique') THEN
			SELECT bankcard_number FROM user_bankcard WHERE user_id = playerid INTO bankcardnumber;
			IF (bankcardnumber IS NULL) THEN
				RETURN json_build_object('resultcode',ACTIVITY_BANKCARD_ERROR);
			ELSEIF EXISTS (SELECT * FROM user_bankcard WHERE user_id in (SELECT id FROM sys_user WHERE user_type = '24' AND id <> playerid) AND bankcard_number = bankcardnumber) THEN
				RETURN json_build_object('resultcode',ACTIVITY_BANKCARD_ERROR);
			END IF;
		ELSEIF (rec_preferential.preferential_code = 'real_name_unique') THEN
			SELECT real_name FROM sys_user WHERE id = playerid INTO realname;
			IF (realname IS NULL) THEN
				RETURN json_build_object('resultcode',ACTIVITY_REALNAME_ERROR);
			ELSEIF EXISTS (SELECT * FROM sys_user WHERE real_name = realname AND id <> playerid AND user_type = '24') THEN
				RETURN json_build_object('resultcode',ACTIVITY_REALNAME_ERROR);
			END IF;
		ELSEIF (rec_preferential.preferential_code = 'register_ip_unique') THEN
			SELECT register_ip FROM sys_user WHERE id = playerid INTO registerip;
			IF (registerip IS NULL) THEN
				RETURN json_build_object('resultcode',ACTIVITY_REGISTERIP_ERROR);
			ELSEIF EXISTS (SELECT * FROM sys_user WHERE register_ip = registerip AND id <> playerid AND user_type = '24') THEN
				RETURN json_build_object('resultcode',ACTIVITY_REGISTERIP_ERROR);
			END IF;
		END IF;
	END LOOP;
	preferentialdata = '{';
	IF (bankcardnumber IS NOT NULL) THEN
  preferentialdata = preferentialdata || '''bankCard'':'  || '''' || bankcardnumber || '''' || ',';
	END IF;
	IF (realname IS NOT NULL) THEN
  preferentialdata = preferentialdata || '''realName'':'  || '''' || realname || '''' || ',';
	END IF;
  IF (registerip IS NOT NULL) THEN
  preferentialdata = preferentialdata || '''registerIp'':'  || '''' || registerip || '''';
	END IF;
	preferentialdata = preferentialdata || '}';
  raise info 'bankcardnumber:%,realName:%,registerIp:%preferentialdata:%',bankcardnumber,realName,registerIp,preferentialdata;
	RETURN json_build_object( 'resultcode',ACTIVITY_MEET,'ordernum',1,'preferentialdata',preferentialdata);
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gamebox_activityhall_rule_regist"(activitymessage json, playerinfo json) IS '注册送规则判断';