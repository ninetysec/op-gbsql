-- auto gen by marz 2018-06-26 19:31:06
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
				o.odd2,o.odd3,o.bonus_model,o.play_model,o.rebate,o.multiple,o.bet_count from lottery_bet_order o where o.id=lo.id) t) FROM lottery_bet_order lo  WHERE po.api_id=lottery_api_id AND po.order_state='settle' AND po.bet_id=lo.id::VARCHAR and lo.expect = lottery_expect AND lo.code=lottery_code AND lo.status=revoke_status
				 RETURNING po.id
		)
	--更新未稽核中间表
			UPDATE player_game_order_not_audit pgoa SET order_state = 'cancel' FROM pgo  WHERE pgoa.id = pgo.id and pgoa.order_state='settle';

raise notice '调用过程结果：%',MSG_SUCCESS;
return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

COMMENT ON FUNCTION "lottery_revocation"(lottery_code text, lottery_expect text) IS '批量撤销';