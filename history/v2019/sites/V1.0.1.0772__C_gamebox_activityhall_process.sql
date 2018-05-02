-- auto gen by linsen 2018-04-23 20:47:25
-- 计算当前周期用户的活动进度 by kobe
DROP FUNCTION IF EXISTS "gamebox_activityhall_process"(activitymessageid int4, playerid int4);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_process"(activitymessageid int4, playerid int4)
  RETURNS "pg_catalog"."json" AS $BODY$
declare
  --优惠活动信息
  effectivetransaction VARCHAR;--活动类型
  profitloss  VARCHAR;--活动审核状态
  applystarttime TIMESTAMP;--申领开始时间
  applyendtime TIMESTAMP;--申领结束时间
  --临时结果
  applytimeinterval json;
  resultjson json;--活动优惠信息
BEGIN
  --查询周期时间
	SELECT * FROM gamebox_activityhall_query_applytime(activitymessageid) INTO applytimeinterval;

  applystarttime = (applytimeinterval->>'applystarttime')::TIMESTAMP;
  applyendtime  = (applytimeinterval->>'applyendtime')::TIMESTAMP;

	--获取有效投注额
	SELECT * FROM gamebox_activityhall_calculator_effective_transaction(playerid , applystarttime , applyendtime, activitymessageid) INTO effectivetransaction;

	--获取盈亏
	SELECT * FROM gamebox_activityhall_calculator_profit_loss(playerid, applystarttime, applyendtime, activitymessageid) INTO profitloss;

	resultjson = json_build_object('effectivetransaction',effectivetransaction,'profitloss',profitloss);

	raise info '活动进度:%',resultjson;

  RETURN resultjson;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gamebox_activityhall_process"(activitymessageid int4, playerid int4) IS '计算当前周期用户的活动进度';