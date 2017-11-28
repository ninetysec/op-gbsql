-- auto gen by bruce 2016-09-17 14:00:10
DROP FUNCTION IF EXISTS f_message_entrance(int4, int4, varchar);
CREATE OR REPLACE FUNCTION "f_message_entrance"(activitymessageid int4, playerid int4, sitecode varchar)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
  --优惠活动信息
  activitytype VARCHAR;--活动类型
  activitystarttime TIMESTAMP;--活动开始时间
  activityendtime TIMESTAMP;--活动结束时间
  checkstatus  VARCHAR;--活动审核状态
  applystarttime TIMESTAMP;--申领开始时间
  applyendtime TIMESTAMP;--申领结束时间
  --玩家信息
  username VARCHAR;--玩家名
  registertime TIMESTAMP;--注册时间
  rankid INT;--层级id
  rankname VARCHAR;--层级名称
  riskmarker BOOLEAN;--层级危险标志
  login_ip INT8;--登录ip
  login_ip_dict_code varchar;--ip登录区域
  --临时结果
  applytimeinterval json;
  result_code text;---code(操作代码)
  activitymessage json;--优惠活动信息
  playerInfo json;--申请玩家信息
  applyresult json;--活动申请信息
  resultjson json;--活动优惠信息
  ACTIVITY_MEET text := '000';--执行成功代码
BEGIN
  --查询优惠活动信息，转化为json存储
  SELECT start_time,end_time,activity_type_code,check_status FROM activity_message WHERE id = activitymessageid INTO activitystarttime,activityendtime,activitytype,checkstatus;
  SELECT * FROM f_message_query_applytime(activitymessageid) INTO applytimeinterval;
  applystarttime = (applytimeinterval->>'applystarttime')::TIMESTAMP;
  applyendtime  = (applytimeinterval->>'applyendtime')::TIMESTAMP;
  activitymessage = json_build_object('activitymessageid',activitymessageid,'activitystarttime',activitystarttime,'activityendtime',activityendtime,'activitytype',activitytype,'checkstatus',checkstatus,'applystarttime',applystarttime,'applyendtime',applyendtime);
  raise info '优惠活动信息:%',activitymessage;
  --查询玩家信息，转化为json存储
  SELECT sysuser.username,sysuser.create_time,sysuser.login_ip,sysuser.login_ip_dict_code,player.rank_id,prank.rank_name,prank.risk_marker FROM sys_user sysuser,user_player player,player_rank prank
  WHERE sysuser.id = player.id AND player.rank_id = prank.id AND sysuser.id=playerid INTO username,registertime,login_ip,login_ip_dict_code,rankid,rankname,riskmarker;
  playerInfo = json_build_object('playerid',playerid,'username',username,'registertime',registertime,'loginIP',login_ip,'loginIpDictCode',login_ip_dict_code,'rankid',rankid,'rankname',rankname,'riskmarker',riskmarker,'applytime',CURRENT_TIMESTAMP,'sitecode',sitecode);
  raise info '申请玩家信息:%',playerInfo;
  --生成优惠活动申请
  SELECT * FROM f_message_apply(activitymessage ,playerInfo) INTO applyresult;
  raise info '生成优惠活动申请的结果:%',applyresult;
  result_code = applyresult->>'resultcode';
  IF result_code<> ACTIVITY_MEET THEN
    RETURN applyresult;
  END IF;
  --计算活动优惠
  SELECT * FROM f_message_calculator(activitymessage, playerinfo, applyresult) INTO resultjson;
  raise info '计算活动优惠的结果:%',resultjson;
  RETURN resultjson;
END
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_message_entrance"(activitymessageid int4, playerid int4, sitecode varchar) IS '优惠活动统一入口';


DROP FUNCTION IF EXISTS f_message_apply(json, json);
CREATE OR REPLACE FUNCTION "f_message_apply"(activitymessage json, playerinfo json)
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
  SELECT * FROM f_message_pre(activitymessage)  INTO result_code;
  IF result_code <> ACTIVITY_MEET_PRE THEN
    raise info '不满足该优惠活动的前置条件,状态码为:%',result_code;
    RETURN json_build_object( 'resultcode',result_code);
  END IF;
  --是否满足活动规则
  SELECT * FROM f_message_rule(activitymessage,playerInfo) INTO ruleresult;
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
  WITH activityaplayapply AS (
    INSERT INTO activity_player_apply(activity_message_id,user_id,user_name,register_time,rank_id,rank_name,risk_marker,apply_time,check_state,start_time,end_time,ip_apply,ip_dict_code)
    VALUES (activitymessageid,playerid,username,registertime,rankid,rankname,riskmarker,applytime,APPLY_CHECK_STATUS_CONFIRMED,applystarttime,applyendtime,loginIP,loginIpDictCode)
    RETURNING id
  )
  SELECT id FROM activityaplayapply INTO applyid ;
  RETURN json_build_object( 'resultcode',result_code,'applyId',applyid,'ordernum',ordernum);

END

$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_message_apply"(activitymessage json, playerinfo json) IS '优惠活动申请统一入口';