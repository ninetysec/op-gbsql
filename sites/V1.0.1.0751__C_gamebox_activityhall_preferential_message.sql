-- auto gen by linsen 2018-04-15 21:32:57
-- 周期性优惠活动计算入口 by kobe
DROP FUNCTION IF EXISTS gamebox_activityhall_preferential_message(activitymessageid int4, sitecode varchar);
CREATE OR REPLACE FUNCTION "gamebox_activityhall_preferential_message"(activitymessageid int4, sitecode varchar)
  RETURNS "pg_catalog"."void" AS $BODY$declare

status  VARCHAR;--活动审核状态

activitytype VARCHAR;--活动类型

activity_status_success VARCHAR := '1';--活动审核状态

type_effective_transaction VARCHAR := 'effective_transaction';--有效交易量的activity_type

type_profit_loss VARCHAR := 'profit_loss';--盈亏送的activity_type

BEGIN

SELECT check_status,activity_type_code FROM activity_message WHERE id = activitymessageid INTO status,activitytype;

raise info '当前审核状态为:%,活动类型为：%',status,activitytype;

IF status != activity_status_success THEN

raise info '活动:%,未审核通过,立即结束计算.',activitymessageid;

RETURN;

END IF;

IF activitytype = type_profit_loss THEN

	PERFORM gamebox_activityhall_preferential_profitloss(activitymessageid,sitecode);

	RETURN;

ELSEIF activitytype = type_effective_transaction THEN

	PERFORM gamebox_activityhall_preferential_effecttransaction(activitymessageid,sitecode);

	RETURN;

END IF;

END

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gamebox_activityhall_preferential_message"(activitymessageid int4, sitecode varchar) IS '周期性优惠活动计算入口';