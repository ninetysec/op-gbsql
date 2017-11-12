-- auto gen by marz 2017-11-09 17:10:36
DROP FUNCTION IF EXISTS "lottery_revoke"(lottery_code text, lottery_expect text, lottery_status text);
CREATE OR REPLACE FUNCTION "lottery_revoke"(lottery_code text, lottery_expect text, lottery_status text)
  RETURNS "pg_catalog"."varchar" AS $BODY$
/*版本说明
	-- 根据code,expect,status批量撤单|批量撤销
  -- lottery_code 彩种代号
  -- lottery_expect 期数
  -- lottery_status 订单状态
	--运行函数
	--select lottery_revoke('cqssc','2017041062','1')
*/

DECLARE
revoke_status VARCHAR:= '3';--已撤单状态
lottery_tranction_revoke VARCHAR:= '8';--待结撤单类型
lottery_tranction_revocation VARCHAR:= '9';--已结撤销类型
lottery_api_id INT:= 22;--LT游戏apiId
api_balance numeric(20,3);--钱包余额
lottery_balance numeric(20,3);--LT资金记录余额
bet_money numeric(20,3);--需要变更的额度
lotteryBetOrder RECORD;--注单数据
MSG_SUCCESS text:= 'success';--开奖成功
PARAM_ERROR text:= 'param-error';--参数丢失
DATA_NULL_ERROR text:= 'data-null-error';--无注单数据
BEGIN

IF lottery_code = ''  or lottery_expect='' or lottery_status ='' THEN
return PARAM_ERROR;
END IF;
IF NOT EXISTS  (SELECT * FROM lottery_bet_order WHERE expect=lottery_expect AND code=lottery_code AND status=lottery_status ) THEN
RETURN DATA_NULL_ERROR;
END IF;
FOR lotteryBetOrder in SELECT * FROM lottery_bet_order WHERE expect = lottery_expect AND code=lottery_code AND status=lottery_status
loop
		--更新player_game_order对应资金记录数据状态
		update player_game_order po set order_state='cancel' FROM lottery_bet_order lo  WHERE po.api_id=lottery_api_id AND po.bet_id=lo.id::VARCHAR AND lo.code=lottery_code AND lo.expect=lottery_expect;
		--获取player_api钱钱包余额
    SELECT COALESCE(max(pa.money), 0) FROM player_api pa WHERE pa.api_id = lottery_api_id AND pa.player_id = lotteryBetOrder.user_id into api_balance;
		--增加lottery资金记录
		IF lotteryBetOrder.bet_amount > 0 THEN
			bet_money = lotteryBetOrder.bet_amount-TRUNC(lotteryBetOrder.bet_amount*COALESCE(lotteryBetOrder.rebate,0),3);
			--待结算
			IF lottery_status = '1' THEN
				INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
		         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,lottery_tranction_revoke, bet_money ,(api_balance+bet_money),
		        now(),lotteryBetOrder.terminal,lotteryBetOrder.id,'待结算注单撤单' WHERE NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lotteryBetOrder.id  AND t.transaction_type=lottery_tranction_revoke);
			--已结算
			ELSEIF lottery_status = '2' THEN
				IF lotteryBetOrder.payout > 0 THEN
					bet_money = bet_money-lotteryBetOrder.payout;
				END IF;
				INSERT INTO lottery_transaction (user_id,username,transaction_type,money,balance,transaction_time,terminal,source_id,memo)
		         SELECT lotteryBetOrder.user_id,lotteryBetOrder.username,lottery_tranction_revocation, bet_money ,(api_balance+bet_money),
		        now(),lotteryBetOrder.terminal,lotteryBetOrder.id,'已结算注单撤销' WHERE NOT EXISTS (SELECT t.id FROM lottery_transaction t WHERE t.source_id=lotteryBetOrder.id  AND t.transaction_type=lottery_tranction_revocation);
			END IF;
		END IF;
		--修改player_api钱包余额
     UPDATE player_api SET money=(COALESCE (money,0) + (lotteryBetOrder.bet_amount-TRUNC(lotteryBetOrder.bet_amount*COALESCE(lotteryBetOrder.rebate,0),3)-COALESCE(lotteryBetOrder.payout,0))) WHERE api_id = lottery_api_id AND player_id = lotteryBetOrder.user_id;
    --更新注单状态为已撤单
		UPDATE lottery_bet_order SET status=revoke_status WHERE id=lotteryBetOrder.id;
END loop;
raise notice '调用过程结果：%',MSG_SUCCESS;
return MSG_SUCCESS;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "lottery_revoke"(lottery_code text, lottery_expect text, lottery_status text) IS '批量撤单|撤销';
