-- auto gen by linsen 2018-05-08 09:54:06
-- 优惠活动规则判断 by kobe
DROP FUNCTION IF EXISTS "gamebox_activityhall_rule"(activitymessage json, playerinfo json);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_rule"(activitymessage json, playerinfo json)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
activitymessageid int4;--活动id
playerid int4;--玩家id
activitytype VARCHAR;--活动类型
playerRank int;--玩家层级
activityRank VARCHAR;--活动参与层级
isAllRank BOOLEAN;--是否全部层级
tempActivityRank VARCHAR;--临时活动参与层级字符串
tempPlayerRank VARCHAR;--临时玩家层级字符串

TYPE_REGIST_SEND VARCHAR := 'regist_send';--注册送的activity_type
TYPE_RELIEF_FUND VARCHAR := 'relief_fund';--救济金的activity_type
TYPE_PROFIT_LOSS VARCHAR := 'profit_loss';--盈亏送的activity_type
TYPE_EFFECTIVE_TRANSACTION VARCHAR := 'effective_transaction';--有效交易量的activity_type
ACTIVITY_NOT_CONTAIN_RANK text:='09';--当前层级无法参与优惠
ACTIVITY_MEET text := '000';--满足优惠规则条件

BEGIN

activitymessageid =  activitymessage ->> 'activitymessageid';
activitytype = activitymessage->>'activitytype';
playerid =  playerInfo ->> 'playerid';
playerRank =  playerInfo ->> 'rankid';
--判断玩家的层级是否能参与该活动
SELECT rank,is_all_rank FROM activity_rule WHERE activity_message_id=activitymessageid INTO activityRank,isAllRank;
IF  isAllRank=FALSE THEN
tempActivityRank = ',' || activityRank || ',';
tempPlayerRank =  ',' || playerRank || ',';
raise info '申请玩家层级:%,活动参与层级:%',tempPlayerRank,tempActivityRank;
IF position(tempPlayerRank in tempActivityRank) <=0 THEN
RETURN json_build_object( 'resultcode',ACTIVITY_NOT_CONTAIN_RANK);
END IF;
END IF;
--注册送活动规则判断
	IF activitytype = TYPE_REGIST_SEND THEN
		RETURN gamebox_activityhall_rule_regist(activitymessage,playerInfo);
	END IF;
--救济金活动规则判断
	IF activitytype = TYPE_RELIEF_FUND THEN
		RETURN gamebox_activityhall_rule_relief(activitymessage,playerInfo);
	END IF;
--盈亏送和有效交易量活动规则判断
	IF activitytype = TYPE_PROFIT_LOSS OR activitytype = TYPE_EFFECTIVE_TRANSACTION THEN
		RETURN gamebox_activityhall_rule_default(activitymessage,playerInfo);
	END IF;

	RETURN  json_build_object( 'resultcode',ACTIVITY_MEET);

END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gamebox_activityhall_rule"(activitymessage json, playerinfo json) IS '优惠活动规则判断';