-- auto gen by linsen 2018-04-15 21:18:25
-- 优惠活动申请统一入口 by kobe
DROP FUNCTION IF EXISTS gamebox_activityhall_apply(activitymessage json, playerinfo json, terminaltype varchar);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_apply"(activitymessage json, playerinfo json, terminaltype varchar)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
  --优惠活动信息
  activitymessageid int4;--活动id
  activitytype VARCHAR;--活动类型
  activitystarttime TIMESTAMP;--活动开始时间
  activityendtime TIMESTAMP;--活动结束时间
  --活动申请信息
  applyid INT;--申请id
  applytime TIMESTAMP;--申请时间
  applystarttime TIMESTAMP;--申领开始时间
  applyendtime TIMESTAMP;--申领结束时间
  --玩家信息
  playerid int4;--玩家id
  username VARCHAR;--玩家名
  registertime TIMESTAMP;--注册时间
  rankid INT;--层级id
  rankname VARCHAR;--层级名称
  riskmarker BOOLEAN;--层级危险标志
  loginIP INT8;
  loginIpDictCode VARCHAR;
  --临时结果
  ordernum INT;--优惠档次
  ruleresult json;--规则验证的返回结果json
  result_code text;---code(操作代码)
  applytimeinterval json;
  --常量
  TYPE_REGIST_SEND VARCHAR := 'regist_send';--注册送的activity_type
  TYPE_RELIEF_FUND VARCHAR := 'relief_fund';--救济金的activity_type
  APPLY_CHECK_STATUS_CONFIRMED VARCHAR := '0';--申请审核状态-待确认
  ACTIVITY_MEET_PRE text:='00';--满足优惠活动前置条件
  ACTIVITY_MEET text:='000';--满足优惠活动的规则
ACTIVITY_REPEAT_APPLY text:='99';--本申领周期已达申请上限
BEGIN
  --信息初始化
  activitymessageid =  activitymessage ->> 'activitymessageid';
  activitytype = activitymessage->>'activitytype';
  applystarttime = (activitymessage->>'applystarttime')::TIMESTAMP;
  applyendtime  = (activitymessage->>'applyendtime')::TIMESTAMP;
  playerid =  playerInfo ->> 'playerid';
  username =  playerInfo ->> 'username';
  registertime =  (playerInfo ->> 'registertime')::TIMESTAMP;
  rankid =  playerInfo ->> 'rankid';
  rankname =  playerInfo ->> 'rankname';
  riskmarker =  playerInfo ->> 'riskmarker';
  applytime =  (playerInfo ->> 'applytime')::TIMESTAMP;
  loginIP = (playerinfo ->> 'loginIP');
  loginIpDictCode = (playerinfo ->> 'loginIpDictCode');
  --是否满足活动前置条件
  SELECT * FROM gamebox_activityhall_pre(activitymessage)  INTO result_code;
  IF result_code <> ACTIVITY_MEET_PRE THEN
    raise info '不满足该优惠活动的前置条件,状态码为:%',result_code;
    RETURN json_build_object( 'resultcode',result_code);
  END IF;
  --是否满足活动规则
  SELECT * FROM gamebox_activityhall_rule(activitymessage,playerInfo) INTO ruleresult;
  raise info '规则判断的结果为:%',ruleresult;
  result_code = ruleresult->>'resultcode';
  IF result_code <> ACTIVITY_MEET THEN
    RETURN json_build_object( 'resultcode',result_code);
  END IF;
  --满足活动规则，生成优惠活动申请信息
  IF activitytype = TYPE_REGIST_SEND OR activitytype =TYPE_RELIEF_FUND THEN
    applyEndTime = applytime;
    ordernum=ruleresult->>'ordernum';
  END IF;
IF  NOT EXISTS (SELECT * FROM activity_player_apply WHERE user_id=playerid AND activity_message_id=activitymessageid AND start_time=applystarttime )  THEN
  WITH activityaplayapply AS (
			INSERT INTO activity_player_apply(activity_message_id,user_id,user_name,register_time,rank_id,rank_name,risk_marker,apply_time,check_state,start_time,end_time,ip_apply,ip_dict_code,activity_terminal_type)
			VALUES (activitymessageid,playerid,username,registertime,rankid,rankname,riskmarker,applytime,APPLY_CHECK_STATUS_CONFIRMED,applystarttime,applyendtime,loginIP,loginIpDictCode,terminaltype)
			RETURNING id
  )
 SELECT id FROM activityaplayapply INTO applyid ;
  RETURN json_build_object( 'resultcode',result_code,'applyId',applyid,'ordernum',ordernum);
ELSE
	RETURN json_build_object( 'resultcode',ACTIVITY_REPEAT_APPLY);
END IF;


END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gamebox_activityhall_apply"(activitymessage json, playerinfo json, terminaltype varchar) IS '优惠活动申请统一入口';