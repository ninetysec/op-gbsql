-- auto gen by marz 2018-06-25 10:24:16
DROP FUNCTION if EXISTS "lottery_payout"(lottery_expect text, lottery_code text, opencode text, winrecordjson text);
CREATE OR REPLACE FUNCTION "lottery_payout"(lottery_expect text, lottery_code text, opencode text, winrecordjson text)
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
	MSG_NOT_NEED text:='not_need';--无需派彩
	NOW_TIME TIMESTAMP:= now();--同一个函数里面，系统当前时间是一样的
BEGIN
	IF lottery_expect = ''  or lottery_code='' or opencode='' or winRecordJson is null or winRecordJson = '' THEN
		return MSG_FAILD;
	END IF;

	IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status = '1') THEN
		RETURN MSG_NOT_NEED;
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
	IF reslut_value = MSG_SUCCESS THEN
		--添加交易表
		INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
			SELECT  lbo.user_id ,lbo.username , '2', lbo.payout, ((select p.money from player_api p where p.player_id=lbo.user_id and p.api_id=22 FOR UPDATE) + sum(payout) over(partition by lbo.user_id order by lbo.id)) as balance ,
				lbo.payout_time,lbo.terminal,lbo.id,'开奖派彩' from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and lbo.status='2' AND lbo.payout>0
																																										and NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lbo.id  AND t.transaction_type in ('2','7')) order by  lbo.user_id ,lbo.id;
		--更新钱包
		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE( (SELECT SUM(lbo.payout) from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and  u.player_id=lbo.user_id AND status='2' AND payout>0 and lbo.payout_time = NOW_TIME) ,0)
		WHERE u.api_id=22
					and  EXISTS ( SELECT 1 from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code AND status='2' AND payout>0 and lbo.payout_time = NOW_TIME and  lbo.user_id   =  u.player_id )  ;

		--更新player_game_order的同时更新未稽核中间表
		with pgo as (
			update player_game_order po set profit_amount=(COALESCE(lo.payout,0)-COALESCE(lo.effective_trade_amount,0)),payout_time=lo.payout_time,effective_trade_amount=lo.effective_trade_amount,
				update_time=NOW_TIME,order_state='settle',is_profit_loss=((COALESCE(lo.payout,0)-COALESCE(lo.bet_amount,0))!=0),bet_detail=(select array_to_json(array_agg(row_to_json(t))) json from (select string_to_array('', ',') as apiLotteryResultVoList,
				o.id,o.expect,o.username,extract(epoch from o.bet_time) bet_time,o.code,o.play_code,o.bet_code,o.bet_num,o.odd,o.bet_amount,o.payout,extract(epoch from o.payout_time) payout_time,o.status,o.terminal,o.memo,o.user_id,o.effective_trade_amount,
				o.odd2,o.odd3,o.bonus_model,o.play_model,o.rebate,o.multiple,o.bet_count from lottery_bet_order o where o.id=lo.id) t)
			FROM lottery_bet_order lo  WHERE po.api_id=22 AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect AND lo.payout_time=NOW_TIME
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

COMMENT ON FUNCTION "lottery_payout"(lottery_expect text, lottery_code text, opencode text, winrecordjson text) IS '彩票派彩';

DROP FUNCTION if EXISTS "lottery_payout_heavy"(lottery_expect text, lottery_code text, opencode text, winrecordjson text);
CREATE OR REPLACE FUNCTION "lottery_payout_heavy"(lottery_expect text, lottery_code text, opencode text, winrecordjson text)
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
NOW_TIME TIMESTAMP:= now();--同一个函数里面，系统当前时间是一样的
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

--添加交易表
INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
		SELECT  lbo.user_id ,lbo.username , '6', lbo.payout, ((select p.money from player_api p where p.player_id=lbo.user_id and p.api_id=22 FOR UPDATE) - sum(payout) over(partition by lbo.user_id order by lbo.id)) as balance ,
			NOW_TIME,lbo.terminal,lbo.id,'重结扣款' from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and lbo.status='2' AND lbo.payout>0 order by  lbo.user_id ,lbo.id;
--更新钱包
		UPDATE player_api u SET money = COALESCE(money,0) - COALESCE( (SELECT SUM(lbo.payout) from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and  u.player_id=lbo.user_id AND status='2' AND payout>0) ,0)
    WHERE u.api_id=22
    and  EXISTS ( SELECT 1 from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code AND status='2' AND payout>0 and lbo.user_id   =  u.player_id )  ;

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

IF reslut_value = MSG_SUCCESS THEN
--添加交易表
	INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
		SELECT  lbo.user_id ,lbo.username , '7', lbo.payout, ((select p.money from player_api p where p.player_id=lbo.user_id and p.api_id=22 FOR UPDATE) + sum(payout) over(partition by lbo.user_id order by lbo.id)) as balance ,
			lbo.payout_time,lbo.terminal,lbo.id,'重结派彩' from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and lbo.status='2' AND lbo.payout>0 and lbo.payout_time = NOW_TIME order by  lbo.user_id ,lbo.id;
--更新钱包
		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE( (SELECT SUM(lbo.payout) from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and  u.player_id=lbo.user_id AND status='2' AND payout>0 and lbo.payout_time = NOW_TIME) ,0)
    WHERE u.api_id=22
    and  EXISTS ( SELECT 1 from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code AND status='2' AND payout>0 and lbo.payout_time = NOW_TIME and  lbo.user_id   =  u.player_id )  ;

--更新player_game_order的同时更新未稽核中间表
	update player_game_order po set profit_amount=(COALESCE(lo.payout,0)-COALESCE(lo.effective_trade_amount,0)),payout_time=lo.payout_time,effective_trade_amount=lo.effective_trade_amount,
		update_time=now(),order_state='settle',is_profit_loss=((COALESCE(lo.payout,0)-COALESCE(lo.bet_amount,0))!=0),bet_detail=(select array_to_json(array_agg(row_to_json(t))) json from (select  string_to_array('', ',') as apiLotteryResultVoList  ,
				o.id,o.expect,o.username,extract(epoch from o.bet_time) bet_time,o.code,o.play_code,o.bet_code,o.bet_num,o.odd,o.bet_amount,o.payout,extract(epoch from o.payout_time) payout_time,o.status,o.terminal,o.memo,o.user_id,o.effective_trade_amount,
				o.odd2,o.odd3,o.bonus_model,o.play_model,o.rebate,o.multiple,o.bet_count from lottery_bet_order o where o.id=lo.id) t)
			FROM lottery_bet_order lo  WHERE po.api_id=22 AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect;

END IF;
raise notice '调用过程结果：%',reslut_value;
  return reslut_value;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_payout_heavy"(lottery_expect text, lottery_code text, opencode text, winrecordjson text) IS '重结派彩';

DROP FUNCTION if EXISTS "lottery_revocation"(lottery_code text, lottery_expect text);
CREATE OR REPLACE FUNCTION "lottery_revocation"(lottery_code text, lottery_expect text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本说明
	-- 根据code,expect批量撤销
  -- lottery_code 彩种代号
  -- lottery_expect 期数
	--运行函数
	--select lottery_revocation('cqssc','2017041062')
*/

DECLARE
lottery_order_status VARCHAR:= '2';--注单已结算状态
revoke_status VARCHAR:= '4';--已取消
lottery_tranction_revoke VARCHAR:= '9';--已结撤销类型
lottery_memo text:='已结算注单撤销';--彩票备注
lottery_api_id INT:= 22;--LT游戏apiId
api_balance numeric(20,3);--钱包余额
bet_money numeric(20,3);--需要变更的额度
lotteryBetOrder RECORD;--注单数据
MSG_SUCCESS text:= 'success';--开奖成功
PARAM_ERROR text:= 'param-error';--参数丢失
DATA_NULL_ERROR text:= 'data-null-error';--无注单数据
BEGIN

IF lottery_code = ''  or lottery_expect='' THEN
return PARAM_ERROR;
END IF;
IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status=lottery_order_status ) THEN
RETURN DATA_NULL_ERROR;
END IF;

--添加交易表
	INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
		SELECT  lbo.user_id ,lbo.username , lottery_tranction_revoke, lbo.bet_amount-TRUNC(lbo.bet_amount*COALESCE(lbo.rebate,0),3) - lbo.payout, ((select p.money from player_api p where p.player_id=lbo.user_id and p.api_id=lottery_api_id FOR UPDATE) + sum(lbo.bet_amount-TRUNC(lbo.bet_amount*COALESCE(lbo.rebate,0),3) - lbo.payout) over(partition by lbo.user_id order by lbo.id)) as balance ,
			now(),lbo.terminal,lbo.id,lottery_memo from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and lbo.status=lottery_order_status
		and NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lbo.id  AND t.transaction_type=lottery_tranction_revoke) order by  lbo.user_id ,lbo.id;
--更新钱包
		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE( (SELECT SUM(lbo.bet_amount-TRUNC(lbo.bet_amount*COALESCE(lbo.rebate,0),3) - lbo.payout) from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and  u.player_id=lbo.user_id AND lbo.status=lottery_order_status) ,0)
    WHERE u.api_id=lottery_api_id
    and  EXISTS ( SELECT 1 from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code AND status=lottery_order_status and  lbo.user_id   =  u.player_id )  ;
		--更新注单状态为已取消
			UPDATE lottery_bet_order SET status=revoke_status WHERE expect=lottery_expect AND code=lottery_code AND status=lottery_order_status;
		--更新player_game_order对应资金记录数据状态
		with pgo as (
				update player_game_order po set order_state='cancel',bet_detail=(select array_to_json(array_agg(row_to_json(t))) json from (select  string_to_array('', ',')  as apiLotteryResultVoList  ,
				o.id,o.expect,o.username,extract(epoch from o.bet_time) bet_time,o.code,o.play_code,o.bet_code,o.bet_num,o.odd,o.bet_amount,o.payout,extract(epoch from o.payout_time) payout_time,o.status,o.terminal,o.memo,o.user_id,o.effective_trade_amount,
				o.odd2,o.odd3,o.bonus_model,o.play_model,o.rebate,o.multiple,o.bet_count from lottery_bet_order o where o.id=lo.id) t) FROM lottery_bet_order lo  WHERE po.api_id=lottery_api_id AND po.order_state='settle' AND po.bet_id=lo.id::VARCHAR and lo.expect = lottery_expect AND locode=lottery_code AND status=revoke_status
				 RETURNING po.id
		)
	--更新未稽核中间表
			UPDATE player_game_order_not_audit pgoa SET pgoa.order_state = 'cancel' FROM pgo  WHERE pgoa.id = pgo.id and pgoa.order_state='settle';

raise notice '调用过程结果：%',MSG_SUCCESS;
return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_revocation"(lottery_code text, lottery_expect text) IS '批量撤销';

DROP FUNCTION if EXISTS "lottery_revoke"(lottery_code text, lottery_expect text);
CREATE OR REPLACE FUNCTION "lottery_revoke"(lottery_code text, lottery_expect text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本说明
	-- 根据code,expect批量撤单
  -- lottery_code 彩种代号
  -- lottery_expect 期数
	--运行函数
	--select lottery_revoke('cqssc','2017041062')
*/

DECLARE
lottery_order_status VARCHAR:= '1';--注单待结算状态
revoke_status VARCHAR:= '3';--已取消
lottery_tranction_revoke VARCHAR:= '8';--待结撤单类型
lottery_memo text:='待结算注单撤单';--彩票备注
lottery_api_id INT:= 22;--LT游戏apiId
api_balance numeric(20,3);--钱包余额
bet_money numeric(20,3);--需要变更的额度
lotteryBetOrder RECORD;--注单数据
MSG_SUCCESS text:= 'success';--开奖成功
PARAM_ERROR text:= 'param-error';--参数丢失
DATA_NULL_ERROR text:= 'data-null-error';--无注单数据
BEGIN

IF lottery_code = ''  or lottery_expect='' THEN
return PARAM_ERROR;
END IF;
IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status=lottery_order_status ) THEN
RETURN DATA_NULL_ERROR;
END IF;
--添加交易表
	INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
		SELECT  lbo.user_id ,lbo.username , lottery_tranction_revoke, lbo.bet_amount-TRUNC(lbo.bet_amount*COALESCE(lbo.rebate,0),3), ((select p.money from player_api p where p.player_id=lbo.user_id and p.api_id=lottery_api_id FOR UPDATE) + sum(lbo.bet_amount-TRUNC(lbo.bet_amount*COALESCE(lbo.rebate,0),3)) over(partition by lbo.user_id order by lbo.id)) as balance ,
			now(),lbo.terminal,lbo.id,lottery_memo from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and lbo.status=lottery_order_status
		and NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lbo.id  AND t.transaction_type=lottery_tranction_revoke) order by  lbo.user_id ,lbo.id;
--更新钱包
		UPDATE player_api u SET money = COALESCE(money,0) + COALESCE( (SELECT SUM(lbo.bet_amount-TRUNC(lbo.bet_amount*COALESCE(lbo.rebate,0),3)) from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code and  u.player_id=lbo.user_id AND lbo.status=lottery_order_status) ,0)
    WHERE u.api_id=lottery_api_id
    and  EXISTS ( SELECT 1 from lottery_bet_order lbo WHERE lbo.expect = lottery_expect and lbo.code = lottery_code AND status=lottery_order_status and  lbo.user_id   =  u.player_id )  ;
		--更新注单状态为已取消
			UPDATE lottery_bet_order SET status=revoke_status WHERE expect=lottery_expect AND code=lottery_code AND status=lottery_order_status;
--更新player_game_order对应资金记录数据状态
			update player_game_order po set order_state='cancel',bet_detail=(select array_to_json(array_agg(row_to_json(t))) json from (select  string_to_array('', ',')  as apiLotteryResultVoList  ,
				o.id,o.expect,o.username,extract(epoch from o.bet_time) bet_time,o.code,o.play_code,o.bet_code,o.bet_num,o.odd,o.bet_amount,o.payout,extract(epoch from o.payout_time) payout_time,o.status,o.terminal,o.memo,o.user_id,o.effective_trade_amount,
				o.odd2,o.odd3,o.bonus_model,o.play_model,o.rebate,o.multiple,o.bet_count from lottery_bet_order o where o.id=lo.id) t) FROM lottery_bet_order lo  WHERE po.api_id=lottery_api_id AND po.order_state='pending_settle' AND po.bet_id=lo.id::VARCHAR and lo.expect = lottery_expect AND lo.code=lottery_code AND lo.status=revoke_status;

raise notice '调用过程结果：%',MSG_SUCCESS;
return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_revoke"(lottery_code text, lottery_expect text) IS '批量撤单';


