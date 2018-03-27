-- auto gen by marz 2018-02-05 14:20:24
DROP FUNCTION IF EXISTS "lottery_payout"(lottery_expect text, lottery_code text, opencode text, winRecordJson text);
CREATE OR REPLACE FUNCTION "lottery_payout"(lottery_expect text, lottery_code text, opencode text, winRecordJson text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lottery_expect 期数
  -- lottery_code 彩种代号
  -- opencode 开奖号码
  -- winrecordjson 中奖记录字符串
*/

DECLARE

lotteryParameter json;--优惠活动信息
reslut_value varchar;--返回结果
lotteryBetOrder RECORD;--开奖结果

MSG_FAILD text:= 'faild';--开奖失败
MSG_SUCCESS text:= 'success';--开奖成功
BEGIN

IF lottery_expect = ''  or lottery_code='' or opencode='' or winRecordJson is null or winRecordJson = '' THEN
return MSG_FAILD;
END IF;

lotteryParameter = json_build_object('expect',lottery_expect,'code',lottery_code,'opencode',opencode);

raise notice '中奖记录为:%', winRecordJson;
raise notice '开奖参数为:%', lotteryParameter;

if lottery_code like '%ssc' then
	SELECT lottery_payout_ssc(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code like '%lhc' then
	SELECT lottery_payout_lhc(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code like '%pk10' OR lottery_code='xyft' then
	SELECT lottery_payout_pk10(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code like '%k3' then
	SELECT lottery_payout_k3(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'cqxync' or lottery_code = 'gdkl10' then
	SELECT lottery_payout_sfc(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'fc3d' or lottery_code = 'tcpl3' then
	SELECT lottery_payout_pl3(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'bjkl8' then
	SELECT lottery_payout_keno(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'xy28' then
	SELECT lottery_payout_xy28(winRecordJson,lotteryParameter) INTO reslut_value;
ELSE
--其它彩种待处理
end if;
--派彩大于0的需要更新api余额，生成资金记录
FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0
loop
    UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22 AND NOT EXISTS (SELECT id FROM lottery_transaction WHERE source_id=lotteryBetOrder.id AND transaction_type in ('2','7'));
    INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,'2',lotteryBetOrder.payout,(select p.money from player_api p where p.player_id=lotteryBetOrder.user_id and p.api_id=22),
        lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'开奖派彩' WHERE NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lotteryBetOrder.id  AND t.transaction_type in ('2','7'));
END loop;

IF reslut_value = MSG_SUCCESS THEN
--更新player_game_order的同时更新未稽核中间表
with pgo as (
update player_game_order po set profit_amount=(COALESCE(lo.payout,0)-COALESCE(lo.effective_trade_amount,0)),payout_time=lo.payout_time,effective_trade_amount=lo.effective_trade_amount,
		update_time=now(),order_state='settle',is_profit_loss=((COALESCE(lo.payout,0)-COALESCE(lo.bet_amount,0))!=0),result_json=(select array_to_json(array_agg(row_to_json(t))) json from (select * from lottery_bet_order o where o.id=lo.id) t)
			FROM lottery_bet_order lo  WHERE po.api_id=22 AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect
			RETURNING po.id, po.api_id, po.bet_id, po.player_id, po.effective_trade_amount, po.payout_time, po.order_state
    )
		INSERT INTO player_game_order_not_audit (id, api_id, bet_id, player_id, effective_trade_amount, payout_time, order_state)
		SELECT id, api_id, bet_id, player_id, effective_trade_amount, payout_time, order_state
		FROM pgo
		ON CONFLICT (id)
		DO UPDATE
		SET player_id= excluded.player_id,
		effective_trade_amount = excluded.effective_trade_amount,
		payout_time = excluded.payout_time,
		order_state = excluded.order_state;

END IF;
raise notice '调用过程结果：%',reslut_value;
  return reslut_value;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout"(lottery_expect text, lottery_code text, opencode text, winRecordJson text) IS '彩票派彩';


--------------------------------------------------------------
DROP FUNCTION IF EXISTS "lottery_payout_heavy"(lottery_expect text, lottery_code text, opencode text, winRecordJson text);
CREATE OR REPLACE FUNCTION "lottery_payout_heavy"(lottery_expect text, lottery_code text, opencode text, winRecordJson text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本更新说明
  -- lottery_expect 期数
  -- lottery_code 彩种代号
  -- opencode 开奖号码
  -- winrecordjson 中奖记录字符串
*/

DECLARE

lotteryParameter json;--优惠活动信息
reslut_value varchar;--返回结果
lotteryBetOrder RECORD;--开奖结果

MSG_FAILD text:= 'faild';--开奖失败
MSG_SUCCESS text:= 'success';--开奖成功
PAYOUT_FIRST text:='payoutfirst';--先派彩
BEGIN

IF lottery_expect = ''  or lottery_code='' or opencode='' or winRecordJson is null or winRecordJson = '' THEN
return MSG_FAILD;
END IF;

lotteryParameter = json_build_object('expect',lottery_expect,'code',lottery_code,'opencode',opencode);

raise notice '中奖记录为:%', winRecordJson;
raise notice '开奖参数为:%', lotteryParameter;

IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2') THEN
RETURN PAYOUT_FIRST;
END IF;

FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0
loop
    UPDATE player_api u SET money = COALESCE(money,0) - COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22;
    INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,'6',lotteryBetOrder.payout,(select p.money from player_api p where p.player_id=lotteryBetOrder.user_id and p.api_id=22),
        now(),lotteryBetOrder.terminal,lotteryBetOrder.id,'重结扣款';
END loop;
    --还原已派彩记录
    UPDATE lottery_bet_order SET payout =null,payout_time =null, status='1',effective_trade_amount=null WHERE expect=lottery_expect AND code=lottery_code and status='2';


if lottery_code like '%ssc' then
	SELECT lottery_payout_ssc(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code like '%lhc' then
	SELECT lottery_payout_lhc(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code like '%pk10' OR lottery_code='xyft' then
	SELECT lottery_payout_pk10(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code like '%k3' then
	SELECT lottery_payout_k3(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'cqxync' or lottery_code = 'gdkl10' then
	SELECT lottery_payout_sfc(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'fc3d' or lottery_code = 'tcpl3' then
	SELECT lottery_payout_pl3(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'bjkl8' then
	SELECT lottery_payout_keno(winRecordJson,lotteryParameter) INTO reslut_value;
ELSEIF lottery_code = 'xy28' then
	SELECT lottery_payout_xy28(winRecordJson,lotteryParameter) INTO reslut_value;
ELSE
--其它彩种待处理
end if;


FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status='2' AND payout>0
loop
	raise notice 'lotteryBetOrder...';
    UPDATE player_api u SET money = COALESCE(money,0) + COALESCE(lotteryBetOrder.payout,0) WHERE u.player_id=lotteryBetOrder.user_id and u.api_id=22;
    INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,'7',lotteryBetOrder.payout,(select p.money from player_api p where p.player_id=lotteryBetOrder.user_id and p.api_id=22),
        lotteryBetOrder.payout_time,lotteryBetOrder.terminal,lotteryBetOrder.id,'重结派彩';
END loop;

IF reslut_value = MSG_SUCCESS THEN
--更新player_game_order的同时更新未稽核中间表

	update player_game_order po set profit_amount=(COALESCE(lo.payout,0)-COALESCE(lo.effective_trade_amount,0)),payout_time=lo.payout_time,effective_trade_amount=lo.effective_trade_amount,
		update_time=now(),order_state='settle',is_profit_loss=((COALESCE(lo.payout,0)-COALESCE(lo.bet_amount,0))!=0),result_json=(select array_to_json(array_agg(row_to_json(t))) json from (select * from lottery_bet_order o where o.id=lo.id) t)
			FROM lottery_bet_order lo  WHERE po.api_id=22 AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect;

END IF;
raise notice '调用过程结果：%',reslut_value;
  return reslut_value;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout_heavy"(lottery_expect text, lottery_code text, opencode text, winRecordJson text) IS '重结派彩';