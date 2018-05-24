-- auto gen by steffan 2018-05-24 14:24:40 update by steffan
DROP FUNCTION IF EXISTS f_message_entrance(int4, int4, varchar);
 CREATE OR REPLACE FUNCTION "f_message_entrance"(activitymessageid int4, playerid int4, sitecode varchar, terminaltype varchar)
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
  SELECT sysuser.username,sysuser.create_time,sysuser.login_ip,sysuser.login_ip_dict_code,player.rank_id,prank.rank_name,prank.risk_marker,sysuser.real_name FROM sys_user sysuser,user_player player,player_rank prank
  WHERE sysuser.id = player.id AND player.rank_id = prank.id AND sysuser.id=playerid  INTO username,registertime,login_ip,login_ip_dict_code,rankid,rankname,riskmarker;
  playerInfo = json_build_object('playerid',playerid,'username',username,'registertime',registertime,'loginIP',login_ip,'loginIpDictCode',login_ip_dict_code,'rankid',rankid,'rankname',rankname,'riskmarker',riskmarker,'applytime',CURRENT_TIMESTAMP,'sitecode',sitecode);
  raise info '申请玩家信息:%',playerInfo;
  --生成优惠活动申请
  SELECT * FROM f_message_apply(activitymessage ,playerInfo, terminaltype ) INTO applyresult;
  raise info '生成优惠活动申请的结果:%',applyresult;
  result_code = applyresult->>'resultcode';
  IF result_code<> ACTIVITY_MEET THEN
    RETURN applyresult;
  END IF;
  --计算活动优惠
  SELECT * FROM f_message_calculator(activitymessage, playerinfo, applyresult,terminaltype ) INTO resultjson;
  raise info '计算活动优惠的结果:%',resultjson;
  RETURN resultjson;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "f_message_entrance"(activitymessageid int4, playerid int4, sitecode varchar, terminaltype varchar) IS '优惠活动统一入口';